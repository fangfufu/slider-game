function [m, s] = gen_puzzle(s,mv, silent)
%GEN_PUZZLE Generate a puzzle
%   Parameters:
%       s: size of the puzzle
%       nm: the number of moves to make
m = reshape([1:(s^2-1), 0], s, s)';

if isscalar(mv)
    l = zeros(1, mv);
    for i = 1:mv
        t = next_rand_move(avail_move(m));
        l(i) = t;
        m = move(m, t);
    end
else
    l = mv;
    for i = 1:numel(mv)
        m = move(m, mv(i));
    end
end
s = move_to_solution(l);
if ~exist('silent', 'var')
    disp(['Upper bound: ', num2str(numel(l)) ' moves']);
    disp(m);
    disp(['Solution: ', s]);
    disp(l);
end
end

function [m] = next_rand_move(v)
%NEXT_MOVE Generate the next random move
n = randi(sum(v));
i = find(v);
m = i(n);
end

function [s] = move_to_solution(mv)
s = num2str(fliplr(mv));
s(s == '1') = 'D';
s(s == '2') = 'U';
s(s == '3') = 'R';
s(s == '4') = 'L';
end