function save(self, varargin)
% us191.dynaload.save
% it's a wrapper on us191.dynaload.write method
%
% $Id: save.m 600 2011-09-14 14:36:29Z jgrelet $

% uses the comma-separated list syntax varargin{:} to pass the optional
% parameters to write
% ---------------------------------------------------------------------
write(self, varargin{:});



