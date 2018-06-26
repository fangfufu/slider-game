function slide_game_gui(puzzle)
%% SLIDE_GAME Sliding Puzzle Game
% Well, this is the digital and improved version of my birthday present 
% from Han Gong

%% Constants
% Window size
wsize = 600;

% Control panel width
pwidth = 200;

% spacing (gap) between buttons
spsize = 5;

%% Input check
global btnNum;
if ~exist('puzzle', 'var')
    prompt = {'Enter the grid size:'};
    title = 'Puzzle set up';
    dims = [1 35];
    definput = {'4'};
    answer = inputdlg(prompt,title,dims,definput);
    gsize = str2double(answer{1});
    newPuzzleFunc(gsize);
    puzzle = btnNum;
elseif isscalar(puzzle) 
    newPuzzleFunc(puzzle);
    puzzle = btnNum;
elseif ~ismatrix(puzzle) || diff(size(puzzle))
    error('Please supply a grid size or a valid puzzle');
end

%% Variables
% Global double array to store the number on each button
btnNum = puzzle;

% grid size
gsize = size(btnNum, 1);
% border size
bdsize = 4 * spsize;
% button size
btnsize = (wsize-2*bdsize)/(gsize)-spsize;
% the button anchors spacing
baspacing = (wsize-2*bdsize)/gsize;

% Global cell array to store the button UI elements
global btn;
btn = cell(gsize);

%% Create the figure window
scsize = get( groot, 'Screensize' );
swidth = scsize(3);
sheight = scsize(4);
% Create and then hide the GUI as it is being constructed
f = figure('Position', ...
    [swidth/2-wsize/2, sheight/2-wsize/2, wsize, wsize], ...
    'Visible', 'on');
f.CloseRequestFcn = @localCloseReq;

%% Programmatically create all the buttons
k = 1;
i2 = 1;
for i1 = wsize-bdsize-baspacing:-baspacing:bdsize
    j2 = 1;
    for j1 = bdsize:baspacing:wsize-bdsize-baspacing
        btn{i2, j2} = uicontrol('Style','pushbutton',...
          'String',[num2str(i2), ', ', num2str(j2)],...
          'Position',[j1,i1,btnsize,btnsize],...
          'Callback',@(source,eventdata)clickRecorder(i2,j2),...
          'FontSize', btnsize/4);
      k = k + 1;
      j2 = j2 + 1;
    end
    i2 = i2 + 1;
end
buttonUpdater;

%% Add the control panel
% Expand the figure window
f.Position = [swidth/2-wsize/2, sheight/2-wsize/2, wsize + pwidth, wsize];

% panel element vertical spacing
pe_vspacing = (wsize - 2 * bdsize) / 6;
% panel element width
pe_width = pwidth - 2 * bdsize;
% panel element height
pe_height = pe_vspacing - spsize;

% We definitely don't change the x_anchor
x_anchor = wsize + 2 * spsize;
% We increment y_anchor as we add in more elements
y_anchor = wsize - bdsize;

% Timer labels;
y_anchor = y_anchor - pe_vspacing / 2;
uicontrol('Style', 'text', ...
    'Position',[x_anchor,y_anchor,pe_width,pe_height / 2], ...
    'String', 'Time:', ...
    'FontSize', pe_height / 5);

y_anchor = y_anchor - pe_vspacing / 2;
global timeLabel;
timeLabel = uicontrol('Style', 'text', ...
    'Position',[x_anchor,y_anchor,pe_width,pe_height / 2], ...
    'String', '', ...
    'FontSize', pe_height / 5);
global tmr;
tmr = timer();
tmr.ExecutionMode = 'fixedDelay';
tmr.Period = 1;
tmr.TimerFcn = @(x,y) timeUpdater(x,y,1);
start(tmr);

% Swap labels: 
y_anchor = y_anchor - pe_vspacing / 2;
uicontrol('Style', 'text', ...
    'Position',[x_anchor,y_anchor,pe_width,pe_height / 2], ...
    'String', 'Moves:', ...
    'FontSize', pe_height / 5);

y_anchor = y_anchor - pe_vspacing / 2;
global moveLabel;
moveLabel = uicontrol('Style', 'text', ...
    'Position',[x_anchor,y_anchor,pe_width,pe_height / 2], ...
    'String', '', ...
    'FontSize', pe_height / 5);
moveUpdater(0);

