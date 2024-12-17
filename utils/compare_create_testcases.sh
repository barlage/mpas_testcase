#!/bin/sh -l

# simple script to compare create test cases and produce a report file
#
# when you created the test cases, you chose a "model_code_base" in the format (using names referenced below):
#    test_repo_name - test_hash_to_compare - compile_flag
#
# Steps:
#   1. module load nccmp
#   2. change test_repo_name to your repository name
#   3. change test_hash_to_compare to the hash of your test repository
#   4. change test_directory to the location of your test case output
#   5. change gsl_hash_baseline to the gsl fork hash that you want to compare to, for PRs should be top of develop branch
#   6. run the script: sh compare_create_testcases.sh

##############################
# options that change often
##############################

test_repo_name="gsl"             # repository name
test_hash_to_compare="df234a689" # 9-digit git hash
test_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
gsl_hash_baseline="26ef9904f"    # 9-digit git hash


#####################################
# options that change infrequently
#  no need to change unless ncar baseline changes or baseline directories changes or compile flag changes
#####################################

ncar_hash_baseline="41e9a3fb8" # 9-digit git hash

gsl_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
ncar_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"

# compile flag used
# use "-gsltest"  for intel-mpi-gsltest
# use "-intelmpi" for intel-mpi

compile_flag="-gsltest"

######################################################################
# shouldn't need to change anything below
######################################################################

fileout="compare_create_testcases_$test_hash_to_compare$compile_flag"

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
echo "# compare to NCAR CONUS baselines                                     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.ncar.conus.120km.gfs.2023031015/case_files/"
dir2=$ncar_baseline_directory"ncar-$ncar_hash_baseline$compile_flag/ncar.ncar.conus.120km.gfs.2023031015/case_files/"

file="mpas.gsl.ncar.conus.120km.static.nc"
filencar="mpas.ncar.ncar.conus.120km.static.nc"
echo "  === $file comparison excluding landusef,soilf,lai12m" >> $fileout
nccmp -x landusef,soilf,lai12m -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.conus.120km.gfs.init.2023-03-10_15.00.00.nc"
filencar="mpas.ncar.ncar.conus.120km.gfs.init.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.conus.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
filencar="mpas.ncar.ncar.conus.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.conus.120km.gfs.lbc.2023-03-10_15.00.00.nc"
filencar="mpas.ncar.ncar.conus.120km.gfs.lbc.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to NCAR GLOBAL baselines                                    " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.ncar.global.120km.gfs.2023031015/case_files/"
dir2=$ncar_baseline_directory"ncar-$ncar_hash_baseline$compile_flag/ncar.ncar.global.120km.gfs.2023031015/case_files/"

file="mpas.gsl.ncar.global.120km.static.nc"
filencar="mpas.ncar.ncar.global.120km.static.nc"
echo "  === $file comparison excluding landusef,soilf,lai12m" >> $fileout
nccmp -x landusef,soilf,lai12m -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.global.120km.gfs.init.2023-03-10_15.00.00.nc"
filencar="mpas.ncar.ncar.global.120km.gfs.init.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.global.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
filencar="mpas.ncar.ncar.global.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$filencar >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare GSL code, NCAR namelist, GFS source, CONUS domain           " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.ncar.conus.120km.gfs.2023031015/case_files/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag/gsl.ncar.conus.120km.gfs.2023031015/case_files/"

file="mpas.gsl.ncar.conus.120km.static.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.conus.120km.gfs.init.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.conus.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.conus.120km.gfs.lbc.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo >> $fileout
echo "######################################################################" >> $fileout
echo "# compare GSL code, NCAR namelist, GFS source, GLOBAL domain          " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.ncar.global.120km.gfs.2023031015/case_files/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag/gsl.ncar.global.120km.gfs.2023031015/case_files/"

file="mpas.gsl.ncar.global.120km.static.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.global.120km.gfs.init.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.ncar.global.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo >> $fileout
echo "######################################################################" >> $fileout
echo "# compare GSL code, GSL namelist, GFS source, CONUS domain            " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.gsl.conus.120km.gfs.2023031015/case_files/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag/gsl.gsl.conus.120km.gfs.2023031015/case_files/"

file="mpas.gsl.gsl.conus.120km.static.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.gfs.init.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.gfs.lbc.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.ugwp_oro_data.nc"
echo "  === $file comparison excluding xtime" >> $fileout
nccmp -x xtime -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo >> $fileout
echo "######################################################################" >> $fileout
echo "# compare GSL code, GSL namelist, GFS source, GLOBAL domain           " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.gsl.global.120km.gfs.2023031015/case_files/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag/gsl.gsl.global.120km.gfs.2023031015/case_files/"

file="mpas.gsl.gsl.global.120km.static.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.global.120km.gfs.init.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.global.120km.gfs.sfc_update.2023-03-10_15.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.global.120km.ugwp_oro_data.nc"
echo "  === $file comparison excluding xtime" >> $fileout
nccmp -x xtime -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo >> $fileout
echo "######################################################################" >> $fileout
echo "# compare GSL code, GSL namelist, RAP winter source, CONUS domain     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.gsl.conus.120km.rap.2024020218/case_files/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag/gsl.gsl.conus.120km.rap.2024020218/case_files/"

file="mpas.gsl.gsl.conus.120km.static.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.rap.init.2024-02-02_18.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.rap.lbc.2024-02-02_18.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.ugwp_oro_data.nc"
echo "  === $file comparison excluding xtime" >> $fileout
nccmp -x xtime -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo >> $fileout
echo "######################################################################" >> $fileout
echo "# compare GSL code, GSL namelist, RAP summer source, CONUS domain     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$test_hash_to_compare$compile_flag/gsl.gsl.conus.120km.rap.2024081518/case_files/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag/gsl.gsl.conus.120km.rap.2024081518/case_files/"

file="mpas.gsl.gsl.conus.120km.static.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.rap.init.2024-08-15_18.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.rap.lbc.2024-08-15_18.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

file="mpas.gsl.gsl.conus.120km.ugwp_oro_data.nc"
echo "  === $file comparison excluding xtime" >> $fileout
nccmp -x xtime -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

