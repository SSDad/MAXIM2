function Callback_Pushbutton_PatientPanel_Patient(src, evnt)

global hFig hFig2

data = guidata(hFig);

%% load image info
td = tempdir;
fd_info = fullfile(td, 'MAXIM2');
fn_info = fullfile(fd_info, 'info.mat');
if ~exist(fd_info, 'dir')
    PatientPath = uigetdir();
    if PatientPath ~=0
        mkdir(fd_info);
        DataPath = fileparts(PatientPath);
        save(fn_info, 'DataPath');
    end
else
    if ~exist(fn_info, 'file')
        PatientPath = uigetdir();
        if PatientPath ~=0
            DataPath = fileparts(PatientPath);
            save(fn_info, 'DataPath');
        end
    else
        load(fn_info);
        PatientPath = uigetdir(DataPath);
    end
end

if PatientPath ~=0
    [junk1, PatientID] = fileparts(PatientPath);
    
    % Processed Image Data Path
    junk2 = fileparts(junk1);
    ImageDataPath = fullfile(junk2, 'ImageData', PatientID);
    if ~exist(ImageDataPath, 'dir')
        mkdir(ImageDataPath);
    end    
    data.ImgInfo.PatientID = PatientID;
    data.ImgInfo.ImageDataPath = ImageDataPath;
    
    fd_allDates = fun_getAllSubFolders(PatientPath);
    modality = fun_getDateModality(fd_allDates);
    data.ImgInfo.fd_allDates = fd_allDates;

    % fill table
    nDate = length(fd_allDates);
    tableData = cell(nDate, 3);
    for iDate = 1:nDate
        tableData{iDate, 1} = false;
        tableData{iDate, 2} = fd_allDates(iDate).name;
        tableData{iDate, 3} = modality{iDate};
    end
    
    data.Panel.Patient.Comp.Table.Date.Data = tableData;
        
    guidata(hFig, data);
    
end
    
    
    %     hWB = waitbar(0, 'Loading Images...');