% Pause button
y_anchor = y_anchor - pe_vspacing;
global pauseButton;
pauseButton = uicontrol('Style','pushbutton',...
    'Position',[x_anchor,y_anchor,pe_width,pe_height],...
    'FontSize', pe_height / 5,...
    'String', 'Start',...
    'Callback',@(source,eventdata)pauseFunc);

% Reset button
y_anchor = y_anchor - pe_vspacing;
global resetButton;
resetButton = uicontrol('Style','pushbutton',...
    'Position',[x_anchor,y_anchor,pe_width,pe_height],...
    'FontSize', pe_height / 5,...
    'String', 'Reset', ...
    'Callback', @(source,eventdata)resetFunc);
resetFunc('s');

y_anchor = y_anchor - pe_vspacing;
uicontrol('Style','pushbutton',...
    'Position',[x_anchor,y_anchor,pe_width,pe_height],...
    'FontSize', pe_height / 5,...
    'String', 'Solve', ...
    'Callback', @(source, eventdata)solveFunc);

y_anchor = y_anchor - pe_vspacing;
uicontrol('Style','pushbutton',...
    'Position',[x_anchor,y_anchor,pe_width,pe_height],...
    'FontSize', pe_height / 5,...
    'String', 'New', ...
    'Callback', @(source, eventdata)newPuzzleFunc);
end

function newPuzzleFunc(gsize)
%% Function for creating a new puzzle
global btnNum;
global resetButton;
if isempty(gsize)
    gsize = size(btnNum, 1);
end
prompt = {'Enter the number of random moves:'};
title = 'Puzzle set up';
dims = [1 35];
definput = {'15'};
answer = inputdlg(prompt,title,dims,definput);
btnNum = gen_puzzle(gsize, str2double(answer{1}));
if ~isempty(resetButton)
    resetFunc('s');
end
end

function solveFunc()
%% Solve function
global btnNum;
disp('Solving the puzzle, please wait');
str = solve_puzzle(btnNum);
msgbox(str, 'Solution');
end

function pauseFunc(p)
%% Pause function
global tmr;
global pauseButton;
global paused;
if isempty(paused)
    paused = false;
end
paused = ~paused;
if exist('p', 'var')
    paused = p;
end
if paused
    stop(tmr);
    pauseButton.String = 'Continue';
else
    start(tmr);
    pauseButton.String = 'Pause';
end
end

function resetFunc(s)
%% Reset function
global btnNum;
global pauseButton;
persistent obtnNum;
% Global logical array to record the clicks
global clickArr;

if exist('s', 'var')
    obtnNum = btnNum;
    clickArr = (btnNum == 0);
else
    btnNum = obtnNum;
    clickArr = (btnNum == 0);
end

timeUpdater([],[],0);
moveUpdater(0);
pauseFunc(true);
pauseButton.String = 'Start';
buttonUpdater;
end

function localCloseReq(~,~)
%% Close request function 
% Basically the destructor
global tmr;
stop(tmr);
delete(tmr);
delete(gcf);
clear all;
end


%% Function which records the number of moves
function moveUpdater(c)
global moveLabel;
persistent n;
if ~c
    n = 0;
else
    n = n + 1;
end
moveLabel.String = num2str(n);
end


%% Timer related stuff
function timeUpdater(~, ~, c)
global timeLabel;
persistent n
if isempty(n)
    n = 0;
end
if ~c
    n = 0;
end
timeLabel.String = datestr(seconds(n), 'HH:MM:SS');
n = n+1;
end


%% Call back function after clicking the button - for recording clicks
function clickRecorder(i,j)
% Declare some global variables
global clickArr;
global btnNum;
global paused;
if isempty(paused)
    paused = 0;
    pauseFunc(false);
end

if paused
    pauseFunc(false);
end

clickArr(i,j) = not(clickArr(i,j));
if sum(clickArr(:)) == 2
    buttonUpdater;
    clickArr = (btnNum == 0);
end

end

%% Function to update all the buttons
function buttonUpdater()
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
[x, y] = find(a);
v = [x y];
if size(v, 1) == 2
    v = v(2,:) - v(1,:);
    if sum(v(:)) == 1
        r = true;
        moveUpdater(1);
    else
        r = false;
    end
else
    r = false;
end

end


%% Check if the current configuration is the final configuration
function checkSuccess(btnNum)
t = btnNum';
t = t(1:end-1);
pzSize = size(btnNum, 1) * size(btnNum, 2);
if isequal(t, 1:(pzSize-1))
    pauseFunc(true);
    msgbox('Well done! You did it!');
end
end