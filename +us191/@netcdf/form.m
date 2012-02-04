function form(self)
% FORM(SELF)
% This function form on us191.netcdf object open a mask when user can
% modify or change global attributes.
%
% Input
% -----
% self ............ us191.netcdf instance
%
% $Id$

% set default uicontrol size
% --------------------------
default_height = 0.03;
default_length = .11;

fontSize = 10;

% Define uicontrol start position
% -------------------------------
left   = .01;
bottom = .95;
inc_x  =  3 * default_length;
inc_y  =  0.02;

% Screen limits for the GUI
% -------------------------
set(0,'Units','normalized');
guiLimits = get(0,'ScreenSize');
guiLimits(1) = guiLimits(1) + 0.1;
guiLimits(2) = guiLimits(2) + 0.2;
guiLimits(3) = guiLimits(3) - 0.2;
guiLimits(4) = guiLimits(4) - 0.4;

% get a copy of attributes list
% -----------------------------
nca = self.ATTRIBUTES;

% get keys
% --------
nca_keys = keys(nca);

% global attributes Uicontrols in a new figure
% --------------------------------------------
%  'BackingStore','off',...
hFormFig = figure(...
  'Name', 'OceanSITES global attributes', ...
  'NumberTitle', 'off', ...
  'Resize', 'on', ...
  'Menubar','none', ...
  'Toolbar', 'none', ...
  'Tag', 'GLOBAL_ATTRIBUTES', ...
  'Visible','on',...
  'WindowStyle', 'modal', ...
  'Units', 'normalized',...
  'Position', guiLimits, ...
  'Color', get(0, 'DefaultUIControlBackgroundColor'));

% bg = [0.92549 0.913725 0.847059] = get(0, 'DefaultUIControlBackgroundColor');

% Iterate from each key of global attributes hashtable nca
% --------------------------------------------------------
for nk = nca_keys
  
  % get key, use char because i is cell
  % -----------------------------------
  key = char(nk);
  
  % get all structure for the key
  % -----------------------------
  s = nca(key);
   
  % check for empty field and replace them by default value
  % -------------------------------------------------------
  %&& isempty(s.length)
  if ~isfield(s, 'length'), s.length = default_length; end;
  if ~isfield(s, 'height'), s.height = default_height; end;
  if ~isfield(s, 'comment'), s.comment = ''; end;
  if ~isfield(s, 'name'), s.name = key; end;
  if ~isfield(s, 'uicontrolType'), s.uicontrolType = 'edit'; end;
  if ~isfield(s, 'horizontalAlignment'), s.horizontalAlignment = 'right'; end;
  if ~isfield(s, 'string'), s.string = s.data__; end;
  if ~isfield(s, 'value'), s.value = 0; end;
  if ~isfield(s, 'conventions'), s.conventions = ''; end;
  
  % set date_update with actual date
  % --------------------------------
  if strcmp(key, 'date_update')
    s.data__ = strcat(datestr(now, 29), 'T', datestr(now, 13),'Z');
  end
  
  % display dynamically uicontrol text
  % use of char function to prevent error when field is empty [] => ''
  % ------------------------------------------------------------------
  uicontrol(...
    'Parent', hFormFig, ...
    'Units', 'normalized', ...
    'Style', 'Text', ...
    'Fontsize', fontSize-1, ...
    'HorizontalAlignment', 'left', ...
    'Position',[left, bottom, s.length, s.height], ...
    'TooltipString', char(s.comment), ...
    'String', char(s.name));
  
  % display dynamically uicontrol
  % -----------------------------
  ui = uicontrol(...
    'Parent', hFormFig, ...
    'Units', 'normalized', ...
    'BackgroundColor', 'w', ...
    'Style', char(s.uicontrolType), ...
    'Fontsize', fontSize-2, ...
    'HorizontalAlignment', char(s.horizontalAlignment), ...
    'Position', [left + s.length, bottom, s.length, s.height], ...
    'String', char(s.string), ...
    'Value', s.value, ...
    'Tag', key);
  
  % display conventions field if exist
  % ----------------------------------
  uicontrol(...
    'Parent', hFormFig, ...
    'Units', 'normalized', ...
    'Style', 'text', ...
    'Fontsize', fontSize-2, ...
    'HorizontalAlignment', 'left', ...
    'Position', [left + 2*s.length, bottom, s.length, s.height], ...
    'String', char(s.conventions));
  
  % set dynamically uicontrol from structure
  % -----------------------------------------
  switch s.uicontrolType
    
    % for a popmenu control, set index position
    % ---------------------------------
    case 'popupmenu'
      str = cellstr(get(ui, 'String'));
      if isfield(s, 'data__') && ~isempty(s.data__)
        ind = strfind(str, s.data__);
        for k=1:numel(ind)
          if ~isempty(ind{k})
            set(ui, 'value', k);
          end
        end
      end
      
      % for edit control, set uicontrol with self.ATTRIBUTES.(key) value
      % -----------------------------------------------------------------
    case 'edit'
      
      % if value empty or equal to N/A, display N/A in red
      % if there is not data for variable or data__ empty
      % ------------------------------------------------
      if ~isfield(s, 'data__'), s.data__ = 'N/A'; end
      if  isempty(s.data__),    s.data__ = 'N/A'; end
      if  strcmp(s.data__, 'N/A')  
        set(ui, 'ForegroundColor', 'r');
      end
      set(ui, 'string', s.data__);
      
      % for checkbox control, not yet implemented
      % ------------------------------------------
    case 'checkbox'
      % not yet implemented !!!
  end
  
  % Check vertical position of last uicontrol and creation new colomn
  % -----------------------------------------------------------------
  bottom = bottom - inc_y - s.height;
  if bottom < .1
    bottom = 0.95;
    left = left + inc_x;
  end
