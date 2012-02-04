function self = plot_map( self )
% methode plot_map de la classe us191.datagui
% trace la route 

% $Id$

%markersize = root.markersize;
root.markersize_lbl   = {'1','2','3','4','6','8','10' };
root.markersize_value = 4;  % default
root.markersize       = 4;

%% met en place les controls
% le tag plot_map est commun a tous les objets
hdl_figure = findobj( 'Tag', 'plot_map' );
if( isempty(hdl_figure) )
  hdl_figure = figure( 'Name','Route oceano',...
    'numbertitle', 'off', ...
    'HandleVisibility','on',...
    'Position',[500 300 700 620],...
    'Tag','plot_map',...
    'MenuBar','figure',...
    'Color', get( 0, 'DefaultUIControlBackgroundColor' ));
  
  % Create axes
  axe = axes(...
    'Units','pixels',...
    'Position',[50 150 500 400],...
    'Tag', 'axe_route',...
    'Box','on');
  
  % affichage des coordonnees de la sourie (ButtonMotion)
  uicontrol( hdl_figure, 'style','Edit',...
    'HorizontalAlignment','left',...
    'tag','tag_but1',...
    'position',[20 70 120 20] );
  uicontrol( hdl_figure, 'style','Edit',...
    'HorizontalAlignment','left',...
    'tag','tag_but2',...
    'position',[20 40 80 20] );
  uicontrol( hdl_figure, 'style','Edit',...
    'HorizontalAlignment','left',...
    'tag','tag_but3',...
    'position',[20 10 80 20] );

  % affichage des coordonnees de la sourie (ButtonMotion)
  uicontrol( hdl_figure, 'style','Edit',...
    'HorizontalAlignment','left',...
    'tag','tag_but4',...
    'position',[150 70 120 20] );
  uicontrol( hdl_figure, 'style','Edit',...
    'HorizontalAlignment','left',...
    'tag','tag_but5',...
    'position',[150 40 80 20] );
  uicontrol( hdl_figure, 'style','Edit',...
    'HorizontalAlignment','left',...
    'tag','tag_but6',...
    'position',[150 10 80 20] );
    
  %% Frame (Run/Next/Last & Reset  button)
  hdl_profil = uipanel('Title','Profils',...
    'FontSize',8,...
    'Units','pixels',...
    'Position',[595 10 100 142]);  
  % Run plot profiles
  uicontrol(...
    'Parent',hdl_profil,...
    'Style','pushbutton',...
    'Position',[5 98 90 30],...
    'String','Run',...
    'Visible', self.visible,...
    'Tag', 'tag_button_run',...
    'Callback', 'getButtonRunCallback' );
  % Next profile
  uicontrol(...
    'Parent',hdl_profil,...
    'Style','pushbutton',...
    'Position',[5 66 90 30],...
    'String','Next',...
    'Visible', self.visible,...
    'Callback', 'getButtonNextCallback');
  % Last profile
  uicontrol(...
    'Parent',hdl_profil,...
    'Style','pushbutton',...
    'Position',[5 34 90 30],...
    'String','Last',...
    'Visible', self.visible,...
    'Callback', 'getButtonLastCallback' );
  % Clear profile
  uicontrol(...
    'Parent',hdl_profil,...
    'Style','pushbutton',...
    'Position',[5 2 90 30],...
    'String','Reset fig.',...
    'Visible', self.visible,...
    'Callback', 'getButtonResetCallback');

  % affichage du popup MarkerSize
  uicontrol( ...
    'Style','text',...
    'Position',[240 30 70 20],...
    'ForegroundColor','k',...
    'String','MarkerSize',...
    'HorizontalAlignment','left');
  uicontrol( ...
    'Style','popupmenu',...
    'Position',[250 10 50 20], ...
    'String',root.markersize_lbl,...
    'BackgroundColor','w',...
    'Value',root.markersize_value,...
    'Tag', 'popup_markersize', ...
    'CallBack', 'select_markersize_callback');
  
else
  figure(hdl_figure);
  % reset(gca);
  % reset(axe);
  cla reset;
  set(gca,'tag','axe_route');
end

