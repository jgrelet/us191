% test_form

nc = us191.oceansites('global_oceansites.csv');
nc.file = 'toto.nc';
nc.autoform = logical(1);

nc.VARIABLES.TEMP.data__ = [5,6];
nc.VARIABLES.TIME.data__ = 1;
nc.VARIABLES.LATITUDE.data__ =1;
nc.VARIABLES.LONGITUDE.data__ =1;
nc.VARIABLES.POSITION_QC.data__ =1;

%nc = nc.form;

nc = nc.write;