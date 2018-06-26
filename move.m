function [mat] = move(mat, m)
%MOVE Move the empty square in a puzzle configuration
%   parameter:
%       mat: the current configuration
%       m: the next move
%           up = 1, down = 2, left = 3, right = 4
%
[i, j] = find(mat == 0);
ni = i;
nj = j;
switch m
    case 1
        ni = ni - 1;
    case 2
        ni = ni + 1;
    case 3
        nj = nj - 1;
    case 4
        nj = nj + 1;
    otherwise
        error('MOVE:INVALID_MOVE', ...
            'MOVE: You passed in an invalid move.');
end
mat(i,j) = mat(ni, nj);
mat(ni, nj) = 0;
end
