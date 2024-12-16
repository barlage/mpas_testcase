#!/bin/sh -l

# 9-digit git hash

gsl_hash_to_compare="df234a689"
gsl_hash_baseline="26ef9904f"
ncar_hash_baseline="41e9a3fb8"

# compile flag used
# use "-gsltest"  for intel-mpi-gsltest
# use "-intelmpi" for intel-mpi

compile_flag="-gsltest"

gsl_test_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
gsl_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"
ncar_baseline_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/"

fileout="compare_init_testcases_$gsl_hash_to_compare$compile_flag"

echo "" > $fileout
echo " gsl_hash_to_compare = $gsl_hash_to_compare" >> $fileout
echo " gsl_hash_baseline   = $gsl_hash_baseline" >> $fileout
echo "ncar_hash_baseline   = $ncar_hash_baseline" >> $fileout
echo "        compile_flag = $compile_flag" >> $fileout
echo "" >> $fileout

echo "######################################################################" >> $fileout
echo "# compare to NCAR CONUS baselines                                     " >> $fileout
echo "######################################################################" >> $fileout
echo >> $fileout

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.ncar.conus.120km.gfs.2023031015/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.ncar.global.120km.gfs.2023031015/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.ncar.conus.120km.gfs.2023031015/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.ncar.global.120km.gfs.2023031015/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.gsl.conus.120km.gfs.2023031015/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.gsl.global.120km.gfs.2023031015/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.gsl.conus.120km.rap.2024020218/case_files/"
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

dir1=$gsl_test_directory"gsl-$gsl_hash_to_compare$compile_flag/gsl.gsl.conus.120km.rap.2024081518/case_files/"
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

