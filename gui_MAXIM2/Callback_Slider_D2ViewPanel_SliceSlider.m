function Callback_Slider_D2ViewPanel_SliceSlider(src, evnt)

global hFig hFig2 contrastRectLim

data = guidata(hFig);

iSlice = round(get(src, 'Value'));

I = rot90(data.imageD2.Images{iSlice}, 3);

% contrast limit
maxI = max(I(:));
minI = min(I(:));
wI = maxI-minI;
% cL1 = minI+wI*contrastRectLim(1);
% cL2 = minI+wI*contrastRectLim(2);
% I(I<cL1) = cL1;
% I(I>cL2) = cL2;

data.Panel.D2View.Comp.hPlotObj.ID2.CData = I;
% hPlotObj.Image.CData = I;

% %tumor center
% data.Panel.View.Comp.hPlotObj.TumorCent.XData = data.Tumor.cent.x(iSlice);
% data.Panel.View.Comp.hPlotObj.TumorCent.YData = data.Tumor.cent.y(iSlice);
% 
% data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(data.Image.nImages)];

% % hist
% yc = histcounts(I, max(I(:))+1);
% yc = log10(yc);
% yc = yc/max(yc);
% xc = 1:length(yc);
% xc = xc/max(xc);
% data.Panel.ContrastBar.Comp.Panel.Constrast.hPlotObj.Hist.XData = xc;
% data.Panel.ContrastBar.Comp.Panel.Constrast.hPlotObj.Hist.YData = yc;
% 
% % snake
% x0 = data.Image.x0;
% y0 = data.Image.y0;
% dx = data.Image.dx;
% dy = data.Image.dy;
% 
% if data.Snake.SlitherDone
%     CB = data.Snake.Snakes{iSlice};
%     if isempty(CB)
%         data.Panel.View.Comp.hPlotObj.Snake.XData = [];
%         data.Panel.View.Comp.hPlotObj.Snake.YData = [];
%     else
%         data.Panel.View.Comp.hPlotObj.Snake.YData = (CB(:, 2)-1)*dy+y0;
%         data.Panel.View.Comp.hPlotObj.Snake.XData = (CB(:, 1)-1)*dx+x0;
%     end
% 
% %     CM =  data_main.maskCont{sV};
% %     if isempty(CM)
% %         data_main.hPlotObj.maskCont.XData = [];
% %         data_main.hPlotObj.maskCont.YData = [];
% %     else
% %         data_main.hPlotObj.maskCont.YData = (CM(:, 2)-1)*dy+y0;
% %         data_main.hPlotObj.maskCont.XData = (CM(:, 1)-1)*dx+x0;
% %     end
% 
%     if data.Point.InitDone
%         % points on contour
%         iSlice = iSlice;
%         xi = data.Point.Data.xi;
%         yi = data.Point.Data.yi;
%         ixm = data.Point.Data.ixm;
%         NP = data.Point.Data.NP;
% 
%         hPlotObj = data.Panel.View.Comp.hPlotObj;
%         hPlotObj.Point.XData = xi(ixm);
%         hPlotObj.Point.YData = yi(iSlice, ixm);
%         hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
%         hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
%         hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
%         hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);
% 
%         % point of current slice on points plot
%         data2 = guidata(hFig2);
%         data2.Panel.View.Comp.hPlotObj.PlotPoint.Current.XData = iSlice;
%         data2.Panel.View.Comp.hPlotObj.PlotPoint.Current.YData = mean(yi(iSlice, ixm-NP:ixm+NP));
%     end
% 
% end
% 
% data.Point.Data.iSlice = iSlice;
% guidata(hFig, data);
% 
% % 
% % 
% 
% % 
% % if data_main.LineDone
% %     
% % 
