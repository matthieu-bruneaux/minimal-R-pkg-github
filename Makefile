### * Setup

TOP_DIR=$(shell git rev-parse --show-toplevel)

### ** Colors

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# https://en.wikipedia.org/wiki/ANSI_escape_code
RED = "\\033[31m"
GREEN = "\\033[92m"
BLUE = "\\033[94m"
YELLOW = "\\033[33m"
NC = "\\033[0m"

### * Rules

### ** help (default rule)

# http://swcarpentry.github.io/make-novice/08-self-doc/
# https://stackoverflow.com/questions/19129485/in-linux-is-there-a-way-to-align-text-on-a-delimiter
.PHONY: help
help: Makefile
	@printf "\n"
	@printf "Please use 'make <target>' where <target> is one of\n"
	@printf "\n"
	@sed -n 's/^## /    /p' $< | column -t -s ":"

### ** document

## document : generate package documentation using roxygen2
.PHONY: document
document:
	@printf "\n"
	@printf "$(GREEN)=== Generating package documentation with roxygen2 ===$(NC)\n"
	@printf "\n"
	@Rscript -e 'devtools::document()'

### ** install

## install : install the package (also runs "document")
.PHONY: install
install: document onlyinstall
	@printf "\n"
	@printf "$(GREEN)=== Package installed ===$(NC)\n"
	@printf "\n"

### ** [onlyinstall]

##onlyinstall : only install the package (no "document")
.PHONY: onlyinstall
onlyinstall:
	@printf "\n"
	@printf "$(GREEN)=== Installing the package ===$(NC)\n"
	@printf "\n"
	@Rscript -e 'devtools::install()'

### ** test

## test : run package tests
.PHONY: test
test:
	@printf "\n"
	@printf "$(GREEN)=== Running package tests ===$(NC)\n"
	@printf "\n"
	@Rscript -e "library(devtools); test()"
	@cd tests/testthat; rm -f Rplots.pdf

### ** check

## check : run R CMD CHECK through devtools::check() function
.PHONY: check
check:
	@printf "\n"
	@printf "$(GREEN)=== Running 'devtools::check()' ===$(NC)\n"
	@printf "\n"
	@Rscript .run_check_and_get_badge.R

### ** coverage

## coverage : determine test coverage
.PHONY: coverage
coverage:
	@printf "\n"
	@printf "$(GREEN)=== Determining test coverage ===$(NC)\n"
	@printf "\n"
	@mkdir -p docs/coverage/
	@Rscript -e "library(covr); cov = package_coverage(); report(cov, \"$(TOP_DIR)/docs/coverage/coverage.html\"); print(paste(\"Coverage_percent: --\", round(percent_coverage(cov), 2), \"--\"))"

### ** pkgdown

## pkgdown : build the package website using pkgdown
.PHONY: pkgdown
pkgdown: document
	@printf "\n"
	@printf "$(GREEN)=== Building the package website with pkgdown ===$(NC)\n"
	@printf "\n"
	@Rscript -e 'pkgdown::build_site()'

### ** uninstall

## uninstall : uninstall the package
.PHONY: uninstall
uninstall:
	@printf "\n"
	@printf "$(GREEN)=== Uninstalling the package ===$(NC)\n"
	@printf "\n"
	@Rscript -e 'tryCatch(remove.packages("minpkg"), error = function(e) {})'

### ** clean

## clean : delete all files and folders generated during the building process
.PHONY: clean
clean: clean-man clean-vignettes clean-docs
	@printf "\n"
	@printf "$(GREEN)=== Cleaned generated files and folders ===$(NC)\n"
	@printf "\n"

### ** [clean-man]

##clean-man : delete documentation generated by Roxygen
.PHONY: clean-man
clean-man:
	@rm -f man/*

### ** [clean-vignettes]

##clean-vignettes : clean the vignettes folder
.PHONY: clean-vignettes
clean-vignettes:
	@cd vignettes; rm -f *.html *.pdf *.rds *.RData

### ** [clean-docs]

##clean-docs : delete documentation generated by pkgdown
.PHONY: clean-docs
clean-docs:
	@rm -fr docs/*
	@rm -f R-CMD-check_badge.svg R-CMD-check_output.txt

### ** rehearse

## rehearse : uninstall, clean, install, pkgdown and check (useful before 'git push')
.PHONY: rehearse
rehearse: uninstall clean install test pkgdown check