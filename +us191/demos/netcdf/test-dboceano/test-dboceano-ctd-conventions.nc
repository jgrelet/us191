CDF       
   
   TIME      LEVEL         LATITUDE      	LONGITUDE         POSITION      	STRING256         STRING14      STRING8       STRING4       N1              cycle_mesure      PIRATA-FR19-TEST   platform_name         ANTEA      	call_sign         FNUR   wmo_platform_code         35A8   project_name      PIRATA     platform_code         FNUR   type_instrument       SBE911+    type_position         GPS    number_instrument         11P928     	data_type         profile    	data_mode         N/A    time_coverage_start       2009-06-13T09:00:00Z   time_coverage_end         2009-07-23T08:00:00Z   netcdf_version        3.6    conventions       OceanSITES 1.2, CF1.4      date_update       2010-06-09T16:10:54Z   data_restrictions         N/A    pi_name       Bernard Bourles    author        Jacques Grelet     data_assembly_center      N/A    processing_state      2C+    comment       N/A       "   REFERENCE_DATE_TIME                	long_name         ORIGIN OF TIME     conventions       yyyymmddHHMMSS     comment       %Reference date for julian days origin           9    DATE                   	long_name         $DATE OF MAINS INSTRUMENT MEASUREMENT   conventions       yyyymmddHHMMSS     axis      T      comment       BThis is the original data describing the date, it must not be lost     
coordinate        TIME      ,  90   TIME                	long_name         ,DECIMAL JULIAN DAY (UTC) OF EACH MEASUREMENT   standard_name         time   units         days since 1950-01-01T00:00:00Z    conventions       URelative julian days with decimal part (as parts of the day) from REFERENCE_DATE_TIME      	valid_min                    	valid_max         @��        format        %9.5lf     	epic_code         @��        axis      T      comment       Julian day of the measurement      
coordinate        TIME        9\   TIME_QC              	   	long_name         QUALITY FLAG OF TIME   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       !Quality flag for each TIME value.      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          9t   LATITUDE               	long_name         LATITUDE OF THE MEASUREMENT    standard_name         latitude   units         degree_north   	valid_min         ´     	valid_max         B�     format        %+8.4lf    
_FillValue        G�O�   	epic_code         C�     axis      Y      comment       %Latitude of the measurement (decimal)      
coordinate        LATITUDE        9x   	LONGITUDE                  	long_name         LONGITUDE OF THE MEASUREMENT   standard_name         	longitude      units         degree_east    	valid_min         �4     	valid_max         C4     format        %+9.4lf    
_FillValue        G�O�   	epic_code         C��    axis      X      comment       &Longitude of the measurement (decimal)     
coordinate        	LONGITUDE           9�   POSITION_QC             	   	long_name         QUALITY FLAG OF POSITION   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       3Quality flag for each LATITUDE and LONGITUDE value.    default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value          9�   TEMP                
   	long_name         SEA WATER TEMPERATURE      standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         ��     	valid_max         B     format        %6.3lf     
_FillValue        G�O�   
resolution        :�o   comment       Ocean temperature      
coordinate        TIME      �  9�   TEMP_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       -Quality flag for each Ocean temperature value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  :0   TEMP_CAL                   	long_name          SEA WATER TEMPERATURE CALIBRATED   standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Ocean temperature calibrated      �  :X   TEMP_ADJUSTED                      	long_name         SEA WATER TEMPERATURE ADJUSTED     standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Adjusted Ocean temperature        �  :�   TEMP_ADJUSTED_ERROR                    	long_name         'ERROR ON SEA WATER TEMPERATURE ADJUSTED    standard_name         sea_water_temperature      units         degree_Celsius     	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       #Error on adjusted Ocean temperature       �  ;�   TEMP_ADJUSTED_QC                	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       2Quality flag applied on adjusted Ocean temperature     default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  <,   TEMP_ADJUSTED_HIST                 	long_name         1ADJUSTED SEA WATER TEMPERATURE PROCESSING HISTORY      comment       -Adjusted Ocean temperature processing history           <T   PSAL                
   	long_name         PRACTICAL SALINITY     standard_name         sea_water_salinity     units         psu    	valid_min         ��     	valid_max         B     format        %6.3lf     
