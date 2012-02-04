function [varList, varLevel, self] = parameterChoice( self )
% [varList, varLevel] = parameterChoice( self )
%
% Display the parameters needed to build NetCDF OceanSITES from dynaload
% instance
% Build a GUI form to choose the parameters
%
% Input
% -----
% self .............. oceansites instance
%
% Output
% ------
% varList  ........... cell array of the chosen parameter
% varLevel ........... cell array of the chosen level

% Initialisation
% --------------
varList           = {};
varLevel          = {};
ncd               = get(self, 'DIMENSIONS');
ncp               = get(self, 'PARAMETERS');
dimensions        = keys(ncd);
parameters        = keys(ncp);
header            = cat(2, dimensions, parameters);
nHeader           = length( header );
indSelectedHeader = zeros(nHeader,1);
indSelectedLevel    = zeros(length(parameters),1);
indSelectedPhysical = zeros(length(parameters),1);

% Current and minimum FontSize
% ----------------------------
fontsize    = 11;
minFontsize = 5;

% Change default units to centimeters
% -----------------------------------
oldUnits = get(0, 'units' );
set(0, 'units', 'centimeters');

% Get the screen dimension in centimeters
% ---------------------------------------
screenSize =  get(0, 'screensize' );

% Pushbutton dimension in cm
% ---------------------------
pbHeight     = 0.8;
pbWidth      = 2.5;
nbPushbutton = 2;

% Set the left and bottom limit of the GUI
% ----------------------------------------
XBorder   = .5;
YBorder   = 1;

% Pre-selected parameter
% ----------------------
selectedPara    = { 'DEPH' };
% selectedPara    = { 'date';'time';'temp';'sal';'lat';'lon' };
nSelectedPara   = length( selectedPara );

% Get the order number of pre-selected parameter
% ----------------------------------------------
for i = 1:nSelectedPara
  x = strfind( header, char(selectedPara(i))  );
  
  % Look for the first not-empty cell
  % ---------------------------------
  for j = 1:nHeader
    if ~isempty(x{j})
      indSelectedHeader(j) = 1;
      break;
    end
  end
end

% Compute the size of the GUI depending on the number of UIcontrol
% If it does not fit into the PC screen, change the FontSize
% -------------------------------------------------------------------
figWidth = 2*screenSize(3);
while figWidth > screenSize(3) && fontsize > minFontsize
  
  % Determine the max size of the UIcontrol
  % ----------------------------------------
  hf = figure('Visible', 'off', 'Position', screenSize);
  for ipar = nHeader : -1 : 1
    
    h = uicontrol( 'Parent', hf, 'Style', 'checkbox', 'String', header(ipar), ...
      'Fontsize', fontsize, 'Units', 'centimeters', 'visible', 'off');
    
    % Get the dimension of the string in the Uicontrol
    % ------------------------------------------------
    extent = get(h, 'extent');
    cbWidth(ipar)  = extent(3);
    cbHeight(ipar) = extent(4);
    
    delete( h )
  end
  delete( hf )
  
  % Checkboxes dimension - + 0.5 : size of the checkbox
  % ---------------------------------------------------
  cbWidth     = max(cbWidth) + .5;
  cbHeight    = max(cbHeight);
  cbYinterval = .1;
  
  % Compute figure height using the number of UIcontrol +
  % the height of some pushbutton + the border height
  % -----------------------------------------------------
  nbCol     = 0;
  figHeight = 2*screenSize(4);
  while figHeight > screenSize(4)
    nbCol     = nbCol + 1;
    nbLine    = floor( nHeader / nbCol );
    figHeight = (cbYinterval + pbHeight) + ...
      cbHeight*nbLine + cbYinterval*(nbLine+1) + YBorder*2;
  end
  
  % Compute figure height using the number of UIcontrol +
  % the height of some pushbutton
  % ---------------------------------------------------
  figHeight = (cbYinterval + pbHeight) + ...
    cbHeight*nbLine + cbYinterval*(nbLine+1);
  
  % Compute figure width using the number of UIcontrol +
  % border width
  % ---------------------------------------------------
  figWidth = cbWidth * nbCol * 2 + 2*XBorder;
  
  fontsize = fontsize -1;
  
end

% Compute figure width using the number of UIcontrol
% --------------------------------------------------
figWidth = cbWidth * nbCol * 2;
figWidth = max( figWidth, nbPushbutton*pbWidth);

% Center the GUI
% --------------
XBorder = (screenSize(3) - figWidth)/2;
YBorder = (screenSize(4) - figHeight)/2;

