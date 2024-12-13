#!/bin/sh -l
#
# -- Request nodes and tasks
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=12
#
# -- Specify queue
#SBATCH -q batch
#SBATCH --partition=xjet
#
# -- Specify a maximum wallclock
#SBATCH --time=0:30:00
#
# -- Specify under which account a job should run
#SBATCH --account=gsd-fv3-dev
#
# -- Set the name of the job, or Slurm will default to the name of the script
#SBATCH --job-name=MPAS-test
#
# -- Tell the batch system to set the working directory to the current working directory
#SBATCH --chdir=.

modules="gnu intel/2023.2.0 impi/2023.2.0 pnetcdf/1.12.3"
clean_before="true"
clean_after="true"
case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/ncar-41e9a3fb8/"
executable="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/ncar/intel-mpi/v8.2.2/init_atmosphere_model.41e9a3fb8"
code_base="ncar"
namelist="ncar"
domain="global"
resolution="120km"
source="gfs"
season="winter"
use_climo_aerosols="true"

################################################################
# do some combination checks
################################################################

valid_combination="false"

if [ $code_base  = "ncar"  ] && [ $namelist = "ncar" ] && [ $domain = "conus" ] && 
   [ $resolution = "120km" ] && [ $source   = "gfs"  ]; then 
  valid_combination="true"
fi

if [ $code_base  = "ncar"  ] && [ $namelist = "ncar" ] && [ $domain = "global" ] && 
   [ $resolution = "120km" ] && [ $source   = "gfs"  ]; then 
  valid_combination="true"
fi

if [ $code_base  = "gsl"   ] && [ $namelist = "ncar" ] && [ $domain = "conus" ] && 
   [ $resolution = "120km" ] && [ $source   = "gfs"  ]; then 
  valid_combination="true"
fi

if [ $code_base  = "gsl"   ] && [ $namelist = "ncar" ] && [ $domain = "global" ] && 
   [ $resolution = "120km" ] && [ $source   = "gfs"  ]; then 
  valid_combination="true"
fi

if [ $code_base  = "gsl"   ] && [ $namelist = "gsl" ] && [ $domain = "conus" ] && 
   [ $resolution = "120km" ] && [ $source   = "gfs" ]; then 
  valid_combination="true"
fi

if [ $code_base  = "gsl"   ] && [ $namelist = "gsl" ] && [ $domain = "global" ] && 
   [ $resolution = "120km" ] && [ $source   = "gfs" ]; then 
  valid_combination="true"
fi

if [ $code_base  = "gsl"   ] && [ $namelist = "gsl" ] && [ $domain = "conus"  ] && 
   [ $resolution = "120km" ] && [ $source   = "rap" ] && [ $season = "summer" ]; then 
  valid_combination="true"
fi

if [ $code_base  = "gsl"   ] && [ $namelist = "gsl" ] && [ $domain = "conus"  ] && 
   [ $resolution = "120km" ] && [ $source   = "rap" ] && [ $season = "winter" ]; then 
  valid_combination="true"
fi

if [ $valid_combination = "false" ]; then 
  echo "ERROR: namelist/domain/resolution/source = $namelist/$domain/$resolution/$source not supported"
  exit 1
fi



################################################################
# set the date according to the source data
################################################################

if [ $source = "gfs" ]; then 
  yyyy="2023"
  mm="03"
  dd="10"
  hh="15"
elif [ $source = "rap" ]; then 
  if [ $season = "summer" ]; then 
    yyyy="2024"
    mm="08"
    dd="15"
    hh="18"
  elif [ $season = "winter" ]; then 
    yyyy="2024"
    mm="02"
    dd="02"
    hh="18"
  fi
fi

################################################################
# some things that will be re-used
################################################################

