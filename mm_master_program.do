* Michler et al., 2018
*	THIS FILE PRODUCES ALL EMPIRICAL RESULTS IN THE PAPER 

version 14
clear all
set more off
#delimit cr
set mem 500m
set matsize 800
cap log c

// SET CD PATH
cd "`=c(pwd)'"

****************************************
*--->PROGRAM FILES FOR GENERATING OUTPUT
****************************************

// RUN REGRESSION ANALYSIS
*	OUTPUT: TABLE 3, 4, 5, B1, B2, C1, C2, D1 AND FIGURE 2, 3, 4
do mm_pub_tables

// GENERATE SUMMARY STATS TABLES
*	OUTPUT: TABLE 1, 2, 6, A1
do mm_sum_stats

// GENERATE SUMMARY FIGURES
*	OUTPUT: FIGURE 1, A1, A2, A3
do mm_graphs
