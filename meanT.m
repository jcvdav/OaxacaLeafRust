clear, close, clc
files = ls('.\Data\tmp\*.csv');


min_date = datenum(2000,1,1);
ignored = zeros(length(files),3);
id = [];
station = id;
latitude = id;
longitude = id;
month = id;
day = id;
year = id;
date = id;
date_num = id;
var = id;


j = 1;

for i = 1:length(files)
    
    file = fullfile('.','Data','tmp',char(string(files(i,:))));
    
    % Load the files
    fileID = fopen(file);
    Meta = textscan(fileID, '%s %s %s %s',8,'Delimiter',',');
    end_date_i = datenum(char(Meta{2}{6}));
    id_i = str2double(string(Meta{2}{1}));
    station_i = string(Meta{2}{2});
    position_i = strsplit(Meta{2}{3}, 'N ');
    latitude_i = str2double(string(position_i{1}));
    longitude_i = strsplit(position_i{2}, 'W');
    longitude_i = str2double(strsplit(string(longitude_i{1})));
    
    if(end_date_i > min_date)
        Data = textscan(fileID, '%f %f %f %f','Delimiter',',','TreatAsEmpty', {'na', 'NA', 'null'});
        month_i = Data{1};
        day_i = Data{2};
        year_i = Data{3};
        date_num_i = datenum(year_i, month_i, day_i);
        date_i = datestr(date_num_i);
        var_i = Data{4};
        
        nrows = length(month_i);
        rows = ones(nrows,1);
        % Meta
        id_i = rows* id_i;
        station_i(1:nrows) = string(station_i);
        latitude_i = rows*latitude_i;
        longitude_i = rows*longitude_i;
        
        %Concatenate data
        id = [id; id_i];
        station = [station, station_i];
        latitude = [latitude; latitude_i];
        longitude = [longitude; longitude_i];
        month = [month; month_i];
        day = [day; day_i];
        year = [year; year_i];
        date = [date; date_i];
        date_num = [date_num; date_num_i];
        var = [var; var_i];
    else
        ignored(j,1) = id_i;
        ignored(j,2) = longitude_i;
        ignored(j,3) = latitude_i;
        j = j+1;
    end
    
    fclose(fileID);
end

T = table(id, station', abs(latitude), longitude, month, day, year, date, date_num, var);

T.Properties.Description = 'Daily mean temperatures for weather stations in Oaxaca, Mexico';

T.Properties.VariableNames = {'id','station','latitude','longitude','month','day','year','date','datenum','meanT'};

T.Properties.VariableDescriptions = cell({'Identification code used by the Mexican Weather Service (SMN)',...
    'Name of the station','Latiude','Longitude',...
    'Month(1:12)','Day','Year','Date in mm/dd/yyy format','Matlab''s datenum','Mean temperature'});
T.Properties.VariableUnits = cell({'NA','NA','Decimal degrees','Decimal degrees','NA','NA','NA','mm/dd/yyyy',...
    'datenum','oC'});






