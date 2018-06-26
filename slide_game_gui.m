function slide_game_gui(v)
%% SLIDE_GAME Sliding Puzzle Game
% Well, this is the digital version of my birthday present from Han Gong

%% Constants
% Window size
wsize = 500;
% border size
bdsize = 50;
% spacing (gap) between buttons
ssize = 5;
% Grid size
gsize = 4;

% the spacing between button anchors
baspacing = (wsize-2*bdsize)/gsize;
btnsize = baspacing-ssize;

%% Variables
% Global cell array to store the button UI elements
global btn;
btn = cell(gsize);

% Global double array to store the number on each button
global btnNum

if ~exist('v','var')
    v = 50;
    btnNum = gen_puzzle(gsize, v);
elseif ~isscalar(v) && ~diff(size(v))
    btnNum = v;
else
    btnNum = gen_puzzle(gsize, v);
end


% Global logical array to record the clicks
global clickArr;
clickArr = (btnNum == 0);

global totalSwaps;
totalSwaps = 0;

%% Create the figure window
ssize = get( groot, 'Screensize' );
swidth = ssize(3);
sheight = ssize(4);
% Create and then hide the GUI as it is being constructed
f = figure('Position', ...
    [swidth/2-wsize/2, sheight/2-wsize/2, wsize, wsize], ...
    'Visible', 'on');


%% Programmatically create all the buttons
k = 1;
i2 = 1;
for i1 = wsize-bdsize-baspacing:-baspacing:bdsize
    j2 = 1;
    for j1 = bdsize:baspacing:wsize-bdsize-baspacing
        btn{i2, j2} = uicontrol('Style','pushbutton',...
          'String',[num2str(i2), ', ', num2str(j2)],...
          'Position',[j1,i1,btnsize,btnsize],...
          'Callback',@(source,eventdata)clickRecorder(i2,j2));
      k = k + 1;
      j2 = j2 + 1;
    end
    i2 = i2 + 1;
end
updateButtons;
end

%% Call back function after clicking the button - for recording clicks
function clickRecorder(i,j)
% Declare some global variables
global clickArr;
global btnNum;

clickArr(i,j) = not(clickArr(i,j));
% disp('clickArr:');
% disp(clickArr);
% disp(' ');
% disp('btnNum:');
% disp(btnNum);

if sum(clickArr(:)) == 2
    updateButtons;
    clickArr = (btnNum == 0);
end
end

%% Function to update all the buttons
function updateButtons()
global btn;
global btnNum;
global clickArr;

% Swap the number if the validator returns the correct result
if validator(clickArr)
    [x, y] = find(clickArr);
    tmp = btnNum(x(1), y(1));
    btnNum(x(1), y(1)) =  btnNum(x(2), y(2));
    btnNum(x(2), y(2)) = tmp;
end

for i = 1:size(btn, 1)
    for j = 1:size(btn, 2)
        if btnNum(i,j) ~= 0
            btn{i,j}.String = num2str(btnNum(i,j));
        else
            btn{i,j}.String = ' ';
        end
    end
end

checkSuccess(btnNum);

end

%% Validate if the clickArr is valid
function [r] = validator(a)
global totalSwaps;
[x, y] = find(a);
v = [x y];
if size(v, 1) == 2
    v = v(2,:) - v(1,:);
    if sum(v(:)) == 1
        r = true;
        disp('Total moves:');
        totalSwaps = totalSwaps + 1;
        disp(totalSwaps);
    else
        r = false;
    end
else
    r = false;
end

end