datestring=$yyyy"-"$mm"-"$dd"_"$hh".00.00"
case_directory=$code_base.$namelist.$domain.$resolution.$source.$yyyy$mm$dd$hh
static_file="mpas.$code_base.$namelist.$domain.$resolution.static.nc"
init_file="mpas.$code_base.$namelist.$domain.$resolution.$source.init.$datestring.nc"
lbc_file="mpas.$code_base.$namelist.$domain.$resolution.$source.lbc.$datestring.nc"
sst_file="mpas.$code_base.$namelist.$domain.$resolution.$source.sfc_update.$datestring.nc"
ugwp_file="mpas.$code_base.$namelist.$domain.$resolution.ugwp_oro_data.nc"
script_home=$PWD
source_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/ungrib"

echo
echo "################################################################"
echo "# Configuration settings"
echo "################################################################"
echo "run directory:      $PWD"
echo "modules:            $modules"
echo "case date:          $datestring"
echo "case directory:     $case_base$case_directory"
echo "executable:         $executable"
echo "code_base:          $code_base"
echo "namelist:           $namelist"
echo "domain:             $domain"
echo "resolution:         $resolution"
echo "input source:       $source"
echo "source directory:   $source_directory"
echo "use_climo_aerosols: $use_climo_aerosols"
echo "static_file:        $static_file"
echo "init_file:          $init_file"
echo "lbc_file(conus):    $lbc_file"
echo "sst_file:           $sst_file"
echo "ugwp_file(gsl):     $ugwp_file"

module purge
module load $modules

################################################################
# remove case directory if exists and clean_before is true
################################################################

if [ $clean_before = "true" ]; then 
  if [ -d $case_base$case_directory ]; then 
    echo
    echo "directory $case_base$case_directory exists is being removed"
    rm -Rf $case_base$case_directory
  fi
fi

echo
echo "################################################################"
echo "Start processing time:" `date`
echo "################################################################"

################################################################
# create static file
################################################################

echo
echo "################################################################"
echo "# Start creating: $static_file"
echo "################################################################"

static_directory=$case_base$case_directory/step1_static
if [ ! -d $static_directory ]; then 
  mkdir -p $static_directory
fi
cd $static_directory

if [ -e static.nc ]; then 

echo "static.nc already exists so moving on to next step"

else

