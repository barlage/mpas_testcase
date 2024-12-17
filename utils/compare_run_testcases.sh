#!/bin/sh -l

# simple script to compare run test cases and produce a report file
#
# when you ran the test cases, you chose a "model_code_base" in the format (using names referenced below):
#    test_repo_name - test_hash_to_compare - compile_flag
#
# Steps:
#   1. module load nccmp
#   2. change test_repo_name to your repository name
#   3. change test_hash_to_compare to the hash of your test repository
#   4. change test_directory to the location of your test case output
#   5. change gsl_hash_baseline to the gsl fork hash that you want to compare to, for PRs should be top of develop branch
#   6. run the script: sh compare_run_testcases.sh

##############################
# options that change often
##############################

test_repo_name="joe"             # repository name
test_hash_to_compare="6b9226531" # 9-digit git hash
test_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/mpas_testcase/run_case/"
gsl_hash_baseline="26ef9904f" # 9-digit git hash


#####################################
# options that change infrequently
#  no need to change unless ncar baseline changes or baseline directories changes or compile flag changes
#####################################

ncar_hash_baseline="41e9a3fb8" # 9-digit git hash

gsl_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"
ncar_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"

# compile flag used
# use "-gsltest"  for intel-mpi-gsltest
# use "-intelmpi" for intel-mpi
# use "-debug"    for intel-mpi + debug

compile_flag="-debug"

######################################################################
# shouldn't need to change anything below
######################################################################

fileout="compare_run_testcases_$test_hash_to_compare$compile_flag"

echo "" > $fileout
echo "   test_hash_to_compare = $test_hash_to_compare" >> $fileout
echo "      gsl_hash_baseline = $gsl_hash_baseline" >> $fileout
echo "     ncar_hash_baseline = $ncar_hash_baseline" >> $fileout
echo "         test_directory = $test_directory" >> $fileout
echo " gsl_baseline_directory = $gsl_baseline_directory" >> $fileout
echo "ncar_baseline_directory = $ncar_baseline_directory" >> $fileout
echo "           compile_flag = $compile_flag" >> $fileout
echo "         test_repo_name = $test_repo_name" >> $fileout
echo "" >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS mesoscale_reference baselines A1GSL   " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"

file="history.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2023-03-10_15.12.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2023-03-10_16.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS hrrrv5 GFS baselines C5GSL            " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.gfs.2023031015/"

file="history.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2023-03-10_15.12.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2023-03-10_16.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS hrrrv5 RAP winter baselines C7GSL     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024020218/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024020218/"

file="history.2024-02-02_18.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2024-02-02_18.12.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2024-02-02_19.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS hrrrv5 RAP winter baselines C8GSL     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024081518/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024081518/"

file="history.2024-08-15_18.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2024-08-15_18.12.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="history.2024-08-15_19.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

