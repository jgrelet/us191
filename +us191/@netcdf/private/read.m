function read(self)
% us191.netcdf.read
% private function read of netcdf toolbox
%
% $Id: read.m 654 2012-01-10 22:15:59Z jgrelet $

% check file validity
% -------------------
self.nc_id = netcdf.open(self.File, self.Mode);
if self.nc_id == -1
  error(['us191.netcdf:netcdf', ...
    'The specified data file ''%s'' does not exist\n' ...
    'or is not in the directory which is on the MATLAB path'],...
    self.File);
end


% Eventually display more info about read file on console
% -------------------------------------------------------
if self.Echo
  fprintf('\nREAD_NETCDF_FILE\n'); tic;
  fprintf('...reading ''%s'' : ', self.File);
end

% returns the number of dimensions, variables, global attributes and
% eventually unlimited dimension in a netCDF file.
% ------------------------------------------------------------------
[n_dims, nvars, ngatts, unlimdimid] = netcdf.inq(self.nc_id);

% get dimensions and store to netcdf hashtable
% --------------------------------------------
for dimid = 0:n_dims-1
  
  % initialize empty structure
  % --------------------------
  s = [];
  
  % Get name and length of id dimension
  % -------------------------------------
  [dimname, dimlen] = netcdf.inqDim(self.nc_id, dimid);
  
  % Get dimid (dimension id) from name
  % normalement pas besoin, a verifier....
  % ----------------------------------
  %dimid = netcdf.inqDimId(self.nc_id, dimname);
  
  % add private member key__
  % ------------------------
  s.key__  = dimname;
  
  % fill dimension structure with name and boolean for unlimdimid
  % -------------------------------------------------------------
  s.dimlen = dimlen;
  if(dimid == unlimdimid)
    s.unlimited = true;
  else
    s.unlimited = false;
  end
  
  % put dimension name and length to DIMENSIONS hashtable
  % ----------------------------------------------------
  put(self, 'DIMENSIONS', dimname, s);
end

% get variables and store to netcdf hashtable
% -------------------------------------------
for id = 0:nvars-1
  
  % initialize empty structure
  % --------------------------
  s = [];
  
  % return information about variable
  % ---------------------------------
  [varName, xtype, dimids, natts] = netcdf.inqVar(self.nc_id, id);
  
  % add private member key__
  % ------------------------
  s.key__ = varName;
  
  % initialize dimension__ here for structure member order
  % ------------------------------------------------------
  s.dimension__ = [];
     
  % add internal type__ member from xtype 2->char, 6->double
  % --------------------------------------------------------
  s.type__ = us191.netcdf.getConstantNames(xtype);  
  
  % fill structure s with variable attribute names and values
  % ---------------------------------------------------------
  for attid = 0:natts-1
    
    % get attribute name
    % ------------------
    attName = netcdf.inqAttName(self.nc_id, id, attid);
    
    % if attribute name is '_FillValue', transforme to 'FillValue,
    % because Matlab dosn't handle member name begining with '_'
    % ------------------------------------------------------------
    if strcmp(attName, '_FillValue')
      s.('FillValue_') = netcdf.getAtt(self.nc_id, id, attName);
      
    else
      
      % otherwise, dynamically fill attribute member of structure s
      % with it's value
      % -----------------------------------------------------------
      s.(attName) = netcdf.getAtt(self.nc_id, id, attName);
    end
    
  end  % end for loop over variable attributes
  
  % fill temporary structure s with value
  % -------------------------------------
  s.data__ = netcdf.getVar(self.nc_id, id);
  
  % If a NetCDF variable has valid scale_factor and add_offset
  % attributes, then the data is scaled accordingly.
  % ----------------------------------------------------------
  if self.AutoScale
    if isfield(s, 'scale_factor') && isfield(s, 'add_offset')
      
      % memorize FillValue index before conversion
      % ------------------------------------------
      if isfield(s, 'FillValue_')
         ind = (s.data__ == s.('FillValue_'));
      end
      
      % apply conversion, value need to be cast
      % ---------------------------------------
      if  isa(s.scale_factor, 'single')
        s.data__ = single(s.data__) * s.scale_factor + s.add_offset;
      elseif  isa(s.scale_factor, 'double')
        s.data__ = double(s.data__) * s.scale_factor + s.add_offset;
      else
        s.data__ = double(s.data__) * double(s.scale_factor) + double(s.add_offset);
      end
      
      % replace FillValue by NaN after conversion
      % -----------------------------------------
      if isfield(s, 'FillValue_')
         s.data__(ind) = NaN;
      end
    end
  end
  
  % replace FillValue_ by NaN only for numeric variable
  % AutoNan mode is set to true by default
  % ---------------------------------------------------
  if self.AutoNan && isfield(s, 'FillValue_')
    switch(xtype)
      case self.NC_CHAR
        % do nothing, FillValue as no sense for char.
        
      case { self.NC_DOUBLE, self.NC_FLOAT, self.NC_LONG,...
          self.NC_SHORT, self.NC_BYTE }
        
        % sometimes, FillValue could be a char in malformed NetCDF
        % files
        % --------------------------------------------------------
        if isnumeric(s.('FillValue_'))
          s.data__(s.data__ == s.('FillValue_')) = NaN;
        else
          s.data__(s.data__ == str2double(s.('FillValue_'))) = NaN;
          
          % verrue, pour les fichiers Roscop netcdf mal formes
          % --------------------------------------------------
          if str2double(s.('FillValue_')) > 1e35
            s.data__(s.data__ >= 1e35) = NaN;
          end
        end
        
      otherwise
        error( 'unhandled datatype %d\n', xtype );
    end % end switch
  end % end if
  