end

% set a callback to check date
% ----------------------------
set(findobj('-regexp', 'Tag', '(date|time)'), 'Callback', @editCallback);

% CONTINUE PUSH BUTTON
% --------------------
% The Continue (valid)  button
uicontrol( ...
  'Parent', hFormFig, ...
  'Style','pushbutton',...
  'Fontsize', fontSize,...
  'Units', 'normalized', ...
  'Position',[.01, .01, .1, .04],...
  'String','Continue',...
  'Interruptible','off',...
  'BusyAction','cancel',...
  'Tag','PUSH_BUTTON',...
  'Callback', @continueCallback);

% CANCEL PUSH BUTTON
% ------------------
% The cancel  button
uicontrol( ...
  'Parent', hFormFig, ...
  'Style','pushbutton',...
  'Fontsize', fontSize,...
  'Units', 'normalized', ...
  'Position',[.2, .01, .1, .04],...
  'String','Cancel',...
  'Interruptible','off',...
  'BusyAction','cancel',...
  'Tag','PUSH_BUTTON',...
  'Callback', @cancelCallback);

% Build structure container for graphic handles with tag property defined.
% ------------------------------------------------------------------------
data = guihandles(hFormFig);

% stop execution until push-button Continue was press and hFormFig is
% deleted. You could omment this line in debug mode
% -------------------------------------------------------------------
uiwait(hFormFig);


%% Nested callback
% -----------------------------------------------------------------------
% check if date format is valid, if not beep and set empty string
% -----------------------------------------------------------------------
  function editCallback(obj, event)
    value = get(obj, 'string');
    match = regexp( value, ...
            '^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z$', 'match');
    if isempty(match)
      beep;
      set(obj, 'string', '');
    end
  end

% -----------------------------------------------------------------------
% Continue action, get uicontrol fields and populate nca structure
% -----------------------------------------------------------------------
  function continueCallback(obj, event)
    
    % Iterate from each element from object nca
    % -----------------------------------------
    for i = nca_keys
      
      % convert cell to char
      % --------------------
      key = char(i);
      
      % get all structure for the key, for additional variables, s = {}
      % --------------------------------------------------------------
      s = nca(key);
      
      % get the corresponding string from uicontrol using guihandles
      % data (dynamic)
      % ------------------------------------------------------------
      s.data__ = get(data.(key), 'string');
%       if strcmp( s.data__, 'N/A' )
%         s.data__ = [];
%       end    
      
      % if uicontrol is a popupmenu, string is cell array with all choices
      % ------------------------------------------------------------------
      if ~isempty(s) && isfield(s, 'uicontrolType') ...
                     && strcmp(s.uicontrolType, 'popupmenu')
        
        % get the corresponding string from cell array using selected value
        % get(data.(key), 'value') is the indice
        % ------------------------------------------------------------------
        s.value  = get(data.(key), 'value');
        s.data__ = deblank(s.data__(s.value, :));
                
      end
      
      % assign structure to key inside containers.Map ATTRIBUTES
      % --------------------------------------------------------
      self.ATTRIBUTES(key) = s;
      
    end % end for loop
    
    % close windows (replace call to uiresume(hFormFig))
    % ----------------------------------------------------
    close(hFormFig);
    
    % flushes the event queue and updates the figure window
    % -----------------------------------------------------
    drawnow;
    
  end % end of continueCallback nested function

% -----------------------------------------------------------------------
% Cancel button, no action
% -----------------------------------------------------------------------
  function cancelCallback(obj, event)
    
    % close windows
    % -------------
    close(hFormFig);
    
    % flushes the event queue and updates the figure window
    % -----------------------------------------------------
    drawnow;
    
  end % end of cancelCallback nested function

end % end of globalAttributesForm

