#!/bin/sh
ncdump test-dboceano-ctd.nc > test-dboceano-ctd.cdl
ncdump test-dboceano-gosud.nc > test-dboceano-gosud.cdl
ncdump test-dboceano-onset.nc > test-dboceano-onset.cdl
ncdump test-dboceano-tsg.nc > test-dboceano-tsg.cdl
tar jcvf test-dboceano.tar.bz2 *.nc *.cdl