cp $script_home/case_files/$namelist/step1_static/* .

if [ $domain = "conus" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/code-MPAS/MPAS-Limited-Area/conus.$resolution.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/code-MPAS/MPAS-Limited-Area/conus.$resolution.grid.nc grid.nc
elif [ $domain = "global" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/$resolution/grid/x1.40962.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/$resolution/grid/x1.40962.grid.nc grid.nc
fi

ln -sf $executable init_atmosphere_model

time srun -n $SLURM_NTASKS ./init_atmosphere_model

if [ ! -e static.nc ]; then 
  echo "ERROR: static.nc was not created"
  exit 2
fi

fi  # static file exist check

################################################################
# create init file
################################################################

echo
echo "################################################################"
echo "# Start creating: $init_file"
echo "################################################################"

init_directory=$case_base$case_directory/step2_init
if [ ! -d $init_directory ]; then 
  mkdir -p $init_directory
fi
cd $init_directory

if [ -e init.nc ]; then 

echo "init.nc already exists so moving on to next step"

else

cp $script_home/case_files/$namelist/step2_init/$source.$yyyy$mm$dd$hh/* .

if [ $domain = "conus" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/code-MPAS/MPAS-Limited-Area/conus.$resolution.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
elif [ $domain = "global" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/$resolution/grid/x1.40962.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
fi

ln -sf $source_directory/$source.$yyyy$mm$dd$hh/*$yyyy-$mm-$dd"_"$hh .
ln -sf $executable init_atmosphere_model
ln -sf ../step1_static/static.nc .

if [ $use_climo_aerosols = "true" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/aerosols/QNWFA_QNIFA_SIGMA_MONTHLY.dat .
fi

time srun -n $SLURM_NTASKS ./init_atmosphere_model

if [ ! -e init.nc ]; then 
  echo "ERROR: init.nc was not created"
  exit 3
fi

fi  # init file exist check

################################################################
# create lbc file
################################################################

if [ $domain = "conus" ]; then 

echo
echo "################################################################"
echo "# Start creating: $lbc_file"
echo "################################################################"

lbc_directory=$case_base$case_directory/step3_lbc
if [ ! -d $lbc_directory ]; then 
  mkdir -p $lbc_directory
fi
cd $lbc_directory

if [ -e lbc.nc ]; then 

echo "lbc.nc already exists so moving on to next step"

else

cp $script_home/case_files/$namelist/step3_lbc/$source.$yyyy$mm$dd$hh/* .


ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/code-MPAS/MPAS-Limited-Area/conus.$resolution.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
ln -sf $source_directory/$source.$yyyy$mm$dd$hh/* .
ln -sf $executable init_atmosphere_model
ln -sf ../step2_init/init.nc .

if [ $use_climo_aerosols = "true" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/aerosols/QNWFA_QNIFA_SIGMA_MONTHLY.dat .
fi

time srun -n $SLURM_NTASKS ./init_atmosphere_model

if [ ! -e lbc.nc ]; then 
  echo "ERROR: lbc.nc was not created"
  exit 4
fi

fi  # lbc file exist check

fi  # domain = conus

################################################################
# create sst file (only for gfs data)
################################################################

if [ $source = "gfs" ]; then 

echo
echo "################################################################"
echo "# Start creating: $sst_file"
echo "################################################################"

sst_directory=$case_base$case_directory/step4_sst
if [ ! -d $sst_directory ]; then 
  mkdir -p $sst_directory
fi
cd $sst_directory

if [ -e sfc_update.nc ]; then 

echo "sfc_update.nc already exists so moving on to next step"

else

cp $script_home/case_files/$namelist/step4_sst/$source.$yyyy$mm$dd$hh/* .

if [ $domain = "conus" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/code-MPAS/MPAS-Limited-Area/conus.$resolution.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
elif [ $domain = "global" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/$resolution/grid/x1.40962.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
fi

ln -sf $source_directory/sst.$yyyy$mm$dd$hh/SST* .
ln -sf $executable init_atmosphere_model
ln -sf ../step2_init/init.nc .

time srun -n $SLURM_NTASKS ./init_atmosphere_model

if [ ! -e sfc_update.nc ]; then 
  echo "ERROR: sfc_update was not created"
  exit 5
fi

fi  # sst file exist check

fi  # source = gfs

################################################################
# move files to central location
################################################################

final_directory=$case_base$case_directory/case_files
mkdir -p $final_directory
cd $final_directory

echo
echo "################################################################"
echo "# Move files to: $final_directory"
echo "################################################################"

mv ../step1_static/static.nc $static_file
mv ../step1_static/log* ./log.static
if [ $namelist = "gsl" ]; then 
 mv ../step1_static/ugwp_oro_data.nc $ugwp_file
fi
mv ../step2_init/init.nc $init_file
mv ../step2_init/log* ./log.init
if [ $domain = "conus" ]; then 
 mv ../step3_lbc/lbc.nc $lbc_file
 mv ../step3_lbc/log* ./log.lbc
fi
if [ $source = "gfs" ]; then 
 mv ../step4_sst/sfc_update.nc $sst_file
 mv ../step4_sst/log* ./log.sst
fi

echo "These files were created with:" > description
echo "modules:            $modules" >> description
echo "executable:         $executable" >> description
echo "use_climo_aerosols: $use_climo_aerosols" >> description
echo "intermediate files: $source_directory" >> description

if [ $clean_after = "true" ]; then 
  
  echo
  echo "################################################################"
  echo "# Cleaning up run directories"
  echo "################################################################"

  rm -Rf ../step1_static
  rm -Rf ../step2_init
  if [ $domain = "conus" ]; then 
   rm -Rf ../step3_lbc
  fi
  if [ $source = "gfs" ]; then 
   rm -Rf ../step4_sst
  fi
  
fi

echo
echo "################################################################"
echo "# Successful completion of case: $code_base.$namelist.$domain.$resolution.$source.$yyyy$mm$dd$hh"
echo "################################################################"

echo
echo "################################################################"
echo "End processing time:" `date`
echo "################################################################"
