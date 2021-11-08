% msalman@gsu.edu
% 11/13/2020

% get output of ls -d /data/analysis/collaboration/NeuroMark/Data/OSUCH/PrepData_backup/*/*/*

fd = fopen('images.txt');
images = textscan(fd, '%s\n');
images = images{1};

for j = 1:size(images, 1)
    t1 = '3dAutomask ';
    t2 = ['-prefix mask' num2str(j) '.nii '];
    t3 = images{j};
    disp( [t1 t2 t3] )
    system( [t1 t2 t3] )
    % break
end

system( ['3dMean -prefix mean1.nii mask*.nii'] )

system( ['3dcalc -a mean1.nii -prefix mean2.nii -expr "step(a-0.75)"'] )
