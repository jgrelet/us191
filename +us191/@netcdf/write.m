function write(self, varargin)
% write(self, varargin)
%  write method from netcdf class, create and write data to netcdf file
%  also call by save method
%
% % Input
% -----
% self        ........... netcdf object
% varargin{1} ........... netcdf file
% varargin{2} ........... file mode
%
% Output
% ------
% not, value class
%
% TODOS: rewrite and check error message for each call to netcdf lib
%
% $Id: write.m 654 2012-01-10 22:15:59Z jgrelet $

%% check arguments
% TODOS: modify and test
% ----------------------
switch nargin
  
  case 2
    
    % if only one arg, put netcdf file mode to NC_CLOBBER, it is to prevent
    % the following message when mode is NC_WRITE :
    % "NetCDF: Operation not allowed in data mode"
    % --------------------------------------------
    self.File = char(varargin{1});
    self.Mode = 'NC_CLOBBER';
    
  case 3
    self.File = char(varargin{1});
    self.Mode = char(varargin{2});
    
  otherwise
    error('netcdf:write', 'one or two arg needed');
    
end

% if nargin > 1
%   self.file = char(varargin{1});
% end
% if nargin > 2
%   self.mode = char(varargin{2});
% end

% check if file defined and is char
% ---------------------------------
if (isempty(self.File) || ~ischar(self.File))
  error('us191:netcdf:write', ...
    'us191.netcdf:write: file not defined or must be a string');
end

% check file extension
% --------------------
[pathName, fileName, fileExt] = fileparts(self.File); %#ok<ASGLU>
switch fileExt
  case {'.nc', 'cdf'}
    % continue
  case {'.csv', '.xls', '.xlsx'}
    
    % write the Netcdf description into dynaload field
    % ------------------------------------------------
    write@us191.dynaload(self);
    if self.Echo
      warning('netcdf:write', ...
        'be careful... this function is not yet fully implemented');
    end
    return
  otherwise
    return
end

% open atributes form when propertiy autoform is enable
% -----------------------------------------------------
if self.AutoForm
  form(self);
end

% get keys list of dimensions, variables and attributes from netcdf instance
% --------------------------------------------------------------------------
ncd_keys = keys(self.DIMENSIONS);
ncv_keys = keys(self.VARIABLES);
nca_keys = keys(self.ATTRIBUTES);

if self.Echo
  % display more info about write file on console
  % ---------------------------------------------
  fprintf('\nWRITE_NETCDF_FILE\n'); tic;
  fprintf('...writing %s : ', self.File);
end

%% Open or create netcdf file
% -------------------------
switch(self.Mode)
  case {'NC_CLOBBER'}
    self.nc_id = netcdf.create(self.File, self.Mode);
  case 'NC_WRITE'
    self.nc_id = netcdf.open(self.File, self.Mode);
  otherwise
    error('Invalid mode : %s', self.Mode);
end

%% Create NetCDF DIMENSIONS
% -------------------------
for i=1:numel(ncd_keys)
  key = ncd_keys{i};
  s = self.DIMENSIONS(key);
  dimlen = s.dimlen;
  
  % create unlimited dimension. Any unlimited dimension is therefore last
  % in the list of dimension IDs in defVar function, todo below...
  % ---------------------------------------------------------------------
  if s.unlimited
    try
      netcdf.defDim(self.nc_id, key, netcdf.getConstant('NC_UNLIMITED'));
    catch ME
      error('netcdf:write', ...
        '%s (line %d), nc_id: %d, key: %s in function call: %s (%s)',...
        ME.stack(2).name, ME.stack(2).line, self.nc_id, key, ...
        ME.stack(1).name, ME.message);
    end
  end
  
  % if dimension is not set, get size from variable
  % a faire evoluer car peu sur, et a voir pour tableaux
  % autre solution, parcourir les variables ayant comme dimension key
  % -----------------------------------------------------------------
  if isempty(dimlen)
    t = self.VARIABLES(key);
    if isfield(t, 'data__')
      dimlen = numel(t.data__);
      if dimlen == 0
        error('netcdf:write', ['us191.netcdf:write: dimension for ' ...
          'variable %s not set and variable is empty'], key);
      end
    end
  end
  try
    netcdf.defDim(self.nc_id, key, dimlen);
  catch ME
    error('netcdf:write', ...
      ' %s (line %d), nc_id: %d, key: %s in function call: %s (%s)',...
      ME.stack(2).name, ME.stack(2).line, self.nc_id, key, ...
      ME.stack(1).name, ME.message);
  end
  
