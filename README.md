# create_mpas_testcase
Environment to create pre-defined MPAS test cases

## Available cases:

GFS input data: 2023-03-10_15.00.00  (conus and global domains, 2 days of LBCs and SSTs)

RAP input data: 2024-02-02_18.00.00  (conus only, 3 hours of LBCs)

RAP input data: 2024-08-15_18.00.00  (conus only, 3 hours of LBCs)

Therefore, certain combiniations of configuration options will not work, e.g., global domain with rap source, ncar code with rap source (ncar code doesn't recognize rap projection)

## Resources needed:

conus: ntasks = 8; time = 6 minutes

global: ntasks = 24; time = 30 minutes

## Configuration options set at the top of the script [options]

`modules` : modules used to compile init_atmosphere 

`clean_before` : if "true", will clobber the case directory (will then recreate static file, which is the slowest step)

`clean_after` : if "true", remove the step run directories

`case_base` : directory where you want the case to be created 

`executable` : path to the init_atmosphere executable 

`code_base` : code based used to create executable ["ncar","gsl"]

`domain` : spatial extent ["conus","global"]

`source` : input data source ["gfs","rap"]

`season` : for rap source; ignored if gfs source ["summer","winter"]

`use_climo_aerosols` : if "true", add climo aerosols to init and lbc file
