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

funcmv (){
  file="$0"
  ftype="$2"  # I don't know why it's 2....
  dn=$(dirname "$0")
  mkdir -p "$dn"
  target="$dn"/"$ftype".csv
  mv "$0" "$target"
}
export -f funcmv


files=( 'fall' 'entgelte' 'ops' 'icd' 'fab' )
# move and rename files to standard notation
for f in "${files[@]}"; do
  find "$SRC" -regextype posix-extended -type f -iregex '.*/[0-9]*'$f'([0-9\_]\w*)?\.csv' -exec bash -c 'funcmv "$0" "$1"' {} $f \;
done

for f in "${files[@]}"; do
  find $SRC -iname "$f".csv -type f -exec bash -c 'func "$0"' {} \;
done
