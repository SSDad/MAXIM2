clearvars

load('testData.mat')

%% Sagital
[M, N, P] = size(img.MM);
iN = round(N/2);

IMP = squeeze(img.MM(:,iN, :));
IS = rot90(IMP);

%% figure on second monitor if available
figPosShft = [0 0]; 
MP = get(0, 'MonitorPositions');
if size(MP, 1) == 2  % Dual monitor
    figPosShft    = MP(2, 1:2);
    sizeF = MP(2, 3:4)/2;
    origF = MP(2, 3:4)/4;
    posF = [origF+figPosShft sizeF];
end

%   FigH     = figure(varargin{:}, 'Visible', 'off');
%   drawnow;
%   set(FigH, 'Units', 'pixels');
%   pos      = get(FigH, 'Position');
%   pause(0.02);  % See Stefan Glasauer's comment
%   set(FigH, 'Position', [pos(1:2) + Shift, pos(3:4)], ...
%             'Visible', paramVisible);
% 


hF(1) = figure(1);
hF(1).Position = posF;

hF(1).Color = 'k';
hAS = subplot(1,2,1, 'Parent', hF(1));
hIS = imshow([], 'Parent', hAS);

hIS.CData = IS;

xxS = img.Info.yy; dxS = xxS(2)-xxS(1); 
yyS = flip(img.Info.zz); dyS = yyS(1)-yyS(2);
hIS.XData = xxS;
hIS.YData = yyS;
               
hAS.CLim = [min(IS(:)) max(IS(:))];
hAS.XColor = 'g';
hAS.YColor = 'b';
% hAS.YDir = 'normal';
hAS.Visible = 'on';

axis(hAS, 'tight', 'equal')

%% d2
hAD2 = subplot(1,2,2, 'Parent', hF);
hID2 = imshow([], 'Parent', hAD2);

ID2 = rgb2gray(d2.I);

hID2.CData = ID2;
hID2.XData =d2.xx;  dx2 = d2.xx(2)-d2.xx(1);
hID2.YData = d2.yy; dy2 = d2.yy(1)-d2.yy(2);

hAD2.CLim = [min(ID2(:)) max(ID2(:))];

% hAD2.YDir = 'normal';
hAD2.XColor = 'g';
hAD2.YColor = 'b';

axis(hAD2, 'tight', 'equal')
hAD2.Visible = 'on';

%% scale

dxy = min([dxS dyS dx2 dy2]);

scaleS = [dyS/dxy dxS/dxy];
IS = imresize(IS, 'Scale', scaleS);
IS = im2single(IS);

scale2 = [dy2/dxy dx2/dxy];
ID2 = imresize(ID2, 'Scale', scale2);
ID2 = im2single(ID2);

hF(2) = figure(2); clf
imshowpair(IS, ID2, 'montage')
hF(2).Position = posF;


%% reg
moving = IS;
fixed = ID2;

[optimizer,metric] = imregconfig('multimodal');
tform = imregtform(moving, fixed, 'affine', optimizer, metric);
mr = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));

% optimizer.InitialRadius = optimizer.InitialRadius/4;
% [mr, R] = imregister(moving,fixed,'affine',optimizer,metric);

% optimize
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
tform2 = imregtform(moving, fixed, 'affine', optimizer, metric);
mr2 = imwarp(moving,tform2,'OutputView',imref2d(size(fixed)));

% [mr2, R2] = imregister(moving,fixed,'affine',optimizer,metric);

hF(3) = figure(3); clf
imshowpair(mr2, fixed)
hF(3).Position = posF;

hF(4) = figure(4); clf
imshowpair(mr2, fixed, 'Montage')
hF(4).Position = posF;