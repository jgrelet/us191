function theResult = ncload(theNetCDFFile, varargin)
% us191.ncload -- Load NetCDF variables.
%  us191.ncload('theNetCDFFile', 'var1', 'var2', ...) loads the
%   given variables of 'theNetCDFFile' into the Matlab
%   workspace of the "caller" of this routine.  If no names
%   are given, all variables are loaded.  The names of the
%   loaded variables are returned or assigned to "ans".
%   Attributes are loaded is this case.
%   Whitout argument, us191.ncload call uigetfile.
%
% Use the same syntax as Dr. Charles R. Denham ncload.m.
%
% $Id: ncload.m 600 2011-09-14 14:36:29Z jgrelet $

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

% create netcdf object, call uigetfile if no filename is given
% ------------------------------------------------------------
if nargin == 0
  nc = us191.netcdf;
else
  nc = us191.netcdf(theNetCDFFile);
end

result = [];
if nargout > 0, theResult = result; end

% get hashtable for VARIABLES & ATTRIBUTES
% ----------------------------------------
varNames = nc.VARIABLES;
attNames = nc.ATTRIBUTES;

% if no argument, set varargin with all variables and global attributes
% ---------------------------------------------------------------------
if isempty(varargin)
  variables  = keys(varNames);
  attributes = keys(attNames);
else
  variables = varargin;
end

% loop over variables
% -------------------
for i = variables
  
  % convert cell to char
  % --------------------
  variable = char(i);
  
  % check if given variable is in the hash
  % --------------------------------------
  if ~isKey(varNames, variable)
    error('us191.ncload: ''%s'' is not a valid variable for ''%s'' file.',...
      variable, theNetCDFFile);
  end
  
  % get variable value
  % ------------------
  var = varNames(variable).data__;
  
  % assign variable to caller workspace
  % -----------------------------------
  assignin('caller', variable, var);
  
end

% assign to base workspace attributes
% ----------------------------------
if isempty(varargin)
  
  for key = attributes
    
    % convert cell to char
    % --------------------
    attribute = char(key);
    
    % assign attribute to caller workspace
    % -------------------------------------
    assignin('caller', attribute, attNames(attribute).data__);
  end
end

% contain all input arg
% ---------------------
result = varargin;

if nargout > 0
  theResult = result %#ok<NOPRT>
else
  % Assign a value to base-workspace.
  % ---------------------------------
  assignin('base', 'ans', result)
end

