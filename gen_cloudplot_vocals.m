function [] = gen_cloudplot_vocals(filepath, plot_type)

%% Documentation Section
% Script:  gen_cloudplot_vocals.m
% Author:  Laura Tomkins
% Version Date:  20 July 2017
% Purpose:  Plots cloud radar reflectivity and velocity data from Hiaper aircraft
% files are in cfrad format. Function inputs filepath and plot types, generates data arrays
% and plots the data and outputs figures.
% NOTE: Only plots SV2 & SH1 files
% 
% Input Arguments: 
%        (a) filepath - path of file to plot
%        (b) plot_type - type of data to plot (can be 'ref', 'vel', or 'both')
%
% Output Arguments: 
%        depending on plot_type, and flightpath_flag, function will output
%        1 or 2 figures (reflectivity, velocity)
%
% Functions Used: gen_netcdfvariablenames.m
%                 gen_readnetcdf2array_v3.m
%
% Required Paths: N/A
%
% Example usage: 
%       gen_cloudplot_hiaper(''/home/disk/molari1/neusarchive/hiapercloudradar/...
%           cfradial/moments/qcv1/10hz/20150202/cfrad.20150202_140000.121_to_...
%           20150202_140100.034_HCR_v0_s00_el-90.00_SUR.nc', 'both');


%   Written By: Laura Tomkins, July 2017
%%
addpath(genpath('/home/disk/zathras/ltomkins/matlab/c130'));

% file info
fields = get_netcdfvariablenames(filepath);
[PP_dimcell, PP_struct] = gen_readnetcdf2array_v3(filepath, fields{:,1} );

filetype = filepath(end-5:end-3);

% time
extratime = etime([1970 01 01 00 00 00], [0000 01 00 00 00 00]);
radar.timelist = (PP_struct(3).data + extratime)./(24*3600);

% gate info
radar.ngates = PP_dimcell{2,2};  
radar.gatespacing = mode(diff(PP_struct(4).data));  % gate spacing [m]
radar.ntimes = PP_dimcell{1,2};
radar.range = PP_struct(4).data;

% plane altitide

switch filetype
    case 'PP4' % This is testing - doesn't work to plot
    radar.altitude = PP_struct(19).data;
    radar.firstgate = radar.altitude - PP_struct(4).data(1);
    radar.latlist = PP_struct(18).data;
    radar.lonlist = PP_struct(17).data;
    radar.reflectivity = PP_struct(11).data; % vv
    radar.velocity = PP_struct(12).data; % dv
    radar.reflectivityhh = PP_struct(10).data; % hh
    radar.missingvalue = PP_struct(10).attributes{3,2};
    
    case 'SV2'    
    radar.altitude = PP_struct(18).data;
    radar.firstgate = radar.altitude - PP_struct(4).data(1);
    radar.latlist = PP_struct(17).data;
    radar.lonlist = PP_struct(16).data;
    radar.reflectivity = PP_struct(10).data; % vv
    radar.velocity = PP_struct(11).data;
    radar.missingvalue = PP_struct(10).attributes{3,2};
    heightdata = (repmat(radar.firstgate,1,radar.ngates))';             % repeat copies of first gate height to make matrix same as data
    heightdata = double(heightdata - repmat(radar.range, 1, radar.ntimes));     % add range to height of first gate
    
    case 'SH1'    
    radar.altitude = PP_struct(18).data;
    radar.firstgate = radar.altitude + PP_struct(4).data(1);
    radar.latlist = PP_struct(17).data;
    radar.lonlist = PP_struct(16).data;
    radar.reflectivity = PP_struct(10).data; % vv
    radar.velocity = PP_struct(11).data;
    radar.missingvalue = PP_struct(10).attributes{3,2};
    heightdata = (repmat(radar.firstgate,1,radar.ngates))';             % repeat copies of first gate height to make matrix same as data
    heightdata = double(heightdata + repmat(radar.range, 1, radar.ntimes));

end

% fixing data
radar.reflectivity(radar.reflectivity<=0)=NaN;
radar.reflectivity = 10.*log10(radar.reflectivity); % convert mm3/mm6 to dBZ

radar.reflectivity(radar.reflectivity==radar.missingvalue)=NaN;
radar.velocity(radar.velocity==radar.missingvalue)=NaN;

% matrices for plotting
timedata = double((repmat(radar.timelist,1, radar.ngates))');

% minAltLoc = max(find(heightdata<0));                                % find lowest index where altitude is below zero
% heightdata(minAltLoc:end,:)=[];
% timedata(minAltLoc:end,:)=[];

refdata = double(radar.reflectivity);
% refdata(minAltLoc:end,:)=[];
veldata = double(radar.velocity);
% veldata(minAltLoc:end,:)=[];

switch plot_type
    case 'ref'
    f1=figure;
    surf(timedata, heightdata, refdata, 'EdgeColor', 'none'); view(2); % sets view to xy plane
    % colorbar
    map1=colormap(LCH_Spiral(150,1,180,1)); % color scale for reflectivity
    map1=flipud(map1); % flips color scale
    colormap(map1); cbar1 = colorbar; caxis([-40 0]);
    cbTitle1 = get(cbar1, 'Title'); titleString = 'Reflectivity (dBZ)';
    set(cbTitle1, 'String', titleString); set(cbTitle1,'FontSize',16);
    set(f1, 'Position', [1262 -144 1920 963]); % automatically sets position
    set(gca,'FontSize',16);
    xlabel('HH:MM:SS GMT'); ylabel('Height(m)');
    title_start = datestr(radar.timelist(1)); title_end = datestr(radar.timelist(end));
    title([title_start, ' to ', title_end]);
    datetick('x','HH:MM:SS'); axis tight
    
    case 'vel'
    f2=figure;
    surf(timedata, heightdata, refdata, 'EdgeColor', 'none'); view(2); % sets view to xy plane
    % colorbar
    map2=colormap(Colormap_DV_BWR(50, 0.3, .9)); % color scale for velocity
    colormap(map2);  cbar2 = colorbar; caxis([-30 30]);
    cbTitle2 = get(cbar2, 'Title'); titleString = 'Velocity (m/s)';
    set(cbTitle2, 'String', titleString);  set(cbTitle2,'FontSize',16);
    set(f2, 'Position', [1262 -144 1920 963]); % automatically sets position
    set(gca,'FontSize',16);
    xlabel('HH:MM:SS GMT'); ylabel('Height(m)');
    title_start = datestr(radar.timelist(1)); title_end = datestr(radar.timelist(end));
    title([title_start, ' to ', title_end]);
    datetick('x','HH:MM:SS');  axis tight
    
    case 'both'
    f1=figure;
    surf(timedata, heightdata, refdata, 'EdgeColor', 'none'); view(2); % sets view to xy plane
    % colorbar
    map1=colormap(LCH_Spiral(150,1,180,1)); % color scale for reflectivity
    map1=flipud(map1); % flips color scale
    colormap(map1); cbar1 = colorbar; caxis([-40 0]);
    cbTitle1 = get(cbar1, 'Title'); titleString = 'Reflectivity (dBZ)';
    set(cbTitle1, 'String', titleString); set(cbTitle1,'FontSize',16);
    set(f1, 'Position', [1262 -144 1920 963]); % automatically sets position
    set(gca,'FontSize',16);
    xlabel('HH:MM:SS GMT'); ylabel('Height(m)');
    title_start = datestr(radar.timelist(1)); title_end = datestr(radar.timelist(end));
    title([title_start, ' to ', title_end]);
    datetick('x','HH:MM:SS'); axis tight
    
    f2=figure;
    surf(timedata, heightdata, refdata, 'EdgeColor', 'none'); view(2); % sets view to xy plane
    % colorbar
    map2=colormap(Colormap_DV_BWR(50, 0.3, .9)); % color scale for velocity
    colormap(map2);  cbar2 = colorbar; caxis([-30 30]);
    cbTitle2 = get(cbar2, 'Title'); titleString = 'Velocity (m/s)';
    set(cbTitle2, 'String', titleString);  set(cbTitle2,'FontSize',16);
    set(f2, 'Position', [1262 -144 1920 963]); % automatically sets position
    set(gca,'FontSize',16);
    xlabel('HH:MM:SS GMT'); ylabel('Height(m)');
    title_start = datestr(radar.timelist(1)); title_end = datestr(radar.timelist(end));
    title([title_start, ' to ', title_end]);
    datetick('x','HH:MM:SS');  axis tight
    otherwise
    print('Invalid plot type')
end


