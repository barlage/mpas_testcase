# create_mpas_testcase
Environment to create pre-defined MPAS test cases

## Available cases:

GFS input data: 2023-03-10_15.00.00  (conus and global domains, 2 days of LBCs and SSTs)

RAP input data: 2024-02-02_18.00.00  (conus only, 3 hours of LBCs)

RAP input data: 2024-08-15_18.00.00  (conus only, 3 hours of LBCs)

## Resources needed:

conus: ntasks = 8; time = 10 minutes

global: ntasks = 36; time = 30 minutes

## Configuration options set at the top of the script [options]

`modules` : modules used to compile init_atmosphere 

`clean` : if "true", will clobber the case directory

`case_base` : directory where you want the case to be created 

`executable` : path to the init_atmosphere executable 

`yyyy` : year of case [see case availability above]

`mm` : month of case [see case availability above]

`dd` : day of case [see case availability above]

`hh` : hour of case [see case availability above]

`code_base` : code based used to create executable ["ncar","gsl"]

`domain` : spatial extent ["conus","global"]

`source` : input data source ["gfs","rap"]

`use_climo_aerosols` : if "true", add climo aerosols to init and lbc file
