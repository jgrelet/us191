%% us191.tests.netcdf
%
% This class implements tests cases on the netcdf class
% which is part of the packaqe +us191. It is based on the 'TestCase'
% class of the xUnit Framework.
%
% You can run one particular test case implemented in a method of netcdf named
% testMethod by typing :
%
%     >> t = us191.tests.netcdf('testMethod');
%     >> t.run
% or
%     >> runtests us191.tests.netcdf:testMethod
%     >> runtests us191.tests.netcdf -verbose
%
% For example run all tests for us191.netcdf :
%
%     >> runtests us191.tests.netcdf
%     Test suite: us191.tests.netcdf
%     Test suite location: +us191/+tests/@netcdf/netcdf.m
%     09-Sep-2011 13:49:32
%
%     Starting test run with 9 test cases.
%     .........
%     PASSED in 0.068 seconds.
%
%     >> t = us191.tests.netcdf('theTest');
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

%% Classdef definition
% -------------------------------------------------------------------------
classdef netcdf < TestCase
  
  % Properties definition
  % ---------------------
  properties (Access = protected)
    
    testroot;
    
    % Location and name for test.xls, test.csv and testSave.csv
    dynaload_filename;
    
    % Location and name for reading netcdf test file
    read_netcdf;
    
    % netcdf fileId
    nc;
    
  end % End of Properties definition
  
  % Class public methods
  % --------------------
  methods % (Access = public)
    
    % setup
    % -----
    function setUp(self)
      
      % get the location of directory test class netcdf
      self.testroot = fullfile(fileparts(mfilename('fullpath')), '..');
      
      % construct test filename
      if ispc
        self.dynaload_filename = fullfile( self.testroot, ...
          '@dynaload/test_pc.csv');
      else
        self.dynaload_filename = fullfile( self.testroot, ...
          '@dynaload/test_linux.csv');
      end
      
      self.read_netcdf = fullfile( self.testroot, ...
        'testdata/us191.nc');
      
      % open the netcdf test file without echo
      self.nc = us191.netcdf( self.read_netcdf, false);
      
      % set autoAccess to falseby default
      self.nc.AutoAccess = false;
      
    end
    
    % tearDown
    % --------
    function tearDown(self)
      if ~isempty(self.nc)
        self.nc.close;
      end
    end
    
    % Constructor
    %------------
    function self = netcdf(testMethod)
      % Creates the test case
      self = self@TestCase(testMethod);
    end % End of contructor
    
    
    %% tests methods
    
    % test that CSV file should be load in memory and attribute File
    % from the netcdf object is the test file
    % --------------------------------------------------------------
    function testLocateNcFile( self )
      ncd = us191.netcdf(self.dynaload_filename);
      msg = sprintf('can''t locate %s file', self.dynaload_filename);
      assertEqual( ncd.getFilename, self.dynaload_filename , msg);
    end
    
    function testDoubleAttributes( self )
      
      x = self.nc.VARIABLES.x;
      assertEqual( class(x.test_double_att), 'double', ...
        'class of retrieved attribute was not double.');
      assertEqual( x.test_double_att, 3.14159, ...
        'retrieved attribute differs from what was written.');
    end
    
    function testFloatAttributes( self )
      x = self.nc.VARIABLES.x;
      assertEqual( class(x.test_float_att), 'single', ...
        'class of retrieved attribute was not float.');
      assertTrue( abs(double( x.test_float_att) - 3.14159) < 1e-5, ...
        'retrieved attribute differs from what was written.');
    end
    
    function testIntAttributes( self )
      x = self.nc.VARIABLES.x;
      assertEqual( class(x.test_int_att), 'int32', ...
        'class of retrieved attribute was not int32.');
      assertEqual( x.test_int_att, int32(3), ...
        'retrieved attribute differs from what was written.');
    end
    
    function testShortAttributes( self )
      x = self.nc.VARIABLES.x;
      assertEqual( class(x.test_short_att), 'int16', ...
        'class of retrieved attribute was not int16.');
      assertEqual( length(x.test_short_att), 2, ...
        'retrieved attribute length differs from what was written.');
      assertFalse( any(double(x.test_short_att) - [5 7]), ...
        'retrieved attribute differs from what was written.');
    end
    
    function testCharAttributes( self )
      x = self.nc.VARIABLES.x;
      assertEqual( class(x.test_schar_att), 'int8', ...
        'class of retrieved attribute was not int8.');
      assertEqual( x.test_schar_att, int8(-100), ...
        'retrieved attribute differs from what was written.');
    end
    
    function testUcharAttributes( self )
      x = self.nc.VARIABLES.x;
      assertEqual( class(x.test_uchar_att), 'int8', ...
        'class of retrieved attribute was not int8.');
      assertEqual( x.test_uchar_att, int8(100), ...
        'retrieved attribute differs from what was written.');
    end
    
    function testTextAttributes( self )
      x = self.nc.VARIABLES.x;
      assertTrue( ischar(x.test_text_att), ...
        'class of retrieved attribute was not char.');
      assertEqual( x.test_text_att, 'abcdefghijklmnopqrstuvwxyz', ...
        'retrieved attribute differs from what was written.');
    end
    
    function testRetrieveGlobalAttribute( self )
      self.nc.AutoAccess = true;
      att = self.nc.ATTRIBUTES.test_double_att;
      assertEqual( class(att), 'double', ...
        'class of retrieved attribute was not double.');
      assertEqual( att, 3.14159, ...
        'retrieved attribute differs from what was written.');
    end
    
    function test1dVariable( self )
      var = self.nc.VARIABLES.test_1D;
      sz = size(var);
      assertFalse(sz(1) ~= 6 && sz(2) ~= 1, ...
        'retrieved variable differs from what was written.');
    end
    
    function testReadSingleValueFrom1dVariable( self )
      self.nc.AutoAccess = true;
      var = self.nc.VARIABLES.test_1D;
      expData = 1.2;
      actData = var(2,1);
      ddiff = abs(expData - actData);
      assertFalse(any( find(ddiff > eps) ), ...
        'input data ~= output data.');
    end
    
    function testReadSingleValueFrom2dVariable( self )
      self.nc.AutoAccess = true;
      var = self.nc.VARIABLES.test_2D;
      expData = 1.5;
      getData = var(3,3);
      ddiff = abs(expData - getData);
      assertFalse(any( find(ddiff > eps) ), ...
        'input data ~= output data.');
    end
    
    function testReadSomeValuesFrom2dVariable( self )
      self.nc.AutoAccess = true;
      expData = [0.8 1.4; 0.9 1.5; 1.0 1.6];
      getData = self.nc.VARIABLES.test_2D(2:4,2:3);
      assertFalse( ndims(getData) ~= 2, ...
        'rank of output data was not correct' );
      assertFalse( numel(getData) ~= 6, ...
        'size of output data was not correct' );
      ddiff = abs(expData(:) - getData(:));
      assertFalse( any( find(ddiff > eps) ), ...
         'input data ~= output data ' );
    end
    
    function test_write_scale_offset( self )
      %
      % Put a scale factor of 2 and add offset of 1.
      % Write some data,
      % Put a scale factor of 4 and add offset of 2.
      % data read back should be twice as large
      
      ncfile = 'foo.nc';
      ncid = us191.netcdf('memory');
      ncid.AutoScale = true;
      ncid.Echo = false;
      ncid.DIMENSIONS('x') = struct('key__', 'x', 'dimlen', 4, ...
        'unlimited', 0);
      ncid.DIMENSIONS('y') = struct('key__', 'y', 'dimlen', 6, ...
        'unlimited', 0);
      %  To create fields that contain cell arrays, place the cell arrays
      % within a VALUE cell array.
      ncid.VARIABLES('data_2D') = struct('key__', 'data_2D', ...
         'type__', 'short', 'dimension__', {{'x','y'}},...
         'scale_factor', 2.0, 'add_offset', 0, 'data__', []);
       
      sz = [4 6];
      count = sz;
      input_data = 1:prod(count);
      input_data = reshape(input_data, count);
      % ncid.AutoAccess = true;
      value = int16(input_data);
      ncid.VARIABLES.data_2D.data__ = value;
      ncid.write(ncfile, 'NC_CLOBBER');
      
      ncid = us191.netcdf('foo.nc');
      ncid.AutoAccess = true;
      
      output_data = ncid.VARIABLES.data_2D;
      
%       nc_attput ( ncfile, 'test_2D', 'scale_factor', 4.0 );
%       nc_attput ( ncfile, 'test_2D', 'add_offset', 2.0 );
      
      ddiff = abs(input_data - (output_data)/2);
      assertFalse( any( find(ddiff > eps) ), 'failed');
      
    end
    
    
  end % End of public methods
  
end % End of classdef
