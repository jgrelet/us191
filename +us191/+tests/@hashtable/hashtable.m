%% us191.tests.hashtable
%
% This class implements tests cases on the hashtable class
% which is part of the packaqe +us191. It is based on the 'TestCase'
% class of the xUnit Framework.
%
% You can run one particular test case implemented in a method of hashtable named
% testMethod by typing :
%
%     >> t = us191.tests.hashtable('testMethod');
%     >> t.run
% or
%     >> runtests us191.tests.hashtable:testMethod
%     >> runtests us191.tests.hashtable -verbose
%
% For example run all tests for us191.hashtable :
%
%     >> runtests us191.tests.hashtable
%     Test suite: us191.tests.hashtable
%     Test suite location: +us191/+tests/@hashtable/hashtable.m
%     09-Sep-2011 13:49:32
%
%     Starting test run with 9 test cases.
%     .........
%     PASSED in 0.068 seconds.
%
%     >> t = us191.tests.hashtable('testKeys');
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
classdef hashtable < TestCase
  
  % Properties definition
  % ---------------------
  properties
    
    % Number of pairs (key , value) used in the tests
    n = 20;
    
    % empty hash
    hash = us191.hashtable;
    
    % Char pairs
    key;
    value;
    
    % Double pairs
    doubleKey;
    doubleValue;
    
    % Other type Keys
    otherKey;
    
    % Other type Values
    otherValue;
    
    % define matlab data types
    type = {'char','single','double','int8','int16','int32','int64'};
    
    % define a vector
    vector;
    
    % define an array
    array;
    
  end % End of Properties definition
  
  methods
    
    % Constructor
    %------------
    function self = hashtable(testMethod)
      self = self@TestCase(testMethod);
    end
    
    % setup
    % -----
    function setUp(self)
      
      % Creation of key and value cell
      % ------------------------------
      self.key   = cell(1, self.n);
      self.value = cell(1, self.n);
      
      % Cell padding
      % ------------
      for i = 1: self.n
        
        % fill key/value pairs
        % --------------------
        self.key{i}   = sprintf('%s %d', 'key', i);
        self.value{i} = sprintf('%s %d', 'value', i);
      end
      
      % Random double keys and values
      % -----------------------------
      self.doubleKey   = num2cell(10*(rand(1, self.n))-5);
      self.doubleValue = num2cell(10000*(rand(1, self.n))-5000);
      
      % Creation of other type keys
      %----------------------------
      self.otherKey = {single(12345*10^9), int32(2147483647), ...
        uint32(4294967295), int64(-9223372036854775808), ...
        uint64(18446744073709551615)};
      
      % Creation of other type values
      %------------------------------
      self.otherValue = {single(12345*10^9), int8(127), ...
        uint8(244), int16(32012), uint16(50421), int32(2147483647), ...
        uint32(4294967295), int64(-9223372036854775808), ...
        uint64(18446744073709551615),logical(true),logical(false)};
      
      % set a vector
      % ---------------
      self.vector = [0:10];
    
      % set an array
      % ------------
      self.array = rand(4,6);
      
    end % end of setUp function
    
    % tearDown
    %---------
    function tearDown(self)
    end
    
    %% tests methods
    % --------------
    function testKeys( self )
      h = us191.hashtable( self.key, self.value);
      assertEqual(keys(h), self.key, 'list of keys don''t match');
      h = us191.hashtable( self.doubleKey, self.doubleValue);
      assertEqual(keys(h), self.doubleKey, 'list of keys don''t match');
    end
    
    function testValues( self )
      h = us191.hashtable( self.key, self.value);
      assertEqual(values(h), self.value, 'list of values don''t match');
      h = us191.hashtable( self.doubleKey, self.doubleValue);
      assertEqual(values(h), self.doubleValue, 'list of values don''t match');
    end
    
    function testClearKeys( self )
      h = us191.hashtable( self.key, self.value);
      clear(h);
      assertEqual(keys(h), {}, 'the keys list is not empty !');
      h = us191.hashtable( self.doubleKey, self.doubleValue);
      clear(h);
      assertEqual(keys(h), {}, 'the keys list is not empty !');
    end
    
    function testClearValues( self )
      h = us191.hashtable( self.key, self.value);
      clear(h);
      assertEqual(values(h), {}, 'the values list is not empty !');
      h = us191.hashtable( self.doubleKey, self.doubleValue);
      clear(h);
      assertEqual(values(h), {}, 'the values list is not empty !');
    end
    
    function testEmptyKey( self )
      assertTrue(isempty(keys(self.hash)), 'the key list isn''t empty!');
    end
    
    function testEmptyValue( self )
      assertTrue(isempty(values(self.hash)), 'the value list isn''t empty');
    end
    
    function testNotEmptyHash( self )
      h = us191.hashtable(self.key, self.value);
      assertFalse(isEmpty(h), 'hashtable should not be empty');
    end
    
    function testNotEmptyKey( self )
      h = us191.hashtable(self.key, self.value);
      assertFalse(isempty(keys(h)), 'the key list is empty!');
    end
    
    function testNotEmptyValue( self )
      h = us191.hashtable(self.key, self.value);
      assertFalse(isempty(values(h)), 'the value list is empty');
    end
    
    function testHashtableConstructorMatch(self)
      assertExceptionThrown( @() us191.hashtable('a', 'b', 'c'), ...
        'HASHTABLE:hashtable', 'Constructor not match');
    end
    
    function testIsKey(self)
      h = us191.hashtable( self.key, self.value);
      for i = 1: self.n
        assertTrue(isKey(h, self.key{i}) , 'key doesn''t match');
      end
    end
    
    function testIsValue(self)
      h = us191.hashtable( self.key, self.value);
      for i = 1: self.n
        assertTrue(isValue(h, self.value{i}) , 'value doesn''t match');
      end
    end
    
    function testGetValue(self)
      h = us191.hashtable( self.key, self.value);
      for i = 1: self.n
        assertEqual(get(h, self.key{i}), self.value{i}, 'value doesn''t match');
      end
      h = us191.hashtable( self.doubleKey, self.doubleValue);
      for i = 1: self.n
        assertEqual(get(h, self.doubleKey{i}), self.doubleValue{i}, 'value doesn''t match');
      end
    end
    
    function testHashtableGetMatch(self)
      h = us191.hashtable( self.key, self.value);
      assertExceptionThrown( @() get(h, h), 'HASHTABLE:get');
    end
    
    function testPutValue(self)
      h = us191.hashtable;
      for i = 1: self.n
        put(h, self.key{i}, self.value{i});
        assertEqual(get(h, self.key{i}), self.value{i}, 'value doesn''t match');
      end
      clear(h);
      for i = 1: self.n
        put(h, self.doubleKey{i}, self.doubleValue{i});
        assertEqual(get(h, self.doubleKey{i}), self.doubleValue{i}, 'value doesn''t match');
      end
    end
    
    function testHashtablePutMatch(self)
      h = us191.hashtable;
      assertExceptionThrown( @() put(h, h, self.value), 'HASHTABLE:put');
    end
    
    function testHashtablePutMatchKeyType(self)
      h = us191.hashtable(1, 1);
      assertExceptionThrown( @() put(h, char(1), 1), 'HASHTABLE:put');
    end
    
    function testRemoveValue(self)
      h = us191.hashtable( self.key, self.value);
      for i = 1: self.n
        remove(h, self.key{i});
      end
      assertTrue(isEmpty(h), 'hashtable should not be empty');
    end
    
    function testVector(self)
      h = us191.hashtable( 'a', self.vector);
      expData = self.vector(1,1:4);
      getData = h.a(1,1:4);
      ddiff = abs(expData - getData);
      assertFalse(any( find(ddiff > eps) ), ...
        'input data ~= output data.');
      getData=[1,2,3,4];
      ddiff = abs(expData - getData);
      assertTrue(any( find(ddiff > eps) ), ...
        'failed in fake test.');
    end
    
    function testArray(self)
      h = us191.hashtable( 'a', self.array);
      expData = self.array(2:4,2:5);
      getData = h.a(2:4,2:5);
      if ndims(getData) ~= 2
        error ( 'rank of output data was not correct' );
      end
      if numel(getData) ~= 12
        error ( 'size of output data was not correct' );
      end
      ddiff = abs(expData - getData);
      assertFalse(any( find(ddiff > eps) ), ...
        'input data ~= output data.');
      getData = rand(3,4);
      ddiff = abs(expData - getData);
      assertTrue(any( find(ddiff > eps) ), ...
        'failed in fake test.');
    end
    
  end % end of methods
  
end % end of class
