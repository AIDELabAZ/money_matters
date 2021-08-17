# Money Matters: The Role of Yields and Profits in Agricultural Technology Adoption

This repository contains the data and Stata programs (version 14) required to replicate the tables and figures in Money Matters as well as the associated appendices. The programs generate all summary tables and figures. In order to construct the final regression tables, some manual editing (and copying/pasting across les) is required, so we do not reproduce them here. However, all relevant numbers are in the regression output generated by the programs files listed below.

The programs are as follows:
- `mm_master_program.do` replicates the all tables and graphics in the paper. This program will run all subsidiary `.do` files.
- `mm_pub_tables.do` replicates the regression results in the paper and the appendix. Specifically Tables 3-5 and B1-D1. Plus Figures 2-4 which are generated using regression results.
- `mm sum stats.do` replicates the summary statistics tables plus MW-tests in the paper and the appendix. Specifically Tables 1-2, 6, and A1.
- `mm graphs.do` replicates Figures 1, A1-A3.

The data are included in `mm.dta`. Several of the programs produce additional data files as inputs into regressions contained in the `.do` files.

Note that the code requires installing the Stata package `randcoef` as discussed in Barriga Cabanillas et al. (2018) and `tuple`.

## References
Barriga Cabanillas, O., J. D. Michler, A. Michuda, and E. Tjernström (2018). Fitting and interpreting correlated random-coecient models using Stata. Stata Journal 18 (1), 159-73.
Michler, J.D, E. Tjernström, S. Verkaart, and K. Mausch (2019). Money matters: The role of yields and profits in agricultural technology adoption. American Journal of Agricultural Economics 101 (3): 710-31.
