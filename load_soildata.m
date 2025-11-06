function soildata = load_soildata()
% LOAD_SOILDATA Load and structure soil data from multiple locations.
%
% This function loads soil moisture, clay percentage, and layering 
% structure data for 5 different locations and organizes it into a 
% structured array.

% Define soil moisture content (Volumetric Water Content, VWC) 
% for 5 locations. Values are in percentage.
VWC1 = [19.0 16.5 16.0 15.0 15.4]/100;      %  location 1-5
VWC2 = [21.7 25.7 25.0 26.9 28.6]/100;  
VWC3 = [29.7 28.3 26.1 27.2 28.1]/100;
VWC4 = [11.5 11.8 14.8 16.3 16.3]/100;
VWC5 = [20.8 21.7 16.6 14.9 16.2]/100;

% Define clay percentage for the same 5 locations.                        
C1 = [26 24 20 20 20]/100;                   % location 1-5
C2 = [28 29 34 38 46]/100;    
C3 = [31 35 36 45 47]/100;
C4 = [22 32 40 45 48]/100;
C5 = [28 42 51 49 48]/100;

% Define layering structure for each location.
%  These arrays represent cumulative depths of layers in meters
Layer1 = [0 0.1 0.2 0.4 0.5];               % location 1-5
Layer2 = [0 0.2 0.4 0.5];                    
Layer3 = [0 0.3 0.5];                        
Layer4 = [0 0.1 0.5];                        
Layer5 = [0 0.1 0.2 0.5];   

% Organize the data into a structured array .
% The structure contains three fields: 'VWC', 'Clay', and 'Layer'.
field1 = 'VWC'; value1 = {VWC1, VWC2, VWC3, VWC4, VWC5};
field2 = 'Clay'; value2 = {C1, C2, C3, C4, C5};
field3 = 'Layer'; value3 = {Layer1,Layer2,Layer3,Layer4,Layer5};

% Create the structured array.
soildata = struct(field1,value1,field2,value2,field3,value3);

end