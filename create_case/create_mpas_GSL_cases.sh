#!/bin/sh -l

# simple script to create the GSL test cases
#
# Steps:
#   1. change case_base to the location where you want the cases created, the final directory should be in the format:
#      -  test_repo_name - version_to_compare - compile_flag
#      -  test_repo_name can be whatever short name you want for your repo
#      -  version_to_compare should be the GSL version number, e.g., v8.2.2-1.0
#      -  currently we are only doing intel-mpi tests so compile_flag should be "intelmpi"
#   2. change executable to the full path of your executable 
#       [my approach is to name it init_atmosphere_model.{version}.{compile flag} but this isn't necessary]
#   3. run the script: sh create_mpas_GSL_cases.sh

case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/gsl-v8.2.2-1.1-intelmpi/"
executable="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/gsl-fork/MPAS-Model/init_atmosphere_model.v8.2.2-1.1.intelmpi"

sbatch create_mpas_testcase_case03.sh $case_base $executable
sbatch create_mpas_testcase_case04.sh $case_base $executable
sbatch create_mpas_testcase_case05.sh $case_base $executable
sbatch create_mpas_testcase_case06.sh $case_base $executable
sbatch create_mpas_testcase_case07.sh $case_base $executable
sbatch create_mpas_testcase_case08.sh $case_base $executable
