function ncdump(theNetCdfFile, varargin)
% us191.ncdump -- List NetCDF file headers as NetCDF Language.
%  us191.ncdump(theNetCDFFile, 'theOutputFile') displays the
%   definitions of items in theNetCDFFile, a filename
%   or a "netcdf" object.  Similar in behavior to the
%   Unidata "ncdump -h" program.  If theNetCDFFile looks
%   like a wild-card (contains '*'), the routine uses
%   the uigetfile() dialog to get the filename.  The
%   default is '*.*'.  The output file, which may be
%   a wild-card to invoke uiputfile(), defaults to
%   'stdout', equivalent to the Matlab command window.
%   (NOTE: if theOutputFile is provided as an integer
%   > 2, it is assumed to be the file-id of an already
%   open file.)
%
% Use the same syntax as Dr. Charles R. Denham ncload.m.
%
% $Id: ncdump.m 610 2011-12-14 13:02:04Z jgrelet $

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

%% check argument
% ---------------
if (nargin == 0)
  [file, path, ext] = uigetfile(...
    {'*.nc;*.cdf','NetCDF (*.nc,*.cdf)'}, 'Select file'); %#ok<NASGU>
  
  % builds a full file specification from the folders and file name
  % ---------------------------------------------------------------
  theNetCdfFile = fullfile(path, file);
end

%% open NetCDF file
% ----------------
nc = us191.netcdf(theNetCdfFile);

% diplay file name
% ----------------
[pathstr, name, ext] = fileparts(theNetCdfFile); %#ok<ASGLU,NASGU>
fprintf('\nnetcdf %s { \n\n', strcat(name, '.', 'nc'));

%% dimensions
% -----------
fprintf('dimensions:\n');

% get key and structure from hashtable DIMENSIONS
% and display members dimlen or unlimited
% -----------------------------------------------
for key = keys(nc.DIMENSIONS)
  
  % convert cell key to char
  % ------------------------
  theKey = char(key);
  
  if (nc.DIMENSIONS(theKey).unlimited)
    fprintf('\t%s = UNLIMITED ; // (%i currently)\n', ...
      char(theKey), nc.DIMENSIONS(theKey).dimlen);
  else
    fprintf('\t%s = %i ;\n', theKey, nc.DIMENSIONS(theKey).dimlen);
  end
end

%% variables
% ----------
fprintf('\n\nvariables:\n');

% get dimensions names and values
% -------------------------------
for key = keys(nc.VARIABLES)
 
  % convert cell key to char
  % ------------------------
  theKey = char(key);
  
  % init format string
  % ------------------
  dimstr = '(';
  
  % construct shape fieldname
  % -------------------------
  a = size(nc.VARIABLES(theKey).data__);
  l = length(a);
  shape = '[';
  for i=1:l-1
    shape =  strcat(shape, sprintf('%dx', a(i)));
  end
  shape =  strcat(shape, sprintf('%d]',a(i+1)));
  
  % construct dimension fieldname
  % -----------------------------
  dimension = nc.VARIABLES(theKey).dimension__;
  
  if isempty(dimension)
    dimstr = sprintf ('([]), ');
  else
    
    % a verifier, car modifie en juin 2009
    % ------------------------------------
    if length(dimension) > 1
      for k=1:length(dimension)-1
        dimstr = strcat(dimstr, sprintf('%s,', dimension{1,k}));
      end
    end
    dimstr = strcat(dimstr, sprintf('%s), ', dimension{1,length(dimension)}));
  end
  
  % print variable information with type, name, dimension and shape
  % ---------------------------------------------------------------
  fprintf('\t%s %s%s shape = %s ;\n', ...
    nc.VARIABLES(theKey).type__, char(theKey), dimstr, shape);
  
  % loop over fieldname (variable attributes)
  % -----------------------------------------
  fieldName = fieldnames(nc.VARIABLES(theKey));
  for f = 1:numel(fieldName)
    
    % get attribute (from structure fieldname) and value
    % --------------------------------------------------
    theValue = nc.VARIABLES(theKey).(fieldName{f});
    
    % shadowing special fieldnames data__, type__ and dimension__
    % -----------------------------------------------------------
    if strcmp( fieldName{f}, 'data__') || strcmp( fieldName{f}, 'type__') || ...
        strcmp( fieldName{f}, 'dimension__')
      continue;
    end
    
    % rename FillValue_ attribute, because Matlab can't handle struct
    % fieldname begining with underscore
    % -------------------------------------------------------------------
    if strcmp( fieldName{f}, 'FillValue_')
      fieldName{f} = '_FillValue';
    end
    
    % set the correct format string from value type
    % ---------------------------------------------
    if isa( theValue, 'char' )
      format = sprintf('"%s"', theValue);
    elseif isa( theValue, 'int8' ) || isa( theValue, 'uint8' )
      format = sprintf('%db', theValue);
    elseif isa( theValue, 'int16' ) || isa( theValue, 'uint16' )
      format = sprintf('%ds', theValue);     
    elseif isa( theValue, 'int32' ) || isa( theValue, 'uint32' )
      format = sprintf('%d', theValue); 
    elseif isa( theValue, 'int64' ) || isa( theValue, 'uint64' )
      format = sprintf('%dl', theValue);   
    elseif isa( theValue, 'single' ) 
      format = sprintf('%gf', theValue);                
    elseif isa( theValue, 'double' )
      format = sprintf('%g', theValue);          
    else isa( theValue, 'integer' )
      format = sprintf('%d', theValue);
    end
    
    % display attribute and value
    % ---------------------------
    fprintf( '\t\t%s:%s = %s\n', ...
      char(theKey), fieldName{f}, format);
  end
end

%% globals attributes
% -------------------
fprintf('\n\n//global attributes:\n');

% get global attributes name and value
% ------------------------------------
for theKey = keys(nc.ATTRIBUTES)
  
  % get theValue
  % ------------
  theValue = nc.ATTRIBUTES(char(theKey)).data__;
  
  % check global attribute type and set display format
  % --------------------------------------------------
  if isa( theValue, 'char' )
    fprintf('\t\t:%s = %s\n', char(theKey), theValue);
  elseif isa( theValue, 'integer' )
    fprintf('\t\t:%s = %d\n', char(theKey), theValue);    
  elseif isa( theValue, 'float' ) 
    fprintf('\t\t:%s = %f\n', char(theKey), theValue);
  end
end

% end
% ----
fprintf('\n}\n');
