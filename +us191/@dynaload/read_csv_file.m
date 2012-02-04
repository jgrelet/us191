function read_csv_file(self)
% read dynaload descriptor in ASCII csv file
%
% $Id: read_csv_file.m 600 2011-09-14 14:36:29Z jgrelet $

% check file validity
% -------------------
self.fid = fopen( self.File, 'r' );
if self.fid == -1
  error('dynaload:dynaload', ...
    ['The specified data file ''%s'' does not exist\n' ...
    'or is not in the directory which is on the MATLAB path'],...
    self.File);
end

% read the end-of-file
% --------------------
while (1)

  % read one line
  % -------------
  inputText = textscan(self.fid, '%s', 1, 'delimiter', '\n');

  if feof(self.fid)
    break;
  end

  % try to match dynamics properties, use '$' separator at begining 
  % and end line
  % ----------------------------------------------------------
  match = regexp( inputText{1}{1}, '^\${1}(\w*)\${1}', 'tokens');

  % increment line counter
  % ----------------------
  self.line = self.line + 1;

  % if no, read next line
  % ---------------------
  if isempty(match)
    continue
  end

  % yes, find dynamic property delimeter prop
  % -----------------------------------------
  prop = match{1}{1};

  % create dynamics properties and initialize to empty containers.Map
  metaDP = self.addprop(prop);
  %self.(prop) = us191.Map;
  self.(prop) = us191.hashtable;
  
  % populate meta with dynamic properties names (cell array)
  if isempty(self.meta)
    self.meta{1} = metaDP.Name;
  else
    self.meta{end+1} = metaDP.Name;
  end

  % read the data inside the file and populate hash
  % -----------------------------------------------
  [nb_members, blk_size, nb_line] = ...
    read_block(self, prop ); %#ok<ASGLU>


  % populate private line propertie
  % -------------------------------
  self.line = self.line + blk_size + nb_line;

end  % end while

% close csv file
% --------------
fclose(self.fid);

end % end of read_csv_file function
