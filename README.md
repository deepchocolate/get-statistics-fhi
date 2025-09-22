An R-package to interact with the API for statistics maintained by the Norwegian Institute for Public Health

Currently, only the drug register is supported.

## Installation
Using devtools, execute in R:
```
devtools::install_github('https://github.com/deepchocolate/get-statistics-fhi')
```

Or download a release and issue:
```R
install.package('path/getStatisticsFHI_x.y.x.tar.gz', repos=NULL)
```

## Usage
In this simple example the number of users for ATC codes starting
with "A01AA" are retrieved from the drug register.
```R
library(getStatisticsFHI)
dta <- getDataLMR('615')
dta <- filterAge(dta, filter='item', value='TOTALT')
dta <- filterATC(dta, filter='all', value='A01AA*')
tmp <- get(dta,0)
```

The number 615 in `getDataLMR('615') is highly mysterious. To find the right table
ID one can use `getSourceDesc('lmr')` to find a potential table, and use its id
with `getTableMeta(#ID)` to get details.

Further information is available in the github repository for the API:
https://github.com/folkehelseinstituttet/Fhi.Statistikk.OpenAPI?tab=readme-ov-file
