function [btnNum] = gen_puzzle_static(v)
%GEN_PUZZLE Deterministically generate a 4x4 puzzle
switch v
    case 0
        gsize = 4;
        btnNum = 1:gsize*gsize-1;
        btnNum(end+1) = 0;
        btnNum = reshape(btnNum, gsize, gsize)';
        disp('Test matrix')
    case 1
        btnNum = [1 2 4 7; 5 10 6 3; 9 14 11 8; 13 0 15 12];
        disp('Upper bound: 10 moves')
    case 2
        btnNum = [2 3 7 4; 0 5 11 8; 1 6 14 12; 9 13 10 15];
        disp('Upper bound: 15 moves')
    case 3
        btnNum = [9 1 4 8; 13 6 3 0; 5 2 7 12; 14 10 11 15];
        disp('Upper bound: 20 moves')
    case 4
        btnNum = [10 5 1 4; 9 6 2 3; 13 11 7 8; 0 14 15 12];
        disp('Upper bound: 25 moves')
    case 5
        btnNum = [5 10 0 7; 14 6 11 3; 2 1 15 4; 9 13 12 8];
        disp('Upper bound: 30 moves')
    case 6
        btnNum = [10 5 2 1; 6 11 0 3; 9 14 7 4; 13 12 15 8];
        disp('Upper bound: 35 moves')
end
disp(btnNum);
end

