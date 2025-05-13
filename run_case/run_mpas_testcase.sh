#!/bin/sh -l
#
# -- Request nodes and tasks
#SBATCH --ntasks=4
#
# -- Specify queue
#SBATCH -q batch
#SBATCH --partition=xjet
#
# -- Specify a maximum wallclock
#SBATCH --time=0:02:00
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

################################################################
# model options
################################################################

model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/gsl-fork/MPAS-Model/"
model_executable="atmosphere_model"
model_code_base="gsl-test-intdebug"
physics_suite="mesoscale_reference"
run_directory=""
namelist_version="ncar"

################################################################
# input file options
################################################################

input_case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/baselines_mpas/create_case/ncar-v8.2.2-intelmpi/"
input_code_base="ncar"
input_namelist="ncar"
resolution="120km"
domain="conus"
source="gfs"
season="summer"


################################################################
################################################################
# shouldn't need to change below this line
################################################################
################################################################


################################################################
# do some checks
################################################################

if [ $source = "rap" ] && [ $domain = "global" ]; then 
  echo "ERROR: global domain incompatible with RAP input"
  exit 6
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
input_case_directory=$input_code_base.$input_namelist.$domain.$resolution.$source.$yyyy$mm$dd$hh
static_file="mpas.$input_code_base.$input_namelist.$domain.$resolution.static.nc"
init_file="mpas.$input_code_base.$input_namelist.$domain.$resolution.$source.init.$datestring.nc"
lbc_file="mpas.$input_code_base.$input_namelist.$domain.$resolution.$source.lbc.$datestring.nc"
sst_file="mpas.$input_code_base.$input_namelist.$domain.$resolution.$source.sfc_update.$datestring.nc"
ugwp_file="mpas.$input_code_base.$input_namelist.$domain.$resolution.ugwp_oro_data.nc"
script_home=$PWD
if [ $SLURM_JOB_PARTITION = "xjet" ]; then 
  system_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas"
elif [ $SLURM_JOB_PARTITION = "hera" ]; then 
  system_directory="/scratch1/BMC/wrfruc/Michael.Barlage/mpas"
fi

if [ $clean_before = "true" ]; then 
  run_directory=$model_code_base.$physics_suite.$input_case_directory
fi

echo
echo "################################################################"
echo "# Configuration settings"
echo "################################################################"
echo "run directory:      $run_directory"
echo "modules:            $modules"
echo "case date:          $datestring"
echo "executable:         $model_base_directory$model_executable"
echo "physics suite:      $physics_suite"
echo "namelist version:   $namelist_version"
echo "model code name:    $model_code_base"
echo "case directory:     $input_case_base$input_case_directory"
echo "system directory:   $system_directory"

module purge
module load $modules

################################################################
# remove case directory if exists and clean_before is true
################################################################

if [ $clean_before = "true" ]; then 
  if [ -d $run_directory ]; then 
    echo
    echo "directory $run_directory exists is being removed"
    rm -Rf $run_directory
  fi
fi

if [ ! -d $run_directory ]; then 
  mkdir -p $run_directory
fi
cd $run_directory

echo
echo "################################################################"
echo "# Start setting up case directory"
echo "################################################################"

ln -sf $model_base_directory/src/core_atmosphere/physics/physics_wrf/files/*.TBL .
ln -sf $model_base_directory/src/core_atmosphere/physics/physics_wrf/files/*.DBL .
ln -sf $model_base_directory/src/core_atmosphere/physics/physics_wrf/files/*DATA .
ln -sf $model_base_directory/src/core_atmosphere/physics/physics_noahmp/parameters/NoahmpTable.TBL .

if [ $domain = "conus" ]; then 
  ln -sf $system_directory/code-MPAS/MPAS-Limited-Area/conus.$resolution.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
elif [ $domain = "global" ]; then 
  ln -sf $system_directory/data/$resolution/grid/x1.40962.graph.info.part.$SLURM_NTASKS graph.info.part.$SLURM_NTASKS
fi

ln -sf $model_base_directory$model_executable atmosphere_model

ln -sf $input_case_base$input_case_directory/case_files/$init_file mpas.init.nc
if [ $domain = "conus" ]; then 
 ln -sf $input_case_base$input_case_directory/case_files/$lbc_file mpas.lbc.nc
fi
if [ $source = "gfs" ]; then 
 ln -sf $input_case_base$input_case_directory/case_files/$sst_file mpas.sfc_update.nc
fi
if [ $namelist_version = "gsl" ]; then 
 ln -sf $input_case_base$input_case_directory/case_files/$ugwp_file mpas.ugwp_oro_data.nc
 ln -sf $system_directory/data/ugwp/ugwp_limb_tau.nc . 
fi
if [ $physics_suite = "hrrrv5" ]; then 
 ln -sf $system_directory/data/microphysics/tables_tempo/* .
fi
if [ $physics_suite = "convection_permitting" ] || [ $physics_suite = "convection_permitting_none" ]; then 
 ln -sf $system_directory/data/microphysics/tables_thompson/* .
fi

cp $script_home/case_files/$namelist_version/$domain/$source.$yyyy$mm$dd$hh/$physics_suite/* .

echo
echo "################################################################"
echo "# Run the model"
echo "################################################################"

time srun -n $SLURM_NTASKS ./atmosphere_model


#echo
#echo "################################################################"
#echo "# Successful completion of case: $model_code_base.$physics_suite.$input_case_directory"
#echo "################################################################"


