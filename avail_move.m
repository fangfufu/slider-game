function [v] = avail_move(m)
%AVAIL_MOVE Return Return the available moves for a configuration
%   Parameters
%       m : input configuration
%   Returns
%       v : the vector containing the available moves
%           format: [up down left right]
s = size(m, 1);
[i, j] = find(m == 0);
v = [(i ~= 1), (i ~= s), (j ~= 1), (j ~= s)];
end

