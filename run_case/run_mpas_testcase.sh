#!/bin/sh -l
#
# -- Request n cores
#SBATCH --ntasks=4
#
# -- Specify queue
#SBATCH -q debug
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

#model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/ncar/intel-base/v8.2.2/"
#model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/gsl-fork/MPAS-Model/"
#model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/barlage-fork/MPAS-Model/"
model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/v8.2.2_merge/MPAS-Model/"
#model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/backward/MPAS-Model/"
#model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/ncar/registry_test/MPAS-Model/"
#model_base_directory="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testing/code/gsl/joe-fork/"
model_executable="atmosphere_model.71791d535"
#model_executable="atmosphere_model.prepost"
#model_executable="atmosphere_model"
#model_executable="atmosphere_model.26783a403"
#model_executable="atmosphere_model.ea390a0c9"
#model_executable="atmosphere_model.e09f3048e"
#model_code_base="dev-ea390a0c9-mesorefmynn"
#model_code_base="ncar-gslreg-mesorefmynn"
#model_code_base="mrg-prepost-mesorefmynn"
#model_code_base="joe-prprepost-mesorefmynn"
model_code_base="jnt-71791d535-mesoref"
physics_suite="mesoscale_reference"
run_directory=""
namelist_version="ncar"

################################################################
# input file options
################################################################

input_case_base="/lfs5/BMC/wrfruc/Michael.Barlage/mpas/testcase.baselines/"
input_code_base="gsl"
domain="conus"
source="gfs"
season="winter"


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
input_case_directory=$input_code_base.$domain.$source.$yyyy$mm$dd$hh
static_file="mpas."$input_code_base"."$domain".120km.static.nc"
init_file="mpas."$input_code_base"."$domain".120km."$source".init."$datestring".nc"
lbc_file="mpas."$input_code_base"."$domain".120km."$source".lbc."$datestring".nc"
sst_file="mpas."$input_code_base"."$domain".120km."$source".sfc_update."$datestring".nc"
ugwp_file="mpas."$input_code_base"."$domain".120km.ugwp_oro_data.nc"
script_home=$PWD

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

cp $model_base_directory/src/core_atmosphere/physics/physics_wrf/files/*.TBL .
cp $model_base_directory/src/core_atmosphere/physics/physics_wrf/files/*.DBL .
cp $model_base_directory/src/core_atmosphere/physics/physics_wrf/files/*DATA .
cp $model_base_directory/src/core_atmosphere/physics/physics_noahmp/parameters/NoahmpTable.TBL .

if [ $domain = "conus" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/code-MPAS/MPAS-Limited-Area/conus.120km.graph.info.part.$SLURM_NTASKS .
elif [ $domain = "global" ]; then 
  ln -sf /lfs5/BMC/wrfruc/Michael.Barlage/mpas/data/120km/grid/x1.40962.graph.info.part.$SLURM_NTASKS global.120km.graph.info.part.$SLURM_NTASKS
fi

ln -sf $model_base_directory$model_executable atmosphere_model

ln -sf $input_case_base$input_case_directory/case_files/$init_file mpas.init.nc
if [ $domain = "conus" ]; then 
 ln -sf $input_case_base$input_case_directory/case_files/$lbc_file mpas.lbc.nc
fi
if [ $source = "gfs" ]; then 
 ln -sf $input_case_base$input_case_directory/case_files/$sst_file mpas.sfc_update.nc
fi

cp $script_home/case_files/$namelist_version/$domain/$source.$yyyy$mm$dd$hh/$physics_suite/* .

echo
echo "################################################################"
echo "# Run the model"
echo "################################################################"

time srun -n $SLURM_NTASKS ./atmosphere_model


#echo
#echo "################################################################"
#echo "# Successful completion of case: $code_base.$domain.$source.$yyyy$mm$dd$hh"
#echo "################################################################"


