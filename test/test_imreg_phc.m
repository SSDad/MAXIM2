clear vars

load('testData.mat')

dxy = 1;

%% Sagital
[M, N, P] = size(img.MM);
iN = round(N/2);

IMP = squeeze(img.MM(:,iN, :));
IS = rot90(IMP);

hF = figure(1);
hF.Color = 'k';
hAS = subplot(1,2,1, 'Parent', hF);
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

scaleS = [dyS/dxy dxS/dxy];
IS = imresize(IS, 'Scale', scaleS);
IS = im2single(IS);

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

scale2 = [dy2/dxy dx2/dxy];
ID2 = imresize(ID2, 'Scale', scale2);
ID2 = im2single(ID2);

figure(2)
imshowpair(IS, ID2, 'montage')


%% reg
moving = IS;
fixed = ID2;

tformEstimate = imregcorr(moving, fixed);
Rfixed = imref2d(size(fixed));
movingReg = imwarp(moving,tformEstimate,'OutputView',Rfixed);
figure(3)
imshowpair(fixed,movingReg,'montage');


[optimizer,metric] = imregconfig('multimodal');
mr = imregister(moving, fixed,...
    'affine', optimizer, metric,'InitialTransformation',tformEstimate);

% % optimizer.InitialRadius = optimizer.InitialRadius/4;


% mr = imregister(moving,fixed,'affine',optimizer,metric);
% 
figure(4)
imshowpair(mr, fixed)
% title('A: Default Registration')