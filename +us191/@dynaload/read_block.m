function [nb_members, blk_size, nb_line] = read_block(self, prop )
% private function read_block
% read each block of line begin and stop with #
% ---------------------------------------------
% ex:
%
% 1: % $Id: read_block.m 604 2011-12-13 15:37:45Z jgrelet $
% 2: % code GF3 utilises au SISMER et fournit par M Fichaut
% 3: %
% 4: %CODE;NAME;UNIT;MIN;MAX;FORMAT;DEFAULT
% 5: $CODES_ROSCOP$
% 6: #;code;name;unit;min;max;format;default;popup;#
% 7: #;char;char;char;double;double;char;double;char;#
% 8: #;N/A;NOT AVAILABLE;N/A;;;%5.1g;1e36;;#
% 9: #;CUPW;14C PRODUCTION UNKNOWN FILTER;milligram carbon/(m3.day);0;200;%6.2lf;999.99;;#
%
% lines 1 to 4, comment lines
% 
% $Id: read_block.m 604 2011-12-13 15:37:45Z jgrelet $

% init blk_size counter to zero
% -------------------------
blk_size = 0;
nb_line = 0;

% read 2 first lines
% ------------------
header   = textscan(self.fid, '%s', 2, 'delimiter', '\n');

% increment line counter
% ----------------------
nb_line = nb_line + 2;

% extract each members name from first header line
% ------------------------------------------------
match = regexp( header{:}, '^#;(.*);#$', 'tokens', 'lineanchors');
members = regexp(match{1}{:}, ';', 'split');
%members    = textscan(header{1}{1}, '%s', 'delimiter', ';');
nb_members = numel(members{1});

% extract data type from second header line
% -----------------------------------------
types    = regexp(match{2}{:}, ';', 'split');

% generate one line format
% ------------------------
%format = repmat('%s', 1, nb_members);

% loop over next line of file begining and start with #
% -----------------------------------------------------
while (1)
  
  % read next line
  % --------------
  buf = textscan(self.fid, '%s', 1, 'delimiter', '\n');
  
  % stop read at end of fine
  % ------------------------
  if feof(self.fid)
    break;
  end
  
  % try to match a comment (%) in the line and exit if yes
  % ------------------------------------------------------
  match =  regexp( buf{1}{1}, '^%', 'match', 'lineanchors');
  if ~isempty(match)
    nb_line = nb_line + 1;
    break
  end
  
  % try to match # separator at begining and end of the line
  % --------------------------------------------------------
  match =  regexp( buf{1}{1}, '^#;(.*);#$', 'tokens', 'lineanchors');
  
  % increment block_line counter
  % ----------------------------
  blk_size = blk_size + 1;
  
  % if not match, stop reading in file and display error
  % ----------------------------------------------------
  if isempty(match)
    fprintf('read: %s\n', buf{1}{1});
    error(['missing #; at begining or ;# at end of line: ' ...
      int2str(self.line+blk_size+2) ' in ' self.file ...
      ', ... Check your file']);
  end
  
  % split each line
  % ---------------
  values = regexp(match{1}{1}, ';', 'split');
  
  % get key, first
  % --------------
  key = values{1};
  
  % loop over other members find in line
  % ------------------------------------
  for j=1:nb_members
    
    try
      member = genvarname(members{:}{j});
      type   = genvarname(types{:}{j});
      value  = values{j};
    catch ME
      error(['mismatch field number in ' self.File ', line: ' ...
        int2str(self.line+blk_size) ' ... Check your file']);
    end
    
    % dynamically populate structure 'theStruct'
    % ------------------------------------------
    if isempty(value)
      
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
          
      end
      
    else
      
      switch type
        
        case {'logical','boolean'}
          % logical value should be 0,1 in csv file
          % and must be converted to logical true or false
          % ----------------------------------------------
          if ischar(value) && ~isempty(regexp(value, '^(1|0)$','ONCE'))
            theStruct.(member) = logical(eval(value));
          end
          
        case 'char'
          % nothing to do, just assign value to struct
          % ------------------------------------------
          theStruct.(member) = value;      
          
        case 'cell'
          % eval needed to construct matlab cell expression
          % -----------------------------------------------
          %value
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
          theStruct.(member) = char(value);
          
      end
      
    end
    
  end % end while
  
  % add empty filled self.MagicField (by default data__)
  %
  % avait été supprimé, remis le 11/05/2010 J Grelet, revoir ce point!!!!
  %
  % n'est pas necessaire pour un objet dynaload, est du ressort de la
  % classe derivee, ex: netcdf
  % ---------------------
  if ~isempty(self.MagicField)
    theStruct.(self.MagicField) = [];
  end
  
  % populate the hashtable
  % ----------------------
  put(self, prop, key, theStruct);
  
  % initialize internal structure for next loop
  % -------------------------------------------
  theStruct = [];
  
end % end of while

end % end of private function read_values
