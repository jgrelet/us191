function test2dboceano( varargin )
% test2dboceano:  convert ASCII test files to OceanSites conventions
% for DB-OCEANO
%
% Usage profile:
%
% test2dboceano('type','profile','infile','test-dboceano-ctd.asc','cycle_mesure','PIRATA-FR19-TEST','platform_name','ANTEA','platform_code','FNUR','type_instrument','SBE911+','parameters',{'TEMP','PSAL','DOX2'},'levels',{'PRES','DEPH'},'number_instrument','11P928','wmo_platform_code','35A8','time_coverage_start','2009-06-13T09:00:00Z','time_coverage_end','2009-07-23T08:00:00Z','pi_name','Bernard Bourles','author','Jacques Grelet','processing_state','2C+','project_name','PIRATA');
%
% Usage trajectory::
%
% test2dboceano('type','trajectory','infile','test-dboceano-tsg.asc','cycle_mesure','TOUCAN-TEST','platform_name','TOUCAN','platform_code','FNAV','type_instrument','SBE21','parameters',{'SSJT','SSTP','SSPS'},'levels',{'PRES','DEPH'},'number_instrument','3196','wmo_platform_code','35A9','time_coverage_start','2007-07-18T08:40:00Z','time_coverage_end','2007-09-07T09:10:00Z','pi_name','Thierry Delcroix','author','Jacques Grelet','processing_state','2C+','project_name','ORE-SSS');
%
% Usage time-series:
%
% test2dboceano('type','timeserie','infile','test-dboceano-onset.asc','cycle_mesure','GORO-TEST','platform_name','GORO','platform_code','N/A','type_instrument','ONSET-TIDBIT','parameters',{'TEMP'},'levels',{'PRES','DEPH'},'number_instrument','N/A','wmo_platform_code','N/A','time_coverage_start','2008-06-09T00:00:00Z','time_coverage_end','2008-08-17T15:30:00Z','pi_name','Thierry Delcroix','author','Jacques Grelet','processing_state','2C+','project_name','ORE-SSS');
%
% Usage GOSUD:
%
% use tsgqc, load test-dboceano-gosud.tsgqc file and save it in
% test-dboceano-gosud.nc
%
% $Id$

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

% import us191 package
% -----------------------
import us191.datagui.util.*

% default value
% -------------
template   = '../global_oceansites.csv';
type       = 'profile';
parameters = {'TEMP','PSAL','DOX2'};
levels     = {'PRES','DEPH'};

infile               = 'N/A';
cycle_mesure         = 'N/A';
platform_name        = 'N/A';
platform_code        = 'N/A';
number_instrument    = 'N/A';
wmo_platform_code    = 'N/A';
time_coverage_start  = 'N/A';
time_coverage_end    = 'N/A';
pi_name              = 'N/A';
author               = 'N/A';
project_name         = 'N/A';
processing_state     = 'N/A';
type_position        = 'GPS';
data_mode            = 'N/A';
data_restriction     = 'N/A';
data_assembly_center = 'N/A';
comment              = 'N/A';
netcdf_version       = '3.6';
conventions          = 'OceanSITES 1.1, CF1.4';
REFERENCE_DATE_TIME  = '19500101000000';


% on parcourt les arguments par couple 'propriete', 'valeur'
% ---------------------------------------------------------------
property_argin = varargin(1:end);
while length(property_argin) >= 2,
  property = property_argin{1};
  value    = property_argin{2};
  property_argin = property_argin(3:end);
  switch lower(property)
    case 'infile'
      infile = value;
    case 'template'
      template = value;
    case 'type'
      type = value;
    case 'parameters'
      parameters = value;
    case 'levels'
      levels = value;
    case 'cycle_mesure'
      cycle_mesure = value;
    case 'platform_name'
      platform_name = value;
    case 'platform_code'
      platform_code = value;
    case 'type_instrument'
      type_instrument = value;
    case 'number_instrument'
      number_instrument = value;
    case 'wmo_platform_code'
      wmo_platform_code = value;
    case 'time_coverage_start'
      time_coverage_start = value;
    case 'time_coverage_end'
      time_coverage_end = value;
    case 'pi_name'
      pi_name = value;
    case 'project_name'
      project_name = value;
    case 'author'
      author = value;
    case 'processing_state'
      processing_state = value;
    case 'type_position'
      type_position = value;
    case 'data_mode'
      data_mode = value;
    case 'data_restriction'
      data_restriction = value;
    case 'data_assembly_center'
      data_assembly_center = value;
    case 'comment'
      comment = value;
    otherwise
      error('Unknow property: "%s"', property);
  end
