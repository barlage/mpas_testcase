#!/bin/sh -l

# simple script to run the GSL test cases
#
# Steps:
#   1. change model_base_directory to the location of your model executable
#   2. change model_executable to the name of your executable 
#       [my approach is to name it atmosphere_model.{version}.{compile flag} but this isn't necessary]
#   3. change model_code_base to be in the format:
#      -  test_repo_name - version_to_compare - compile_flag
#      -  test_repo_name can be whatever short name you want for your repo
#      -  version_to_compare should be the GSL version number, e.g., v8.2.2-1.0
#      -  currently we are only doing debug tests so compile_flag should be "intdebug"
#   4. change gsl_input_case_base to the location of the gsl case input data (should be the most recent input data)
#   5. change ncar_input_case_base to the location of the ncar case input data (shouldn't change often)
#   6. run the script: sh run_mpas_GSL_cases.sh

model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/gsl-fork/MPAS-Model/"
model_executable="atmosphere_model.v8.2.2-2.0.intdebug"
model_code_base="gsl-v8.2.2-2.0-intdebug"
gsl_input_case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/gsl-v8.2.2-2.0-intelmpi/"
ncar_input_case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/ncar-v8.2.2-intelmpi/"

sbatch run_mpas_case_A1GSL.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch run_mpas_case_B1GSL.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch run_mpas_case_C5GSL.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
sbatch run_mpas_case_C7GSL.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
sbatch run_mpas_case_C8GSL.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
