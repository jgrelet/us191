%% us191.stack class
%
% Matlab stack implementation, 
% stack is an abstract data type and data structure based on the principle 
% of Last In First Out (LIFO).
% This class give fonctionnality for adding or removing nodes from a stack, 
% as well as the length and top functions.
% 
% $Id: stack.m 600 2011-09-14 14:36:29Z jgrelet $

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
classdef stack < handle
  
  % Properties definition
  % ---------------------
  properties (SetAccess = private, GetAccess = private)
    stack_pointer = {};
  end
  
  % Class public methods
  % --------------------
  methods
    
    % push
    % -----------
    function self = push(self, element)
      self.stack_pointer = us191.node(element, self.stack_pointer);
    end
    
    % pop, increase the stack pointer and return 'top' node data
    % ----------------------------------------------------------
    function element = pop(self)
      if isempty(self.stack_pointer)
        element = {};
      else
        element = self.stack_pointer.data;
        self.stack_pointer = self.stack_pointer.next;
      end
    end
    
    % top, return 'top' node
    % -----------------------
    function element = top(self)
      if isempty(self.stack_pointer)
        element = {};
      else
        element = self.stack_pointer.data;
      end
    end
    
    % length, return the amount of nodes in the stack
    % -----------------------------------------------
    function length = length(self)
      length = 0;
      node = self.stack_pointer;
      while ~isempty(node)
        length = length + 1;
        node = node.next;
      end
    end
    
  end
  
end
