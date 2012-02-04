function self = read_onset(self)

import us191.datagui.util.*;

% display information on command window
% -------------------------------------
fprintf('Read onset file: %s\n', self.FileName);

% init
self.cycle =[]; self.time = []; self.data = []; self.qc = [];

% jump two first line
% -------------------
textscan(self.FileId, '%s', 2, 'delimiter', '\n');
  
% read the end-of-file
% --------------------
while (1)

  % read one line
  % -------------
  inputText = textscan(self.FileId, '%s', 1, 'delimiter', '\n');

  % reach end of file, exit
  % -----------------------
  if feof(self.FileId)

    % exit while loop
    % ---------------
    break;
  end

  % use string instead cell
  % -----------------------
  str = inputText{1}{1};

  % jump to next line if empty line
  % -------------------------------
  if isempty(str)
    continue
  end
  
  % split str with ';' and return result to a cell
  % ----------------------------------------------
  match = regexp(str, ';', 'split');
  
  % convert result
  % --------------
  if ~isempty(match)
    self.cycle = [self.cycle;str2double(match(1))];
    self.time  = [self.time;datenumToJulian(datenum(match(2),'dd/mm/yyyy HH:MM:SS'))];
    self.data  = [self.data;str2double(regexprep(match(3), ',', '.'))];
    self.qc    = [self.qc;0];
  end
end

% end of read_onset method