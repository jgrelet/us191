CDF       
   
   TIME      LEVEL         LATITUDE      	LONGITUDE         POSITION      	STRING256         STRING14      STRING8       STRING4       N1              cycle_mesure      TOUCAN-TEST    platform_name         TOUCAN     	call_sign         FNAV   wmo_platform_code         35A9   project_name      ORE-SSS    platform_code         FNAV   type_instrument       SBE21      type_position         GPS    number_instrument         3196   	data_type         
trajectory     	data_mode         N/A    time_coverage_start       2007-07-18T08:40:00Z   time_coverage_end         2007-09-07T09:10:00Z   netcdf_version        3.6    conventions       OceanSITES 1.1, CF1.4      date_update       2010-06-09T16:54:18Z   data_restrictions         N/A    pi_name       Thierry Delcroix   author        Jacques Grelet     data_assembly_center      N/A    processing_state      2C+    comment       N/A           REFERENCE_DATE_TIME                	long_name         ORIGIN OF TIME     conventions       yyyymmddHHMMSS     comment       %Reference date for julian days origin           7�   DATE                   	long_name         $DATE OF MAINS INSTRUMENT MEASUREMENT   conventions       yyyymmddHHMMSS     axis      T      comment       BThis is the original data describing the date, it must not be lost     
coordinate        TIME      H  7�   TIME                	long_name         ,DECIMAL JULIAN DAY (UTC) OF EACH MEASUREMENT   standard_name         time   units         days since 1950-01-01T00:00:00Z    conventions       URelative julian days with decimal part (as parts of the day) from REFERENCE_DATE_TIME      	valid_min                    	valid_max         @��        format        %9.5lf     	epic_code         @��        axis      T      comment       Julian day of the measurement      
coordinate        TIME      (  84   TIME_QC              	   	long_name         QUALITY FLAG OF TIME   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       !Quality flag for each TIME value.      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          8\   LATITUDE               	long_name         LATITUDE OF THE MEASUREMENT    standard_name         latitude   units         degree_north   	valid_min         ´     	valid_max         B�     format        %+8.4lf    
_FillValue        G�O�   	epic_code         C�     axis      Y      comment       %Latitude of the measurement (decimal)      
coordinate        LATITUDE        8d   	LONGITUDE                  	long_name         LONGITUDE OF THE MEASUREMENT   standard_name         	longitude      units         degree_east    	valid_min         �4     	valid_max         C4     format        %+9.4lf    
_FillValue        G�O�   	epic_code         C��    axis      X      comment       &Longitude of the measurement (decimal)     
coordinate        	LONGITUDE           8x   POSITION_QC             	   	long_name         QUALITY FLAG OF POSITION   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       3Quality flag for each LATITUDE and LONGITUDE value.    default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          8�   SSJT                
   	long_name         $SEA SURFACE WATER JACKET TEMPERATURE   standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         ��     	valid_max         B     format        %6.3lf     
_FillValue        G�O�   
resolution        :�o   comment       Ocean temperature      
coordinate        TIME        8�   SSJT_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       -Quality flag for each Ocean temperature value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          8�   SSJT_CAL                   	long_name         /SEA SURFACE WATER JACKET TEMPERATURE CALIBRATED    standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Ocean temperature calibrated        8�   SSJT_ADJUSTED                      	long_name         -SEA SURFACE WATER JACKET TEMPERATURE ADJUSTED      standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Adjusted Ocean temperature          8�   SSJT_ADJUSTED_ERROR                    	long_name         6ERROR ON SEA SURFACE WATER JACKET TEMPERATURE ADJUSTED     standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       #Error on adjusted Ocean temperature         8�   SSJT_ADJUSTED_QC                	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       2Quality flag applied on adjusted Ocean temperature     default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          8�   SSJT_ADJUSTED_HIST                 	long_name         @ADJUSTED SEA SURFACE WATER JACKET TEMPERATURE PROCESSING HISTORY   comment       -Adjusted Ocean temperature processing history           8�   SSTP                
   	long_name         SEA SURFACE WATER TEMPERATURE      standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         ��     	valid_max         B     format        %6.3lf     
_FillValue        G�O�   
resolution        :�o   comment       Sea surface Ocean temperature      
coordinate        TIME        9�   SSTP_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       9Quality flag for each Sea surface Ocean temperature value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          :   SSTP_CAL                   	long_name         (SEA SURFACE WATER TEMPERATURE CALIBRATED   standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       (Sea surface Ocean temperature calibrated        :   SSTP_ADJUSTED                      	long_name         &SEA SURFACE WATER TEMPERATURE ADJUSTED     standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       &Adjusted Sea surface Ocean temperature          :$   SSTP_ADJUSTED_ERROR                    	long_name         /ERROR ON SEA SURFACE WATER TEMPERATURE ADJUSTED    standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       /Error on adjusted Sea surface Ocean temperature         :8   SSTP_ADJUSTED_QC                	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       >Quality flag applied on adjusted Sea surface Ocean temperature     default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          :L   SSTP_ADJUSTED_HIST                 	long_name         9ADJUSTED SEA SURFACE WATER TEMPERATURE PROCESSING HISTORY      comment       9Adjusted Sea surface Ocean temperature processing history           :T   SSPS                
   	long_name         SEA SURFACE PRACTICAL SALINITY     standard_name         sea_water_salinity     units         psu    	valid_min         ��     	valid_max         B     format        %6.3lf     
_FillValue        G�O�   
resolution        :�o   comment       Ocean salinity     
coordinate        TIME        ;T   SSPS_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       *Quality flag for each Ocean salinity value     default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          ;h   SSPS_CAL                   	long_name         )SEA SURFACE PRACTICAL SALINITY CALIBRATED      standard_name         sea_water_salinity     units         psu    	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Ocean salinity calibrated           ;p   SSPS_ADJUSTED                      	long_name         'SEA SURFACE PRACTICAL SALINITY ADJUSTED    standard_name         sea_water_salinity     units         psu    	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Adjusted Ocean salinity         ;�   SSPS_ADJUSTED_ERROR                    	long_name         0ERROR ON SEA SURFACE PRACTICAL SALINITY ADJUSTED   standard_name         sea_water_salinity     units         psu    	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment        Error on adjusted Ocean salinity        ;�   SSPS_ADJUSTED_QC                	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       /Quality flag applied on adjusted Ocean salinity    default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          ;�   SSPS_ADJUSTED_HIST                 	long_name         :ADJUSTED SEA SURFACE PRACTICAL SALINITY PROCESSING HISTORY     comment       *Adjusted Ocean salinity processing history          ;�   PRES                	   	long_name         SEA WATER PRESSURE     standard_name         sea water pressure     units         decibard   positive      down   format        %7.2lf     
_FillValue        G�O�   axis      Z      comment       Pressure of the measurement    
coordinate        LEVEL           <�   PRES_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       !Quality flag for each level value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          <�   DEPH                	   	long_name         SEA WATER DEPH     standard_name         deph   units         m      positive      up     format        %7.2lf     
_FillValue        G�O�   axis      Z      comment       Deph of the measurement    
coordinate        LEVEL           <�   DEPH_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       !Quality flag for each level value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          <�19500101000000  2007081503450020070815035000200708150355002007081504000020070815040500  @ԍJ    @ԍJ8�@@ԍJq��@ԍJ����@ԍJ�8���������A�@�A�%�A�
�A��A�ՁG�?�7+.�&F��������A�z�A��A�A� �A��     ���G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�     ���                                                                                                                                                                                                                                                                A�A� �A�7LA�S�A�I����A�!A�"�A�9XA�"�A�K�A�-A�$�A�9XA�$�A�M�G�O�G�O�G�O�G�O�G�O����                                                                                                                                                                                                                                                                B�B�'B�hBaHBJ����B�B�-B�oBbNBK�B�B�3B�oBcTBL�G�O�G�O�G�O�G�O�G�O����                                                                                                                                                                                                                                                                G�O�G�O�G�O�G�O�G�O���������G�O�G�O�G�O�G�O�G�O���������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    