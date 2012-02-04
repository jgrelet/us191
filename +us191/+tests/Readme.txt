-------------------------------------------------------------------------------
%                            us191.tests readme                               %
-------------------------------------------------------------------------------

The package us191.tests contains different tests on the built-in class
containers.Map and on different classes of us191 which are : 

- hashtable
- dynaload
- netcdf

-------------------------------------------------------------------------------

IMPORTANT NOTES : 

- these tests are based on the xUnit framework (v 3.0.1) for MATLAB so that 
  you will have to install it in order to run us191.tests tests. 
  Please use a recent version of the framework.

- In order to work with the us191 package, you must declare his directory 
  in the MATLAB path.

-------------------------------------------------------------------------------
                   -- HOW TO GENERATE TEST NETCDF FILE --
-------------------------------------------------------------------------------
Test files are under +tests/testdata directory
Use ncgen to generate netcdf file from cdl description:

$ gvim us191.cdl
$ ncgen -b -o us191.nc us191.cdl

see example cdl file from:
http://ferret.wrc.noaa.gov/noaa_coop/coop_cdf_example.html
 
-------------------------------------------------------------------------------
                        -- USING THE INTERFACE --
-------------------------------------------------------------------------------

In order to launch the tests of us191.tests, you can use the graphic interface
entering the following command line : 

	>> us191.tests.interface;


-------------------------------------------------------------------------------
                        -- DIRECT INSTRUCTIONS --
-------------------------------------------------------------------------------

If you want to launch tests without using the graphic interface, you can do it
as following :

# To run all the tests of this package in MATLAB, enter the following 
instruction :

	>> runtests us191.tests;
 
# >> runtests us191.tests '-verbose'

displays the name and result, result, and time taken for each test case 
to the Command Window

# To run all the tests on a particular class, for example hashtable, 
you can enter :

	>> runtests us191.tests.hashtable;


# To run a particular test, for example testValues of the map class, 
you can enter :

	>> t = us191.tests.map('testValues'); % declares a new test case
	>> t.run; % runs the test
