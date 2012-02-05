% onset_timeseries_oceansites
%
%% COPYRIGHT & LICENSE
%  Copyright 2009-2001 - IRD US191, all rights reserved.
%
%  This file is part of us191 Matlab package.
%
%    us191 package is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    us191 package is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
%    USA

clear;

import us191.datagui.util.*;

% nectdf descriptor
dynaload = 'onset_timeseries_oceansites';

% input data file
self.FileName = 'goro_200806_1_test.txt';

% load Excel file descptor and save it in csv
% f = us191.dynaload(strcat(dynaload, '.xls'));
% write(f, strcat(dynaload, '.csv');

% create netcdf file
nc = us191.netcdf(strcat(dynaload, '.csv'));

% date format oceansites
datefmt = 'yyyy-mm-ddTHH:MM:SSZ';

% onpen onset data file
self.FileId = fopen(self.FileName);

% read onset data file
self = read_onset(self);

% global attribute
nc.ATTRIBUTES.cycle_mesure.data__       = 'goro_200806_1';
nc.ATTRIBUTES.platform_name.data__      = 'GORO';
nc.ATTRIBUTES.time_coverage_start.data__= '2008-06-09T00:00:00Z';
nc.ATTRIBUTES.time_coverage_end.data__  = '2008-08-17T15:30:00Z';
nc.ATTRIBUTES.project_name.data__       = 'ORE-SSS';
nc.ATTRIBUTES.type_instrument.data__    = 'ONSET-TIDBIT';
nc.ATTRIBUTES.number_instrument.data__  = 'N/A';
nc.ATTRIBUTES.pi_name.data__            = 'Thierry Delcroix';
nc.ATTRIBUTES.author.data__             = 'David Varillon';
nc.ATTRIBUTES.processing_state.data__   = '0A';
nc.ATTRIBUTES.type_position.data__      = 'GPS';
nc.ATTRIBUTES.conventions.data__        = 'OceanSITES 1.1, CF1.4';
nc.ATTRIBUTES.netcdf_version.data__     = '3.6';
nc.ATTRIBUTES.data_type.data__          = 'TIME-SERIES';
nc.ATTRIBUTES.data_mode.data__          = 'D';
nc.ATTRIBUTES.data_restriction.data__   = 'NONE';
nc.ATTRIBUTES.data_assembly_center.data__ = 'IRD';
%nc.ATTRIBUTES.data_processing_centre.data__   = 'ORE-SSS';
nc.ATTRIBUTES.comment.data__            = 'timeserie data test from Onset file';
nc.ATTRIBUTES.date_update.data__        = datestr(now, datefmt);  % format (ISO 8601)


% variable
nc.VARIABLES.REFERENCE_DATE_TIME.data__ = '19500101000000';

nc.VARIABLES.DATE.data__ = datestr(julianToDatenum(self.time),'yyyymmddHHMMSS');
nc.VARIABLES.TIME.data__ = self.time;

nc.VARIABLES.LATITUDE.data__ = -21.16;
nc.VARIABLES.LONGITUDE.data__ = 166.26;
nc.VARIABLES.POSITION_QC.data__ = 3;  
nc.VARIABLES.DEPH.data__ = 3.5; 

nc.VARIABLES.TEMP.data__ = self.data;
nc.VARIABLES.TEMP_QC.data__ = self.qc;

% dimensions
nc.DIMENSIONS.TIME.value = length(nc.VARIABLES.TEMP.data__);

% write file
outfile = strcat(dynaload, '.nc');
nc.write(outfile, 'NC_CLOBBER');
us191.ncdump(outfile);
us191.ncload(outfile);