end

% open data infile
% ---------------------
%[path, name, ext] = fileparts(data);

% read ascii infile and load data in workspace
% ----------------------------------------
switch type
  case 'profile'
    gen_profile_data;
  otherwise
    read_asc_file
end

% create oceansites object
% ------------------------
nc = us191.oceansites(template, type, parameters, levels);

% set global attributes
% ---------------------
nc.ATTRIBUTES('cycle_mesure').data__         = cycle_mesure;
nc.ATTRIBUTES('platform_name').data__        = platform_name;
nc.ATTRIBUTES('platform_code').data__        = platform_code;
nc.ATTRIBUTES('call_sign').data__            = platform_code;
nc.ATTRIBUTES('type_instrument').data__      = type_instrument;
nc.ATTRIBUTES('number_instrument').data__    = number_instrument;
nc.ATTRIBUTES('wmo_platform_code').data__    = wmo_platform_code;
nc.ATTRIBUTES('time_coverage_start').data__  = time_coverage_start;
nc.ATTRIBUTES('time_coverage_end').data__    = time_coverage_end;
nc.ATTRIBUTES('pi_name').data__              = pi_name;
nc.ATTRIBUTES('author').data__               = author;
nc.ATTRIBUTES('project_name').data__         = project_name;
nc.ATTRIBUTES('processing_state').data__     = processing_state;
nc.ATTRIBUTES('type_position').data__        = type_position;
nc.ATTRIBUTES('data_mode').data__            = data_mode;
nc.ATTRIBUTES('data_restrictions').data__    = data_restriction;
nc.ATTRIBUTES('data_assembly_center').data__ = data_assembly_center;
nc.ATTRIBUTES('comment').data__              = comment;
nc.ATTRIBUTES('netcdf_version').data__       = netcdf_version;
nc.ATTRIBUTES('conventions').data__          = conventions;
nc.ATTRIBUTES('data_type').data__            = type;
nc.ATTRIBUTES('date_update').data__          = ...
  strcat(datestr(now, 29), 'T', datestr(now, 13), 'Z');

% populate variable
% -----------------
nc.VARIABLES('REFERENCE_DATE_TIME').data__ = REFERENCE_DATE_TIME;
nc.VARIABLES('DATE').data__        = s.DATE;
nc.VARIABLES('TIME').data__        = s.DAYD;
nc.VARIABLES('LATITUDE').data__    = s.LATX;
nc.VARIABLES('LONGITUDE').data__   = s.LONX;
if isfield(s, 'TIME_QC')
  nc.VARIABLES('TIME_QC').data__     = s.TIME_QC;
end
if isfield(s, 'POSITION_QC')
  nc.VARIABLES('POSITION_QC').data__ = s.POSITION_QC;
end

if isfield(s, 'DEPH')
  nc.VARIABLES('DEPH').data__        = s.DEPH;
  % convert pressure fron depth
  try
    nc.VARIABLES('PRES').data__        = sw_pres(s.DEPH', s.LATX')';
  catch ME
    nc.VARIABLES('PRES').data__        = sw_pres(s.DEPH, s.LATX);
  end
elseif isfield(s, 'PRES')
  nc.VARIABLES('PRES').data__        = s.PRES;
  % convert pressure fron depth
  nc.VARIABLES('DEPH').data__        = sw_dpth(s.PRES', s.LATX')';
end
if isfield(s, 'PRES_QC')
  nc.VARIABLES('PRES_QC').data__ = s.PRES_QC;
  nc.VARIABLES('DEPH_QC').data__ = s.PRES_QC;
end

