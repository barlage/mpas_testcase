#!/bin/bash

#SBATCH --ntasks=4
#SBATCH --time=0:30:00
#SBATCH --job-name=ideal_run

nt=$SLURM_NTASKS

module load gnu/13.2.0
module load intel/2023.2.0
module load impi/2023.2.0
module load pnetcdf/1.12.3
export PNETCDF=/apps/pnetcdf/1.12.3/intel_2023.2.0-impi/						       

srun -n $nt ./atmosphere_model
