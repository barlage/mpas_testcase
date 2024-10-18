# mpas_testcase
Environment to create and run pre-defined MPAS test cases - only on jet for now

## Available cases:

GFS input data: 2023-03-10_15.00.00  (conus and global domains, 2 days of LBCs and SSTs)

RAP input data: 2024-02-02_18.00.00  (conus only, 3 hours of LBCs)

RAP input data: 2024-08-15_18.00.00  (conus only, 3 hours of LBCs)

Therefore, certain combiniations of configuration options will not work, e.g., global domain with rap source, ncar code with rap source (ncar code doesn't recognize rap projection)

## CREATE resources needed:

conus: ntasks = 8; time = 6 minutes

global: ntasks = 24; time = 30 minutes

## CREATE configuration options set at the top of the script [options]

`modules` : modules used to compile `init_atmosphere_model` 

`clean_before` : if `"true"`, will clobber the case directory (will then recreate static file, which is the slowest step)

`clean_after` : if `"true"`, remove the step run directories

`case_base` : directory where you want the case to be created 

`executable` : path to the `init_atmosphere_model` executable 

`code_base` : code based used to create executable [`"ncar"`,`"gsl"`]

`domain` : spatial extent [`"conus"`,`"global"`]

`source` : input data source [`"gfs"`,`"rap"`]

`season` : for rap source; ignored if gfs source [`"summer"`,`"winter"`]

`use_climo_aerosols` : if `"true"`, add climo aerosols to init and lbc file

## RUN resources needed:

conus: ntasks = 4; time = 1 minute

global: ntasks = 24; time = 3 minutes

## RUN configuration options set at the top of the script [options]

### configuration options related to running model

`modules` : modules used to compile `atmosphere_model`

`clean_before` : if `"true"`, will clobber the case directory 

`model_base_directory` : top-level MPAS directory; `model_executable` is assumed to reside here, also used as path to parameter files

`model_executable` : name of model executable, will be linked to `atmosphere_model` in script

`model_code_base` : name to identify code version; only used if `run_directory` is not given

`physics_suite` : physics suite to be run [`"mesoscale_reference"`]

`run_directory` : path to where you want model to be run; if `run_directory=""` then script will create a directory in the `$PWD` (see below)

`namelist_version` : namelist to be used [`"ncar"`,`"gsl"`]

### configuration options related to input files

`input_case_base` : top level directory of case input files

`input_code_base` : code used to create input files [`"ncar"`,`"gsl"`]

`domain` : spatial extent [`"conus"`,`"global"`]

`source` : input data source [`"gfs"`,`"rap"`]

`season` : for rap source; ignored if gfs source [`"summer"`,`"winter"`]

## RUN directory convention

When run_directory is not specified a local directory will be created. For
```
model_code_base="ncar_v8.2.2"
physics_suite="mesoscale_reference"
input_code_base="ncar"
domain="conus"
source="gfs"
```
directory name will be: `ncar_v8.2.2.mesoscale_reference.ncar.conus.gfs.2023031015`
