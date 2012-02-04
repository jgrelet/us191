%% us191.dynaload class
%
% file +us191/@dynaload/dynaload
%
% Class used to load complex object descriptor from Excel (xls) or
% ASCII (csv) files
% Usually Excel file is used during development under Windows, and csv file
% is create and use in production.
% dynaload inherit from dynamicprops and is handle class
%
% >> d = us191.dynaload('tsgqc_netcdf.csv')
% 	      file: 'C:\...\toolbox\+us191\demos\netcdf\tsgqc_netcdf.csv'
%   MagicField: [data__]
%   AutoAccess: 'false'
% 
% 	DIMENSIONS    	 9  [us191.hashtable]
% 	VARIABLES     	66  [us191.hashtable]
% 	ATTRIBUTES    	32  [us191.hashtable]
% 	QUALITY       	10  [us191.hashtable]
%
% >> d.VARIABLES
%   us191.hashtable handle
%   Package: us191
%
% Properties:
%       Count: 66
%     KeyType: 'char'
%   ValueType: 'any'
% 	MagicField: [data__]
%  AutoAccess: 'false'
% 
%     'CNDC'                   [1x1 struct]
%     'CNDC_CAL'               [1x1 struct]
%     'CNDC_CALCOEF'           [1x1 struct]
%     'CNDC_CALCOEF_CONV'      [1x1 struct]
%      ...
%     'SSTP'                   [1x1 struct]
%     'SSTP_CAL'               [1x1 struct]
%     'SSTP_QC'                [1x1 struct]
%
% >> keys(d.VARIABLES)
%
%     ''CNDC''    ''CNDC_CAL''    ''CNDC_CALCOEF''    ''CNDC_CALCOEF_CONV''
%      ...
%     ''SSTP''    ' 'SSTP_CAL''   ''SSTP_QC''
%
% % get value :
% >> d.VARIABLES('SSTP')
% 
%            key__: 'SSTP'
%       dimension__: {'DAYD'}
%            type__: 'float'
%         long_name: 'SEA SURFACE TEMPERATURE'
%     standard_name: 'sea_surface_temperature'
%             units: 'degree_Celsius'
%       conventions: ''
%         valid_min: -1.5000
%         valid_max: 38
%            format: '%6.3lf'
%        FillValue_: 99999
%         epic_code: []
%              axis: ''
%        resolution: 1.0000e-003
%           comment: [1x99 char]
%     default_value: []
%        coordinate: 'DAYD'
%            data__: []
%
%
% % get field value:
% >> value = d.VARIABLES('SSTP').long_name
% value = 
% SEA SURFACE TEMPERATURE
%
% % change value :
% >> d.VARIABLES('SSTP').long_name = 'new SEA SURFACE TEMPERATURE name'
% % or
% >> d.VARIABLES.SSTP.long_name = 'new SEA SURFACE TEMPERATURE name'
%
% % use of AutoAccess mode :
% >> d.AutoAccess = 1;
% d.VARIABLES('SSTP') = 25.257;
% d.VARIABLES('SSTP')
% 
% ans =
%    25.2570

% % convert Excel file to csv :
% >> save(d, 'tsgqc_netcdf.csv');
% % or
% >> d.write('tsgqc_netcdf.csv');
%
% % csv file format :
% >> type +us191/demos/netcdf/tsgqc_netcdf.csv
%
% tsgqc_netcdf.csv
%
% $DIMENSIONS$
% #;code;value;#
% #;char;integer;#
% #;PROFILE;120;#
% ...
% %
% $VARIABLES$
% #;code;dimension;nctype;long_name;standard_name;units;conventions;valid_min;valid_max;format;FillValue_;epic_code;axis;resolution;comment;missing_value;#
% #;char;cell;char;char;char;char;char;double;double;char;double;double;char;double;char;double;#
% #;REFERENCE_DATE_TIME;'STRING14';char;REFERENCE DATE TIME FOR JULIAN DAYS;reference date time;;yyyymmddhhmmss;;;;;;;;Reference date for julian days origin;;#
% ...
%
% % An instance of dynaload can be created in memory, arguments are the dynamic
% % properties initializing to empty us191.hashtable object:
%
% m = us191.dynaload('DIMENSIONS','VARIABLES','ATTRIBUTES')
% 	     file:  'memory'
%   MagicField: [data__]
%   AutoAccess: 'false'
% 
% 	DIMENSIONS    	 0  [us191.hashtable]
% 	VARIABLES     	 0  [us191.hashtable]
% 	ATTRIBUTES    	 0  [us191.hashtable]
%
% m.DIMENSIONS('STRING4') = 4;
% m.VARIABLES('TEMP')=struct('long_name','Temperature','FillValue',99999,...
%   'dimension',{'DAYD'},'nctype','float','data__',[20.0 21.2 23.5]);
% etc ... 
%
% $Id: dynaload.m 621 2011-12-14 21:48:31Z jgrelet $

