function [ns, nm] = next_state(cs, fs, pc)
%% NEXT_STATE Generate the next state based on the L1 distance
%   Generate the next state based on the L1 distance of the next moves
%   Parameters:
%       cs: the current configuration 
%       fs: the final configuration
%       pc: which of the next configuration to pick
%   Output: 
%       ns: the next configuration

[nd, ndi] = next_distance(cs, fs);

% Check if the chosen path is valid
if isnan(nd(pc))
    error('next_state_L1:path_unavailable', ...
        'The chosen path is unavailable');
end
nm = ndi(pc);
ns = move(cs, nm);

end

