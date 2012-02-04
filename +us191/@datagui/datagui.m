classdef datagui < us191.oceansites 
  
  properties(Constant)
    version = '0.03';
  end
  
%   properties
%     nc = [];
%   end
  
  properties (Access = private, SetObservable)
    mainFigHdl;
    pathHdl;
    fileHdl;
    changeDirHdl;
    formatHdl;
    data_typeHdl;
    axisHdl;
    routeHdl;
    mapHdl;
  end
  
  properties %(Dependent)
    title = 'us191.dataGUI';
    isBusy = false;
  end
  
  properties(Hidden)
    busyTitle = '(busy...)';
    listeners = struct();
  end
  
  properties(Access = private, Hidden)
  %properties
    path            = 'C:\Documents and Settings\jgrelet\Mes documents\MATLAB\toolbox\+us191\demos\netcdf';
    ext             = '.nc';
    selectmode      = 'off';
    files           = { 'no data'};
    files_value     = 1;
    format          = {'RAW','NetCDF','dataGUI','XML'};
    format_value    = 2;
    data_type       = {'TIME SERIE','TSG','METEO','BATHYMETRIE',...
                       'CTD','XBT','ADCP','BOUTEILLES','RADIOSONDAGE'};
    data_type_value = 5;
    axis            = {'DAYD','LATX','LONX'};
    axis_value      = 1;
    route           = {'LAT/LON','DAYD/LAT','DAYD/LON'};
    route_value     = 1;
    map             = {'NONE','M_MAP'};
    map_value       = 1;
    %
    visible = 'on';
  end
  
  % public methods
  % --------------
  methods
    
    % constructor
    % -----------
    function self = datagui
      
      % Call base-class constructor before accessing object
      % ---------------------------------------------------
      %self = self@us191.oceansites('memory');
      
      % define main interface
      % ---------------------
      self.mainFigHdl = figure( ...
        'Position',[10 10 300 460],...
        'Name', strcat(self.title, ' - Main'),...
        'numbertitle', 'off', ...
        'Tag','main',...
        'MenuBar','none',...
        'ToolBar', 'none',...
        'HandleVisibility','on',...
        'NextPlot','new',...
        'CloseRequestFcn', @(obj, event) delete(self),...
        'Color', get( 0, 'DefaultUIControlBackgroundColor' ));
      
      % initialize properties value from mat file
      % -----------------------------------------
      self = initDatagui(self);
      
      % call function that define Uicontrols
      % -----------------------------------
      self.setUicontrols;
      
    end % end of constructor
    
    % destructor
    % ----------
    function delete(self)
      if ~isempty(self.mainFigHdl) && ishandle(self.mainFigHdl);
        delete(self.mainFigHdl);
        self.mainFigHdl = [];
      end
      self.deleteListeners;
    end
    
    % destructor for listenners
    % -------------------------
    function deleteListeners(self)
      % would like to use struct2array, but
      % cannot concatenate event.listener withevent.proplistener
      % so, iterate the struct fields
      fn = fieldnames(self.listeners);
      if ~isempty(fn)
        for ii = 1:length(fn)
          delete([self.listeners.(fn{ii})]);
        end
      end
    end
    
    % initialize properties value from mat file
    % -----------------------------------------
    function self = initDatagui(self)
      
      % setup mat configuration file using prefdir
      % ------------------------------------------
      file = strcat('us191.', mfilename);
      config_file = [prefdir, filesep, file, '.mat'];
      
      % open mat file
      % -------------
      fid = fopen(config_file, 'r');
      if fid ~= -1
        
        % load structure S from matfile in workspace
        % -------------------------------------------
        load( config_file, 'S');
        
        if exist('S', 'var') == 1
          if isfield(S, 'version') && strcmp(S.version, self.version) %#ok<NODEF>
            self = loadobj(self, S);
          end
        end
      else
        
        % if something wrong, save new matfile with the last valid
        % structure with rigth version number
        % --------------------------------------------------------
        S = saveobj(self); %#ok<NASGU>
        save( config_file, 'S');
      end
      
    end % end of initDatagui
    
    % function setUicontrols that define Uicontrols
    % ---------------------------------------------
    function setUicontrols(self)
      
      if isempty(self.path)
        str = 'Pick one file: ';
      else
        str = self.path;
      end
      
      %creation du texte "nom de fichier"
      self.pathHdl = uicontrol( 'Style', 'text',...
        'Position', [20 410 270 50],...
        'ForegroundColor', 'r',...
        'String', str ,...
        'Tag', 'text_file',...
        'HorizontalAlignment', 'left');
      
      % creation popup "nom de fichier" et appel read_file
      self.fileHdl = uicontrol( 'Style', 'popupmenu',...
        'Position', [20 380 150 30],...
        'String', self.files,...
        'Value', self.files_value,...
        'Tag', 'popup_file',...
        'BackgroundColor', 'w',...
        'Callback', {@us191.datagui.select_file_callback, self});
      
      % pushbutton getting uigetfile
      self.changeDirHdl = uicontrol( 'Style','pushbutton',...
        'Position', [190 388 100 23],...
        'String', 'Change directory',...
        'Tag', 'button_getfile', ...
        'CallBack', {@us191.datagui.change_directory_callback, self});
      
      % select type file (DataGUI/XML/NetCDF/ASCII/Excel)
      % definit dans common/select_type.m
      uicontrol( ...
        'Style','text',...
        'Position',[20 360 150 20],...
        'ForegroundColor','b',...
        'String','Select format',...
        'HorizontalAlignment','left');
      self.formatHdl = uicontrol( ...
        'Style','popupmenu',...
        'Position',[20 340 150 20],...
        'String',self.format,...
        'BackgroundColor','w',...
        'Value',self.format_value,...
        'Tag', 'popup_format', ...
        'CallBack', {@us191.datagui.select_format_callback, self});
      
      % select data type 'TIME SERIE','TSG','METEO','BATHYMETRIE,'RADIO SONDAGE',...
      %                  'ADCP','CTD','XBT','BOUTEILLES''
      uicontrol( 'Style','text',...
        'Position', [20 310 150 20],...
        'ForegroundColor', 'k',...
        'String', 'Select data type ',...
        'HorizontalAlignment', 'left');
      
      self.data_typeHdl = uicontrol( 'Style','popupmenu',...
        'Position', [20 280 150 30],...
        'String', self.data_type,...
        'Value', self.data_type_value,...
        'Tag', 'popup_data_type',...
        'BackgroundColor', 'w',...
        'Callback', {@us191.datagui.select_data_type_callback, self});
      
      % select X axis
      uicontrol( 'Style','text',...
        'Position', [20 260 150 20],...
        'ForegroundColor', 'k',...
        'String', 'Set plot axis',...
        'HorizontalAlignment', 'left');
      
      self.axisHdl = uicontrol( 'Style','popupmenu',...
        'Position',[20 230 150 30],...
        'String', self.axis,...
        'Value', self.axis_value,...
        'Tag', 'popup_axis',...
        'BackgroundColor', 'w',...
        'Callback', {@us191.datagui.select_axis_callback, self});
      
      % select route axis
      uicontrol( 'Style','text',...
        'Position', [20 210 150 20],...
        'ForegroundColor', 'k',...
        'String', 'Set route axis',...
        'HorizontalAlignment', 'left');
      
      self.routeHdl = uicontrol( 'Style','popupmenu',...
        'Position', [20 180 150 30],...
        'String', self.route,...
        'Value', self.route_value,...
        'Tag', 'popup_route',...
        'BackgroundColor', 'w',...
        'Callback', {@us191.datagui.select_route_callback, self});
      
      % select map
      uicontrol( 'Style','text',...
        'Position', [20 160 150 20],...
        'ForegroundColor', 'k',...
        'String', 'Select map',...
        'HorizontalAlignment', 'left');
      
      self.mapHdl = uicontrol( 'Style','popupmenu',...
        'Position', [20 130 150 30],...
        'String', self.map,...
        'Value', self.map_value,...
        'Tag', 'popup_map',...
        'BackgroundColor', 'w',...
        'Callback', {@us191.datagui.select_map_callback, self});
      
      % The quit button
      uicontrol( 'Style','pushbutton',...
        'Position', [20 20 150 30],...
        'String', 'Quit',...
        'Interruptible', 'off',...
        'BusyAction', 'cancel',...
        'Tag', 'button_quit',...
        'Callback', {@us191.datagui.button_quit_callback, self});
    end
    
    % overriden save and load functions
    % ---------------------------------
    function S = saveobj(self)
      % Save property values in struct
      % Return struct for save function to write to MAT-file
      S.version        = self.version;
      S.path           = self.path;
      S.ext            = self.ext;
      S.selectmode     = self.selectmode;
      S.files          = self.files;
      S.files_value    = self.files_value;
      S.format         = self.format;
      S.format_value   = self.format_value;
      S.data_type      = self.data_type;
      S.data_type_value = self.data_type_value;
      S.axis           = self.axis;
      S.axis_value     = self.axis_value;
      S.route          = self.route;
      S.route_value    = self.route_value;
      S.map            = self.map;
      S.map_value      = self.map_value;
    end
    
    function self = loadobj(self, S)
      % Method used to assign values from struct to properties
      % Called by loadobj and subclass
      self.path           = S.path;
      self.ext            = S.ext;
      self.selectmode     = S.selectmode;
      self.files          = S.files;
      self.files_value    = S.files_value;
      self.format         = S.format;
      self.format_value   = S.format_value;
      self.data_type      = S.data_type;
      self.data_type_value = S.data_type_value;
      self.axis           = S.axis;
      self.axis_value     = S.axis_value;
      self.route          = S.route;
      self.route_value    = S.route_value;
      self.map            = S.map;
      self.map_value      = S.map_value;
    end
    
    % properties set/get methods
    % --------------------------
    function set.title(self, title)
      self.title = title;
      set(self.mainFigHdl, 'Name', title);
    end
    
    function title = get.title(self)
      title = self.title ;
    end
    
    function set.isBusy(self, isBusy)
      self.isBusy = isBusy;
      if isBusy
        set(self.mainFigHdl, 'Name', self.busyTitle);
      else
        set(self.mainFigHdl, 'Name', self.title);
      end
      drawnow;
    end
    
    % display datagui object
    % -------------------------
    function display(self)
     
      fprintf('<a href="matlab:help us191.datagui">us191.datagui</a>\n\n');
      fprintf('  version:              %s\n\n', self.version);

      % call superclass display method
      % ------------------------------
      display@us191.oceansites(self);
      
    end % end of display method
    
    % prototype of function that was in separate files
    % ------------------------------------------------
    self = plot_map(self);
    val  = subsref(self, s);
    
  end % end of public methods
  
  % static methods, use for callbacks
  % ---------------------------------
  methods(Static)
    
    % select file callback
    % --------------------
    function select_file_callback(obj, evnt, self)
      
      % get selected filename
      % ----------------------
      self.files_value = get(obj, 'value');
      self.files = get(obj, 'string');
      self.file = fullfile(self.path, self.files{self.files_value});
      
      % read file
      switch self.format_value
        case 1 % raw
        case {2,3} % xml
        %case 3 % netcdf
          self = self.read;
          self = self.plot_map;
      end
      
    end % end of select_file_callback
    
    % browse directory and select file callback
    % -----------------------------------------
    function change_directory_callback(obj, evnt, self)
      
      [selected_file, self.path, filterIndex] = uigetfile( {['*' self.ext]}, ...
        'fichier', [self.path filesep],'MultiSelect', self.selectmode);
      
      %filterIndex
      if filterIndex ~= 0
        if ischar( selected_file )
          % bug de uigetfile, retourne pirata-fr4_mto_mto
          if strcmp(self.format{self.format_value}, 'dataGUI')
            % supprime la double extension retournee par uigetfile
            % que si fichier de type dataGUI
            if regexp(self.ext, '_')
              selected_file = regexprep(selected_file, self.ext,'','once');
            end
          end
          dlist = dir( fullfile(self.path, ['*'  self.ext ]) );
          self.files = {dlist.name};
          idx = strfind(self.files, selected_file);
          for i=1: length(idx)
            if idx{i}==1; self.files_value = i; end
          end
          
          % test test que l'indice des campagnes ne soit pas > aux nb fichiers
          if length( self.files ) < self.files_value
            self.files_value = 1;
          end;
          
          if isempty( dlist )
            self.files = { 'no data' };
            set( self.fileHdl, 'String', self.files );
          else
            set( self.fileHdl, 'String', self.files );
            set( self.fileHdl, 'Value',  self.files_value );
            self.file = fullfile(self.path, selected_file);
            
            % flushes the event queue and updates the figure window.
            % ------------------------------------------------------
            drawnow;
            
            self = self.read;
            self = self.plot_map;
            
          end
        end
      end
    end % end of change_directory_callback
    
    % select the format of the file data: raw, Netcdf, etc ...
    % -----------------------------------------------
    function select_format_callback(obj, evnt, self)
      
      % get index value of the popup
      % ----------------------------
      self.format_value = get(obj, 'value');
      
      % update self.ext following user choice
      % -------------------------------------
      self = update_ext(self);
      
      % update list files
      % -----------------
      self = update_files_dir(self);
      
      % update uicontrol fileHdl
      % ----------------------------
      set(self.fileHdl, 'string', self.files);
      
    end % end of select_format_callback
    
    % select the type of data: CTD, XBT, TSG, etc ...
    % -----------------------------------------------
    function select_data_type_callback(obj, evnt, self)
      
      % get index value of the popup
      % ----------------------------
      self.data_type_value = get(obj, 'value');
      
      handle = findobj('-regexp','Tag','plot');
      if ~isempty(handle)
        delete(handle);
      end
      
      % update self.ext following user choice
      % -------------------------------------
      self = update_ext(self);
      
      % update uicontrol formatHdl
      % ----------------------------
      set(self.formatHdl, 'string', self.format);
      
      % update list files
      % -----------------
      self = update_files_dir(self);
      
      % update uicontrol fileHdl
      % ----------------------------
      set(self.fileHdl, 'string', self.files);
      
    end % end of select_data_type_callback
    
    % select abcisse value: DAYD, LATX or LONX
    % ----------------------------------------
    function select_axis_callback(obj, evnt, self)
      
      % get index value of the popup
      % ----------------------------
      self.axis_value = get(obj, 'value');
      
    end % end of select_axis_callback
    
    % select route callback
    % ----------------------------------------
    function select_route_callback(obj, evnt, self)
      
      % get index value of the popup
      % ----------------------------
      self.route_value = get(obj, 'value');
      
    end % end of select_route_callback
    
    % select map callback
    % ----------------------------------------
    function select_map_callback(obj, evnt, self)
      
      % get index value of the popup
      % ----------------------------
      self.map_value = get(obj, 'value');
      
    end % end of select_map_callback
    
    % quit program
    % ------------
    function button_quit_callback(obj, evnt, self)
      
      % flushes the event queue and updates the figure window.
      % ------------------------------------------------------
      drawnow;
      
      % setup mat configuration file using prefdir
      % ------------------------------------------
      file = strcat('us191.', mfilename);
      config_file = [prefdir, filesep, file, '.mat'];
      
      % save structure S in mat file
      % ----------------------------
      S = saveobj(self); %#ok<NASGU>
      save( config_file, 'S');
      
      % call destructor and exit
      % ------------------------
      self.delete;
      
    end % of of button_quit_callback
    
  end % end of static methods
  
  % private methods
  % ---------------
  methods(Access = private)
    
    % -------------------------------
    function self = update_files_dir(self)
      
      % get new directory listing
      % -------------------------
      dlist    = dir( fullfile(self.path, ['*' self.ext]) );
      if( isempty( dlist ) )
        self.files = {'no data'};
        self.files_value = 1;
      else
        if self.files_value > length( dlist )
          self.files_value = 1;
        end
        self.files = {dlist.name};
      end
      
    end % end of update_files_dir
    
    % ----------------------------
    function self = update_ext(self)
      
      switch self.data_type_value
        case 1
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_tms';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_tms.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_tms_*.nc';
              self.selectmode = 'off';
            case 4  % ASCII
              self.ext = '.*';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
        case 2  %  TSG
          self.format = {'dataGUI','XML','NetCDF','Thermo DOS','Thermo Labview'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_tsg';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_tsg.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_tsg_*.nc';
              self.selectmode = 'off';
            case 4  % ASCII
              self.ext = '.*';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
          
        case 3  %  METEO
          self.format = {'dataGUI','XML','NetCDF','ASCII'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_mto';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_mto.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_mto_*.nc';
              self.selectmode = 'off';
            case 4  % ASCII
              self.ext = '.*';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
          
        case 4  %  BATHYMETRIE
          self.format = {'dataGUI','XML','NetCDF'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_snd';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_snd.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_snd_*.nc';
              self.selectmode = 'off';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
          
        case 5  %  CTD
          self.format = {'dataGUI','XML','NetCDF','Seabird .HDR/.ASC','Seabird .CNV'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_ctd';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_ctd.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_ctd_*.nc';
              self.selectmode = 'off';
            case 4  % HDR/ASC
              self.ext = '.hdr';
              self.selectmode = 'on';
            case 5  % CNV
              self.ext = '.cnv';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
          
        case 6  %  XBT
          self.format = {'dataGUI','XML','NetCDF','CLS Argos .DROP','Sippican .EDF'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_xbt';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_xbt.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_xbt_*.nc';
              self.selectmode = 'off';
            case 4  % DROP
              self.ext = '.*';
              self.selectmode = 'on';
            case 5  % EDF
              self.ext = '.edf';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
          end
          
        case 7  %  ADCP
          self.format = {'dataGUI','XML','NetCDF','CODAS .CON','CODAS .ASC'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_adcp';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_adcp.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_adcp_*.nc';
              self.selectmode = 'off';
            case 4  % CON
              self.ext = '.con';
              self.selectmode = 'on';
            case 5  % ASC
              self.ext = '.asc';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
          
        case 8  %  BTL
          self.format = {'dataGUI','XML','NetCDF','Excel','.BIL'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_btl';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_btl.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_btl_*.nc';
              self.selectmode = 'off';
            case 4  % Excel
              self.ext = '.xls';
              self.selectmode = 'off';
            case 5  % BIL
              self.ext = '.bil';
              self.selectmode = 'on';
            otherwise
              self.ext = '.*';
          end
          
        case 9  %  RADIO SONDAGE
          self.format = {'dataGUI','XML','NetCDF'};
          switch self.format_value
            case 1  % fichier ASCII datagui
              self.ext = '_rsm';
              self.selectmode = 'off';
            case 2  % XML
              self.ext = '_rsm.xml';
              self.selectmode = 'off';
            case 3  % NetCDF
              self.ext = '_rsm_*.nc';
              self.selectmode = 'off';
            otherwise
              self.ext = '.*';
              self.selectmode = 'on';
          end
      end % end of main switch
      
    end % end of update_ext
    
  end % end of private methods
  
end % end of us191.datagui class
