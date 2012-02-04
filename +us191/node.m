%% us191.node
%
% This class is used with us191.stack class to implemete LIFO stack
%
% $Id: node.m 600 2011-09-14 14:36:29Z jgrelet $

%% COPYRIGHT & LICENSE
%  Copyright 2009 - IRD US191, all rights reserved.
%
%  This file is part of us191 Matlab package.
%
%    us191 package is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    us191 package is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with Datagui; if not, write to the Free Software
%    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
%    USA

%% Classdef definition
% -------------------
classdef node
  
  % Properties definition
  % ---------------------
  properties (SetAccess = private, GetAccess = public)
    data = {};
    next = {};
  end
  
  % Class public methods
  % --------------------
  methods
    
    % Constructor
    % -----------
    function self = node(data, next)
      self.data = data;
      self.next = next;
    end
    
    % get access methods for properties 
    % ---------------------------------
    function next = get.next(self)
      next = self.next;
    end
    
    function data = get.data(self)
      data = self.data;
    end
    
  end
  
end