_FillValue        G�O�   
resolution        :�o   comment       Ocean salinity     
coordinate        TIME      �  =T   PSAL_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       *Quality flag for each Ocean salinity value     default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  =�   PSAL_CAL                   	long_name         PRACTICAL SALINITY CALIBRATED      standard_name         sea_water_salinity     units         psu    	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Ocean salinity calibrated         �  >   PSAL_ADJUSTED                      	long_name         PRACTICAL SALINITY ADJUSTED    standard_name         sea_water_salinity     units         psu    	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       Adjusted Ocean salinity       �  >�   PSAL_ADJUSTED_ERROR                    	long_name         $ERROR ON PRACTICAL SALINITY ADJUSTED   standard_name         sea_water_salinity     units         psu    	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment        Error on adjusted Ocean salinity      �  ?P   PSAL_ADJUSTED_QC                	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       /Quality flag applied on adjusted Ocean salinity    default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  ?�   PSAL_ADJUSTED_HIST                 	long_name         .ADJUSTED PRACTICAL SALINITY PROCESSING HISTORY     comment       *Adjusted Ocean salinity processing history          @   DOX2                
   	long_name         DISSOLVED OXYGEN   standard_name         ?moles_of_oxygen_per_unit_mass_in_sea_water was dissolved_oxygen    units         micromole/kg   	valid_min         ��     	valid_max         B     format        %6.3lf     
