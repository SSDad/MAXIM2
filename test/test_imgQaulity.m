clearvars
close all

load('testData.mat')
xxS = img.Info.yy; 
yyS = flip(img.Info.zz); 

ID2 = rgb2gray(d2.I);

%% Sagital
[M, N, P] = size(img.MM);

ffn = 'maxN.mat';
if exist(ffn, 'file')
    load(ffn);
else

tic
parfor iN = 1:N
% iN = round(N/2)+2;

    IMP = squeeze(img.MM(:,iN, :));
    IS = rot90(IMP);

    %% reg
    if max(IS(:)) == 0
        ssimval(iN) = 0;
    else
        [fixed, mvr, tform, scalef, scalem] = fun_imgreg(ID2, d2.xx, d2.yy, IS, xxS, yyS);
        ssimval(iN) = ssim(fixed, mvr);
    end

end
toc

[~, idx] = max(ssimval);
save('maxN', 'ssimval', 'idx');
end

%% figure on second monitor if available
figPosShft = [0 0]; 
MP = get(0, 'MonitorPositions');
if size(MP, 1) == 2  % Dual monitor
    figPosShft    = MP(2, 1:2);
    sizeF = MP(2, 3:4)/2;
    origF = MP(2, 3:4)/4;
    posF = [origF+figPosShft sizeF];
end

hF = figure;
hF.Position = posF;
plot(ssimval, 'o');

%% maxN
IMP = squeeze(img.MM(:,idx, :));
IS = rot90(IMP);

%% plot
hF = figure;
hF.Position = posF;

hF.Color = 'k';
hAS = subplot(1,2,1, 'Parent', hF);
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

% hID2.CData = ID2;
hID2.CData = d2.I;
hID2.XData =d2.xx;  
d2.yy = flip(d2.yy);
hID2.YData = d2.yy; 

% hAD2.CLim = [min(ID2(:)) max(ID2(:))];

hAD2.YDir = 'normal';
hAD2.XColor = 'g';
hAD2.YColor = 'b';

axis(hAD2, 'tight', 'equal')
hAD2.Visible = 'on';

%% contour
[C, idxC] = fun_extractContour(d2.I);
dx = d2.xx(2)-d2.xx(1);
dy = d2.yy(2)-d2.yy(1);
xxC = (C(:, 1)-1)*dx+d2.xx(1);
yyC = (C(:, 2)-1)*dy+d2.yy(1);
line(hAD2, 'XData', xxC, 'YData', yyC, 'Color', 'c', 'LineWidth', 2);

%% reg
ID2 = rgb2gray(d2.I);
[fixed, mvr, tform, scalef, scalem] = fun_imgreg(ID2, d2.xx, d2.yy, IS, xxS, yyS);

hF = figure; clf
imshowpair(mvr, fixed)
hF.Position = posF;

hF = figure; clf
hAm = subplot(1,2,1); imshow(mvr, [], 'parent', hAm)
hAf = subplot(1,2,2); imshow(fixed, [], 'parent', hAf)
% imshowpair(mvr, fixed, 'Montage')
hF.Position = posF;

%% burn
C1 = [C(:,1)*scalef(2) C(:,2)*scalef(1)];
line(hAf, 'XData', C1(:,1), 'YData', C1(:,2), 'Color', 'c', 'LineWidth', 2);
line(hAm, 'XData', C1(:,1), 'YData', C1(:,2), 'Color', 'c', 'LineWidth', 2);

[u, v] = transformPointsInverse(tform, C1(:, 1), C1(:,2));

moving = IS;
moving = im2single(moving);
moving = imresize(moving, 'Scale', scalem);
moving = moving/max(moving(:));


% itform = invert(tform);
% iT = itform.T;
% C2 = iT(1:2, 1:2)*(C1+iT(3, 1:2))';
% C2 = C2';
hF = figure; clf
imshow(moving, []), hold on
line('XData', u, 'YData', v, 'Color', 'c', 'LineWidth', 2);
set(gca, 'YDir', 'Normal')
hF.Position = posF;
axis on

% back to original
u = u/scalem(2);
v = v/scalem(1);

dx = xxS(2)-xxS(1);
dy = yyS(2)-yyS(1);
xxC = (u-1)*dx+xxS(1);
yyC = (v-1)*dy+yyS(1);
line(hAS, 'XData', xxC, 'YData', yyC, 'Color', 'c', 'LineWidth', 2);

