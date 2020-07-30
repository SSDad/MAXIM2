function Callback_XHair_x(src, evnt)

global hFig hFig2
data = guidata(hFig);

%% x
x = src.Position(1, 1);
[~, iN] = min(abs(x-data.image.Info.xx));
hIS = data.Panel.SagitalView.Comp.hPlotObj.IS;
hIS.CData = flip(rot90(squeeze(data.image.MM(:, iN, :)), 3), 2);

%% sync
src.Position(:, 2) = evnt.PreviousPosition(:, 2);

x = data.image.Info.xx(iN);
data.Panel.CoronalView.Comp.hPlotObj.xLine.Position(:, 1) = x;
data.Panel.AxialView.Comp.hPlotObj.xLine.Position(:, 1) = x;