function Callback_XHair_yOnAxialView(src, evnt)

global hFig
data = guidata(hFig);

%% x
y = src.Position(1, 2);
[~, iM] = min(abs(y-data.image.Info.yy));
hIC = data.Panel.CoronalView.Comp.hPlotObj.IC;
hIC.CData = flip(rot90(squeeze(data.image.MM(iM, :, :)), 3), 2);

%% sync
src.Position(:, 1) = evnt.PreviousPosition(:, 1);
y = data.image.Info.yy(iM);
src.Position(:, 2) = y;
data.Panel.SagitalView.Comp.hPlotObj.yLine.Position(:, 1) = y;