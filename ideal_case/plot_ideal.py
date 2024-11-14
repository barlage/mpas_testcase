import os
import sys
import shutil
import yaml
import pathlib
import datetime
from typing import Dict

import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm

CONFIG_FILE = './config.yaml'
CONFIG_PLOT = './config_plot.yaml'

def read_config(CFILE: pathlib.Path) -> Dict[str, str]:
    """
    Reads a yaml config file

    Args:
        CFILE (pathlib.Path): Config file path.

    Returns:
        config (Dict[str, str]): config dictionary 
    """    
    try:
        with open(CFILE, 'r') as f:
            config_data = yaml.safe_load(f)
            
        print(f"Read config file: {CFILE}")
        return config_data
    except FileNotFoundError as e:
        print(f"Error: {e}")


def plot_get_gridded(configplot: Dict[any, any], ds: xr.core.dataset.Dataset, varname: str) -> np.ndarray:
    """
    Returns gridded MPAS data for plotting

    Args:
        configplot (Dict[any, any]): Config dictionary
        ds (xarray.core.dataset.Dataset): xarray dataset of MPAS output
        varname (str): variable name to plot
    Returns:
        plotx (numpy.ndarray): xgrid for plotting
        plotz (numpy.ndarray): zgrid for plotting
        plot_var (numpy.ndarray): gridded variable to plot
    """    

    timeind = configplot['time_index']
    nz = configplot['nz']
    nx = 200 # Hardcoded for idealized simulation

    # zgrid 
    zgrid_stag = ds.variables['zgrid'].values # Staggered in z
    zgrid = 0.5*(zgrid_stag[:,:-1] + zgrid_stag[:,1::])

    # Hardcoded and converted to km
    xCell = ds.xCell.values / 1000. - 100.
    yCell = ds.yCell.values / 1000.

    nCells = xCell.shape[0]

    plot_zgrid1 = np.zeros((nz,nx))
    plot_var1 = np.zeros((nz,nx))
    x1 = np.zeros((nx))

    plot_zgrid2 = np.zeros((nz,nx))
    plot_var2 = np.zeros((nz,nx))
    x2 = np.zeros((nx))

    plot_zgrid = np.zeros((nz,nx*2))
    plot_var = np.zeros((nz,nx*2))
    x = np.zeros((nx*2))

    var = ds.variables[varname].values[timeind,:,:]
        
    # Set up the xgrid/zgrid based on y-staggering
    cnt1 = 0
    cnt2 = 0
    for iCell in range(nCells):
        if ((yCell[iCell] >= 0.2) and (yCell[iCell] <= 0.3)):
            plot_zgrid1[:,cnt1] = zgrid[iCell,:]
            plot_var1[:,cnt1] = var[iCell,:]
            x1[cnt1] = xCell[iCell]
            cnt1 = cnt1 + 1
        if ((yCell[iCell] >= 0.5) and (yCell[iCell] <= 0.6)):
            plot_zgrid2[:,cnt2] = zgrid[iCell,:]
            plot_var2[:,cnt2] = var[iCell,:]
            x2[cnt2] = xCell[iCell]
            cnt2 = cnt2 + 1
            
    for i in range(cnt1):
        ii = 2*i
        plot_zgrid[:,ii] = plot_zgrid1[:,i]
        plot_var[:,ii] = plot_var1[:,i]
        x[ii] = x1[i]
    for i in range(cnt2):
        ii = 2*i + 1
        plot_zgrid[:,ii] = plot_zgrid2[:,i]
        plot_var[:,ii] = plot_var2[:,i]
        x[ii] = x2[i]

    plotx, tmpz = np.meshgrid(x, plot_zgrid[:,0])
    plotz = plot_zgrid/1000.
    
    return plotx, plotz, plot_var
    

class MathOperations:
    def multiply(self, val, x):
        return val * x

    def mixing_ratio_to_conc(self, val, argdict):
        return val * argdict['rho']

    def theta_to_tempc(self, val, argdict):
        return argdict['theta']*(argdict['pressure']/100000.)**0.286 - 273.15

# ------------------------------------------------------------------------------------- #
print(f"")
print(f"Running create_ideal.py with python version: {sys.version}")

# Read configuration file
config = read_config(pathlib.Path(CONFIG_FILE))
if config['verbose']: print(config)

# Read plotting configuration file
configplot = read_config(pathlib.Path(CONFIG_PLOT))
if configplot['verbose']: print(configplot)
print("")

# Plotting
# Read mpas file in xarray dataset (ds)
filename = pathlib.Path(configplot['plotdir']) / pathlib.Path(configplot['output'])
ds = xr.open_dataset(filename, decode_times=False)

# Loop over variables to plot
rhosave = None
thetasave = None
pressuresave = None

loopvars = list(configplot['vars'].keys())
for var in loopvars:
    currentvar = configplot['vars'][var]
    shortname = currentvar['shortname']
    
    # Get x, z and variable on regular grid
    if shortname is not None:
        print(f"Gridding variable to plot: {shortname} ({currentvar['longname']})")
        plotx, plotz, plotvar = plot_get_gridded(configplot, ds, shortname)
    else:
        print(f"Gridding variable to plot: {var}")
        plotx, plotz, plotvar = plot_get_gridded(configplot, ds, 'theta')
        plotvar = plotvar*0.
        
    # Transform variables, e.g. kg/kg -> g/kg
    math_ops = MathOperations()
    if 'transform' in currentvar:
        transform = currentvar['transform']
        if transform is not None:
            for key, value in transform.items():
                print(f"...Transform on variable {var}: {key} by {value}")
                if key == 'convert':
                    if configplot['verbose']:
                        print(f"   ...Calling function {transform['convert']['function']}")
                        print(f"      ...with function arguments {transform['convert']['depends']}")
                    funcname = transform['convert']['function']
                    arglist = transform['convert']['depends']
                    argdict = {}
                    for arg in arglist:
                        tmpx, tmpzz, argvar = plot_get_gridded(configplot, ds, arg)
                        argdict[arg] = argvar
                    plotvar = getattr(math_ops, funcname)(plotvar, argdict)
                else:
                    if configplot['verbose']:
                        print(f"...Calling function {key}")
                    plotvar = getattr(math_ops, key)(plotvar, value)

    # Mask variable
    if 'mask' in currentvar:
        mask = currentvar['mask']
        for key, value in mask.items():
            print(f"...Masking variable {shortname} using {key} threshold {value}")
            tmpx, tmpzz, maskvar = plot_get_gridded(configplot, ds, key)
            plotvar = np.ma.masked_where(maskvar < value, plotvar)
            
    # Set up figure
    fig, ax = plt.subplots(1,1, figsize=(8,8))

    levels = currentvar['levels']
    label = currentvar['label']

    im = ax.contourf(plotx, plotz, plotvar, levels=levels, cmap=cm.gist_ncar)
    cb = plt.colorbar(im, shrink=0.9, orientation='horizontal', aspect=50,
                      pad=0.1, label=label)
    # Plot terrain
    ax.plot(plotx[0,:], plotz[0,:], color='k')
    
    ax.set_ylim((0,10))
    ax.set_ylabel(r'z [km]')
    ax.set_xlabel(r'x [km]')
    plt.savefig(f"{var}_timeindex{configplot['time_index']}.pdf", dpi=50, bbox_inches='tight')  

        
