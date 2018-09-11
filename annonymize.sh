#!/bin/bash

# source directory
export SRC=$1

# target directory
export TGT=$2

if [ -z "${SRC// }" ] | [ -z "${SRC// }" ]; then
  echo "Annonymize p21-data. Use like:
    ./annonymize.sh [source-directory] [target-directory]"
  exit 1
fi

func () {
  source="$0"
  target="${0/$SRC/$TGT}"
  target="${target,,}"
  echo "Annonymize $source to $target"

  file_type=$(basename -- "$target")
  target_directory=$(dirname "$target")
  mkdir -p "$target_directory"
  line1=$(head -n 1 "$source")
  # Wohnort only appears in formats after 2015
  ispre15="TRUE"
  if [[ "$line1" = *"Wohnort"* ]]; then
    ispre15="FALSE"
  fi

  awk -F';' -v type="$file_type" -v pre15="$ispre15" 'BEGIN { OFS=";"; ORS="\n"}
                                  {if (NR > 1){
                                    $2="01";
                                    if (type == "fall.csv"){
                                      $5="abc";
                                      $6="xy";
                                      $11=substr($11,1,2);
                                      if (pre15 == "FALSE"){
                                        $12="Buxtehude";
                                      }
                                    }
                                  };
                                   print}' "$source" > "$target"
}
export -f func


files=( 'fall.csv' 'entgelte.csv' 'ops.csv' 'icd.csv' 'fab.csv' )
for f in "${files[@]}"; do
  find $SRC -iname "$f" -type f -exec bash -c 'func "$0"' {} \;
done
