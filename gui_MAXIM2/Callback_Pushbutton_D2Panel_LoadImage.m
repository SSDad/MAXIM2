function Callback_Pushbutton_D2Panel_LoadImage(src, evnt)

global hFig

data = guidata(hFig);

%% load image info
td = tempdir;
fd_info = fullfile(td, 'MAXIM2');
fn_info = fullfile(fd_info, 'infoD2.mat');
if ~exist(fn_info, 'file')
    [D2ImageFileName, D2ImageFolder] = uigetfile();
    if D2ImageFileName ~=0
        save(fn_info, 'D2ImageFolder');
    end
else
    load(fn_info);
    [D2ImageFileName, ~] = uigetfile(D2ImageFolder);
end

hWB = waitbar(0, 'Loading 2D Slices...');

% Change mouse pointer (cursor) to an hourglass.  
% QUIRK: use 'watch' and you'll actually get an hourglass not a watch.
set(hFig,'Pointer','watch');
drawnow;  % Cursor won't change right away unless you do this.


load(fullfile(D2ImageFolder, D2ImageFileName));
imageD2.Images = imgWrite;
junk = imageD2.Images{1};
ID2 = rot90(junk, 3);
[M, N, ~] = size(ID2);
nSlice = length(imageD2.Images);

[~, junk, ~] = fileparts(D2ImageFileName);
ffn_ImgInfoD2 = fullfile(D2ImageFolder, [junk, '_ImgInfo.mat']);
load(ffn_ImgInfoD2);
dx = ImgInfoD2.FoV/N;
dy = ImgInfoD2.FoV/M;
xx = ImgInfoD2.x0:dx:ImgInfoD2.x0+ImgInfoD2.FoV;
yy = ImgInfoD2.y0:dy:ImgInfoD2.y0+ImgInfoD2.FoV;
yy = flip(yy);

hID2 = data.Panel.D2View.Comp.hPlotObj.ID2;
hID2.CData = ID2;
hID2.XData =xx;
hID2.YData = yy;

hAD2 = data.Panel.D2View.Comp.hAxis.Image;
hAD2.CLim = [min(ID2(:)) max(ID2(:))];

hAD2.YDir = 'normal';
hAD2.XColor = 'g';
hAD2.YColor = 'b';

axis(hAD2, 'tight', 'equal')
hAD2.Visible = 'on';

% slider
hSS = data.Panel.D2View.Comp.hSlider.Slice;
hSS.Min = 1;
hSS.Max = nSlice;
hSS.Value = 1;
hSS.SliderStep = [1 10]/(nSlice-1);

%
imageD2.nSlice = nSlice;
imageD2.dx = dx;
imageD2.dy = dy;
imageD2.xx = xx;
imageD2.yy = yy;
data.imageD2 = imageD2;

waitbar(100, hWB, 'Loading 2D Slices...');
pause(1);
close(hWB)
% Change mouse pointer (cursor) to an arrow.
set(hFig,'Pointer','arrow')
drawnow;  % Cursor won't change right away unless you do this.

guidata(hFig, data);

