% ctd_ProfileOceanSITES
% ----------------------
% testing program for CTD OceanSITES netCDF output

clear;

import us191.datagui.util.*;

fprintf('\nStart testXBTProfileOceanSITES\n');

% nectdf descriptor
dynaload = 'ctd_profile_oceansites';

% input data file
self.FileName = 'pirata-fr19_ctd.nc';

% load Excel file descptor and save it in csv
% -------------------------------------------
% fprintf('\nCreate dynaload descriptor : %s\n', strcat(dynaload, '.csv'));
% f = us191.dynaload(strcat(dynaload, '.xls'));
% write(f, strcat(dynaload, '.csv'));

% load input Argo netcdf file
us191.ncload(self.FileName);

% diplay
fprintf('\nRead dynaload descriptor : %s\n', strcat(dynaload, '.csv'));

% create netcdf instance from dynaload descriptor
nc = us191.netcdf(strcat(dynaload, '.csv'));

% date format oceansites
datefmt = 'yyyy-mm-ddTHH:MM:SSZ';

% global attribute
nc.ATTRIBUTES.cycle_mesure.data__       = 'PIRATA-FR19';
nc.ATTRIBUTES.platform_name.data__      = 'ANTEA';
nc.ATTRIBUTES.call_sign.data__          = 'FNUR';
nc.ATTRIBUTES.platform_code.data__      = 'FNUR';
nc.ATTRIBUTES.wmo_platform_code.data__  = '35A8';
nc.ATTRIBUTES.time_coverage_start.data__= '2009-06-14T10:00:00Z';
nc.ATTRIBUTES.time_coverage_end.data__  = '2009-07-23T08:00:00Z';
nc.ATTRIBUTES.timezone.data__           = 'GMT';
nc.ATTRIBUTES.project_name.data__       = 'ORE-PIRATA';
nc.ATTRIBUTES.type_instrument.data__    = 'SBE911+';
nc.ATTRIBUTES.number_instrument.data__  = '09P10828';
nc.ATTRIBUTES.pi_name.data__            = 'Bernard Bourles';
nc.ATTRIBUTES.author.data__             = 'Jacques Grelet';
nc.ATTRIBUTES.processing_state.data__   = '0A';
nc.ATTRIBUTES.type_position.data__      = 'GPS';
nc.ATTRIBUTES.conventions.data__        = 'OceanSITES 1.1, CF1.4';
nc.ATTRIBUTES.netcdf_version.data__     = '3.6';
nc.ATTRIBUTES.data_type.data__          = 'PROFILE';
nc.ATTRIBUTES.data_mode.data__          = 'D';
nc.ATTRIBUTES.data_restriction.data__   = 'NONE';
nc.ATTRIBUTES.data_assembly_center.data__ = 'IRD';
%nc.ATTRIBUTES.data_processing_centre.data__   = 'ORE-SSS';
nc.ATTRIBUTES.comment.data__            = 'CTD data test from PIRATA-FR19 cruise';
nc.ATTRIBUTES.date_update.data__        = datestr(now, datefmt);  % format (ISO 8601)

% variable
nc.VARIABLES.REFERENCE_DATE_TIME.data__ = '19500101000000';
% convertit de jour julien-reference en datenum
jj = double(julianToDatenum(DAYD,REFERENCE_DATE_TIME));
nc.VARIABLES.DATE.data__        = datestr( jj ,'yyyymmddHHMMSS');
nc.VARIABLES.TIME.data__        = datenumToJulian(jj');
nc.VARIABLES.STATION.data__     = PROFILS;
nc.VARIABLES.CAST.data__        = PROFILS;
nc.VARIABLES.LATITUDE.data__    = LATX;
nc.VARIABLES.LONGITUDE.data__   = LONX;
%% a changer, utiliser default_value
nc.VARIABLES.PRES.data__        = PRES; 
% convert depth from pressure
nc.VARIABLES.DEPH.data__        = sw_dpth(PRES',LATX')';

% value TEMP, PSAL, DOX2 et DENS
nc.VARIABLES.TEMP.data__        = TEMP;
%nc.VARIABLES.TEMP_QC.data__     = TEMP_QC';
nc.VARIABLES.TEMP_QC.data__     = zeros(size(TEMP));
nc.VARIABLES.PSAL.data__        = PSAL;
nc.VARIABLES.PSAL_QC.data__     = zeros(size(PSAL));
nc.VARIABLES.DOX2.data__        = DOX2;
nc.VARIABLES.DOX2_QC.data__     = zeros(size(DOX2));
nc.VARIABLES.DENS.data__        = DENS;
nc.VARIABLES.DENS_QC.data__     = zeros(size(DENS));

% dimensions
nc.DIMENSIONS.TIME.value        = length(PROFILS);
nc.DIMENSIONS.LATITUDE.value    = length(LATX);
nc.DIMENSIONS.LONGITUDE.value   = length(LONX);
nc.DIMENSIONS.POSITION.value    = length(LATX);
nc.DIMENSIONS.LEVEL.value       = length(PRES);
 
outfile = strcat(dynaload, '.nc');
nc.write(outfile,'NC_CLOBBER');
us191.ncdump(outfile);
us191.ncload(outfile);

