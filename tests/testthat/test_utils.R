test_that('Endpoints', {
  ur <- API_URL
  expect_equal(endpointSources(), ur %s+% '/Common/source')
  expect_equal(endpointSource('lmr'), ur %s+% '/lmr/Table')
  expect_equal(endpointTableMeta('lmr', 1), ur %s+% '/lmr/Table/1')
  expect_equal(endpointTableDesc('lmr', 1), ur %s+% '/lmr/Table/1/query')
  expect_equal(endpointTableData('lmr', 1), ur %s+% '/lmr/Table/1/data')
})

test_that('Recode data', {
  df <- read.csv('data/lmr-sample.csv')
  tmp <- recodeLMR(df)
  cnames <- colnames(tmp)
  cnamesExp <- c('atc','description','sex','age','year','individuals','flag')
  expect_equal(cnames, cnamesExp)
  expect_equal(unique(tmp$sex), c('Females', 'Both','Males'))
  expect_equal(unique(tmp$description), c('Midler mot karies', 'natriumfluorid'))
  expect_equal(unique(tmp$age), c('10 - 14', '45 - 49','40 - 44','50 - 54','60 - 64','80 - 84','5 - 9','65 - 69'))
  expect_equal(nrow(tmp), 10)
  expect_equal(unique(tmp$year), c(2016,2020,2009,2006,2013,2015,2011))
})