% not necessary !!!!  
%   % if var is char and as vertical alignment, transpose it
%   % ------------------------------------------------------
%   if xtype == self.NC_CHAR && (size(s.data__', 1) == 1)
%     s.data__ = s.data__';
%     
%     % Because MATLAB uses FORTRAN-style indexing, we need to transpose
%     % N-D array (k,i,j,...) to (i,j,k,...) however, the order of
%     % the dimension IDs is reversed relative to what would be obtained
%     % from the C API
%     % If s.data__ is a vector, NetCDF API return vertical vector,
%     % do nothing, it's OK
%     % -----------------------------------------------------------------
%   elseif length(dimids) > 1
%     s.data__ = permute(s.data__, fliplr(1:length(dimids)));
%     dimids = fliplr(dimids);
%   end
  
  % add internal dimension__ member with dimensions names
  % -----------------------------------------------------
  for dimid = 1:numel(dimids)
    dimname = netcdf.inqDim(self.nc_id, dimids(dimid));
    
    % add next dimension name to cell
    % -------------------------------
    s.dimension__{dimid} = dimname;
  end
  
  % in case of unlimited dimensions set at 0
  % ----------------------------------------
  if isempty(dimids)
    s.dimension__ = [];
  end
  
  % put variable name and value to VARIABLES hashtable
  % ----------------------------------------------------
  put(self, 'VARIABLES', varName, s);
  
end

% get gloabal attributes and store to netcdf hashtable
% -----------------------------------------------------
for id = 0:ngatts-1
  
  % initialize empty structure
  % --------------------------
  s = [];
  
  % Get the name of the global attribute associated with the
  % variable.
  % --------------------------------------------------------
  gattName = netcdf.inqAttName(self.nc_id, ...
    us191.netcdf.NC_GLOBAL, id);
  
  % add private member key__
  % ------------------------
  s.key__ = gattName;
  
  % Get value of global attribute.
  % ------------------------------
  s.data__ = netcdf.getAtt(self.nc_id, ...
    us191.netcdf.NC_GLOBAL, gattName);
  
  % put variable name and value to VARIABLES hashtable
  % ----------------------------------------------------
  put(self, 'ATTRIBUTES', gattName, s);
  
end

if self.Echo
  % Display time to read file on console
  % -------------------------------------
  t = toc; fprintf('...done (%6.2f sec).\n',t);
end

end
