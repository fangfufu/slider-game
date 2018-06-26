function [ns, nm] = next_state(cs, fs, pc)
%% NEXT_STATE Generate the next state based on the L1 distance
%   Generate the next state based on the L1 distance of the next moves
%   Parameters:
%       cs: the current configuration 
%       fs: the final configuration
%       pc: which of the next configuration to pick
%   Output: 
%       ns: the next configuration
%       nm: the next move

am = avail_move(cs);
nd = zeros(size(am));
[zi, zj] = find(cs == 0);

for i = 1:numel(am)
    ni = zi;
    nj = zj;
    if am(i)
        switch i
            case 1
                ni = ni - 1;
            case 2
                ni = ni + 1;
            case 3
                nj = nj - 1;
            case 4
                nj = nj + 1;
        end
        [fi, fj] = find(fs == cs(ni, nj));
        nd(i) = abs(fi-zi) + abs(fj-zj);
    else
        nd(i) = nan;
    end
end

[nd, ndi] = sort(nd);

% Check if the chosen path is valid
if isnan(nd(pc))
    error('next_state_L1:path_unavailable', ...
        'The chosen path is unavailable');
end
nm = ndi(pc);
ns = move(cs, nm);

end
