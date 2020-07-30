function Callback_XHair_yOnSagitalView(src, evnt)

global hFig
data = guidata(hFig);

%% x
y = src.Position(1, 1);
[~, iM] = min(abs(y-data.image.Info.yy));
hIC = data.Panel.CoronalView.Comp.hPlotObj.IC;
% hIC.CData = rot90(squeeze(data.image.MM(iM, :, :)));
hIC.CData =flip(rot90(squeeze(data.image.MM(iM, :, :)), 3), 2);


%% sync
src.Position(:, 2) = evnt.PreviousPosition(:, 2);
y = data.image.Info.yy(iM);
src.Position(:, 1) = y;
data.Panel.AxialView.Comp.hPlotObj.yLine.Position(:, 2) = y;