end


%% Create and write NetCDF GLOBAL ATTRIBUTES
% -----------------------------------

% get netcdf global attribute constant
% ------------------------------------
nga = netcdf.getConstant('NC_GLOBAL');

for i=1:numel(nca_keys)
  key = nca_keys{i};
  s = self.ATTRIBUTES(key);
  
  % if attribute not defined or empty, don't write it
  % -------------------------------------------------
  if isfield(s, 'data__') && ~isempty( s.data__ )
    
    % Create an attribute associated with the variable.
    % -------------------------------------------------
    try
      netcdf.putAtt(self.nc_id, nga, key, s.data__);
    catch ME
      %       fprintf('\nError: us191.netcdf.%s (line %d)\n\tin function call: %s (%s)',...
      %         ME.stack(2).name, ME.stack(2).line, ME.stack(1).name, ME.message);
      error('netcdf:write',...
        ['\nError: us191.netcdf.%s (line %d), nc_id: %d, key: %s dimlen: %d\n',...
        'in function call: %s (%s)'],...
        ME.stack(2).name, ME.stack(2).line, self.nc_id, key, dimlen, ...
        ME.stack(1).name, ME.message);
      
    end
  end
end

% Leave define mode.
% ------------------
netcdf.endDef(self.nc_id)

%% Adds NetCDF VARIABLES
% ----------------------
for i=1:numel(ncv_keys)
  
  % Re-enter define mode.
  % ---------------------
  netcdf.reDef(self.nc_id);
  
  % initialise varstruct
  % nc_addvar use a structure with four fields:
  % Name
  % Nctype
  % Dimension
  % Attribute is also a structure array
  % see help nc_addvar
  % -----------------------------------
  %varstruct = [];
  
  % get variable name
  % -----------------
  key  = ncv_keys{i};
  
  % uncomment for debug only, display variable
  % ------------------------------------------
  % key
  
  % get structure
  % -------------
  s = self.VARIABLES(key);
  
  % get dimension(s) dimids from ncetcdf file, s.dimension is cell
  % --------------------------------------------------------------
  %dimids = [];
  
  % utiliser numel(s.dimension__) et dimids(i) pour creer le tableau des
  % dimids
  if ~isfield(s, 'dimension__') %#ok<NOPRT>
    error('us191:netcdf:write', ...
      'us191.netcdf:write: field dimension__ not defined in variables %s structure ...', key);
  end
  
  try
    % preallocate dimids
    % ------------------
    dimids = zeros(size(s.dimension__));
    
    % fill dimids array from dim name
    % -------------------------------
    for ind=1:length(dimids)
      dimid = netcdf.inqDimID(self.nc_id, s.dimension__{ind});
      dimids(ind) = dimid;
    end
    
    % find index of unlimited dimension
    % ---------------------------------
    %ind = find(dimids == unlimDimId);
    
    % reshape dimids array with unlimited  value at the start
    % -------------------------------------------------------
    %     if ~isempty(ind)
    %       dimids = [ dimids(1:ind-1), circshift(dimids(ind+1:end),[0 -1])];
    %       dimids = [circshift(dimids(1:ind),[0 1]), dimids(ind+1:end)];
    %     end
    
    % leave comment these lines, it's right case
    % ------------------------------------------
  catch ME
    warning('netcdf:write', ...
      '\nNotice: us191.netcdf.%s, dimension %s don''t exist or is empty',...
      ME.stack(2).name, s.dimension__{ind});
    
    % Leave define mode and go to next variable (key)
    % -------------------------------------------------
    netcdf.endDef(self.nc_id);
    continue;
  end
  