_FillValue        G�O�   
resolution        :�o   comment       Ocean oxygen in micromole by kg    
coordinate        TIME      �  A   DOX2_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       ;Quality flag for each Ocean oxygen in micromole by kg value    default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  A�   DOX2_CAL                   	long_name         DISSOLVED OXYGEN CALIBRATED    standard_name         ?moles_of_oxygen_per_unit_mass_in_sea_water was dissolved_oxygen    units         micromole/kg   	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       *Ocean oxygen in micromole by kg calibrated        �  A�   DOX2_ADJUSTED                      	long_name         DISSOLVED OXYGEN ADJUSTED      standard_name         ?moles_of_oxygen_per_unit_mass_in_sea_water was dissolved_oxygen    units         micromole/kg   	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       (Adjusted Ocean oxygen in micromole by kg      �  Bt   DOX2_ADJUSTED_ERROR                    	long_name         "ERROR ON DISSOLVED OXYGEN ADJUSTED     standard_name         ?moles_of_oxygen_per_unit_mass_in_sea_water was dissolved_oxygen    units         micromole/kg   	valid_min         G�O�   	valid_max         G�O�   format        %6.3lf     
_FillValue        G�O�   comment       1Error on adjusted Ocean oxygen in micromole by kg         �  C   DOX2_ADJUSTED_QC                	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       @Quality flag applied on adjusted Ocean oxygen in micromole by kg   default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  C�   DOX2_ADJUSTED_HIST                 	long_name         ,ADJUSTED DISSOLVED OXYGEN PROCESSING HISTORY   comment       ;Adjusted Ocean oxygen in micromole by kg processing history         C�   PRES                	   	long_name         SEA WATER PRESSURE     standard_name         sea water pressure     units         decibard   positive      down   format        %7.2lf     
_FillValue        G�O�   axis      Z      comment       Pressure of the measurement    
coordinate        LEVEL         �  D�   PRES_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       !Quality flag for each level value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  Ep   DEPH                	   	long_name         SEA WATER DEPH     standard_name         deph   units         m      positive      up     format        %7.2lf     
_FillValue        G�O�   axis      Z      comment       Deph of the measurement    
coordinate        LEVEL         �  E�   DEPH_QC                 	   	long_name         QUALITY FLAG   conventions       OceanSITES reference table 2   	valid_min                	valid_max         	      format        %1d    comment       !Quality flag for each level value      default_value                flag_values       0, 1, 2, 3, 4, 5, 7, 8, 9      flag_meanings         �no_qc_performed, good_data, probably_good_data, bad_data_that_are_potentially_correctable, bad_data, value_changed, not_used, nominal_value, interpolated_value, missing_value        (  F4   STATION                 	long_name         STATION NUMBER     format        %4d    comment       :Station number, a station could be have more than one cast     
coordinate        TIME        F\   CAST                	long_name         CAST NUMBER    format        %4d    comment       Cast number    
coordinate        TIME        Fh19500101000000  200906181420322009061915470220090620122703  @�5�>� `@�5�"�@@�6!3������92B    ���&�O�N��  �A��;A��/A��A��#A��A��
A���A�ȴAБhAЏ\A�E�G�O�G�O�A��A��A��A�+B	{A�(�A�(�A�ĜA��mA�{A��A���A�ZA�^5A�^5A�ĜA�ĜA�A���A�ffA�A���G�O�G�O�G�O�G�O�      �A��HA��;A��#A��/A��#A��A���A���AГuAБhA�G�G�O�G�O�A��A��A��A�-B	�A�+A�+A�ƨA��yA��A��A���A�\)A�`BA�`BA�ƨA�ƨA�ĜA���A�hsA�A�  G�O�G�O�G�O�G�O�A��TA��HA��/A��;A��/A��#A��
A���AЕ�AГuA�I�G�O�G�O�A��A��A��A�-B	�A�+A�+A�ƨA��yA��A��A���A�\)A�`BA�`BA�ƨA�ƨA�ĜA���A�hsA�A�  G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�      �                                                                                                                                                                                                                                                                B{�B{�B{�B{�B{�B{�B{�Bz�Bz�By�Bx�G�O�G�O�B9XB9XB9XB9XB_9XB9XB8RB8RB>wBC�BE�BF�BI�B9XB9XB9XB<jB=qB8RB5?B33B'�G�O�G�O�G�O�G�O�      �B|�B|�B|�B|�B|�B|�B|�B{�B{�Bz�By�G�O�G�O�B:^B:^B:^B:^B_:^B:^B9XB9XB?}BD�BF�BG�BJ�B:^B:^B:^B=qB>wB9XB6FB49B(�G�O�G�O�G�O�G�O�B}�B}�B}�B}�B}�B}�B}�B|�B|�B{�Bz�G�O�G�O�B:^B:^B:^B:^B_:^B:^B9XB9XB?}BD�BF�BG�BJ�B:^B:^B:^B=qB>wB9XB6FB49B(�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�      �                                                                                                                                                                                                                                                                CD�CCOCC��CC;CC�=CCR-CCZ�CC~5CC#�CC6CC��G�O�G�O�CN}�CN}�CN}�CNe`CNT9CM׍Db|�CL��CI��CIf%CI�CH�uCH�CN}�CN}�CNc�CNA�CNT9CM��CK}CGXRCD�'G�O�G�O�G�O�G�O�      �CD�ZCCO\CC�#CC}CC�CCRoCCZ�CC~wCC$CC6FCC��G�O�G�O�CN~5CN~5CN~5CNe�CNT{CM��Db}CL��CI��CIffCI�CH��CH�CN~5CN~5CNdCNA�CNT{CM��CK�CGX�CD�hG�O�G�O�G�O�G�O�CD��CCO�CC�dCC�CC��CCR�CC[#CC~�CC$ZCC6�CC�G�O�G�O�CN~5CN~5CN~5CNe�CNT{CM��Db}CL��CI��CIffCI�CH��CH�CN~5CN~5CNdCNA�CNT{CM��CK�CGX�CD�hG�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�G�O�      �                                                                                                                                                                                                                                                                @@  @�  @�  @�  @�  A   A  A   A0  A@  AP  G�O�G�O�    ?�  @   @@  @�  @�  @�  @�  A   A  A   A0  A@      ?�  @   @@  @�  @�  @�  @�  A   G�O�G�O�G�O�G�O�      �@>�@~�Y@�~@��F@��@���A4�A A/JA>�AN��G�O�G�O�    ?~��?���@>�@~�Y@�~@��F@��@���A4�A A/JA>�    ?~��?���@>�@~�Y@�~@��F@��@���G�O�G�O�G�O�G�O�      �                  