function [MM, Info] = fun_readDICOMCT(folder, fn)

hWB = waitbar(0, 'Reading images...');

for iFile = 1:numel(fn)
    I = dicomread(fullfile(folder, fn{iFile}));
    M(:,:,iFile) = I;
    dcmInfo = dicominfo(fullfile(folder, fn{iFile}));
    IPP(:, iFile) = dcmInfo.ImagePositionPatient;
    SOPI_UID{iFile} = dcmInfo.SOPInstanceUID;

    waitbar(iFile/numel(fn), hWB, 'Reading images...');
end
waitbar(1, hWB, 'Bingo!');

    ImagePositionPatient = dcmInfo.ImagePositionPatient;    
    
    ctDate = dcmInfo.SeriesDate;
    ctTime = dcmInfo.SeriesTime;
    ctDate = [ctDate, '_', ctTime(1:2)];
    Info.ctDate = ctDate;
    
    nRows = double(dcmInfo.Rows);
    nColumns = double(dcmInfo.Columns);
    dx = dcmInfo.PixelSpacing(1);
    dy = dcmInfo.PixelSpacing(2);
    x0 = ImagePositionPatient(1);
    y0 = ImagePositionPatient(2);
    Info.xx = x0:dx:x0+dx*(nRows-1);
    Info.yy = y0:dy:y0+dy*(nColumns-1);
    
    z = IPP(3, :);
    [zz idx] = sort(z, 'descend');
    z0 = zz(1);
    dz = zz(2)-zz(1);
    MM = M(:, :, idx);
    SOPI_UID = SOPI_UID(idx);
    
    Info.dimensions = [nRows nColumns length(zz)];
    Info.zz = zz;
    Info.dd = [dx dy dz];
    Info.xyz0 = [x0 y0 z0];
        
    close(hWB);
