#!/bin/sh -l

model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/joe-fork/"
model_executable="atmosphere_model.6b9226531.debug"
model_code_base="joe-6b9226531-debug"
gsl_input_case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/gsl-26ef9904f-intelmpi/"
ncar_input_case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/ncar-41e9a3fb8-intelmpi/"

sbatch run_mpas_case_A1GSL.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch run_mpas_case_B1GSL.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch run_mpas_case_C5GSL.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
sbatch run_mpas_case_C7GSL.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
sbatch run_mpas_case_C8GSL.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