% populate parameters
% --------------------
for p = parameters
  nc.VARIABLES(char(p)).data__          = s.(char(p));
  nc.VARIABLES([char(p) '_QC']).data__  = s.([char(p) '_QC']);
  nc.VARIABLES([char(p) '_CAL']).data__ = s.([char(p) '_CAL']);
  nc.VARIABLES([char(p) '_ADJUSTED']).data__ = s.([char(p) '_ADJUSTED']);
  nc.VARIABLES([char(p) '_ADJUSTED_QC']).data__ = s.([char(p) '_ADJUSTED_QC']);
end

% populate dimensions
% -------------------
switch type
  case 'profile'
    nc.DIMENSIONS.TIME.dimlen        = length(s.PROFILE);
    nc.VARIABLES('STATION').data__   = s.PROFILE;
    nc.VARIABLES('CAST').data__      = s.PROFILE;
    nc.DIMENSIONS.LEVEL.dimlen       = length(nc.VARIABLES('PRES').data__);
    nc.DIMENSIONS.LATITUDE.dimlen    = length(nc.VARIABLES('LATITUDE').data__);
    nc.DIMENSIONS.LONGITUDE.dimlen   = length(nc.VARIABLES('LONGITUDE').data__);
    nc.DIMENSIONS.POSITION.dimlen    = length(nc.VARIABLES('LATITUDE').data__);
  case 'trajectory'
    nc.DIMENSIONS.TIME.dimlen        = length(s.DAYD);
    % may be changer it, hardcoded with 1
    nc.DIMENSIONS.LEVEL.dimlen       = 1;
    nc.DIMENSIONS.LATITUDE.dimlen    = length(nc.VARIABLES('LATITUDE').data__);
    nc.DIMENSIONS.LONGITUDE.dimlen   = length(nc.VARIABLES('LONGITUDE').data__);
    nc.DIMENSIONS.POSITION.dimlen    = length(nc.VARIABLES('LATITUDE').data__);
  case 'timeserie'
    nc.DIMENSIONS.TIME.dimlen        = length(s.DAYD);
    % may be changer it, hardcoded with 1
    nc.DIMENSIONS.LEVEL.dimlen       = 1;
    nc.DIMENSIONS.LATITUDE.dimlen    = 1;
    nc.DIMENSIONS.LONGITUDE.dimlen   = 1;
    nc.DIMENSIONS.POSITION.dimlen    = 1;
    % get only one level for timeserie
    nc.VARIABLES('LATITUDE').data__ = s.LATX(1);
    nc.VARIABLES('LONGITUDE').data__ = s.LONX(1);
    nc.VARIABLES('POSITION_QC').data__ = s.POSITION_QC(1);
end

% change FileName extension to data file
% --------------------------------------
outfile = regexprep(infile, '.asc', '.nc');

nc.write(outfile, 'NC_CLOBBER');
% us191.ncdump('test.nc');
% us191.ncload('test.nc');

