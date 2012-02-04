%% us191.Map class
% US191.MAP  Provide access to containers.Map (hashtable with key/value pair).
%
% Unlike the containers.Map object, give full access to methods put and get
% and redefined subsref and subsasgn.
% If value is a structure and have magicField, user can access directly to
% the magicField data.
%
% example:
% m = us191.Map('TEMP', struct('data__', 21.56, 'long_name', 'Temperature'))
%  Properties:
% 	      Count: 1 [containers.Map]
% 	 MagicField: [data__]
% 	    KeyType: [char]
% 	  ValueType: [any]
% 
% m.TEMP
%
% ans = 21.5600
%
% m.MagicField = '';
% m.TEMP
%
% ans = 
%        data__: 21.5600
%     long_name: 'Temperature'
%
% m.MagicField = 'data__';
% m('TEMP')
% 
% ans =
%    21.5600
%
% m('TEMP').long_name
% 
% ans =
% Temperature
%
%  m('PSAL') = struct('data__', 35.43, 'long_name', 'Salinity')
% 
%   us191.Map handle
% 
%   Properties:
% 	      Count: 2 [containers.Map]
% 	 MagicField: [data__]
% 	    KeyType: [char]
% 	  ValueType: [any]
%
% m.PSAL = struct('data__', 35.43, 'long_name', 'Salinity')
% 
% keys(m)
% 
% ans = 
%     'PSAL'    'TEMP'
%     
% remove(m,'TEMP')
% m.TEMP = struct('data__', 21.56, 'long_name', 'Temperature');
%  m.remove({'TEMP','PSAL'})
% 
%   us191.Map handle
% 
%   Properties:
% 	      Count: 0 [containers.Map]
% 	 MagicField: [data__]
% 	    KeyType: [char]
% 	  ValueType: [any]
%
% $Id$

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

classdef Map < dynamicprops
  
  % properties definitions
  % ----------------------
  properties (Access = private)
    
    % private property, inherited class must be redefine this property
    %prop =  'map';
    map;
    
    % the MagicField, set to 'data__' by default
    MagicField = 'data__';
    
    % enable/disable data access to MagicField
    AutoAccess = false;
    
  end
  
  % public functions
  % ----------------
  methods
    
    % constructor
    % -----------
    function self = Map(varargin)
      
      % assign containers.Map object to property map
      % --------------------------------------------
      self.map = containers.Map(varargin{:});

    end
    
    % put method, call containers.Map
    % -------------------------------
    function put(self, theKey, theValue)
      self.map(theKey) = theValue;
    end
    
    % get method from containers.Map
    % -------------------------------
    function theValue = get(self, theKey)
      theValue = self.map(theKey);
      if isstruct(theValue) && isfield(theValue, self.MagicField)
        theValue = theValue.(self.MagicField);
      end
    end
    
    % properties set/get methods
    % --------------------------
    function set.MagicField(self, value)
      if (~isempty(value)) && (~ischar(value)) 
        error('us191:Map', 'us191.Map:set.MagicField: property must be a string')
      end
      self.MagicField = value;
    end
    
    function magicField = get.MagicField(self)
      magicField = self.MagicField;
    end
    
    % accept nc.AutoAccess = true, false, 0 or 1
    % ------------------------------------------
    function set.AutoAccess(self, value)
      if value == 0 || value == 1
        value = logical(value);
      end
      if (~islogical(value)) 
        error('us191:Map', 'us191.Map:set.AutoAccess: property must be a boolean')
      end
      self.AutoAccess = value;
    end
    
    function autoAccess = get.AutoAccess(self)
      autoAccess = self.AutoAccess;
    end
    
    % overload containers.Map functions iskey, keys, size, length, values
    % and remove
    % --------------------------------------------------------------------
    function theBoolean = iskey(self)
      theBoolean = iskey(self.map);
    end
    
    function theKeys = keys(self)
      theKeys = keys(self.map);
    end
    
    function tf = isKey(self, keys)
      tf = isKey(self.map, keys);
    end
    
    function theSize = size(self)
      theSize = size(self.map);
    end
    
    function theLength = length(self)
      theLength = length(self.map);
    end
    
    function theValues = values(self, varargin)
      theValues = values(self.map, varargin{:});
    end
    
    function remove(self, varargin)
      remove(self.map, varargin{:});
    end
    
    % display Map object
    % -----------------------
    function display(self)
      
      fprintf(['\n  <a href="matlab:help us191.Map">us191.Map</a> ' ...
        '<a href="matlab:help handle">handle</a>\n']);
      
      fprintf('\n  Properties:\n');
      fprintf('\t      Count: %d [%-10s]\n', ...
        self.map.Count, class(self.map));
      fprintf('\t MagicField: [%s]\n', self.MagicField);
      fprintf('\t    KeyType: [%s]\n', self.map.KeyType);
      fprintf('\t  ValueType: [%s]\n', self.map.ValueType);
      
      fprintf('\n');
    end
    
    % subsagn. MATLAB uses the built-in subsasgn function to interpret
    % indexed assignment statements. Modify the indexed assignment behavior 
    % of classes by overloading subsasgn in the class
    % ex:
    % m = us191.Map('TEMP', struct('data__',21.56,'long_name','Temperature'))
    % m('PSAL') = struct('data__', 35.43, 'long_name', 'Salinity')
    % ----------------------------------------------------
    function self = subsasgn(self, theStruct, theValue)
      
      % theStruct is a struct array with two fields, type and subs
      % ----------------------------------------------------------
      switch (length(theStruct))
        
        % m('TEMP') = [1:5]
        % -----------------
        case 1
          if iscell(theStruct.subs)
            key = theStruct.subs{:};
          else
            key = theStruct.subs;
          end
          switch theStruct.type
            case {'()', '.'}
              switch key
                case {'MagicField', 'AutoAccess'}
                  builtin('subsasgn', self, theStruct, theValue);
                  return
                otherwise
                  self.map(key) = theValue;
              end
          end
          
          % m('TEMP').name = [1:5]
          % m.put('TEMP') = [1:5]
          % ----------------------
        case 2
          switch theStruct(1).type
            case {'.'}
              switch theStruct(1).subs
                case 'put'
                  if iscell(theStruct(2).subs)
                    key = theStruct(2).subs{:};
                  else
                    key = theStruct(2).subs(:);
                  end
                  self.map(key) = theValue;
              end
            case {'()'}
              if iscell(theStruct(1).subs)
                key = theStruct(1).subs{:};
              else
                key = theStruct(1).subs(:);
              end
              value = self.map(key);
              switch theStruct(2).type
                case '.'
                  if isfield(value, theStruct(2).subs)
                    value.(theStruct(2).subs) = theValue;
                    self.map(key) = value;
                  else
                    error('''%s'' is not a field structure for key ''%s''', ...
                      theStruct(2).subs, key);
                  end
              end
          end
          
      end % end of switch length(theStruct)
      
    end % end of subsagn
    
    % subsref, MATLAB uses the built-in subsref function to interpret indexed
    % references to objects. To modify the indexed reference behavior of 
    % objects, overload subsref in the class.
    % ex:
    % m = us191.Map('TEMP', struct('data__',21.56,'long_name','Temperature'))
    % m('PSAL') = struct('data__', 35.43, 'long_name', 'Salinity')
    % ---------------------------------------------------------------------
    function theValue = subsref(self, theStruct)
      
      % theStruct is a struct array with two fields, type and subs
      % ----------------------------------------------------------
      switch (length(theStruct))
        
        % m('TEMP')
        % m.keys
        % ------
        case 1
          if iscell(theStruct.subs)
            key = theStruct.subs{:};
          else
            key = theStruct.subs;
          end
          switch theStruct.type
            case {'()', '.'}
              switch key
                case 'MagicField'
                  theValue = builtin('subsref', self, theStruct);
                  return
                case 'keys'
                  theValue = keys(self.map); 
                  return                  
                case 'values'
                  theValue = values(self.map); 
                  return     
                case 'size'
                  theValue = size(self.map); 
                  return
                case 'length'
                  theValue = length(self.map); 
                  return                      
                otherwise
                  % m.TEMP
                  theValue = self.map(key);
              end
          end
          
          % m('TEMP').long_name
          % m.TEMP.long_name
          % m.get('TEMP')
          % get(m,'TEMP')
          % m.isKey('TEMP')
          % ------------------
        case 2
          switch theStruct(1).type
            
            % m.TEMP.long_name
            case {'.'}
              if iscell(theStruct(1).subs) %
                key = theStruct(1).subs{:};
              else
                key = theStruct(1).subs;
              end %
              switch theStruct(2).subs
                case 'get'
                  theValue = self.map(key);
                case {'remove'}
                  remove(self.map, key); 
                  return
                case {'isKey'}
                  theValue = isKey(self.map, key); 
                  return  
                case {'values'}
                  theValue = values(self.map, key); 
                  return    
