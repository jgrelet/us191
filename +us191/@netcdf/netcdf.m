%% us191.netcdf class
%
% NetCDF object interface based on Matlab R2008b netCDF Library Functions
% This toolbox is in development, be careful....
%
%  us191.netcdf(with no argument) invokes Matlab's "uigetfile" dialog box
%  for selecting the file to open.
%  us191.netcdf(name) opens the specified file or variable in the
%  appropriate application.
%
%  Input:
%    1. name is a NetCDF file, 
%    2. name is an Excel or CSV dynaload file
%    3. name is char like 'memory' and create 
%                   cell array: {'DIMENSIONS','VARIABLES','ATTRIBUTES'}
%
% usage:
%
% >> nc = us191.netcdf('foo.nc')
%
% 	Descriptor:   'netcdf'
% 	Mode:         'NC_WRITE'
% 	AutoNan:       true
% 	AutoScale:     false
% 	AutoForm:      false
% 	File:         'foo.nc'
% 
% 	DIMENSIONS    	10  [us191.Map]
% 	VARIABLES     	48  [us191.Map]
% 	ATTRIBUTES    	21  [us191.Map]
%
% >> keys(nc.DIMENSIONS)'
% 
%     'LATITUDE'
%     'LEVEL'
%     'LONGITUDE'
%     'N1'
%     'POSITION'
%     'STRING14'
%     'STRING256'
%     'STRING4'
%     'STRING8'
%     'TIME'
%
%
% >> nc.ATTRIBUTES
%
% >> keys(nc.ATTRIBUTES)'
%
%     'author'
%     'call_sign'
%     'comment'
%     'conventions'
%     'cycle_mesure'
%     'data_assembly_center'
%     'data_mode'
%     'data_restriction'
%     'data_type'
%     'netcdf_version'
%     'number_instrument'
%     'pi_name'
% ...
%
% >> nc.ATTRIBUTES('cycle_mesure')
%
%     data__: 'PIRATA-FR19'
%
% access to variable :
%
%  >> nc.VARIABLES('TEMP')
% 
%         long_name: 'SEA WATER TEMPERATURE'
%     standard_name: 'sea_water_temperature'
%             units: 'degree_Celsius'
%         valid_min: -1.5000
%         valid_max: 38
%            format: '%6.3lf'
%        FillValue_: 99999
%        resolution: 0.0010
%           comment: 'Ocean temperature'
%        coordinate: 'TIME'
%            type__: 'float'
%            data__: [31x2049 single]
%       dimension__: {'TIME'  'LEVEL'}
%
% >> nc.VARIABLES('TEMP').long_name
%
% ans = SEA WATER TEMPERATURE
%
% Create NetCDF file from Excel or CSV file template:
%
% >> nc = us191.netcdf('tsgqc_netcdf.csv')
% 
% 	Descriptor:   'dynaload'
% 	Mode:         'NC_CLOBBER'
% 	AutoNan:       true
% 	AutoScale:     false
% 	AutoForm:      false
% 	File:         ''
% 
% 	DIMENSIONS    	 9  [us191.Map]
% 	VARIABLES     	66  [us191.Map]
% 	ATTRIBUTES    	32  [us191.Map]
% 	QUALITY       	10  [us191.Map]
%
% Read dat from file and set following example:
%
% >> nc.ATTRIBUTES('CYCLE_MESURE').data__  = 'TOUC0702';
% >> nc.ATTRIBUTES('PLATFORM_NAME').data__ = 'TOUCAN';
% >> nc.VARIABLES('REFERENCE_DATE_TIME').data__ = '19500101000000';
% >> nc.VARIABLES('DAYD').data__ = [2.101736111111113];
% 
% add a new DIMENSIONS :
%
% >> nc.DIMENSIONS('N2') = struct('key__', 'N2', 'value', 2, ...
%                                 'unlimited', 0)
% 
% >> nc.DIMENSIONS.N3    = struct('key__', 'N3', 'value', 6, ...
%                                 'unlimited', 0)
%
% 
% nc.DIMENSIONS('N2')
% 
% ans = 
%      code: 'N2'
%     value: 2
%
% write to NetCDF file :
%
% >> nc.write('toto.nc', 'NC_CLOBBER')
% 
% WRITE_NETCDF_FILE
% ...writing toto.nc : ...done (  0.84 sec).
%
% If a NetCDF variable has _FillValue attributes, 
% then the data with _FillValue are set to NaN. 
% AutoNan is set to true by default
% 
% >> nc.AutoNan = 0;  % disable AutoNan mode
%
% If a NetCDF variable has valid scale_factor and add_offset 
% attributes, then the data is scaled accordingly. 
% AutoScale is set to false by default
% 
% >> nc.AutoScale = 1; % enable AutoScale mode
%
% inside dynaload descrptor, for column type__, you can use NetCDF type
% or native 
% % In NetCDF 3 (classic mode) :
% NetCDF name           Matlab name  Type
% NC_BYTE               int8         8-bit signed integer
% NC_CHAR               uint8        8-bit unsigned integer
% NC_SHORT              int16        16-bit signed integer
% NC_INT (or NC_LONG)   int32        32-bit signed integer
% NC_FLOAT              float        floating point
% NC_DOUBLE             double       64-bit floating point 
%
% In NetCDF 4 :
% NetCDF name           Matlab name  Type
% NC_BYTE               int8         8-bit signed integer
% NC_CHAR               uint8        8-bit unsigned integer
% NC_SHORT              int16        16-bit signed integer
% NC_USHORT             uint16       16-bit unsigned integer *
% NC_INT (or NC_LONG)   int32        32-bit signed integer
% NC_UINT               unint32      32-bit unsigned integer *
% NC_INT64              int64        64-bit signed integer *
% NC_UINT64             uint64       64-bit unsigned integer *
% NC_FLOAT              float        floating point
% NC_DOUBLE             double       64-bit floating point 
% NC_STRING             string       string length  (need to be testing) 

