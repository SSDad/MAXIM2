function [modality] = fun_getDateModality(fd_allDates)

nDate = length(fd_allDates);
hWB = waitbar(0, 'Exploring images...');
for iDate = 1:nDate
    junk = dir(fullfile(fd_allDates(iDate).folder, fd_allDates(iDate).name));
    allFiles  = junk(~[junk.isdir]);
    iFile = 1;%:length(allFiles)
    di = dicominfo(fullfile(allFiles(iFile).folder, allFiles(iFile).name));
    modality{iDate} = di.Modality;
    waitbar(iDate/nDate, hWB, 'Exploring image folders...');
end
waitbar(1, hWB, 'Bingo!');
pause(1);
close(hWB);