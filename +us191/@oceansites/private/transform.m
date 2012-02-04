function self = transform(self)
% private us191.oceansites function used to transform a dynaload
% netcdf template to real dynaload netcdf structure
%
% $Id: transform.m 600 2011-09-14 14:36:29Z jgrelet $

% get template variables list as hashtable
% ----------------------------------------
variables = self.VARIABLES;

% get parameters codesRoscop from PARAMETERS list as hashtable
% --------------------------------------------------------------
codesRoscop = self.PARAMETERS;

% call process
% -----------------------------------------
process(self.physicalParameters, '{variable}');
process(self.levelParameters,  '{level}');
if regexpi(self.type, 'profil')
  process({'STATION'}, '{station}');
  process({'CAST'}, '{cast}');
else
  % for trajectory and timeseries, remove {station} & {cast}
  % --------------------------------------------------------
  remove( variables, '{station}'); 
  remove( variables, '{cast}'); 
  %self.VARIABLES(variables);
end

  % nested function process
  % -----------------------
  function process(parameters, template)
    % iterate on each physical parameters
    % self.physicParameters = {'TEMP','PSAL','DOX2',...}
    % -------------------------------------------------
    for para = parameters
      
      % convert cell to char
      % --------------------
      pp = char(para);
      
      % get the structure of physical parameter  (ssop)
      % ----------------------------------------------
      sopp = codesRoscop(pp);
      
      % add new physical parameter to the hashtable property VARIABLES
      % ------------------------------------------------------------------
      self.VARIABLES(pp) = sopp;
      
      % get keys and templates structure (cell array)
      % --------------------------------------------
      cles = keys(variables);
      ts   = values(variables);
      
      % produce indexing cell array that match '{template}'
      % ---------------------------------------------------
      match = regexp(cles, (template), 'once');
      
      % loop over templates structure
      % -----------------------------
      for i = 1: numel(match)
        
        % s is the template structure
        % ---------------------------
        s = ts{i};
        
        % process only matching values (==1)
        % ---------------------------------
        if ~isempty(match{i})
          
          % get key for each physical parameter template,
          % eg TEMP, TEMP_QC, TEMP_CAL, ....
          % -----------------------------------------------
          variable = regexprep(cles{i}, template, pp);
          
          % don't process physical parameter, eg TEMP, PSAL, ...
          % ----------------------------------------------------
          if ~strcmp(cles{i}, template)
            
            % replace template {variable} in all variable attribute
            % -----------------------------------------------------
            for j = fieldnames(s)'
              
              % convert cell 2 char
              % -------------------
              member = char(j);
              
              % find and replace template only on string member
              % -----------------------------------------------
              if ischar(s.(char(j)))
                
                % replace in each structure member template with parameter
                % --------------------------------------------------------
                s.(member) = regexprep(s.(member), '{variable}', pp);
                
                % produce indexing cell array that match '{template}'
                % ---------------------------------------------------
                memberMatch = regexp(s.(char(j)), '(.*){(\w+)}(.*)','tokens');
                
                if ~isempty(memberMatch)
                  try
                    if strcmp(j, 'key__')
                      s.(char(j)) = [char(memberMatch{1}{1}) ...
                        sopp.key__ char(memberMatch{1}{3})];
                    else
                      s.(char(j)) = [char(memberMatch{1}{1}) ...
                        sopp.(char(memberMatch{1}{2})) char(memberMatch{1}{3})];
                    end
                  catch ME
                    %disp(s);
                    warning('oceansites:transform', ...
                      ' ''%s'' function: %s, line: %d, parameter: %s \n',...
                      ME.message, ME.stack(1).name, ME.stack(1).line, s.key__);
                  end
                end
                
              end
            end
            
            % add new physical parameter key to Map
            % -----------------------------------------------
            self.VARIABLES(variable) = s;
            
          end % if ~strcmp(cles{i}, template)
          
        end % if ~isempty(match{i})
        
      end % for i = 1: numel(match)
      
    end % for para = parameters
    
    for i = 1: numel(match)
      
      % process only matching values (=1)
      % ---------------------------------
      if ~isempty(match{i})
        
        % remove key form hashtable
        % ------------------------------
        remove(self.VARIABLES, cles{i});
        
        % update dynaload hashtable for key VARIABLES
        % -----------------------------------------------
        %self = put(self, 'VARIABLES', variables);
      end
      
    end % for i = 1: numel(match)
    
  end % end function process

end % end function transform


