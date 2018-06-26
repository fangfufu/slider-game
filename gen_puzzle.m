function [out, solution, state_history] = gen_puzzle(gsize,m, silent)
%GEN_PUZZLE Generate a puzzle
%   Parameters:
%       gsize: size of the puzzle
%       m: the number of moves to make, or the the move to make
%       silent: suppress the solution output

out = reshape([1:(gsize^2-1), 0], gsize, gsize)';

if isscalar(m)
    move_history = zeros(1, m);
    state_history = out(:)';
    for i = 1:m
        pns = reshape(state_history(end, :), gsize, gsize);
        while ismember(pns(:)', state_history, 'rows')
            % proposed next move
            pnm = next_rand_move(avail_move(out));
            % proposed next state
            pns = move(out, pnm);
        end
        out = pns;
        state_history(end+1,:) = out(:)'; %#ok<AGROW>
        move_history(i) = pnm;
    end
else
    move_history = m;
    for i = 1:numel(m)
        out = move(out, m(i));
    end
end
solution = move_to_solution(move_history);
if ~exist('silent', 'var')
    disp(['Upper bound: ', num2str(numel(move_history)) ' moves']);
    disp(out);
    disp(['Solution: ', solution]);
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