#!/bin/sh -l

# simple script to run the NCAR test cases
#
# Steps:
#   1. change model_base_directory to the location of your model executable 
#       (needed for path to parameter files and data tables)
#   2. change model_executable to the name of your executable (optional step)
#       [my approach is to name it atmosphere_model.{version}.{compile flag} but this isn't necessary]
#   3. change model_code_base to be in the format:
#      -  test_repo_name - version_to_compare - compile_flag [e.g., ncar-v8.3.0-intdebug]
#   4. change ncar_input_case_base to the location of the ncar case input data 
#        (shouldn't change often, only when ncar version is updated)
#   5. set system configuration:
#      - partition: xjet for Jet, u1-compute for Ursa
#      - account: account to charge, obviously
#      - queue: batch or debug (if you're impatient)
#   6. run the script: sh run_mpas_NCAR_cases.sh

model_base_directory="/scratch4/BMC/wrfruc/Michael.Barlage/mpas/code/ncar/MPAS-Model/"
model_executable="atmosphere_model.v8.3.0.intdebug"
model_code_base="ncar-v8.3.0-intdebug"
ncar_input_case_base="ncar-v8.3.0-intelmpi"
partition="u1-compute"
account="gsd-fv3-dev"
queue="batch"

################################################################
################################################################
# shouldn't need to change below this line
################################################################
################################################################

if [ $partition = "xjet" ]; then 
  system_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
elif [ $partition = "u1-compute" ]; then 
  system_directory="/scratch4/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
fi
ncar_input_case_base=$system_directory$ncar_input_case_base/

sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:02:00 --mem=8g run_mpas_case_A1NCAR.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:02:00 --mem=8g run_mpas_case_B1NCAR.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:02:00 --mem=8g run_mpas_case_F1NCAR.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
sbatch --account=$account --qos=$queue --partition=$partition --ntasks=4 --time=0:02:00 --mem=8g run_mpas_case_E1NCAR.sh $model_base_directory $model_executable $model_code_base $ncar_input_case_base
