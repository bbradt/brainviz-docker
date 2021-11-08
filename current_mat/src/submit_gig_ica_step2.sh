#!/bin/bash
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 31
#SBATCH --mem=100g
#SBATCH -p qTRD
#SBATCH -t 1440
#SBATCH -J bottles
#SBATCH -e ../results/log/error_%A.err
#SBATCH -o ../results/log/out_%A.out
#SBATCH -A PSYC0002
#SBATCH --oversubscribe
#SBATCH -x trendscn006.rs.gsu.edu 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=msalman@gsu.edu

sleep 10s

export OMP_NUM_THREADS=1
export MODULEPATH=/apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles/ 
echo $HOSTNAME >&2

module load Framework/Matlab2019a
time matlab -batch gig_ica_step2

sleep 10s
