function [nd, ndi] = next_distance(cs, fs)
%NEXT_IJ Compute the next coordinates, given a movement list
% Paramters:
%   cs: The current state
%   fs: The final configuration

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