#!/bin/sh -l

# simple script to compare run test cases and produce a report file
#
# when you ran the test cases, you chose a "model_code_base" in the format (using names referenced below):
#    test_repo_name - version_to_compare - compile_flag
#
# Steps:
#   1. module load nccmp
#   2. change test_repo_name to your repository name
#   3. change version_to_compare to the version of your test repository, e.g., v8.2.2-1.0
#   4. change test_directory to the location of your test case output
#   5. change gsl_version_baseline to the gsl fork version that you want to compare to, for PRs should be top of develop branch
#   6. change partition to either "xjet" or "hera"
#   6. run the script: sh compare_run_testcases.sh

##############################
# options that change often
##############################

test_repo_name="gsl"                # repository name
version_to_compare="v8.3.0-1.8"     # GSL version proposed for this PR
test_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baseline_factory/mpas_testcase/run_case/"
gsl_version_baseline="v8.3.0-1.6"   # GSL version of current develop
partition="xjet"                    # xjet or hera

#####################################
# options that change infrequently
#  no need to change unless ncar baseline changes or baseline directories changes or compile flag changes
#####################################

ncar_version_baseline="v8.3.0" # NCAR version

if [ $partition = "xjet" ]; then 
  gsl_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"
  ncar_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"
elif [ $partition = "hera" ]; then 
  gsl_baseline_directory="/scratch1/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"
  ncar_baseline_directory="/scratch1/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"
fi

# compile flag used
# use "-gsltest"  for intel-mpi-gsltest
# use "-intelmpi" for intel-mpi
# use "-intdebug" for intel-mpi + debug

compile_flag="-intdebug"

######################################################################
# shouldn't need to change anything below
######################################################################

fileout="compare_run_testcases_final_$version_to_compare$compile_flag"

echo "" > $fileout
echo "     version_to_compare = $version_to_compare" >> $fileout
echo "   gsl_version_baseline = $gsl_version_baseline" >> $fileout
echo "  ncar_version_baseline = $ncar_version_baseline" >> $fileout
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

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_version_baseline$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

echo "#############################################################################" >> $fileout
echo "# compare to previous GSL CONUS convection_permitting_none baselines F1GSL   " >> $fileout
echo "#############################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.convection_permitting_none.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_version_baseline$compile_flag.convection_permitting_none.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

echo "#############################################################################" >> $fileout
echo "# compare to previous GSL CONUS mesoscale_reference_noahmp baselines E1GSL   " >> $fileout
echo "#############################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.mesoscale_reference_noahmp.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_version_baseline$compile_flag.mesoscale_reference_noahmp.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_version_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024020218/"
dir2=$gsl_baseline_directory"gsl-$gsl_version_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024020218/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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
echo "# compare to previous GSL CONUS hrrrv5 RAP summer baselines C8GSL     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024081518/"
dir2=$gsl_baseline_directory"gsl-$gsl_version_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024081518/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

echo "########################################################################" >> $fileout
echo "# compare to previous NCAR CONUS mesoscale_reference baselines A1NCAR   " >> $fileout
echo "########################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$ncar_baseline_directory"ncar-$ncar_version_baseline$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

echo "########################################################################" >> $fileout
echo "# compare to previous NCAR CONUS convection_permitting baselines B1NCAR   " >> $fileout
echo "########################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.convection_permitting.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$ncar_baseline_directory"ncar-$ncar_version_baseline$compile_flag.convection_permitting.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

echo "###############################################################################" >> $fileout
echo "# compare to previous NCAR CONUS convection_permitting_none baselines F1NCAR   " >> $fileout
echo "###############################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.convection_permitting_none.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$ncar_baseline_directory"ncar-$ncar_version_baseline$compile_flag.convection_permitting_none.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

echo "###############################################################################" >> $fileout
echo "# compare to previous NCAR CONUS mesoscale_reference_noahmp baselines E1NCAR   " >> $fileout
echo "###############################################################################" >> $fileout
echo >> $fileout

dir1=$test_directory"$test_repo_name-$version_to_compare$compile_flag.mesoscale_reference_noahmp.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$ncar_baseline_directory"ncar-$ncar_version_baseline$compile_flag.mesoscale_reference_noahmp.ncar.ncar.conus.120km.gfs.2023031015/"

if [ ! -d $dir1 ]; then 
  echo
  echo "directory $dir1 does not exist"
  exit
fi

if [ ! -d $dir2 ]; then 
  echo
  echo "directory $dir2 does not exist"
  exit
fi

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

