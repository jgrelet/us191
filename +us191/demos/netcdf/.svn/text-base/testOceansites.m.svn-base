
clear;

% csv=us191.dynaload('global_oceansites.xls');
% write(csv, 'global_oceansites.csv');

o = us191.oceansites('global_oceansites.csv','trajectory',...
  {'TEMP','PSAL','DOX2','DENS'},{'PRES','DEPH'});

o.DIMENSIONS.TIME;
o.DIMENSIONS.TIME.value = 2;
o.DIMENSIONS.LATITUDE.value = 2;
o.DIMENSIONS.LONGITUDE.value = 2;
o.DIMENSIONS.LEVEL.value = 1;
o.DIMENSIONS.POSITION.value = 2;

%o.VARIABLES.TEMP.data__ = 

o.write('test.nc','NC_CLOBBER');
us191.ncdump('test.nc');
us191.ncload('test.nc');