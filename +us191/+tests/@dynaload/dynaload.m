%% us191.tests.dynaload
%
% This class implements tests cases on the dynaload class
% which is part of the packaqe +us191. It is based on the 'TestCase'
% class of the xUnit Framework.
%
% You can run one particular test case implemented in a method of dynaload named
% testMethod by typing :
%
%     >> t = us191.tests.dynaload('testMethod');
%     >> t.run
% or
%     >> runtests us191.tests.dynaload:testMethod
%     >> runtests us191.tests.dynaload -verbose
%
% For example run all tests for us191.dynaload :
%
%     >> runtests us191.tests.dynaload
%     Test suite: us191.tests.dynaload
%     Test suite location: +us191/+tests/@dynaload/dynaload.m
%     09-Sep-2011 13:49:32
%
%     Starting test run with 9 test cases.
%     .........
%     PASSED in 0.068 seconds.
%
%     >> t = us191.tests.dynaload('testKeys');
%     >> t.run
%     Starting test run with 1 test case.
%     .
%     PASSED in 0.009 seconds.
%
%
%
% For more details about the use of these tests, you can have a look on the
% help of the xUnit classes 'TestCase' and 'TestSuite'.
% To use MATLAB xUnit in MATLAB, add the "xunit" folder (directory)
% to the MATLAB path.

%% COPYRIGHT & LICENSE
%  Copyright 2009-2001 - IRD US191, all rights reserved.
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
%    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
%    USA

