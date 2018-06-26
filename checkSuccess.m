%% Check if the current configuration is the final configuration
function [r] = checkSuccess(btnNum, silent)
t = btnNum';
t = t(1:end-1);
pzSize = size(btnNum, 1) * size(btnNum, 2);
if isequal(t, 1:(pzSize-1))
    if ~exist('silent', 'var')
        msgbox('Well done! You did it!');
    end
    r = true;
else 
    r=  false;
end
end