% header Uicontrols in a new figure
% ---------------------------------
hParamFig = figure(...
  'Name', 'Parameters', ...
  'NumberTitle', 'off', ...
  'Resize', 'off', ...
  'Menubar','none', 'Toolbar', 'none', ...
  'Tag', 'TAG_LBV_CHOIX', ...
  'Visible','on',...
  'HandleVisibility', 'callback',...
  'Units', 'centimeters',...
  'Position',[XBorder, YBorder, figWidth, figHeight], ...
  'Color', get(0, 'DefaultUIControlBackgroundColor'));
% 'WindowStyle', 'modal', ...

% Iterate from each element
% -------------------------
ipar   = 1; nb = 1;
x_left = .05;
y_bottom = (pbHeight + cbYinterval) + ...
  cbHeight*(nbLine-1) + cbYinterval*(nbLine);

% loop for dimensions
% -------------------
for key = dimensions
  
  % Set the upper UIcontrol first
  % -----------------------------
  if nb > nbLine
    y_bottom = (pbHeight + cbYinterval) + ...
      cbHeight*(nbLine-1) + cbYinterval*(nbLine);
    nb  = 1;
    nbCol = nbCol +1;
    x_left = (x_left + cbWidth) *2 ;
  end
  
  % if unlimited set
  % ------------------
    
    % display dynamically checkbox uicontrol
    % -----------------------------
    uiCbDim(ipar) = uicontrol(...
      'Parent', hParamFig, ...
      'Style', 'checkbox', ...
      'String', header(ipar), ...
      'Fontsize', fontsize, ...
      'Value', ncd.(char(key)).unlimited, ...
      'Tag', [num2str(ipar), '_TAG_CHECK_BOX_DIM'], ...
      'HandleVisibility', 'on',...
      'Units', 'centimeters', ...
      'Position', [x_left y_bottom cbWidth cbHeight ],...
      'Callback', @unlimitedCallback);
    
    uiEditDim(ipar) = uicontrol(...
      'Parent', hParamFig, ...
      'Style', 'edit', ...
      'String', ncd.(char(key)).dimlen, ...
      'Fontsize', fontsize, ...
      'Tag', [num2str(ipar), '_TAG_EDIT_BOX_DIM_UNLIMITED'], ...
      'HandleVisibility', 'on',...
      'Units', 'centimeters', ...
      'HorizontalAlignment', 'right', ...
      'Position', [x_left+cbWidth y_bottom cbWidth/2 cbHeight ]);

    if isempty(ncd.(char(key)).dimlen)
      set(uiEditDim(ipar), 'BackgroundColor', 'w');
    else
      set(uiEditDim(ipar), ...
        'BackgroundColor', get(0, 'DefaultUIControlBackgroundColor'));
      set(uiCbDim(ipar), 'enable', 'off', 'tag', '');
    end
    
    if ncd.(char(key)).unlimited
      set(uiEditDim(ipar), 'string', 'unlimited');
    end
    
  %end
  
  y_bottom = y_bottom - cbHeight - cbYinterval;
  ipar = ipar + 1;
  nb = nb + 1;
  
end

% loop for parameters
% -------------------
for key = parameters
  
  if nb > nbLine
    y_bottom = (pbHeight + cbYinterval) + ...
      cbHeight*(nbLine-1) + cbYinterval*(nbLine);
    nb  = 1;
    nbCol = nbCol +1;
    x_left = (x_left + cbWidth) * 2;
  end
  
  % display dynamically checkbox uicontrol
  % -----------------------------
  uiParameters(ipar) = uicontrol(...
    'Parent', hParamFig, ...
    'Style', 'checkbox', ...
    'String', header(ipar), ...
    'Fontsize', fontsize, ...
    'Value', indSelectedHeader(ipar), ...
    'Tag', [ num2str(ipar), '_TAG_CHECK_BOX_PARAM'], ...
    'HandleVisibility', 'on',...
    'Units', 'centimeters', ...
    'Position', [x_left y_bottom cbWidth cbHeight ]);
  
  y_bottom = y_bottom - cbHeight - cbYinterval;
  ipar = ipar + 1;
  nb = nb + 1;
  
end

% CONTINUE PUSH BUTTON
% --------------------
uicontrol( ...
  'Parent', hParamFig, ...
  'Style','pushbutton',...
  'Fontsize', fontsize,...
  'String','Continue',...
  'Interruptible','off',...
  'BusyAction','cancel',...
  'Tag','PUSH_BUTTON',...
  'Units', 'centimeters', ...
  'Position',[.05, cbYinterval, pbWidth, pbHeight],...
  'Callback', @continueCallback);

