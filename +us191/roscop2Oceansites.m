function roscop2Oceansites( varargin )
% roscop2Oceansites:  convert ARGO netcdf files to OceanSites conventions
% 
% Usage:
%
% us191.roscop2oceansites('type','profile','argo','profile/pirata-fr19_ctd.nc',...
%   'cycle_mesure','PIRATA-FR19',...
%   'platform_name','ANTEA','platform_code','FNUR','type_instrument','SBE911+',...
%   'parameters',{'TEMP','PSAL','DOX2','DENS','SVEL'},'levels',{'PRES','DEPH'},...
%   'number_instrument','11P928','wmo_platform_code','35A8',...
%   'time_coverage_start','2009-06-13T09:00:00Z',...
%   'time_coverage_end','2009-07-23T08:00:00Z',...
%   'pi_name','Bernard Bourles','author','Jacques Grelet');
%
% Input:
%   
%
% Output:
%   none
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
template   = 'global_oceansites.csv';
type       = 'profile';
parameters = {'TEMP','PSAL','DOX2','DENS'};
levels     = {'PRES','DEPH'};

argo                 = 'N/A';
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
default_qc           = int8(0);

% on parcourt les arguments par couple 'propriete', 'valeur'
% ---------------------------------------------------------------
property_argin = varargin(1:end);
while length(property_argin) >= 2,
  property = property_argin{1};
  value    = property_argin{2};
  property_argin = property_argin(3:end);
  switch lower(property)
    case 'argo'
      argo = value;
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
    case 'default_qc'
      default_qc = int8(value);      
    otherwise
      error('Unknow property: "%s"', property);
  end
end

% open ARGO Netcdf file
% ---------------------
[path, name, ext] = fileparts(argo);

% load input Argo netcdf file in workspace
% ----------------------------------------
us191.ncload(argo);

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
nc.ATTRIBUTES('data_type').data__            = upper(type);
nc.ATTRIBUTES('date_update').data__          = ...
  strcat(datestr(now, 29), 'T', datestr(now, 13), 'Z');

% variable
nc.VARIABLES('REFERENCE_DATE_TIME').data__ = '19500101000000';

% convertit de jour julien-reference en datenum
% ---------------------------------------------
if exist('DAYD','var')
  jj = double(julianToDatenum(DAYD, REFERENCE_DATE_TIME));
elseif exist('DAYS','var')
  jj = double(julianToDatenum(DAYS, REFERENCE_DATE_TIME));
end

nc.VARIABLES('DATE').data__        = datestr( jj ,'yyyymmddHHMMSS');
nc.VARIABLES('TIME').data__        = datenumToJulian(jj');
nc.VARIABLES('LATITUDE').data__    = LATX;
nc.VARIABLES('LONGITUDE').data__   = LONX;

% compute PRES from DEPH or vice versa
% ------------------------------------
if exist('DEPH', 'var')
  nc.VARIABLES('DEPH').data__        = DEPH;
  % convert pressure fron depth
  nc.VARIABLES('PRES').data__        = sw_pres(DEPH',LATX')';
  assignin('base', 'PRES', nc.VARIABLES('PRES').data__);
elseif exist('PRES', 'var')
  nc.VARIABLES('PRES').data__        = PRES;
  % convert pressure fron depth
  nc.VARIABLES('DEPH').data__        = sw_dpth(PRES',LATX')';
  assignin('base', 'DEPH', nc.VARIABLES('DEPH').data__)
end

% populate parameters
% --------------------
for i = [parameters, levels]
  var = char(i);
  nc.VARIABLES(var).data__       = eval(char(i));
  
  % populate QC 
  % -----------
  if exist([var '_QC'], 'var')
    nc.VARIABLES([var '_QC']).data__  = eval([var '_QC']);
  else
    nc.VARIABLES([var '_QC']).data__  = int8(ones(size(eval(var)))) * default_qc;
  end
  if exist([var '_ADJUSTED_QC'], 'var')
    nc.VARIABLES([var '_ADJUSTED_QC']).data__ = eval([var '_ADJUSTED_QC']);
  else
    nc.VARIABLES([var '_ADJUSTED_QC']).data__ = int8(ones(size(eval(var)))) * default_qc;
  end
end

% populate POSITION_QC
% --------------------
if exist('POSITION_QC', 'var')
  nc.VARIABLES('POSITION_QC').data__  = eval('POSITION_QC');
else
  nc.VARIABLES('POSITION_QC').data__  = ...
    int8(ones(size(nc.VARIABLES('LATITUDE').data__))) * default_qc;
end

% set dimensions for profile, trajectory or timeserie
% ---------------------------------------------------
switch type
  case 'profile'
    if exist('PROFILS', 'var')
      nc.DIMENSIONS.TIME.dimlen      = length(PROFILS);
      nc.VARIABLES('STATION').data__ = PROFILS;
      nc.VARIABLES('CAST').data__    = PROFILS;
    elseif exist('PROFILE', 'var')
      nc.DIMENSIONS.TIME.dimlen      = length(PROFILE);
      nc.VARIABLES('STATION').data__ = PROFILE;
      nc.VARIABLES('CAST').data__    = PROFILE;
    end
    nc.DIMENSIONS.LEVEL.dimlen     = length(nc.VARIABLES('PRES').data__);
  case 'trajectory'
    nc.DIMENSIONS.TIME.dimlen      = size(nc.VARIABLES('LATITUDE').data__, 1);
    nc.DIMENSIONS.LEVEL.dimlen     = size(nc.VARIABLES('LATITUDE').data__, 2);
  case 'timeserie'
end

nc.DIMENSIONS.LATITUDE.dimlen    = length(nc.VARIABLES('LATITUDE').data__);
nc.DIMENSIONS.LONGITUDE.dimlen   = length(nc.VARIABLES('LONGITUDE').data__);
nc.DIMENSIONS.POSITION.dimlen    = length(nc.VARIABLES('LATITUDE').data__);

% write netcdf oceansites file
% -----------------------------
nc.write(strcat(name, '_oceansites', ext), 'NC_CLOBBER');

% us191.ncdump('test.nc');
% us191.ncload('test.nc');
