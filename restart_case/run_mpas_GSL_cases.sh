#!/bin/sh -l

# simple script to run the GSL test cases
#
# Steps:
#   1. change model_base_directory to the location of your model executable 
#       (needed for path to parameter files and data tables)
#   2. change model_executable to the name of your executable (optional step)
#       [my approach is to name it atmosphere_model.{version}.{compile flag} but this isn't necessary]
#   3. change model_code_base to be in the format:
#      -  test_repo_name - version_to_compare - compile_flag [e.g., gsl-v8.2.2-1.0-intdebug]
#        -  test_repo_name can be whatever short name you want for your repo
#        -  version_to_compare should be the GSL version number, e.g., v8.2.2-1.0
#        -  currently we are only doing debug tests so compile_flag should be "intdebug"
#   4. change gsl_input_case_base to the location of the gsl case input data 
#        (should be the most recent input data in system_directory below)
#   5. change ncar_input_case_base to the location of the ncar case input data 
#        (shouldn't change often, only when ncar version is updated)
#   6. set system configuration:
#      - partition: xjet for Jet, hera for Hera
#      - account: account to charge, obviously
#      - queue: batch or debug (if you're impatient)
#   7. run the script: sh run_mpas_GSL_cases.sh

model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/gsl-fork/MPAS-Model/"
model_executable="atmosphere_model.v8.3.0-1.13.intdebug"
model_code_base="gsl-restart-v8.3.0-1.13-intdebug"
gsl_input_case_base="gsl-v8.3.0-1.8-intelmpi"
ncar_input_case_base="ncar-v8.3.0-intelmpi"
partition="xjet"
account="gsd-fv3-dev"
queue="batch"

################################################################
################################################################
# shouldn't need to change below this line
################################################################
################################################################

if [ $partition = "xjet" ]; then 
  system_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
elif [ $partition = "hera" ]; then 
  system_directory="/scratch1/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
fi
gsl_input_case_base=$system_directory$gsl_input_case_base/
ncar_input_case_base=$system_directory$ncar_input_case_base/

sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:06:00 run_mpas_case_A1_restart.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:06:00 run_mpas_case_B1_restart.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:06:00 run_mpas_case_E1_restart.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:06:00 run_mpas_case_C5_restart.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:06:00 run_mpas_case_C7_restart.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:06:00 run_mpas_case_C8_restart.sh $model_base_directory $model_executable $model_code_base $gsl_input_case_base
