<!-- badges: start -->
  [![R-CMD-check](https://github.com/deepchocolate/get-statistics-fhi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/deepchocolate/get-statistics-fhi/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->
  
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
with "A01AA" are retrieved from the drug register. Filters are applied to remove
specific age groups, and ATC codes are restricted to those starting with "A01AA*".
```R
library(getStatisticsFHI)
req <- dataRequest('lmr', '615')
req <- filterAge(req, filter='item', value='TOTALT')
req <- filterATC(req, filter='all', value='A01AA*')
dta <- getData(req)
```
Alternatively, an English, recoded version of data can be fetched with:
```R
dta <- getData(req, recode=TRUE)
```

The number 615 (table ID) in `getDataLMR('615')` is highly mysterious. To find the right table
ID one can use `getSourceDesc('lmr')` to find a potential table, and use its id
with `getTableMeta(#ID)` to get details. The `filter` argument to the `filter...` functions
can be any of `"item"`, `"all"` or `"top"`. The link below provides a more detailed
explanation of how to use these.

Further information is available in the github repository for the API:
https://github.com/folkehelseinstituttet/Fhi.Statistikk.OpenAPI?tab=readme-ov-file