%   % We need to flip the dimensions
%   % ------------------------------
%   dimids = fliplr(dimids);
%   %netcdf.reDef(self.nc_id);
  
  % check Netcdf variable type
  % --------------------------
  switch s.type__
    case {'double', 'NC_DOUBLE'}
      type = netcdf.getConstant('NC_DOUBLE');
    case {'float', 'NC_FLOAT'}
      type = netcdf.getConstant('NC_FLOAT');
    case {'int64', 'long', 'NC_INT64'}
      type = netcdf.getConstant('NC_INT64');
    case {'uint64', 'ulong', 'NC_UINT64'}
      type = netcdf.getConstant('NC_UINT64');
    case {'int', 'int32', 'NC_INT'}
      type = netcdf.getConstant('NC_INT');
    case {'uint', 'uint32' 'NC_UINT'}
      type = netcdf.getConstant('NC_UINT');
    case {'short', 'NC_SHORT'}
      type = netcdf.getConstant('NC_SHORT');
    case {'ushort', 'NC_USHORT'}
      type = netcdf.getConstant('NC_USHORT');
    case {'byte', 'NC_BYTE'}
      type = netcdf.getConstant('NC_BYTE');
    case {'char', 'NC_CHAR'}
      type = netcdf.getConstant('NC_CHAR');
    otherwise
      error('Invalide type : %s\n', s.type__),
  end
  % create variable and get it's varid
  % ----------------------------------
  try
    varid = netcdf.defVar(self.nc_id, key, type, dimids);
  catch ME
    % 'Matlab:us191.netcdf.write:netcdf.defVar',...
    error('Cannot create netcdf variable %s\n%s.', key,  ME.message);
  end
  
  % dynamically reate variable attributes
  % get structure fieldnames from hashtable
  % ---------------------------------------
  ncv_fieldNames  = fieldnames(s);
  
  % loop over fieldname (variable attributes), first is key (code)
  % --------------------------------------------------------------
  for j=1:numel(ncv_fieldNames)
    
    % get fielname and value
    % ----------------------
    fieldName = ncv_fieldNames{j};
    value = s.(fieldName);
    
    % jump each internal fieldname (eg key, data__, type__, dimension__)
    % or empty fieldname
    % -------------------------------------------------------------
    if ~isempty(regexp(fieldName, '__$','ONCE')) || isempty(value)
      continue;
    end
    
    % change struct fieldname FillValue_ to attribute _FillValue
    % ----------------------------------------------------------
    if strcmp( fieldName, 'FillValue_')
      fieldName = '_FillValue';
    end
    
    % BE CARREFULL: it's an very important notice
    % value assign to attribute _FillValue should have same type
    % as variable, true for all numeric atribute variable
    % ------------------------------------------------------
    if isnumeric(value)
      switch s.type__
        case {'double', 'NC_DOUBLE'}
          value = double(value);
        case {'float', 'NC_FLOAT'}
          value = single(value);
        case {'long', 'int64', 'NC_INT64'}
          value = int64(value);
        case {'ulong', 'uint64', 'NC_UINT64'}
          value = uint64(value);
        case {'int', 'int32', 'NC_INT'}
          value = int32(value);
        case {'uint', 'uint32', 'NC_UINT'}
          value = uint32(value);
        case {'short', 'NC_SHORT'}
          value = int16(value);
        case {'ushort', 'NC_USHORT'}
          value = uint16(value);
        case {'byte', 'NC_BYTE'}
          value = int8(value);
        case {'char', 'NC_CHAR'}
          value = char(value);
      end
    end
    
    % Write variable netCDF attribute
    % -------------------------------
    try
      netcdf.putAtt(self.nc_id, varid, fieldName, value);
    catch ME
      warning('netcdf:write', ...
        '%s, when writing %s with netcdf.putAtt',...
        ME.stack(2).name, fieldName);
    end
  end
  
  % Leave define mode and enter data mode to write data.
  % -----------------------------------------------------
  netcdf.endDef(self.nc_id);
  
  % if there is not data for variable or data__ empty
  % ------------------------------------------------
  if ~isfield(s, 'data__') || isempty(s.data__)
    
    % and it's missing_value attribute is set, fill data with missing_value
    % -------------------------------------------------------------------
    if isfield(s, 'missing_value') && ~isempty(s.missing_value)
      
      % get dimension id from name
      % --------------------------
      dimsize = numel(s.dimension__);
      
      % rajouter un test iscell
      
      % set dimids size array
      % ----------------------
      dimids = zeros(dimsize, 1);
      
      % fill dimids array with dimension(s) Id
      % --------------------------------------
      try
        for dim = 1: dimsize
          dimids(dim) = netcdf.inqDimID(self.nc_id, s.dimension__{dim});
        end
      catch ME
        warning('netcdf:write', ...
          'dimension: %s don''t exist, %s (line %d)\n\tin function call: %s',...
          s.dimension__{dim}, ME.stack(2).name, ME.stack(2).line, msg);
        continue;
      end
      
      % get size of pre-allocate dimsize
      % -------------------------------
      dimlen = zeros(dimsize, 1);
      
      % get dimension name and length from it's dimid
      % ---------------------------------------------
      for dim = 1: dimsize
        [dimname, dimlen(dim)] = netcdf.inqDim(self.nc_id, dimids(dim));
      end
      
      % fill data with missing_value
      % could use repmat to do that: s.data__ = repmat(1, dimlen, 1));
      % --------------------------------------------------------------
      if dimsize == 1
        s.data__ = ones(dimlen,1) * s.missing_value;
      else
        s.data__ = ones(dimlen) * s.missing_value;
      end
    else
      
      % if variable don't have attribute missing_value, exit loop and go to
      % next variable
      % -------------------------------------------------------------------
      continue;
    end
    
  end
  
  % BE CAREFULL:
  % cast variable with the right netcdf nctype
  % see
  % http://www.unidata.ucar.edu/software/netcdf/docs/netcdf/External-Types.html#External-Types
  % and netcdf.getConstantNames
  % ------------------------------------------
  switch s.type__
    case {'double', 'NC_DOUBLE'}
      value = double(s.data__);
    case {'float', 'NC_FLOAT'}
      value = single(s.data__);
    case {'long', 'int64', 'NC_INT64'}
      value = int64(s.data__);
    case {'ulong', 'uint64', 'NC_UINT64'}
      value = uint64(s.data__);
    case {'int', 'int32', 'NC_INT'}
      value = int32(s.data__);
    case {'uint', 'uint32', 'NC_UINT'}
      value = uint32(s.data__);
    case {'short', 'NC_SHORT'}
      value = int16(s.data__);
    case {'ushort', 'NC_USHORT'}
      value = uint16(s.data__);
    case {'byte', 'NC_BYTE'}
      value = int8(s.data__);
    case {'char', 'NC_CHAR'}
      value = char(s.data__);
  end
  
