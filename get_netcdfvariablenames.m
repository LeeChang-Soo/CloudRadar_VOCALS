function [ varname ] = get_netcdfvariablenames( file )
% For a given netcdf file, output a cell array containing all variable
% names.

ncid = netcdf.open(file, 'NC_NOWRITE');
[~, numvars, ~, ~] = netcdf.inq(ncid);

varname = cell(numvars, 1);
for i = 1:numvars
    [varname{i,1}, ~, ~, ~] = netcdf.inqVar(ncid, i-1);
    %varname{i,2} = i-1;
end


end

