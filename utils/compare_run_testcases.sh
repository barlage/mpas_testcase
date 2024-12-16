#!/bin/sh -l

# 9-digit git hash

gsl_hash_to_compare="df234a689"
gsl_hash_baseline="26ef9904f"
ncar_hash_baseline="41e9a3fb8"

# compile flag used
# use "-gsltest"  for intel-mpi-gsltest
# use "-intelmpi" for intel-mpi
# use "-debug"    for intel-mpi + debug

compile_flag="-debug"

gsl_test_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/mpas_testcase/run_case/"
gsl_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"
ncar_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/run_case/"

fileout="compare_run_testcases_$gsl_hash_to_compare$compile_flag"

echo "" > $fileout
echo " gsl_hash_to_compare = $gsl_hash_to_compare" >> $fileout
echo " gsl_hash_baseline   = $gsl_hash_baseline" >> $fileout
echo "ncar_hash_baseline   = $ncar_hash_baseline" >> $fileout
echo "        compile_flag = $compile_flag" >> $fileout
echo "" >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS mesoscale_reference baselines A1GSL   " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.mesoscale_reference.ncar.ncar.conus.120km.gfs.2023031015/"

file="history.2023-03-10_16.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS hrrrv5 GFS baselines C5GSL            " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.gfs.2023031015/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.gfs.2023031015/"

file="history.2023-03-10_16.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS hrrrv5 RAP winter baselines C7GSL     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024020218/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024020218/"

file="history.2024-02-02_19.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to previous GSL CONUS hrrrv5 RAP winter baselines C8GSL     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024081518/"
dir2=$gsl_baseline_directory"gsl-$gsl_hash_baseline$compile_flag.hrrrv5.gsl.gsl.conus.120km.rap.2024081518/"

file="history.2024-08-15_19.00.00.nc"
echo "  === $file comparison" >> $fileout
nccmp -dsSqf $dir1$file $dir2$file >> $fileout
echo >> $fileout

