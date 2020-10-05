function [fixed, mvr, tform, scalef, scalem] = fun_imgreg(fixed, xxf, yyf, moving, xxm, yym)

%% scale
dxf = xxf(2)-xxf(1); 
dyf = abs(yyf(2)-yyf(1));
dxm = xxm(2)-xxm(1);
dym = abs(yym(2)-yym(1));
dxy = min([dxf dyf dxm dym]);

scalem = [dym/dxy dxm/dxy];
moving = im2single(moving);
moving = imresize(moving, 'Scale', scalem);
moving = moving/max(moving(:));

scalef = [dyf/dxy dxf/dxy];
fixed = im2single(fixed);
fixed = imresize(fixed, 'Scale', scalef);
fixed = fixed/max(fixed(:));

%% reg
[optimizer,metric] = imregconfig('multimodal');
% tform = imregtform(moving, fixed, 'affine', optimizer, metric);
% mvr = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));

% optimize
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
tform = imregtform(moving, fixed, 'affine', optimizer, metric);
mvr = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));