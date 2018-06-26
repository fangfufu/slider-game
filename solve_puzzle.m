function [move_history, state_history] = solve_puzzle(i_state, s_depth)
%% SOLVE_PUZZLE Solve a slide puzzle
%   Parameter:
%       c_state: The initial state
%   Output:
%       pl: The path list
% Basic idea:
% - Depth first search
% - While not successful, shuffle states.
%
% Two approaches
% - Move the most / least out of place piece first, based on L1 distance
%       - next_state_L1
% - Program the thing to solve the first piece first, then the second piece
%   and so on. 
%       - next_state_seq
%
if diff(size(i_state))
    error('solve_puzzle:invalid_input', ...
        'solve_puzzle: The input must be a square matrix');
end
disp('starting state:');
c_state = i_state;
disp(i_state);

% Generate a final state
g_size = size(c_state,1);
f_state = gen_puzzle(g_size, 0, 'silent');

move_history = [];
state_history = i_state(:)'; 
edge_history = 1;
if ~exist('s_depth', 'var')
    d_limit = 1;
else
    d_limit = s_depth;
end

iteration_counter = 0;
tic;
while ~isequal(c_state, f_state)
    % If we have exhausted the current node,
    %  rewind the stack by 1, and run this test again
    if edge_history(end) > 4 || numel(edge_history) > d_limit
        % rewind the state history by 1
        state_history(end,:) = [];
        if ~isempty(state_history)
            %if state history is not empty
            c_state = state_history(end,:);
            c_state = reshape(c_state, g_size, g_size);
            % rewind move history by 1
            move_history(end) = [];
            % Try the next path choice.
            edge_history(end) = [];
            edge_history(end) = edge_history(end) + 1;
            continue;
        else
            % increase the depth limit, restart the search
            d_limit = d_limit + 1;
            disp(['increase search depth to: ', num2str(d_limit)]);
            move_history = [];
            state_history = i_state(:)';
            edge_history = 1;
        end
    end
    
    try
        % Try and obtain a next state and next movement history
        %   (proposed state, proposed movement)
        [p_state, pm] = next_state(c_state, f_state, edge_history(end));
        if ismember(p_state(:)', state_history, 'rows')
            % The new proposed state has been visited before
            % propose new edge
            edge_history(end) = edge_history(end) + 1;
        else
            % The proposed state is new, record it
            c_state = p_state;
            state_history(end+1, :) = c_state(:)'; %#ok<AGROW>
            edge_history(end+1) = 1; %#ok<AGROW>
            move_history(end+1) = pm; %#ok<AGROW>
        end
    catch me
        if strcmp(me.identifier, 'next_state_L1:path_unavailable')
            % next_state function fail to produce the next state,
            %   set the choice_history to 5, force stack rewinding
            edge_history(end) = 5;
        else
            rethrow(me);
        end
    end
    iteration_counter = iteration_counter + 1;
end
disp(['iteration: ', num2str(iteration_counter)]);
toc;
move_history = move_to_solution(move_history);
disp(move_history);
state_history = state_history(2:end,:);

end

function [s] = move_to_solution(mv)
s = num2str(mv);
s(s == '1') = 'U';
s(s == '2') = 'D';
s(s == '3') = 'L';
s(s == '4') = 'R';
end

