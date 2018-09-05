# p21-tools
Tools for handling the medical §21 data-set

## Annonymize
To remove personal information from §21-data simply run
```
./annonymize.sh [src-directory] [target-directory]
```
The script will walk through the `src-directory` and move all `fall.csv`, `entgelte.csv`, `ops.csv`, `icd.csv` and `fab.csv` into the `target-directory`. Thereby it will do the following transformations:

all files:
* "Entlassender-Standort" --> 01

fall.csv
* "Versicherten-ID" --> "abc"
* "Vertragskennzeichen-64b-Modellvorhaben" --> "xy"
* "PLZ" --> first two digits
* "Wohnort" --> Buxtehude

Todos:
* encrypt `Versichterten-ID` or `Personennummer`
* also handle additional files (e.g. krankenhaus.csv)
* check file-headers before transforming script (plausibility check)


## About
Contributions welcome.