% read data
% ----------
  function gen_profile_data
    
    nbp = 3;
    format = '%d %d %d %d %d %d';
    
    header = [
      '2009 06 18 14 20 32';...
      '2009 06 19 15 47 02';...
      '2009 06 20 12 27 03'];
    s.TIME_QC = [1, 1, 1];
    
    s.PROFILE = [1,2,4];
    
    s.LATX = [-0.00750, 0.00017, 0.0];
    s.LONX = [-22.98933, -12.99983, -20];
    s.POSITION_QC = [1, 1, 1];
    
    % PRES with 13 levels
    s.PRES = [
      3 4 5 6 7 8 9 10 11 12 13 NaN NaN;
      0 1 2 3 4 5 6 7 8 9 10 11 12;
      0 1 2 3 4 5 6 7 8 NaN NaN NaN NaN ];
    s.PRES_QC = int8([
      1 1 1 1 1 1 1 1 1 1 1 0 0;
      2 2 1 1 1 1 1 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % temp profile, bad value in profile 2, level 5
    s.TEMP = [
      26.109 26.108 26.106 26.107 26.106 26.105 26.103 26.098 26.071 26.070 26.034 NaN NaN;
      24.241 24.241 24.241 24.271 34.270 24.270 24.270 24.221 23.988 23.635 23.513 23.475 23.419;
      23.546 23.546 23.346 22.221 22.220 22.199 22.050 22.001 21.999 NaN NaN NaN NaN];
    
    s.TEMP_QC = int8([
      1 1 1 1 1 1 1 1 1 1 1 0 0;
      2 2 1 1 4 1 1 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % add 0.001 to all value for calibrated data
    s.TEMP_CAL = s.TEMP + 0.001;
    
    % add 0.001 to only first profile for adjusted data
    s.TEMP_ADJUSTED = [ s.TEMP_CAL(1,:) + 0.001; s.TEMP_CAL(2:end,:)];
    
    s.TEMP_ADJUSTED_QC = int8([
      5 5 5 5 5 5 5 5 5 5 5 0 0;
      2 2 1 1 4 1 1 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % sal profile, bad value in profile 2, level 5
    s.PSAL = [
      36.371 36.371 36.371 36.371 36.371 36.371 36.371 36.370 36.370 36.369 36.368 NaN NaN;
      35.806 35.806 35.806 35.806 55.806 35.806 35.805 35.805 35.811 35.816 35.818 35.819 35.822;
      35.806 35.806 35.806 35.809 35.810 35.805 35.802 35.800 35.789 NaN NaN NaN NaN];
    
    %     s.PSAL = [
    %       NaN NaN NaN NaN NaN  NaN NaN NaN NaN NaN NaN NaN NaN;
    %       NaN NaN NaN NaN NaN  NaN NaN NaN NaN NaN NaN NaN NaN;
    %       NaN NaN NaN NaN NaN  NaN NaN NaN NaN NaN NaN NaN NaN];
    
    s.PSAL_QC = int8([
      1 1 1 1 1 1 1 1 1 1 1 0 0;
      2 2 1 1 4 1 1 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % add 0.001 to all value for calibrated data
    s.PSAL_CAL = s.PSAL + 0.001;
    
    % add 0.001 to only first profile for adjusted data
    s.PSAL_ADJUSTED = [s.PSAL_CAL(1,:) + 0.001; s.PSAL_CAL(2:end,:)];
    
    s.PSAL_ADJUSTED_QC = int8([
      5 5 5 5 5 5 5 5 5 5 5 0 0;
      2 2 1 1 1 4 1 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % oxy profile, bad value in profile 2, level 5
    s.DOX2 = [
      196.516 195.309 195.605 195.497 195.79 195.321 195.354  195.493 195.14 195.211 195.51 NaN NaN;
      206.492 206.492 206.492 206.396 206.329 205.842 905.953 204.561 201.971 201.399 201.018 200.576 200.069;
      206.492 206.492 206.390 206.256 206.329 205.565 203.123 199.345 196.567 NaN NaN NaN NaN];
    
    s.DOX2_QC = int8([
      1 1 1 1 1 1 1 1 1 1 1 0 0;
      2 2 1 1 1 1 4 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % add 0.001 to all value for calibrated data
    s.DOX2_CAL = s.DOX2 + 0.001;
    
    % add 0.001 to only first profile for adjusted data
    s.DOX2_ADJUSTED = [s.DOX2_CAL(1,:) + 0.001; s.DOX2_CAL(2:end,:)];
    
    s.DOX2_ADJUSTED_QC = int8([
      5 5 5 5 5 5 5 5 5 5 5 0 0;
      2 2 1 1 1 1 4 1 1 1 1 1 1;
      2 1 1 1 1 1 1 1 1 0 0 0 0]);
    
    % loop over profiles
    % ------------------
    for ii = 1 : nbp
      
      % read the date in a cell
      % -----------------------
      cellData = textscan( header(ii,:), format );
      
      % Date (y m d h m s) in the first 6 elements in data
      % --------------------------------------------------
      yy = double(cellData{1});
      mm = double(cellData{2});
      dd = double(cellData{3});
      hh = double(cellData{4});
      mi = double(cellData{5});
      ss = double(cellData{6});
      
      % add computed fields DAYD and DATE to structure
      % -----------------------------------------------
      s.DATE(ii,:) = datestr(datenum(yy, mm, dd, hh, mi, ss), 'yyyymmddHHMMSS' );
      s.DAYD(ii) = datenumToJulian(datenum(yy, mm, dd, hh, mi, ss));
    end
    s.LATX = s.LATX';
    s.LONX = s.LONX';
    
  end % end of gen_profile_data

% read data
% ----------
  function read_asc_file
    % Display read infile info on console
    % ---------------------------------
    fprintf('\nREAD_ASCII_FILE\n'); tic;
    
    % Open the file
    % -------------
    fid = fopen( infile, 'rt' );
    
    % Check infile
    % -----------
    if fid == -1
      msg_error = ['file_lecture : Open file error : ' infile];
      warndlg( msg_error, 'ASCII error dialog');
      sprintf('...cannot locate %s\n', infile);
      error = -1;
      return;
    end
    
    % Display more info about read file on console
    % --------------------------------------------
    fprintf('...reading %s : ', infile);
    
    % Read the header till the header line has been read
    % --------------------------------------------------
    OK = 0;
    while ~OK
      
      % Read every line
      % ---------------
      line = fgetl( fid );
      c = textscan( line, '%s');
      
      switch char( c{1}(1) )
        
        case '%HEADER'
          
          % Read the header then quit the while loop
          % ----------------------------------------
          header = c{1}(2:end);
          nHeader = length( header );
          OK = 1;
          
        otherwise
          
          % Get the parameter Name (Delete '%')
          % ----------------------------------
          Para = char( strtok(c{1}(1), '%') );
          
          % Read the parameter value
          % ------------------------
          %ind = strmatch( Para, tsgNames);
          %if ~isempty( ind )
          
          % patch added for composed name
          % -----------------------------
          a = c{1}(2:end)';
          str=[];
          for i=a
            str = sprintf('%s %s', str, char(i));
          end
          
          % copy to tsg struct & remove leading and trailing white space
          % ------------------------------------------------------------
          Para = strtrim(str);
          %end
          
      end
    end
    
    % Builld the format depending on the header parameters
    % 1 - Decimate the HEADER - The 7th first parameters are always
    %     %HEADER YEAR MNTH DAYX hh mm ss
    % 2 - The 6 Date and time parametes are read in %d
    % -------------------------------------------------------------
    format = strcat('%d %d %d %d %d %d', repmat(' %f', 1 , nHeader - 6));
    
    % Read the data in a cell
    % -----------------------
    cellData = textscan( fid, format );
    
    % Convert cell to a structure
    % ---------------------------
    s = cell2struct(cellData, header, 2);
    
    clear cellData
    
    % Date (y m d h m s) in the first 6 elements in data
    % --------------------------------------------------
    yy = double( s.(char(header(1))) );
    mm = double( s.(char(header(2))) );
    dd = double( s.(char(header(3))) );
    hh = double( s.(char(header(4))) );
    mi = double( s.(char(header(5))) );
    ss = double( s.(char(header(6))) );
    
    % remove fields YEAR MNTH DAYX hh mm ss from structure
    % ----------------------------------------------------
    s = rmfield(s, {'YEAR', 'MNTH', 'DAYX', 'hh', 'mi', 'ss'});
    
    % add computed fields DAYD and DATE to structure
    % -----------------------------------------------
    s.DAYD = datenumToJulian(datenum(yy, mm, dd, hh, mi, ss));
    s.DATE = datestr(datenum(yy, mm, dd, hh, mi, ss), 'yyyymmddHHMMSS' );
    
    % Close the file
    % --------------
    fclose( fid );
    
    % Display time to read file on console
    % ------------------------------------
    t = toc; fprintf('...done (%6.2f sec).\n\n',t);
    
  end % read_asc_file

  function julian = datenumToJulian(dateNum)
    
    % datenumToJulian -- Convert Matlab Julian Day to datenum.
    %  datenumToJjulian(theDateNum) converts theDateNum (Matlab
    %   datenum) to its equivalent Julian day with days since
    %   1950-01-01 00:00:00.
    
    % $Id: datenumToJulian.m 92 2008-01-09 11:10:40Z jgrelet $
    
    
    
    if nargin < 1, help(mfilename), return, end
    
    origin = datenum(1950, 1, 1);
    
    result = dateNum - origin;
    
    if nargout > 0
      julian = result;
    else
      disp(result)
    end
    
  end % datenumToJulian
    
  end
