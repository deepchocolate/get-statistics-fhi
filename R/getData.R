#' @importFrom jsonlite toJSON unbox
#' @importFrom utils read.csv
#' @importFrom methods new callNextMethod
#' @import httr2
NULL

#' An S4 class representing a data request
#'
#' Holds information regarding each request.
#'
#' @name dataRequestAbstract-class
#' @slot source The data source.
#' @slot table The table to retrieve data from.
#' @slot endpoint The URL from which to retrieve data.
#' @slot filters A list of filters to apply.
setClass('dataRequestAbstract', representation(
  source = 'character',
  table = 'character',
  endpoint = 'character',
  filters = 'list'
))
setMethod('initialize', signature('dataRequestAbstract'),
          function (.Object, source, idTable, type='') {
            .Object@source = source
            .Object@table = idTable
            .Object@endpoint = endpointTable(source, idTable, type)
            .Object@filters = list()
            .Object
          })
setClass('dataRequestLMR', contains='dataRequestAbstract')
setMethod('initialize', signature('dataRequestLMR'),
          function (.Object, source, idTable, type='') {
            .Object <- callNextMethod(.Object, source, idTable, type)
            .Object@filters = list(
              age=list(code=unbox('Aldersgruppe_Verdi'),filter=unbox('all'), values='*'),
              measure=list(code=unbox('MEASURE_TYPE'),filter=unbox('item'), values='AntallBrukere'),
              sex=list(code=unbox('Kjonn_Verdi'),filter=unbox('all'), values='*'),
              variable=list(code=unbox('Atc_Verdi'),filter=unbox('item'), values='A01AA01'),
              year=list(code=unbox('Utlevering_Ar'),filter=unbox('all'), values='*')
            )
            .Object
          })

#' Execute a request to get data.
#'
#' @name getData
#' @docType methods
#' @param x A dataRequest object.
#' @param ... Verbosity of execution.
#' @examples
#' \dontrun{
#' library(getStatisticsFHI)
#' req <- dataRequestLMR('615')
#' req <- filterAge(req, filter='item', value='TOTALT')
#' getData(req)
#' }
#' @return A dataframe.
#' @export
setGeneric('getData', function (x, ...) standardGeneric('getData'))
#' @rdname getData
#' @param verb Verbosity of execution.
setMethod('getData', signature('dataRequestAbstract'),
          function (x, verb=0) {
            js <- jsonlite::toJSON(filters(x))
            req <- request(x@endpoint)
            req <- req |> req_body_raw(js,type = 'application/json')
            resp <- req_perform(req, verbosity=verb)
            o <- resp |> resp_body_string()
            read.csv(text=o, sep=';')
          })

#' Get filters that are applied to a request.
#'
#' @name filters
#' @docType methods
#' @param object A dataRequest object.
#' @examples
#' \dontrun{
#' library(getStatisticsFHI)
#' req <- dataRequestLMR('615')
#' req <- filterAge(req, filter='item', value='TOTALT')
#' filters(req)
#' }
#' @return A list outlining the filters.
#' @export
setGeneric('filters', function (object) standardGeneric('filters'))
#' @rdname filters
setMethod('filters', signature('dataRequestAbstract'),
          function (object) {
            list(dimensions=list(
              object@filters$variable,
              object@filters$sex,
              object@filters$age,
              object@filters$measure,
              object@filters$year),
              response=list(format=unbox('csv2'),
                            maxRowCount=unbox(0)))
          })

#' Prepare a request to retrieve data from the drug register
#'
#' @name dataRequest
#' @docType methods
#' @param source Data source, e.g. "LMR".
#' @param idTable A table ID.
#' @examples
#' \dontrun{
#' library(getStatisticsFHI)
#' req <- dataRequest('lmr', '615')
#' req <- filterAge(req, filter='item', value='TOTALT')
#' getData(req)
#' }
#' @return A dataframe.
#' @export
setGeneric('dataRequest', function (source, idTable) standardGeneric('dataRequest'))
#' @rdname dataRequest
setMethod('dataRequest', signature('character', 'character'),
          function (source, idTable) {
            cl <- 'dataRequest' %s+% toupper(source)
            new(cl, source, idTable, 'data')
          })

#' Function to simplify getting an age group by specifying an age you wish to look at.
#' @param age An age. If age is not an integer, age will be returned as is.
getAgeGroup <- function (age) {
  if (typeof(age) != 'double') return(age)
  which(apply(AGE_GROUPS, MARGIN = 1, function (x) {dplyr::between(age,x[1], x[2]);}))
}

#' Filter data on age group.
#'
#' @name filterAge
#' @docType methods
#' @param object A dataRequest object.
#' @param filter Type of filter to apply: item, top or all.
#' @param value Filtering value, either an age or "TOTALT" for all groups.
#' @examples
#' \dontrun{
#' library(getStatisticsFHI)
#' req <- dataRequestLMR('615')
#' req <- filterAge(req, filter='item', value='TOTALT')
#' getData(req)
#' }
#' @return A dataRequest object with a filter applied.
#' @export
setGeneric('filterAge', function (object, filter, value) standardGeneric('filterAge'))
#' @rdname filterAge
setMethod('filterAge', signature('dataRequestLMR', 'character', 'character'),
          function (object, filter, value='TOTALT') {
            object@filters$age <- list(code=unbox('Aldersgruppe_Verdi'), filter=unbox(filter), values=value)
            object
          })
#' @rdname filterAge
setMethod('filterAge', signature('dataRequestLMR', 'character', 'numeric'),
          function (object, filter, value) {
            value <- getAgeGroup(value)
            filterAge(object, filter, as.character(value))
          })

#' Filter data on ATC code.
#'
#' @name filterATC
#' @docType methods
#' @param object A dataRequest object.
#' @param filter Type of filter to apply: item, top or all.
#' @param values Filtering value
#' @examples
#' \dontrun{
#' library(getStatisticsFHI)
#' req <- dataRequestLMR('615')
#' req <- filterATC(req, filter='all', value='AA*')
#' getData(req)
#' }
#' @return A dataRequest object with a filter applied.
#' @export
setGeneric('filterATC', function (object, filter, values) standardGeneric('filterATC'))
#' @rdname filterATC
setMethod('filterATC', signature('dataRequestLMR', 'character', 'character'),
          function (object, filter, values) {
            object@filters$variable=list(code=unbox('Atc_Verdi'),filter=unbox(filter), values=values)
            object
          })

