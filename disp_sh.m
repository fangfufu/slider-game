function [] = disp_sh(sh)
l = size(sh, 1);
for i = 1:l
    disp([num2str(i), ' :']);
    disp(reshape(sh(i,:), sqrt(size(sh,2)), sqrt(size(sh,2))));
end
end

