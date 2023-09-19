#!/bin/bash -l
#SBATCH -J array-test
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=00:00:05
#SBATCH -A plgprimage4-cpu
#SBATCH -p plgrid
#SBATCH --array=0-1

cd $SLURM_SUBMIT_DIR

echo $SLURM_ARRAY_TASK_ID