% $Id: netcdf.m 646 2012-01-09 20:46:39Z jgrelet $

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

%% Classdef definition
% -------------------

classdef netcdf < us191.dynaload 
  
  % properties definitions
  % ----------------------
  properties (Access = public)
    File               = '';            % NetCDF filename
    Descriptor         = '';            % file descriptor, sould be :
                                        % netcdf, dynaload or memory
    AutoNan            = logical(1);    % fill _Fillvalue attribute with N/A
    AutoScale          = logical(1);    % compute real value from slope and offset
    AutoForm           = logical(0);    % display attribute form
    Mode               = 'NC_NOWRITE';  % netcdf acces mode
  end
  
  properties (Access = private, Hidden)
    nc_id              = 0;
  end
  
  properties (Constant = true, Hidden)
    
    % constants for netcdf data types
    % -------------------------------
    NC_BYTE             = netcdf.getConstant('NC_BYTE');    % 1
    NC_CHAR             = netcdf.getConstant('NC_CHAR');    % 2
    NC_SHORT            = netcdf.getConstant('NC_SHORT');   % 3
    NC_INT              = netcdf.getConstant('NC_INT');     % 4
    NC_LONG             = netcdf.getConstant('NC_LONG');    % 4
    NC_FLOAT            = netcdf.getConstant('NC_FLOAT');   % 5
    NC_DOUBLE           = netcdf.getConstant('NC_DOUBLE');  % 6
    
    NC_MEMORY           = -1;
    
    % constants for netcdf.open()
    % ---------------------------
    % NC_NOWRITE:	Read-only access
    NC_NOWRITE          = netcdf.getConstant('NC_NOWRITE');   % 0
    
    % NC_WRITE:      	Read-write access
    NC_WRITE            = netcdf.getConstant('NC_WRITE');     % 1
    
    % constants for netcdf.create()
    % -----------------------------
    NC_CLOBBER          = netcdf.getConstant('NC_CLOBBER');   % 0
    
    % NC_NOCLOBBER:    Prevent overwriting of existing file with the same name.
    NC_NOCLOBBER        = netcdf.getConstant('NC_NOCLOBBER'); % 4
    
    % NC_SHARE:	       Allow synchronous file updates.
    NC_SHARE            = netcdf.getConstant('NC_SHARE');     % 2048
    
    % NC_64BIT_OFFSET: Allow easier creation of files and variables which
    %                  are larger than two gigabytes.
    NC_64BIT_OFFSET     = netcdf.getConstant('NC_64BIT_OFFSET');  % 512
    
    % general constant
    % ----------------
    NC2_ERR             = netcdf.getConstant('NC2_ERR');      % -1
    NC_EBADDIM          = netcdf.getConstant('NC_EBADDIM');
    NC_EBADID           = netcdf.getConstant('NC_EBADID');
    NC_EBADNAME         = netcdf.getConstant('NC_EBADNAME');
    NC_EBADTYPE         = netcdf.getConstant('NC_EBADTYPE');
    NC_ECHAR            = netcdf.getConstant('NC_ECHAR');
    NC_EDIMSIZE         = netcdf.getConstant('NC_EDIMSIZE');
    NC_EEDGE            = netcdf.getConstant('NC_EEDGE');
    NC_EEXIST           = netcdf.getConstant('NC_EEXIST');
    NC_EGLOBAL          = netcdf.getConstant('NC_EGLOBAL');
    NC_EINDEFINE        = netcdf.getConstant('NC_EINDEFINE');
    NC_EINVAL           = netcdf.getConstant('NC_EINVAL');
    NC_EINVALCOORDS     = netcdf.getConstant('NC_EINVALCOORDS');
    NC_EMAXATTS         = netcdf.getConstant('NC_EMAXATTS');
    NC_EMAXDIMS         = netcdf.getConstant('NC_EMAXDIMS');
    NC_EMAXNAME         = netcdf.getConstant('NC_EMAXNAME');
    NC_EMAXVARS         = netcdf.getConstant('NC_EMAXVARS');
    NC_ENAMEINUSE       = netcdf.getConstant('NC_ENAMEINUSE');
    NC_ENFILE           = netcdf.getConstant('NC_ENFILE');
    NC_ENOMEM           = netcdf.getConstant('NC_ENOMEM');
    NC_ENORECVARS       = netcdf.getConstant('NC_ENORECVARS');
    NC_ENOTATT          = netcdf.getConstant('NC_ENOTATT');
    NC_ENOTINDEFINE     = netcdf.getConstant('NC_ENOTINDEFINE');
    NC_ENOTNC           = netcdf.getConstant('NC_ENOTNC');
    NC_ENOTVAR          = netcdf.getConstant('NC_ENOTVAR');
    NC_EPERM            = netcdf.getConstant('NC_EPERM');
    NC_ERANGE           = netcdf.getConstant('NC_ERANGE');
    NC_ESTRIDE          = netcdf.getConstant('NC_ESTRIDE');
    NC_ESTS             = netcdf.getConstant('NC_ESTS');
    NC_ETRUNC           = netcdf.getConstant('NC_ETRUNC');
    NC_EUNLIMIT         = netcdf.getConstant('NC_EUNLIMIT');
    NC_EUNLIMPOS        = netcdf.getConstant('NC_EUNLIMPOS');
    NC_EVARSIZE         = netcdf.getConstant('NC_EVARSIZE');
    NC_FATAL            = netcdf.getConstant('NC_FATAL');       % 1
    NC_FILL             = netcdf.getConstant('NC_FILL');        % 0
    NC_FILL_BYTE        = netcdf.getConstant('NC_FILL_BYTE');   % -127
    NC_FILL_CHAR        = netcdf.getConstant('NC_FILL_CHAR');   % 0
    NC_FILL_DOUBLE      = netcdf.getConstant('NC_FILL_DOUBLE'); % 9.9692e+036
    NC_FILL_FLOAT       = netcdf.getConstant('NC_FILL_FLOAT');  % 9.9692e+036
    NC_FILL_INT         = netcdf.getConstant('NC_FILL_INT');    % -2.1475e+009
    NC_FILL_SHORT       = netcdf.getConstant('NC_FILL_SHORT');  % -32767
    NC_FORMAT_64BIT     = netcdf.getConstant('NC_FORMAT_64BIT');   % 2
    NC_FORMAT_CLASSIC   = netcdf.getConstant('NC_FORMAT_CLASSIC'); % 1
    NC_GLOBAL           = netcdf.getConstant('NC_GLOBAL');       % -1
    NC_LOCK             = netcdf.getConstant('NC_LOCK');         % 1024
    NC_MAX_ATTRS        = netcdf.getConstant('NC_MAX_ATTRS');    % 8192
    NC_MAX_DIMS         = netcdf.getConstant('NC_MAX_DIMS');     % 1024
    NC_MAX_NAME         = netcdf.getConstant('NC_MAX_NAME');     % 256
    NC_MAX_VARS         = netcdf.getConstant('NC_MAX_VARS');     % 8192
    NC_MAX_VAR_DIMS     = netcdf.getConstant('NC_MAX_VAR_DIMS'); % 1024
    NC_NAT              = netcdf.getConstant('NC_NAT');          % 0
    NC_NOERR            = netcdf.getConstant('NC_NOERR');        % 0
    NC_NOFILL           = netcdf.getConstant('NC_NOFILL');       % 256
    NC_SIZEHINT_DEFAULT = netcdf.getConstant('NC_SIZEHINT_DEFAULT');  % 0
    NC_UNLIMITED        = netcdf.getConstant('NC_UNLIMITED');    % 0
    NC_VERBOSE          = netcdf.getConstant('NC_VERBOSE');      % 2
    
  end
  
  % public functions
  % ----------------
  methods
    
    % constructor
    % -----------
    function self = netcdf(varargin)
      
      arg = nargin;
      
      if arg == 1 && isempty(varargin{1})
        arg = 0;
      end
      
      % initialisation
      theFile = ''; theDescriptor = ''; theDynaload = '';
      theMode = 'NC_NOWRITE';
      theEcho = true;
      
      switch arg
        
        % with not arg, read netcdf file with uigetfile
        % ---------------------------------------------
        case 0           
          [fileName, pathName] = uigetfile(...
            {'*.nc;*.cdf','NetCDF (*.nc,*.cdf)';
             '*.xls;*.xlsx;*.csv','Dynaload (*.xls,*.xlsx,*.csv)'}, ...
             'Select file');
          if any(fileName)
            theFile = fullfile(pathName, fileName);
            [pathName, fileName, fileExt] = fileparts(theFile); %#ok<ASGLU>
            theDynaload = {'DIMENSIONS','VARIABLES','ATTRIBUTES'};
            switch fileExt
              case {'.nc', 'cdf'}
                theDescriptor = 'netcdf';
                theMode = 'NC_NOWRITE';
              case {'.csv', '.xls', '.xlsx'}
                theDynaload = theFile;
                theFile = '';
                theDescriptor = 'dynaload';
                theMode = 'NC_WRITE';
              otherwise
                error('Wrong file type');
            end
          else
            theFile = '';
          end
                   
          % with one arg, read given netcdf filename
          % ----------------------------------------
        case 1
          if( strcmp(varargin{1}, 'memory'))
            theDescriptor     = 'memory';
            theMode           = 'NC_CLOBBER';
            theFile           = '';     
            theDynaload       = {'DIMENSIONS','VARIABLES','ATTRIBUTES'};
            
          elseif( isa(varargin{1}, 'char'))
            theFile = varargin{1};
            if isempty(exist(theFile, 'file'))
              error('us191.netcdf: %s file don''t exist.\n', theFile );  
            end
            [pathName, fileName, fileExt] = fileparts(theFile); %#ok<ASGLU>
            
            switch fileExt
              case {'.nc', 'cdf'} 
                theDescriptor = 'netcdf';
                theMode       = 'NC_NOWRITE';
                theDynaload   = {'DIMENSIONS','VARIABLES','ATTRIBUTES'};
              case {'.csv', '.xls', '.xlsx'}
                theDynaload   = theFile;
                theFile       = '';
                theDescriptor = 'dynaload';
                theMode       = 'NC_CLOBBER';                
              otherwise
                error('Wrong file type');
            end
            
          else
            error('Wrong input argument');
          end
          
          % work on given netcdf filename with mode and dynaload dexcriptor
          % file
          % ---------------------------------------------------------------
        case 2
          
          if( strcmp(varargin{1}, 'memory'))
            theDescriptor     = 'memory';
            theMode           = 'NC_CLOBBER';
            theFile           = '';     
            theDynaload       = {'DIMENSIONS','VARIABLES','ATTRIBUTES'};
            
          elseif( isa(varargin{1}, 'char'))
            theFile = varargin{1};
            if isempty(exist(theFile, 'file'))
              error('us191.netcdf: %s file don''t exist.\n', theFile );  
            end
            [pathName, fileName, fileExt] = fileparts(theFile); %#ok<ASGLU>
            
            switch fileExt
              case {'.nc', 'cdf'} 
                theDescriptor = 'netcdf';
                theMode       = 'NC_NOWRITE';
                theDynaload   = {'DIMENSIONS','VARIABLES','ATTRIBUTES'};
              case {'.csv', '.xls', '.xlsx'}
                theDynaload   = theFile;
                theFile       = '';
                theDescriptor = 'dynaload';
                theMode       = 'NC_CLOBBER';                
              otherwise
                error('Wrong file type');
            end
          end
          
          % is the mode numeric.
          if ischar(varargin{2})
            %  convert it in numeric value
            switch (varargin{2})
              case { 'NC_WRITE', 'NC_CLOBBER', 'NC_NOCLOBBER', 'NC_SHARE' };
                theMode = varargin{2};
              otherwise
                error('Wrong mode to create netcdf file: %s', varargin{2});
            end
            
          % Defines the echo property (print or not read / write /
          % warnings on the command window)
          elseif islogical(varargin{2})
            theEcho = varargin{2};
          
          else
            % a modifier sur Mode est numeric
            theMode = varargin{2};
          end
          
        otherwise
          error('Wrong number of input arguments');
      end
      
      % Object Initialization
      % Call base-class constructor before accessing object
      % ---------------------------------------------------
      self@us191.dynaload( theDynaload );
      
      % properties initialization
      % -------------------------
      self.File       = theFile;
      self.Descriptor = theDescriptor;
      self.Mode       = theMode;
      self.Echo       = theEcho;
      
      % call private function following mode state
      % a revoir !!!!!!!!!!!!!!!
      % ------------------------------------------
      switch self.Descriptor
        case 'netcdf'     % 
          read(self);
          self.Mode = 'NC_WRITE';
        case 'memory'     
          self.Mode = 'NC_CLOBBER';
        case 'dynaload'
          self.Mode = 'NC_CLOBBER';
        otherwise
          error('Wrong descriptor type');
      end
      
    end % end of constructor
    
    % close netcdf file
    % -----------------
    function close(self)
      if self.nc_id
        netcdf.close(self.nc_id);
      end
    end
    
    % display netcdf object
    % -----------------------
    function display(self)
      
      % diplay help in hypertext link
      % ------------------------------
      %fprintf('<a href="matlab:help us191.netcdf">us191.netcdf</a>\n');
      
      % use local variables for displaying boolean
      % ------------------------------------------
      if self.AutoNan,   theAutonan   = 'true'; else theAutonan   = 'false'; end
      if self.AutoScale, theAutoscale = 'true'; else theAutoscale = 'false'; end
      if self.AutoForm,  theAutoform  = 'true'; else theAutoform  = 'false'; end
            
      % display properties
      % ------------------
      fprintf('\n');
      fprintf('\tDescriptor:     ''%s''\n', self.Descriptor);
      fprintf('\t      Mode:     ''%s''\n', self.Mode);
      fprintf('\t   AutoNan:     ''%s''\n', theAutonan);
      fprintf('\t AutoScale:     ''%s''\n', theAutoscale);
      fprintf('\t  AutoForm:     ''%s''\n', theAutoform);
      
      % call base class display
      % -----------------------
      display@us191.dynaload(self);
      
      % diplay methods list in hypertext link
      % -------------------------------------
      %disp('list of <ahref="matlab:methods(''us191.netcdf'')">methods</a>');
      
    end
    
    % properties set/get methods
    % --------------------------
    function self = set.File(self, theAutoAccess)
      if (~ischar(theAutoAccess))
        error('us191:netcdf:File', 'us191.netcdf:set.File: Filename must be a string')
      end 
      self.File = theAutoAccess;
    end
    
    function theFile = get.File(self)
      theFile = self.File;
    end
    
    function self = set.Mode(self, theValue)
      self.Mode = theValue;
    end
    
    function theMode = get.Mode(self)
      theMode = self.Mode;
    end
    
    function theDescriptor = get.Descriptor(self)
      theDescriptor = self.Descriptor;
    end
    
    function theAutoNan = get.AutoNan(self)
      theAutoNan = self.AutoNan;
    end
    
    function self = set.AutoNan(self, theValue)
      if (~islogical(theValue))
        error('us191:netcdf:AutoNan', 'us191.netcdf:set.AutoNan: value must be a boolean')
      end       
      self.AutoNan = logical(theValue);
    end
    
    function theAutoScale = get.AutoScale(self)
      theAutoScale = self.AutoScale;
    end
    
    function self = set.AutoScale(self, theValue)
      if (~islogical(theValue))
        error('us191:netcdf:AutoScale', 'us191.netcdf:set.AutoScale: value must be a boolean')
      end
      self.AutoScale = logical(theValue);
    end
    
    function theAutoForm = get.AutoForm(self)
      theAutoForm = self.AutoForm;
    end
    
    function self = set.AutoForm(self, theValue)
      if (~islogical(theValue))
        error('us191:netcdf:AutoForm', 'us191.netcdf:set.AutoForm: value must be a boolean')
      end
      self.AutoForm = logical(theValue);
    end
    
    % prototype of public functions in separate files
    % -----------------------------------------------
    theResult = load(self, varargin);
    write(self, varargin);
    form(self);
    
  end % end of public methods
  
  % static methods
  % --------------
  methods (Static)
    
    % get netcdf constant name from data type
    % ----------------------------------------------------
    function name = getConstantNames(xtype)
      switch xtype
        case  1   % NC_BYTE 1
          name = 'byte';
        case  2   % NC_CHAR 2
          name = 'char';
        case  3   % NC_SHORT 3
          name = 'short';
        case  4   % NC_INT, NC_LONG 4
          name = 'int';
        case  5   %NC_FLOAT 5
          name = 'float';
        case  6   % NC_DOUBLE 6
          name = 'double';
        otherwise
          error( 'unhandled data type %d\n', xtype );
      end
    end
    
  end % end of static methods
  
  % private functions
  % -----------------
  methods %(Access = private)
    
    % prototype of function that was in separate files
    % ------------------------------------------------
    read(self); 
    
  end % end of private methods
  
end % end of class netcdf
