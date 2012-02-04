function [self] = read_xls_file(self)
% read Microsoft Excel Spreadsheet file and parse it
%
% $Id: read_xls_file.m 602 2011-12-11 18:44:50Z jgrelet $

% check file validity
% -------------------
[type, sheet] = xlsfinfo( self.File);

if ~strcmp(type, 'Microsoft Excel Spreadsheet')
  error('dynaload:dynaload', ...
    ['The specified data file ''%s'' does not exist\n' ...
    'or is not a valid Microsoft Excel Spreadsheet'],...
    self.File);
end

if isempty( sheet)
  error('dynaload:dynaload', ...
    'The specified data file ''%s'' does not contain valid sheet',...
    self.File);
end

% loop over each excel sheet
% --------------------------
for k=1:length(sheet)
  
  % associate each sheet name to dynamic property
  % ---------------------------------------------
  prop = sheet{k};
  
  % create dynamics properties and initialize to empty us191.hashtable
  % -----------------------------------------------------------------
  metaDP = self.addprop(prop);
  self.(prop) = us191.hashtable;
  
  % populate meta with dynamic properties names (cell array)
  % --------------------------------------------------------
  if isempty(self.meta)
    self.meta{1} = metaDP.Name;
  else
    self.meta{end+1} = metaDP.Name;
  end
  
  % read Excel worksheet in raw mode (unprocessed cell content) which
  % contains both numeric and text data, empty cell is fillwith NaN
  % -----------------------------------------------------------------
  [A,B,raw] = xlsread( self.File, sheet{k} );
  
  % get size of each sheet
  % ----------------------
  [line,column] = size(raw);
  
  % jump the 2 header lines
  % -----------------------
  for i=3:line
    
    % loop over other members find in first line
    % ------------------------------------------
    for j=1:column
      
      % get member, type and value dynamicaly
      % -------------------------------------
      member = genvarname(raw{1,j});
      type   = genvarname(raw{2,j});
      value  = raw{i,j};
      
      % get key name
      % ------------
      if ischar(value) && ~isempty(regexp(member, 'key__$','ONCE'))
        
        % removes all trailing whitespace
        % -------------------------------
        key__ = deblank(value);
        
      end
      
      % dynamically populate structure 'theStruct'
      % ------------------------------------------
      if isnan(value)
        
        % when value is empty, give the rigth type to empty value, expect
        % for logical, that is false by default
        % ---------------------------------------------------------------
        switch type
          case {'logical','boolean'}
            theStruct.(member) = false;
          case 'char'
            theStruct.(member) = char([]);
          case {'integer','int8','int16','int32','int','long'}
            theStruct.(member) = int32([]);
          case {'float','single'}
            theStruct.(member) = single([]);
          case {'double','real'}
            theStruct.(member) = double([]);
          case 'cell'
            error(['MATLAB:dynaload:read_xls: empty dimension.\n',...
              'Check your line %s: dimension__ is empty !!!'], key__ );
          otherwise
            error(['MATLAB:dynaload:read_xls:invalid type.\n',...
              '%s: should be a valid Matlab type for key: %s, ', ...
              'check header in your dynaload file'], type, key__ );
        end
        
      else
        
        switch type
          
          case {'logical','boolean'}
            % logical value sould be 0,1 or char 'true' or 'false'
            % and must be converted to logical true or fase
            % -------------------------------------------
            if ischar(value) && ~isempty(regexp(value, '^(true|false)$','ONCE'))
              theStruct.(member) = logical(eval(value));
            elseif isnumeric(value) && (value == 0 || value == 1)
              theStruct.(member) = logical(value);
            else
              theStruct.(member) = false;
            end
            
          case 'char'
            % just assign value to struct removes all trailing whitespace
            % -----------------------------------------------------------
            theStruct.(member) = deblank(num2str(value));
            %value
            
          case 'cell'
            % eval needed to construct matlab cell expression
            % -----------------------------------------------
            theStruct.(member) = eval(['{' value '}']);
            
          case {'integer','int8','int16','int32','int','long'}
            % Excel use dot in english format and comma in french
            % real number with dot is character in french
            % -------------------------------------------
            if ischar(value)
              theStruct.(member) = int32(str2double(value));
            else
              theStruct.(member) = int32(value);
            end
            
          case {'float','single'}
            %
            % -------------------------------------------
            if ischar(value)
              theStruct.(member) = single(str2double(value));
            else
              theStruct.(member) = single(value);
            end
            
          case {'double','real'}
            %
            % -------------------------------------------
            if ischar(value)
              theStruct.(member) = str2double(value);
            else
              theStruct.(member) = double(value);
            end
            
          otherwise
            error(['MATLAB:dynaload:read_xls:invalid type.\n',...
              '%s: should be a valid Matlab type, check header in your '...
              'dynaload file'], type );
            
        end
        
      end
      
    end % end for j
    
    % add data__ member to structure, cast to empty array
    % n'est pas necessaire pour un objet dynaload, est du ressort de la
    % classe derivee, ex: netcdf
    % ---------------------------------------------------
    %     if isfield( theStruct, 'type__')
    %       switch theStruct.type__
    %         case {'logical','boolean'}
    %           theStruct.data__ = logical([]);
    %         case 'char'
    %           theStruct.data__ = char([]);
    %         case 'cell'
    %           theStruct.data__ = cell({});
    %         case {'int8', 'byte'}
    %           theStruct.data__ = int8([]);
    %         case {'int16', 'short'}
    %           theStruct.data__ = int16([]);
    %         case {'integer', 'int', 'int32'}
    %           theStruct.data__ = int32([]);
    %         case {'int64', 'long'}
    %           theStruct.data__ = int64([]);
    %         case {'float','single'}
    %           theStruct.data__ = single([]);
    %         case {'double','real'}
    %           theStruct.data__ = double([]);
    %         otherwise
    %           error(['MATLAB:dynaload:read_xls:invalid type.\n',...
    %             'member type__: %s  should be a valid Matlab object', ...
    %             ', check your dynaload file' ], theStruct.type__);
    %       end
    %     end
    
    % populate dynamic property (containers.Map) with key/structure
    % -------------------------------------------------------------
    put(self, prop, key__, theStruct);
    
    % initialize internal structure for next loop
    % -------------------------------------------
    theStruct = []; key__ = [];
    
  end % end for i
  
end % end of sheet

end
