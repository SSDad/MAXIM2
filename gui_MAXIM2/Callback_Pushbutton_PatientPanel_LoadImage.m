function Callback_Pushbutton_PatientPanel_LoadImage(src, evnt)

global hFig

data = guidata(hFig);
dateTableData = data.Panel.Patient.Comp.Table.Date.Data;
junk = cell2mat(dateTableData(:, 1));
iDate = find(junk, 1);

fd_Date = data.ImgInfo.fd_allDates(iDate);
ImageFileFolder = fullfile(data.ImgInfo.ImageDataPath, fd_Date.name);
ImageFileName = fullfile(ImageFileFolder, 'image.mat');

if exist(ImageFileName, 'file')
    load(ImageFileName)
else
    fd = fullfile(fd_Date.folder, fd_Date.name);
    junk = dir(fd);
    allFiles  = junk(~[junk.isdir]);
    names = {allFiles.name}';
    image = LoadDICOMImages(fd, names);
    
    if ~exist(ImageFileFolder, 'dir')
        mkdir(ImageFileFolder);
    end
    save(ImageFileName, 'image');
end
    
data.image = image;
guidata(hFig, data);


% CT images
M = image.dimensions(1);
N = image.dimensions(2);
P = image.dimensions(3);
iP = round(P/2);
I = image.data(:,:,iP);
data.image.AxialView.iP = iP;

x0 = image.start(1);
y0 = image.start(2);
z0 = image.start(3);

dx = image.width(1);
dy = image.width(2);
dz = image.width(3);

xWL(1) = x0-dx/2;
xWL(2) = xWL(1)+dx*N;
yWL(1) = y0-dy/2;
yWL(2) = yWL(1)+dy*M;
zWL(1) = z0-dz/2;
zWL(2) = zWL(1)+dz*P;

RA = imref2d([M N], xWL, yWL);
data.image.AxialView.RA = RA;

hA = data.Panel.AxialView.Comp.hAxis.Image;
cla(hA);
hPlotObj.Image = imshow(I, RA, 'DisplayRange',[], 'parent', hA);
axis(hA, 'tight', 'equal')

% 
% %% load image data
% td = tempdir;
% fd_info = fullfile(td, 'MAXIM');
% fn_info = fullfile(fd_info, 'info.mat');
% if ~exist(fd_info, 'dir')
%     [matFile, dataPath] = uigetfile('*.mat');
%     mkdir(fd_info);
%     save(fn_info, 'dataPath');
% else
%     if ~exist(fn_info, 'file')
%         [matFile, dataPath] = uigetfile('*.mat');
%         save(fn_info, 'dataPath');
%     else
%         load(fn_info);
%         [matFile, ~] = uigetfile([dataPath, '*.mat']);
%     end
% end
% 
% if matFile ~=0
%     hWB = waitbar(0, 'Loading Images...');
% 
%     ffn = fullfile(dataPath, matFile);
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
%     data.FileInfo.DataPath = dataPath;
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
%     ffn_snakes = fullfile(dataPath, [fn1, '_Snake.mat']);
%     data.FileInfo.ffn_snakes = ffn_snakes;
%     if exist(ffn_snakes, 'file')
%         data.Panel.LoadImage.Comp.Pushbutton.LoadSnake.Enable = 'on';
%     end
%     
%     % ffn_points
%     ffn_points = fullfile(dataPath, [fn1, '_Point.mat']);
%     data.FileInfo.ffn_points = ffn_points;
% 
%     % ffn_measureData
%     ffn_measureData = fullfile(dataPath, [fn1, '_measureData.mat']);
%     data.FileInfo.ffn_measureData = ffn_measureData;
%     ffn_measureDataFig = fullfile(dataPath, [fn1, '_measureDataFig']);
%     data.FileInfo.ffn_measureDataFig = ffn_measureDataFig;
%     data.FileInfo.ffn_PointData = fullfile(dataPath, [fn1, '_PointData.csv']);
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