#!/bin/bash
# echo 'OSUCH result reproduction'
# cat ../results/log/out2916115-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 

# echo 'zfu_ica_nm_ref BP/MDD'
# cat ../results/log/zfu_ica_nm_ref_log/out3055849-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# echo 'zfu_ica_nm_ref BP/MDD/nonresponders'
# cat ../results/log/zfu_ica_nm_ref_log/out3051938-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# echo 'zfu_ica_nm_ref MDD/nonresponders'
# cat ../results/log/zfu_ica_nm_ref_log/out3057859-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# # aggregate log
# cat ../results/log/zfu_ica_nm_ref_log/out3057859-*.out | grep 'best IC in' | sort | uniq -c > ../results/line7.txt
# echo 'zfu_ica_nm_ref BP/nonresponders'
# cat ../results/log/zfu_ica_nm_ref_log/out3057276-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# cat ../results/log/zfu_ica_nm_ref_log/out3057276-*.out | grep 'best IC in' | sort | uniq -c > ../results/line2.txt

# echo 'zfu_prep_nm_ref'
# cat ../results/log/zfu_prep_nm_ref_log/out3065848-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 

# echo 'zfu_ica_nm_ref BP/MDD using top 1% SM' 
# cat ../results/log/zfu_ica_nm_ref_top1pc_log/out3096028-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 

# echo 'zfu_ica_nm_ref BP/MDD using FNC'
# cat ../results/log/zfu_ica_nm_ref_fnc_log/out3339242-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 

# echo 'zfu_ica_nm_ref BP/MDD using 1% SM+FNC'  
# cat ../results/log/zfu_ica_nm_ref_nulti_log/out3338270-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# cat ../results/log/zfu_ica_nm_ref_nulti_log/out3338270-*.out | grep 'best IC in' | sort | uniq -c > ../results/line5.txt

# echo 'zfu_ica_nm_ref BP/NC using 1% SM+FNC'
# cat ../results/log/zfu_ica_nm_ref_log/out3374936-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# cat ../results/log/zfu_ica_nm_ref_log/out3374936-*t | grep 'best IC in' | sort | uniq -c > ../results/line8.txt

# echo 'zfu_ica_nm_ref MDD/NC using 1% SM+FNC'
# cat ../results/log/zfu_ica_nm_ref_log/out3374887-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
# cat ../results/log/zfu_ica_nm_ref_log/out3374887-*.out | grep 'best IC in' | sort | uniq -c > ../results/line6.txt

echo 'LA5c BP/NC using 1% SM'
cat ../results/log/la5c_sm_log/out3439376-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
echo 'LA5c BP/NC using FNC'
cat ../results/log/la5c_fnc_log/out3439376-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
echo 'LA5c BP/NC using 1% SM+FNC'
cat ../results/log/la5c_multi_log/out3439376-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 

echo 'EMBARC MDD/NC using 1% SM'
cat ../results/log/embarc_sm_log/out3439376-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
echo 'EMBARC MDD/NC using FNC'
cat ../results/log/embarc_fnc_log/out3439376-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
echo 'EMBARC MDD/NC using 1% SM+FNC'
cat ../results/log/embarc_multi_log/out3439376-* | grep "acc:" | awk '{print $NF}' | Rscript run_average.R 