%% Classdef definition
% -------------------------------------------------------------------------
classdef dynaload < TestCase
  
  % Properties definition
  % ---------------------
  properties (Access = protected)
    
    % Locations of test.xls, test.csv and testSave.csv
    xls_filename;
    csv_filename;
    hash;
    planete;
    
  end % End of Properties definition
  
  % Class public methods
  % --------------------
  methods % (Access = public)
    
    % setup
    % -----
    function setUp(self)
      
      % get the location of directory test class dynaload
      pathstr = fileparts(mfilename('fullpath'));
      
      % construct test filename
      self.xls_filename = fullfile(pathstr, 'test.xls');
      if ispc
        self.csv_filename = fullfile(pathstr, 'test_pc.csv');
      else
        self.csv_filename = fullfile(pathstr, 'test_linux.csv');
                
        % Disable these warning for the duration of the tests.
        warning('off','MATLAB:xlsread:ActiveX');
      end
      
      self.hash = us191.hashtable;
      self.planete = {'MERCURE', 'VENUS', 'TERRE'};
      
      put(self.hash, self.planete{1}, us191.hashtable({'Masse', 'Diametre', 'Densite', 'Journee',...
        'Revolution', 'DistanceSoleil'}, {struct('key__', 'Masse',...
        'Num', 1, 'Description', 'Masse comparee a la Terre', 'Unit', '',...
        'Valeur', 0.056, 'TestLogical', true), struct('key__', 'Diametre', 'Num', 2,...
        'Description', 'Diametre a l''equateur', 'Unit', 'km',...
        'Valeur', 4860, 'TestLogical', false), struct('key__', 'Densite', 'Num', 3,...
        'Description', 'Densite moyenne', 'Unit', 'g/cm3','Valeur', 5.6, 'TestLogical', true),...
        struct('key__', 'Journee', 'Num', 4, 'Description',...
        'Duree d''une journee', 'Unit', 'jours', 'Valeur', 58.6250, 'TestLogical', false),...
        struct('key__', 'Revolution', 'Num', 5, 'Description',...
        'Periode de revolution', 'Unit', 'jours', 'Valeur', 88, 'TestLogical', true),...
        struct('key__', 'DistanceSoleil', 'Num', 6, 'Description',...
        'Distance au soleil','Unit', 'Mkm', 'Valeur', 58, 'TestLogical', false)}));
      
      % Venus
      put(self.hash, self.planete{2}, us191.hashtable({'Masse', 'Diametre', 'Densite', 'Journee',...
        'Revolution', 'DistanceSoleil'}, {struct('key__', 'Masse',...
        'Num', 1, 'Description', 'Masse comparee a la Terre', 'Unit', '',...
        'Valeur', 0.82, 'TestLogical', true), struct('key__', 'Diametre', 'Num', 2,...
        'Description', 'Diametre a l''equateur', 'Unit', 'km',...
        'Valeur', 12140, 'TestLogical', false), struct('key__', 'Densite', 'Num', 3,...
        'Description', 'Densite moyenne', 'Unit', 'g/cm3', 'Valeur',...
        5.2, 'TestLogical', true), struct('key__', 'Journee', 'Num', 4, 'Description',...
        'Duree d''une journee', 'Unit', 'jours', 'Valeur', 243, 'TestLogical', false),...
        struct('key__', 'Revolution', 'Num', 5,...
        'Description', 'Periode de revolution','Unit', 'jours', ...
        'Valeur', 225, 'TestLogical', true), struct('key__', 'DistanceSoleil', 'Num', 6,...
        'Description', 'Distance au soleil',...
        'Unit', 'Mkm', 'Valeur', 108, 'TestLogical', false)}));
      
      % Terre
      put(self.hash, self.planete{3}, us191.hashtable({'Masse', 'Diametre', 'Densite', 'Journee',...
        'Revolution', 'DistanceSoleil'}, {struct('key__', 'Masse', 'Num',...
        1, 'Description', 'Masse comparee a la Terre', 'Unit', '',...
        'Valeur', 1, 'TestLogical', true), struct('key__', 'Diametre', 'Num', 2,...
        'Description', 'Diametre a l''equateur', 'Unit', 'km',...
        'Valeur', 12760, 'TestLogical', false), struct('key__', 'Densite', 'Num', 3,...
        'Description', 'Densite moyenne', 'Unit', 'g/cm3', 'Valeur',...
        5.5, 'TestLogical', true), struct('key__', 'Journee', 'Num', 4, 'Description',...
        'Duree d''une journee', 'Unit', 'heures', 'Valeur', 23.93, 'TestLogical', false),...
        struct('key__', 'Revolution', 'Num', 5, 'Description',...
        'Periode de revolution', 'Unit', 'jours', 'Valeur', 365.25, 'TestLogical', true),...
        struct('key__', 'DistanceSoleil', 'Num', 6,...
        'Description', 'Distance au soleil',...
        'Unit', 'Mkm', 'Valeur', 150, 'TestLogical', false)}));
    end
    
    % tearDown
    % -----
    %     function tearDown(self)
    %     end
    
    % Constructor
    %------------
    function self = dynaload(testMethod)
      % Creates the test case
      self = self@TestCase(testMethod);
    end % End of contructor
    
    
    %% tests methods
    
    % test that CSV file should be load in memory and attribute File 
    % from the dynaload object is the test file
    % --------------------------------------------------------------
    function testLocateCsvFile( self )
      d = us191.dynaload(self.csv_filename);
      msg = sprintf('can''t locate %s file', self.csv_filename);
      assertEqual(d.getFilename, self.csv_filename , msg);
    end
    
    function testLocateXlsFile( self )
      d = us191.dynaload(self.xls_filename);
      msg = sprintf('can''t locate %s file', self.xls_filename);
      assertEqual(d.getFilename, self.xls_filename , msg);
    end
    
    % load CSV file and check that each dynamic properties of the
    % dynaload object contain hashtable
    % --------------------------------------------------------------
    function testLoadCsvFile( self )
      
      % load excel test file in memory: test.csv
      d = us191.dynaload(self.csv_filename);
      
      for i = self.planete
        
        % Test if it is hashtable Structure
        assertEqual(class(d.(char(i))), 'us191.hashtable', sprintf(...
          'd.%s doesn''t seem to be a hashtable object.', char(i)));
      end
      
    end
    
    % load Excel file and check that each dynamic properties of the
    % dynaload object contain hashtable
    % --------------------------------------------------------------
    function testLoadXlsFile( self )
      
      % load excel test file in memory: test.csv
      d = us191.dynaload(self.xls_filename);
      
      for i = self.planete
        
        % Test if it is hashtable Structure
        assertEqual(class(d.(char(i))), 'us191.hashtable', sprintf(...
          'd.%s doesn''t seem to be a hashtable object.', char(i)));
      end
      
    end
    
    % load Excel file, save it in csv temp file and compare with
    % test.csv
    % --------------------------------------------------------------
    function testCompareFiles( self )
      
      % load excel test file in memory: test.csv
      d = us191.dynaload(self.xls_filename);
      
      % do not display output on console
      d.Echo = false;
      
      % get tmp file name
      tmpfile = tempname;
      
      % write tmp csv ascii file
      write(d, tmpfile);
      
      % test 
      assertFilesEqual(self.csv_filename, tmpfile);
      
      % delete tmp file
      delete(tmpfile);
      
    end
    
    % compare Excel with csv file
    % ---------------------------
%     function testCompExcelFiles(self)
%       % load excel test file in memory: test.csv
%       d = us191.dynaload(self.xls_filename);
%       
%       for i = self.planete
%         for j = d.(char(i))
%         % Test if it is hashtable Structure
%         assertEqual(d.(char(i)), 'us191.hashtable', sprintf(...
%           'd.%s doesn''t seem to be a hashtable object.', char(i)));
%         end
%       end
%       
%     end
    
  end % End of public methods
  
end % End of classdef
