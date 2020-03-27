### * Description

# This script runs covr::package_coverage() and parse the returned value to download a
# badge from https://shields.io/

### * Run

library(covr)
library(here)

# Run covr
cov = package_coverage()
report(cov, file.path(here::here(), "docs/coverage/coverage.html"))
print(paste("Coverage_percent: --", round(percent_coverage(cov), 2), "--"))

cov <- round(percent_coverage(cov), 2)

# Get the badge
SITE = "https://img.shields.io/badge/"
MAIN = "coverage"
STATUS = paste0(cov, "%")
COLOR = "lightgrey"
## Parse the check results
if (cov < 50) {
    COLOR = "red"
}
if (cov > 70) {
    COLOR = "orange"
}
if (cov > 80) {
    COLOR = "yellow"
}
if (cov > 90) {
    COLOR = "green"
}
if (cov > 95) {
    COLOR = "brightgreen"
}

## Download the badge
target = paste(c(MAIN, STATUS, COLOR), collapse = "-")
target = gsub(" ", "%20", target)
link = paste0(c(SITE, target, ".svg"), collapse = "")
print("Badge for coverage downloaded from:")
print(link)
command = paste0("wget \"", link, "\" -O coverage_badge.svg")
system(command)
