test_that('Endpoints', {
  ur <- API_URL
  expect_equal(endpointSources(), ur %s+% '/Common/source')
  expect_equal(endpointSource('lmr'), ur %s+% '/lmr/Table')
  expect_equal(endpointTableMeta('lmr', 1), ur %s+% '/lmr/Table/1')
  expect_equal(endpointTableDesc('lmr', 1), ur %s+% '/lmr/Table/1/query')
  expect_equal(endpointTableData('lmr', 1), ur %s+% '/lmr/Table/1/data')
})