%% titre sur plusieurs lignes 
% title({'First line';'Second line'})
title( { [ get(get(self, 'ATTRIBUTES', 'cycle_mesure'), '  ', ...
           self.ATTRIBUTES.platform_name, ' / ', ...
            ];...
           self.ATTRIBUTES.type_instrument });

%% selectionne X et Y
try
  switch self.route_value
    case 1  % X=LONX Y=LATX
      X = self.VARIABLES.LONGITUDE; Y = self.VARIABLES.LATITUDE;  
      xlabel('Longitude'); ylabel('Latitude');
    case 2  % X=DAYD Y=LATX;
      X = self.VARIABLES.TIME; Y = self.VARIABLES.LATITUDE;  
      xlabel('Jour julien'); ylabel('Latitude');
    case 3  % X=DAYD Y=LONX;
      X = self.VARIABLES.TIME; Y = self.VARIABLES.LONGITUDE; 
      xlabel('Jour julien'); ylabel('Longitude');
  end
catch
  warn ('profil', 'plot_map', 'load datafile first') ;
  delete(hdl_figure);
  return
end
interlx = 2;   % valeur de l'intervalle entre les labels X
interly = 2;   % valeur de l'intervalle entre les labels Y
intervx = 1;   % valeur de l'intervalle entre les tickmark X
intervy = 1;   % valeur de l'intervalle entre les tickmark Y
ymin = floor(min( Y ))-2;
ymax = ceil( max( Y ))+2;
xmin = floor(min( X ))-2;
xmax = ceil( max( X ))+2;
limx   = [xmin xmax];
limy   = [ymin ymax];

%% trace la route en fonction du fdc
switch self.route_value
  case 1
    if length( limx(1):interlx:limx(2)) > 9
      interlx = 4;
    end
    if length( limy(1):interly:limy(2)) > 9
      interly = 4;
    end
    [tickx, labelx] = tickgeo( limx(1), limx(2), intervx, limx(1), interlx, 1);
    [ticky, labely] = tickgeo( limy(1), limy(2), intervy, limy(1), interly, 0);
    
    switch self.map_value
      case 1   % none
        hdl_line_route = line( X, Y, 'Color', 'r', 'Marker', '+',...
                              'MarkerSize', root.markersize,'Tag','TagRoute',...
                              'LineStyle', 'none');
        set( gca, 'YLim', limy, 'YTick', ticky, 'YtickLabel', labely,...
             'XLim', limx, 'Xtick', tickx, 'XtickLabel', labelx,...
             'Box', 'on', 'fontSize', [10],...
             'DataAspectRatio', [1 1 1], 'DataAspectRatioMode', 'manual');
        
      case 2   % m_map
        proj = 'Equidistant Cylindrical';
        %proj = 'mercator';
        %plot_m_map( ymin-5, ymax+5, xmin-5, xmax+5, proj );
        m_proj(proj, 'lat', [ymin ymax], 'long',[xmin xmax]);
        m_coast('patch',[0.9 0.9 0.9]);
        m_grid;
        hold on;
        hdl_line_route = m_line( X, Y, 'Color', 'r', 'Marker', '+',...
                                'MarkerSize', root.markersize, 'LineStyle', 'none');
        %hidem(gca);
        
      case 3   % map toolbox
        hw = worldmap([ymin-5 ymax+5],[xmin-5 xmax+5]); 
        land = shaperead('landareas', 'UseGeoCoords', true);
        geoshow(hw, land, 'FaceColor', [1 1 0.7]);      % terre jaune pale
        setm(gca,'FFaceColor',[0.7 0.9 1]);             % mer bleue
%       obsolete
%         hw = worldmap([ymin-5 ymax+5],[xmin-5 xmax+5],'patch');
%         % pour une carte plus detaillee, mieux pour zoomer
%         % mais tres tres long!
%         %worldmap('hi',[ymin ymax],[lonmin lonmax],'patch')
%         set(handlem('allpatch'),'Facecolor',[1 1 0.7]); % terre jaune pale
%         setm(gca,'FFaceColor',[0.7 0.9 1]); % mer bleue
        %pour avoir une carte rectangle
        %setm(gca,'FFaceColor',[0.7 0.9 1],'MapParallels',1)
        % on inverse les axes pour plotm
        hdl_line_route = linem( Y, X, 'Color', 'r', 'Marker', '+',...
                                'MarkerSize', root.markersize , 'LineStyle','none');
        %hidem(gca);
    end
    
  case {2,3}  % pour DAYD = f(LATX) ou f(LONX)
    if length( xmin:interlx:xmax) > 9
      interlx = 5;
    end
    if length( limy(1):interly:limy(2)) > 9
      interly = 4;
    end
    [tickx, labelx] = ticktemps( limx(1), limx(2), intervx, limx(1), interlx);
		if self.route_value == 2
      [ticky, labely] = tickgeo( limy(1), limy(2), intervy, limy(1), interly, 0);
		else
      [ticky, labely] = tickgeo( limy(1), limy(2), intervy, limy(1), interly, 1);
		end
    hdl_line_route = line( X, Y, 'Color', 'r', 'Marker', '+', 'MarkerSize',... 
                           root.markersize, 'LineStyle','none');
    set(gca, 'YLim', limy, 'YTick', ticky, 'YtickLabel', labely,...
             'XLim', limx, 'Xtick', tickx, 'XtickLabel', labelx,...
             'Box', 'on', 'fontSize', [10],...
             'DataAspectRatio', [1 1 1], 'DataAspectRatioMode', 'manual');
end

% on va stocker les valeurs limx et limy dans les chanps UserData
% de button 2 (Lat) et 3 (lon)
set( findobj( 'Tag', 'tag_but2' ), 'UserData', limx );
set( findobj( 'Tag', 'tag_but3' ), 'UserData', limy );

% %% met en place les gestionnaires de sourie sur la zone de travail               
% set( hdl_figure, 'WindowButtonMotionFcn',...
%                  'getButtonMotionCallback' );
% % sur la route + click uniquement 
% set( hdl_line_route, 'tag', 'line_route',...
%                      'ButtonDownFcn', 'getButtonDownCallback');