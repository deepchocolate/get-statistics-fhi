# Function to recode drug register data into a better format.
recodeLMR <- function (df) {
  colnames(df) <- c('desc', 'sex', 'age', 'year', 'individuals', 'flag')
  # Separate description and ATC code
  pos <- stri_locate_first(df$desc, fixed=' ')[,1]
  atc <- stri_sub(df$desc, 0, pos - 1)
  desc <- stri_sub(df$desc, pos + 3)
  df$atc <- atc
  df$description <- desc
  df$age <- stri_sub(df$age, to=-4)
  ch <- which(df$age == 'Alle al')
  if (length(ch) > 0) df[df$age == 'Alle al',]$age <- 'Any'
  df <- df[, c('atc','description','sex', 'age', 'year', 'individuals', 'flag')]
  sexFac <- c('Begge kj\U00F8nn'='Both', 'Kvinne'='Females', 'Mann'='Males')
  df$sex <- sexFac[df$sex]
  df
}