%% COPYRIGHT & LICENSE
%  Copyright 2009 - IRD US191, all rights reserved.
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
%    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%% Classdef definition
% -------------------
classdef dynaload < dynamicprops
  
  % properties definitions
  % ----------------------
  properties (Access = private)
    
    % private property, inherited class must be redefine this property
    File               = '';
    
  end
  
  properties (Access = private, Hidden)
    
    % internal properties used for descriptor file informations
    line               = 0;
    fid                = 0;
    
  end
  
  properties (Access = protected, Hidden)
    
    % store dynamic property names (cell array) given by
    % meta.DynamicProperty instance, used by display method
    meta;
    
  end
  
  % properties (Access = protected)
    properties (Access = public)%, Dependent = true)
      
    % the MagicField, used by us191.hashtable or us191.Map object to set 
    % direct access from/to special field when value is a structure in
    % hashtable
    MagicField = 'data__';            %  by default
    
    % enable/disable automatic access to MagicField
    AutoAccess = false;
    
    % Print or not the results of read and write methods
    Echo;
    
  end
  
  % public functions
  % ----------------
  methods
    
    % constructor
    % -----------
    function self = dynaload(varargin)
      
      % init default value
      % ------------------
      filterIndex = 0; theArg = []; theFileName = 'memory';
      
      % test constructor argument
      % ------------------------
      switch nargin
        
        % default constructor, try to open dynaload file descriptor
        % ---------------------------------------------------------
        case 0
          [fileName, pathName, filterIndex] = uigetfile(...
            {'*.csv','Ascii-file (*.csv)';...
            '*.xls;*.xlsx','Excel-file (*.xls,*.xlsx)'}, 'Select file'); 
          if ~any(fileName)
            self.File = 'memory';
            return
          else
            theFileName = fullfile(pathName, fileName);
          end
          
          % one arg, if it is a dynaload filename, open it, otherwise,
          % create new dynamic propertiy
          % ----------------------------------------------------------
        case 1
          
          if (isa(varargin{1}, 'char'))
            
            % if file exist and is in the search path, return 2
            % --------------------------------------------------
            if exist(varargin{1}, 'file') == 2
              theFileName = varargin{1};
              
            else
              
              % if file is in matlab path directories
              % -------------------------------------
              theFileName = which(varargin{1});
              
              % if not, bad name, return an error
              % ---------------------------------
              if isempty( theFileName)                
                error('Wrong or bad file: %s', varargin{1});
              end
           end
            
            % return the pieces of a theFileName specification
            % -------------------------------------------------
            [pathName, fileName, fileExt] = fileparts(theFileName); %#ok<ASGLU>
               
            % switch from file extension to numeric val like uigetfile
            % ---------------------------------------------------------
            switch fileExt
              case '.csv'
                filterIndex = 1;
              case {'.xls','.xlsx'}
                filterIndex = 2;
              otherwise
                error('Wrong file type: %s', fileExt);
            end
           
            % if argument is a cell, initialise theArg for dynamic prop
            % ---------------------------------------------------------
          elseif (isa(varargin{1}, 'cell'))
            theArg = varargin{1};
            
            % bad or unknow constructor argument
            % ----------------------------------
          else
            error('Wrong input argument');
          end
          
          % initialise theArg for dynamic prop
          % ----------------------------------
        otherwise
          theArg = varargin;
      end
      
      % execute the rigth statement following file extention
      % ---------------------------------------------------
      self.File = theFileName;
      
      % create dynamics properties and initialize to empty us191.hashtable
      % only when theArg is defined
      % -----------------------------------------------------------------
      for i = 1: length(theArg)
        
        % create new dynamic property
        % ----------------------------
        prop = theArg{i};
        metaDP = self.addprop(prop);
        
        % fill property meta with new created dynamic property name
        % ---------------------------------------------------------
        if isempty(self.meta)
          self.meta{1} = metaDP.Name;
        else
          self.meta{end+1} = metaDP.Name;
        end
        
        % assign dynamically us191.hashtable object to dynamic property
        % -------------------------------------------------------------
        self.(prop) = us191.hashtable;
      end
      
      % call read_xxx_file functions
      % ----------------------------
      switch filterIndex
        case 0
          % memory, do nothing
        case 1
          read_csv_file(self);
        case 2
          read_xls_file(self);
        otherwise
          error('Wrong filterIndex');
      end
      
      % By default, print the result of write and read methods
      self.Echo = true;
      
    end % end of constructor
    
    % property File is private, we can't use get.File interface 
    % ---------------------------------------------------------
    function theFile = getFilename(self)
      theFile = self.File;
    end
    
    % assessors
    % ---------    
    function magicField = get.MagicField(self)
      magicField = self.MagicField;
    end
    
    function set.MagicField(self, magicField)
      self.MagicField = magicField;
      for dp = self.meta %#ok<MCSUP>
        self.(char(dp)).MagicField = self.MagicField;
      end
    end
    
    function theAutoAccess = get.AutoAccess(self)
      theAutoAccess = self.AutoAccess;
    end
    
    function set.AutoAccess(self, theAutoAccess)
      self.AutoAccess = theAutoAccess;
      for dp = self.meta %#ok<MCSUP>
        self.(char(dp)).AutoAccess = self.AutoAccess;
      end
    end
    
    % add new key / value in dynamic propertie hash (us191.hashtable instance)
    % ---------------------------------------------------------------------
    function put(self, hash, theKey, theValue)
      
      % us191.hashtable writing rule,
      % ex: self.VARIABLES('TEMP') = value
      % ----------------------------------
      self.(hash)(theKey) = theValue;
    end
    
    % display dynaload object
    % -----------------------
    function display(self)
 
      % convert logical AutoAccess to char
      % ----------------------------------
      if self.AutoAccess, theAutoAccess = 'true'; else theAutoAccess = 'false'; end
      if isempty(self.MagicField), mf ='[]'; else mf = self.MagicField; end  
      if self.Echo, echo = 'true'; else echo = 'false'; end
      
      % diplay help in hypertext link
      % -----------------------------
      %fprintf('<a href="matlab:help us191.dynaload">us191.dynaload</a>\n');
      fprintf('        File:     ''%s''\n',   self.File);
      fprintf('  MagicField:     ''%s''\n',   mf);
      fprintf('  AutoAccess:     ''%s''\n',   theAutoAccess);
      fprintf('        Echo:     ''%s''\n\n', echo);
      
      % display dynamic properties names and types
      % ------------------------------------------
      for dp = self.meta
        fprintf('\t%-14s\t%2d  [%-9s]\n', ...
          char(dp), length(keys(self.(char(dp)))), class(self.(char(dp))));
      end
      fprintf('\n');
      
      % diplay methods list in hypertext link, debug only
      % -------------------------------------------------
      disp('list of <a href="matlab:methods(''us191.dynaload'')">methods</a>');
    end
    
    % The concatenation of us191.dynaload objects
    % --------------------------------------------
    function self = vertcat(self, dyna) %#ok<MANU,INUSD>
      
      % display warning
      % ---------------
      error('dynaload:vertcat',...
              'methods vertcat is not implemented at this time'); 
      
    end % end of vertcat
    
    % prototype of public functions in separate files
    % -----------------------------------------------
    %self = subsasgn(self, s, val);
    write(self, varargin);
    save(self, varargin);
    
  end % end of public methods
    
  % private functions
  % -----------------
  methods (Access = private)
    
    % prototype of function that was in separate files
    % ------------------------------------------------
    read_csv_file(self);
    read_xls_file(self);
    [h, nb_members, blk_size, nb_line] = read_block(self, h );
    
  end % end of private methods
  
end % end of class