% CANCEL PUSH BUTTON
% ------------------
uicontrol( ...
  'Parent', hParamFig, ...
  'Style','pushbutton',...
  'Fontsize', fontsize,...
  'String','Cancel',...
  'Interruptible','off',...
  'BusyAction','cancel',...
  'Tag','PUSH_BUTTON',...
  'Units', 'centimeters', ...
  'Position',[.05+pbWidth, cbYinterval, pbWidth, pbHeight],...
  'Callback', @cancelCallback);

set(0, 'units', oldUnits);

% stop execution until push-button Continue was press
% and hParamFig is deleted
% ---------------------------------------------------
uiwait(hParamFig);

%% Nested callback

% -----------------------------------------------------------------------
% action on unlimited checkbox
% -----------------------------------------------------------------------
  function unlimitedCallback(obj, event)
    
   tag = get(obj, 'Tag' );
   rTag = regexp( tag, '(\d)_TAG_CHECK_BOX_DIM', 'tokens');
   idTag = str2double(char(rTag{:}));
   hdlEdit = findobj('tag', [num2str(idTag), '_TAG_EDIT_BOX_DIM_UNLIMITED']);
   
   % checkbox selected
   % -----------------
   if get(obj, 'value')
     set(hdlEdit, 'BackgroundColor', get(0, 'DefaultUIControlBackgroundColor'));
     set(hdlEdit, 'string', 'unlimited');
     hdlCbx = findobj('-regexp', 'tag', '_TAG_CHECK_BOX_DIM');
     for ii=1: length(hdlCbx)
       if hdlCbx(ii) ~= obj
         set(hdlCbx(ii), 'enable', 'off');
       end
     end
   else
     set(hdlEdit, 'BackgroundColor', 'w');
     set(hdlEdit, 'string', '');
     hdlCbx = findobj('-regexp', 'tag', '_TAG_CHECK_BOX_DIM');
     for ii=1: length(hdlCbx)
       %if hdlCbx(ii) ~= obj
         set(hdlCbx(ii), 'enable', 'on');
      % end
     end
   end
   
  end

% -----------------------------------------------------------------------
% Continue action, get uicontrol fields and populate tsg structure
% -----------------------------------------------------------------------
  function continueCallback(obj, event)
     
    % Get the values of the checkboxes
    % --------------------------------
    iparam = 1; idim = 1;
    for i = 1 : nHeader
      h = findobj( 'tag', [num2str(i), '_TAG_CHECK_BOX_PARAM']);
      if ~isempty(h)
        if get(h, 'value') % == 1
          if strcmp( ncp.(parameters(iparam)).function__, 'level')
            indSelectedLevel(iparam) = 1;
          elseif strcmp( ncp.(parameters(iparam)).function__, 'physical')
            indSelectedPhysical(iparam) = 1;
          end
        end
        iparam = iparam + 1;
      end   
      
      s.unlimited = 0;
      h = findobj( '-regexp', 'tag', [ num2str(i), '_TAG_CHECK_BOX_DIM']);
      if ~isempty(h)
        value = get(h, 'value');
        if (value)
          s = get(ncd, dimensions(idim));
          s.dimlen = 0;
          s.unlimited = 1;
          ncd = put(ncd, dimensions(idim), s);
        end
       
      end
      h = findobj( '-regexp', 'tag', [ num2str(i), '_TAG_EDIT_BOX_DIM']);
      if ~isempty(h)
        value = get(h, 'string');
        if ~isempty(value) 
          value = str2double(value);
          s = get(ncd, dimensions(idim));
          if strcmp(value, 'unlimited')
            s.dimlen = [];
          else
            s.dimlen = value;
          end
          ncd = put(ncd, dimensions(idim), s);
        end
        idim = idim + 1;
      end
    end
    
    % return level & parameters cells list 
    % ------------------------------------
    varLevel = parameters( indSelectedLevel == 1 );
    varList  = parameters( indSelectedPhysical == 1 );
    
    if isempty(varList) || isempty(varLevel)
      msgbox( 'Choose a physical parameter from list', 'modal' );
      return
    end
    
    self = put(self, 'DIMENSIONS', ncd);

    % close windows (replace call to uiresume(hParamFig))
    % ----------------------------------------------------
    close(hParamFig);
    
    % flushes the event queue and updates the figure window
    % -----------------------------------------------------
    drawnow;
    
  end

% -----------------------------------------------------------------------
% Cancel button, no action
% -----------------------------------------------------------------------
  function cancelCallback(obj, event)
    
    % close windows
    % -------------
    close(hParamFig);
    
    % flushes the event queue and updates the figure window
    % -----------------------------------------------------
    drawnow;
    
    varList = {}; varLevel = {};
  end
end