% 
%     ffn = fullfile(PatientPath, matFile);
%     load(ffn)
% 
%     %%%%%%%%%%%%%%%%%%%%%%%
%     % tumor
%     data.Tumor.gatedContour = gatedContour;
%     data.Tumor.trackContour = trackContour;
%     data.Tumor.refContour = refContour;
%     data.Panel.Tumor.Comp.Pushbutton.Init.Enable = 'on';
%     %%%%%%%%%%%%%%%%%%%%%%%
% 
%     data.FileInfo.DataPath = PatientPath;
%     data.FileInfo.MatFile = matFile;
% 
%     %% load image info
%     Image.Images = imgWrite;
%     nImages = length(imgWrite);
%     [mImgSize, nImgSize, ~] = size(imgWrite{1});
%     Image.mImgSize = mImgSize;
%     Image.nImgSize = nImgSize;
%     Image.nImages = nImages;
% 
%     Image.indSS = 1:nImages;
%     Image.SliderValue = 1;
%     Image.FreeHandSlice = [];
% 
%     Image.GatedContour = gatedContour;
%     Image.TrackContour = trackContour;
%     Image.RefContour = refContour;
%     % image info
%     Image.x0 = 0;
%     Image.y0 = 0;
% 
%     Image.FoV = str2num(data.Panel.LoadImage.Comp.hEdit.ImageInfo(1).String);
%     Image.dx = Image.FoV/nImgSize;
%     Image.dy = Image.dx;
% 
%     data.Image = Image;
% 
%     data.Panel.LoadImage.Comp.hEdit.ImageInfo(2).String = num2str(nImgSize);
%     data.Panel.LoadImage.Comp.hEdit.ImageInfo(2).ForegroundColor = 'c';
% 
%     data.Panel.LoadImage.Comp.hEdit.ImageInfo(3).String = num2str(Image.dx);
%     data.Panel.LoadImage.Comp.hEdit.ImageInfo(3).ForegroundColor = 'c';
% 
%     % check previously saved snakes
%     [~, fn1, ~] = fileparts(matFile);
%     ffn_snakes = fullfile(PatientPath, [fn1, '_Snake.mat']);
%     data.FileInfo.ffn_snakes = ffn_snakes;
%     if exist(ffn_snakes, 'file')
%         data.Panel.LoadImage.Comp.Pushbutton.LoadSnake.Enable = 'on';
%     end
%     
%     % ffn_points
%     ffn_points = fullfile(PatientPath, [fn1, '_Point.mat']);
%     data.FileInfo.ffn_points = ffn_points;
% 
%     % ffn_measureData
%     ffn_measureData = fullfile(PatientPath, [fn1, '_measureData.mat']);
%     data.FileInfo.ffn_measureData = ffn_measureData;
%     ffn_measureDataFig = fullfile(PatientPath, [fn1, '_measureDataFig']);
%     data.FileInfo.ffn_measureDataFig = ffn_measureDataFig;
%     data.FileInfo.ffn_PointData = fullfile(PatientPath, [fn1, '_PointData.csv']);
%     
%     data.Snake.Snakes = cell(nImages, 1);
%     
%     % enable buttons
%     data.Panel.Snake.Comp.Pushbutton.FreeHand.Enable = 'on';
%     data.Panel.Snake.Comp.Pushbutton.StartSlice.Enable = 'on';
%     data.Panel.Snake.Comp.Pushbutton.EndSlice.Enable = 'on';
%     data.Panel.Snake.Comp.Edit.StartSlice.String = '1';
%     data.Panel.Snake.Comp.Edit.EndSlice.String = num2str(nImages);
%     data.Panel.Snake.Comp.Edit.StartSlice.ForegroundColor = 'r';
%     data.Panel.Snake.Comp.Edit.EndSlice.ForegroundColor = 'r';
% 
%     waitbar(1/3, hWB, 'Initializing View...');
% 
%     % CT images
%     sV = 1;
%     nImages = data.Image.nImages;
% 
%     I = rot90(Image.Images{sV}, 3);
%     [M, N, ~] = size(I);
% 
%     x0 = Image.x0;
%     y0 = Image.y0;
%     dx = Image.dx;
%     dy = Image.dy;
%     xWL(1) = x0-dx/2;
%     xWL(2) = xWL(1)+dx*N;
%     yWL(1) = y0-dy/2;
%     yWL(2) = yWL(1)+dy*M;
%     RA = imref2d([M N], xWL, yWL);
%     data.Image.RA = RA;
% 
%     hA = data.Panel.View.Comp.hAxis.Image;
%     hPlotObj.Image = imshow(I, RA, 'parent', hA);
%     axis(data.Panel.View.Comp.hAxis.Image, 'tight', 'equal')
% 
%     % snake
%     hPlotObj.Snake = line(hA,...
%         'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 3);
%     hPlotObj.SnakeMask = line(hA,...
%         'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 1);
% 
%     % point on diaphragm
%     hPlotObj.Point = line(hA,...
%         'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
%         'Marker', '.', 'MarkerSize', 24);
% 
%     hPlotObj.LeftPoints = line(hA,...
%             'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
%             'Marker', '.', 'MarkerSize', 16);
% 
%     hPlotObj.RightPoints = line(hA,...
%             'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
%             'Marker', '.', 'MarkerSize', 16);
% 
%     data.Panel.View.Comp.hPlotObj = hPlotObj;
% 
%     % slider
%     hSS = data.Panel.SliceSlider.Comp.hSlider.Slice;
%     hSS.Min = 1;
%     hSS.Max = nImages;
%     hSS.Value = sV;
%     hSS.SliderStep = [1 10]/(nImages-1);
% 
%     data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(sV), ' / ', num2str(nImages)];
% 
%     waitbar(1, hWB, 'All slices are loaded!');
%     pause(2);
%     close(hWB);
% 
%     % contrast
%     yc = histcounts(I, max(I(:))+1);
%     yc = log10(yc);
%     yc = yc/max(yc);
%     xc = 1:length(yc);
%     xc = xc/max(xc);
% 
%     data.Panel.ContrastBar.Comp.hPlotObj.Hist.XData = xc;
%     data.Panel.ContrastBar.Comp.hPlotObj.Hist.YData = yc;
% 
%     data.Snake.SlitherDone = false;
%     data.Point.InitDone = false;
%     data.Tumor.InitDone = false;
% 
%     guidata(hFig, data);
%     
%     % tumor profile
%     Callback_Pushbutton_TumorPanel_Init;
%     
% end