%                 case {'size'}
%                   theValue = size(self.map, key); 
%                  return
                otherwise
                  theValue = self.map(key);
                  if isfield(theValue, theStruct(2).subs)
                    theValue = self.map(key).(theStruct(2).subs);
                  else
                    error('unknow method %s for Map object', theStruct(1).subs);
                  end
              end
              
            % m('TEMP').long_name  
            case {'()'}
              if iscell(theStruct(1).subs)
                key = theStruct(1).subs{:};
              else
                key = theStruct(1).subs;
              end
              theValue = self.map(key);
              switch theStruct(2).type
                case '.'
                  if isfield(theValue, theStruct(2).subs)
                    theValue = self.map(key).(theStruct(2).subs);
                  else
                    error('''%s'' is not a field structure for key ''%s''', ...
                      theStruct(2).subs, key);
                  end
              end
          end
          
          % m.get('TEMP').name
          % get(m,'TEMP').name  not allowed
          % -------------------------------
        case 3 % only for m.get('TEMP').data rule
          switch theStruct(1).type
            case {'.'}
              switch theStruct(1).subs
                case 'get'
                  if iscell(theStruct(2).subs)
                    key = theStruct(2).subs{:};
                  else
                    key = theStruct(2).subs;
                  end
                  theValue = self.map(key);
                  if isfield(theValue, theStruct(3).subs)
                    theValue = self.map(key).(theStruct(3).subs);
                  else
                    error('(%s) is not struct member for key (%s)', ...
                      theStruct(3).subs, key);
                  end
              end
          end
          
      end % end of switch length(theStruct)
      
      % if key/value is a structure and have MagicField defined and AutoAccess
      % mode is true, return value of this MagicField instead of structure
      % description
      % -------------------------------------------------------------------
      if isstruct(theValue) && isfield(theValue, self.MagicField) && self.AutoAccess
        theValue = theValue.(self.MagicField);
      end
      
    end % end of subsref
    
  end % end of public methods
  
end % end of class
