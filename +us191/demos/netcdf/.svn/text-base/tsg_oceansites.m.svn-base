% tsg_oceansites
% ----------------------
% testing program for TSG OceanSITES netCDF output

clear;

import us191.datagui.util.*;

% convert dynaload descriptor Excel to csv, todo the first time
% csv = us191.dynaload('global_oceansites.xls');
% write(csv, 'global_oceansites.csv');

% create netcdf file descriptor
nc = us191.oceansites('global_oceansites.csv','trajectory',...
  {'SSJT','SSPS','SSTP'},{'DEPH'});

% input data filename
self.FileName = 'trajectory\pirata-fr19_tsg.nc';

% define median size
self.medianSize = 49;

% load input Argo netcdf file
us191.ncload(self.FileName);

% date format oceansites
datefmt = 'yyyy-mm-ddTHH:MM:SSZ';

% global attribute
nc.ATTRIBUTES.cycle_mesure.data__       = 'PIRATA-FR19';
nc.ATTRIBUTES.platform_name.data__      = 'ANTEA';
nc.ATTRIBUTES.call_sign.data__          = 'FNUR';
nc.ATTRIBUTES.wmo_platform_code.data__  = '35A8';
nc.ATTRIBUTES.time_coverage_start.data__= '2009-06-14T10:00:00Z';
nc.ATTRIBUTES.time_coverage_end.data__  = '2009-07-23T08:00:00Z';
nc.ATTRIBUTES.timezone.data__           = 'GMT';
nc.ATTRIBUTES.project_name.data__       = 'ORE-PIRATA';
nc.ATTRIBUTES.type_instrument.data__    = 'SBE21';
nc.ATTRIBUTES.number_instrument.data__  = '3284';
nc.ATTRIBUTES.pi_name.data__            = 'Bernard Bourles';
nc.ATTRIBUTES.author.data__             = 'Jacques Grelet';
nc.ATTRIBUTES.processing_state.data__   = '0A';
nc.ATTRIBUTES.type_position.data__      = 'GPS';
nc.ATTRIBUTES.conventions.data__        = 'OceanSITES 1.1, CF1.4';
nc.ATTRIBUTES.netcdf_version.data__     = '3.6';
nc.ATTRIBUTES.data_type.data__          = 'TRAJECTORY';
nc.ATTRIBUTES.data_mode.data__          = 'D';
nc.ATTRIBUTES.data_restriction.data__   = 'NONE';
nc.ATTRIBUTES.data_assembly_center.data__ = 'IRD';
%nc.ATTRIBUTES.data_processing_centre.data__   = 'ORE-SSS';
nc.ATTRIBUTES.comment.data__            = 'Thermosalinographe data test from PIRATA-FR19 cruise';
nc.ATTRIBUTES.date_update.data__        = datestr(now, datefmt);  % format (ISO 8601)

% variable
DEPH = 3.5;
nc.VARIABLES.REFERENCE_DATE_TIME.data__ = '19500101000000';
% convertit de jour julien-reference en datenum
jj = medianf( DAYD, self.medianSize );
dn = double(julianToDatenum(jj,REFERENCE_DATE_TIME));

nc.VARIABLES.DATE.data__        = datestr( dn ,'yyyymmddHHMMSS');
nc.VARIABLES.TIME.data__        = datenumToJulian(dn');
nc.VARIABLES.LATITUDE.data__    = medianf( LATX', self.medianSize );
nc.VARIABLES.LONGITUDE.data__   = medianf( LONX', self.medianSize );
%
nc.VARIABLES.DEPH.data__        = DEPH; 

% value SSJT, SSPS, SSPT
nc.VARIABLES.SSJT.data__        = medianf( SSJT', self.medianSize );
%nc.VARIABLES.SSJT_QC.data__     = 0;
nc.VARIABLES.SSPS.data__        = medianf( SSPS', self.medianSize );
%nc.VARIABLES.SSPS_QC.data__     = 0;
nc.VARIABLES.SSTP.data__        = medianf( SSTP', self.medianSize );
%nc.VARIABLES.SSTP_QC.data__     = 0;

% dimensions
nc.DIMENSIONS.TIME.value        = length(nc.VARIABLES.TIME.data__);
nc.DIMENSIONS.LATITUDE.value    = length(nc.VARIABLES.LATITUDE.data__);
nc.DIMENSIONS.LONGITUDE.value   = length(nc.VARIABLES.LONGITUDE.data__);
nc.DIMENSIONS.POSITION.value    = length(nc.VARIABLES.LONGITUDE.data__);
nc.DIMENSIONS.LEVEL.value       = length(DEPH);
nc.VARIABLES.DEPH.dimension__   = {'LEVEL'};
 
outfile = strcat('pirata-fr19_tsg', '.nc');
nc.write(outfile,'NC_CLOBBER');
us191.ncdump(outfile);
us191.ncload(outfile);

