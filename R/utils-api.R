#' Endpoint for available sources.
endpointSources <- function () {
  API_URL %s+% '/Common/source'
}

#' Endpoint for a source.
#' @param source A source.
endpointSource <- function (source) {
  API_URL %s+% '/' %s+%  source %s+% '/Table'
}

#' Endpoint for a table.
#' @param source A source.
#' @param idTable A table ID.
#' @param type Type of information to retrieve.
endpointTable <- function (source, idTable, type='') {
  endpointSource(source) %s+% '/' %s+% idTable %s+% ifelse(type == '', '', '/' %s+% type)
}

#' Endpoint for meta information for a table.
#' @param source A source.
#' @param idTable A table ID.
endpointTableMeta <- function (source, idTable) {
  endpointTable(source, idTable)
}

#' Endpoint for table description.
#' @param source A source.
#' @param idTable A table ID.
endpointTableDesc <- function (source, idTable) {
  endpointTable(source, idTable, 'query')
}

#' Endpoint for table data.
#' @param source A source.
#' @param idTable A table ID.
endpointTableData <- function (source, idTable) {
  endpointTable(source, idTable, 'data')
}

#' Perform a GET request.
#' @param endpoint An endpoint (returned by endpoint* functions).
#' @param dataFrame Whether to convert the response to a data.frame.
getRequest <- function (endpoint, dataFrame=T) {
  req <- request(endpoint)
  resp <- req_perform(req)
  o <- resp |> resp_body_string()
  if (dataFrame) o <- jsonlite::fromJSON(o)
  o
}

#' Get available sources.
#' @param dataFrame Whether to convert the response to a data.frame.
getSources <- function (dataFrame=T) {
  getRequest(endpointSources(), dataFrame)
}

#' Get description of a source.
#' @param source A source (e.g. lmr).
#' @param dataFrame Whether to convert the response to a data.frame.
getSourceDesc <- function (source, dataFrame=T) {
  getRequest(endpointSource(source), dataFrame)
}

#' Get metadata for a table.
#' @param source A source (e.g. lmr).
#' @param idTable The table ID.
#' @param dataFrame Whether to convert the response to a data.frame.
getTableMeta <- function(source, idTable, dataFrame=T) {
  getRequest(endpointTableMeta(source, idTable), dataFrame)
}

#' Get descriptoin of a table.
#' @param source A source (e.g. lmr).
#' @param idTable The table ID.
#' @param dataFrame Whether to convert the response to a data.frame.
getTableDesc <- function (source, idTable, dataFrame=T) {
  getRequest(endpointTableDesc(source, idTable), dataFrame)
}
