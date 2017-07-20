%% Documentation
% Script:  cloudplot_script_vocals.m
% Author:  Laura Tomkins
% Version Date:  20 July 2017
% Purpose:  Plots cloud radar reflectivity and velocity data from c130
% aircraft from VOCALS project. Files are in various formats (PP4, PP6,
% SV2, SH1, FH1). This script/function currently only works with SV2 and
% SH1 file types. Script sets up filepath and plot types and gen_cloudplot plots
% the data and outputs figures which are then saved in the script. See gen_cloudplot for more
% information
%
% My understanding of file types: SH1 - upward looking radar, SV2 -
% downward looking radar, PP4 - up and down looking radar (?)
% 
% Input Arguments: starttime, endtime, plot_type 
%
% Output Arguments: ***************
% Functions Used: gen_cloudplot_vocals.m
%
% Required Paths: N/A
%
%


%   Written By: Laura Tomkins, July 2017

%% Working 

clear, clc

addpath(genpath('/home/disk/zathras/ltomkins/matlab/c130'));

% file info

% filename = 'WCR.VOCALS08.20081109.175127_180239.SV2.nc';    % CHANGE
% filename = 'WCR.VOCALS08.20081115.180533_184951.PP4.nc';    % CHANGE
filename = 'WCR.VOCALS08.20081115.162633_171712.SH1.nc';      % CHANGE  

plot_type = 'both';                                           % CHANGE (can be 'ref', 'vel', or 'both')

inpath = '/home/disk/molari1/vocals_C130_cloudradar/WCR/';

gen_cloudplot_vocals([inpath,filename], plot_type);

keyboard % put this in to check images before saving

f1=figure(1); f2=figure(2);        
saveas(f1, [savedir, starttime, '_ref.png'])
saveas(f2, [savedir, starttime, '_vel.png'])
close all
    
