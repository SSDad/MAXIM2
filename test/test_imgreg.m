clearvars

load('testData.mat')

%% Sagital
[M, N, P] = size(img.MM);
iN = round(N/2)+2;
iN = 137;

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

hF(1) = figure(1);
hF(1).Position = posF;

hF(1).Color = 'k';
hAS = subplot(1,2,1, 'Parent', hF(1));
hIS = imshow([], 'Parent', hAS);

hIS.CData = IS;

xxS = img.Info.yy; 
yyS = img.Info.zz; 
hIS.XData = xxS;
hIS.YData = yyS;
               
hAS.CLim = [min(IS(:)) max(IS(:))];
hAS.XColor = 'g';
hAS.YColor = 'b';
hAS.YDir = 'normal';
hAS.Visible = 'on';

axis(hAS, 'tight', 'equal')

%% d2
hAD2 = subplot(1,2,2, 'Parent', hF);
hID2 = imshow([], 'Parent', hAD2);

ID2 = rgb2gray(d2.I);

hID2.CData = ID2;
hID2.XData =d2.xx;
d2.yy = flip(d2.yy);
hID2.YData = d2.yy; 

hAD2.CLim = [min(ID2(:)) max(ID2(:))];

hAD2.YDir = 'normal';
hAD2.XColor = 'g';
hAD2.YColor = 'b';

axis(hAD2, 'tight', 'equal')
hAD2.Visible = 'on';

%% reg
[fixed, mvr, tform, scalef, scalem] = fun_imgreg(ID2, d2.xx, d2.yy, IS, xxS, yyS);

hF(3) = figure(3); clf
imshowpair(mvr, fixed)
hF(3).Position = posF;

hF(4) = figure(4); clf
imshowpair(mvr, fixed, 'Montage')
hF(4).Position = posF;

ssimval = ssim(fixed, mvr)

% %% img quality
% BW = im2bw(mvr, 0.051);
% B = bwboundaries(BW);
% figure(5), clf
% imshow(BW)

