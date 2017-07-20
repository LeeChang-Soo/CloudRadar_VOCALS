function [cm] = Colormap_DV_BWR(nc,ip,wl)
%Colormap_DV_BWR This function generates a blue-to-white-to-red colormap
%that is suitable for doppler velocity plots or any situation where a
%diverging colormap is required. The colors transition from a 50% saturated
%color at the extremes to a 100% saturated color at the specified color
%inflection point. White will always be in the middle. The white level is
%customizable in the event that you want a shade of gray in the middle
%
%INPUTS (all optional)
%  nc = number of color levels; default = 64
%  ip = color inflection point; default = 1/3 **; valid range: 0 - 0.5
%  wl = white level for middle color; default = 1; 1 = white, 0.7 = 70%
%  gray; 0 = black; valid range: 0 - 1
%
%  ** the color inflection point marks the point along the colormap where
%  the 100% saturated color lies. For example, ip = 1/3 means that 100%
%  blue if found at color level 33 in a 100 level scale. 100% red would be
%  at 67 in this case.
%
%OUTPUTS
%  cm = a colormap
%
%Written by: Matthew Miller, 2014

%Input validation
if nargin<1
    nc=64;
elseif nc < 5
    error('too few colors specified\n')
end
if nargin<2
    ip=1/3;
end
if nargin<3
    wl=1;
end
if ip>0.5||ip <=0
    error('invalid value for input variable ''ip''\n')
end
if wl>1||wl <0
    error('invalid value for input variable ''wl''\n')
end

cr1_b=linspace(0.5,1,floor(nc*ip));
cr1_r=linspace(0,0,floor(nc*ip));
cr1_g=linspace(0,0,floor(nc*ip));

cr2_b=linspace(1,wl,floor(nc/2) - floor(nc*ip)+1);
cr2_r=linspace(0,wl,floor(nc/2) - floor(nc*ip)+1);
cr2_g=linspace(0,wl,floor(nc/2) - floor(nc*ip)+1);

cr3_b=linspace(wl,0,ceil(nc/2) - floor(nc*ip)+1);
cr3_r=linspace(wl,1,ceil(nc/2) - floor(nc*ip)+1);
cr3_g=linspace(wl,0,ceil(nc/2) - floor(nc*ip)+1);

cr4_b=linspace(0,0,floor(nc*ip));
cr4_r=linspace(1,0.5,floor(nc*ip));
cr4_g=linspace(0,0,floor(nc*ip));

cm = cat(1,[cr1_r cr2_r(2:end) cr3_r(1:end-1) cr4_r],[cr1_g cr2_g(2:end) cr3_g(1:end-1) cr4_g],[cr1_b cr2_b(2:end) cr3_b(1:end-1) cr4_b])';

end

