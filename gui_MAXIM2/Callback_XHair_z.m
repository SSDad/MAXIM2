function Callback_XHair_z(src, evnt)

global indSS
global hFig hFig2
data = guidata(hFig);

%% z
z = src.Position(1, 2);
[~, iP] = min(abs(z-data.image.Info.zz));
hIA = data.Panel.AxialView.Comp.hPlotObj.IA;
hIA.CData = data.image.MM(:,:,iP);

%% sync
src.Position(:,1) = evnt.PreviousPosition(:,1);

z = data.image.Info.zz(iP);
data.Panel.CoronalView.Comp.hPlotObj.zLine.Position(:, 2) = z;
data.Panel.SagitalView.Comp.hPlotObj.zLine.Position(:, 2) = z;