%   % matlab use FORTRAN indexing (k,j,i) and lib netcdf come from C  style
%   % indexing (i,j,k)
%   % Matlab documentation is not very clear about this very important tips
%   % see:
%   % http://www.mathworks.com/access/helpdesk/help/techdoc/index.html?/access/helpdesk/help/techdoc/matlab_prog/brrbr9v-1.html&http://www.mathworks.fr/cgi-bin/texis/webinator/search/
%   % -------------------------------------------
%   value = permute(value, fliplr(1:ndims(value)));
  
%   % If a NetCDF variable has valid scale_factor and add_offset
%   % attributes, then the data is scaled accordingly.
%   % ----------------------------------------------------------
%   if self.AutoScale
%     if isfield(s, 'scale_factor') && isfield(s, 'add_offset')
%       value = (value - s.add_offset) / s.scale_factor;
%     end
%   end
  
  % If a NetCDF variable has valid _FillValue attributes, then
  % the data is filled accordingly.
  % ----------------------------------------------------------
  if self.AutoNan && isfield(s, 'FillValue_')
    value(isnan(value)) = s.FillValue_;
  end
  
  % Write data to variable.
  % -----------------------
  try
    % don't create empty variable
    % ---------------------------
    if ~isempty(value)
      netcdf.putVar(self.nc_id, varid, value);
    end
  catch exception
    fprintf('write variable error: %s', s.key__'); %#ok<NOPRT>
    fprintf('check your dynaload csv or xls file !!!\n');
    % 'Matlab:us191.netcdf.write:netcdf.putVar'
    error('Cannot write netcdf file\n%s.', exception.message);  %#ok<CTPCT>
  end
  
  % synchronizes the state of a netCDF file to disk
  % -----------------------------------------------
  netcdf.sync(self.nc_id);
  
end % end for ncv variables loop

if self.Echo
  % Display time to write file on console
  % -------------------------------------
  t = toc; fprintf('...done (%6.2f sec).\n\n',t);
end

% close netcdf file
% -----------------
netcdf.close(self.nc_id)

end % end of write function
