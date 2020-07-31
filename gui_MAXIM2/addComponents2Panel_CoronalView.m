function Comp = addComponents2Panel_CoronalView(hPanel)

FC = [255 255 102]/255;

% axes
hA = axes('Parent',                   hPanel, ...
                            'color',        'none',...
                            'Units',                    'normalized', ...
                            'HandleVisibility',     'callback', ...
                            'Position',                 [0.075 0.05 0.9 0.9]);

hPlotObj.IC = imshow([], 'parent', hA);

hPlotObj.zLine = images.roi.Line(hA, 'Position',[0, 0; 0, 0], 'Color', 'b', 'LineWidth', 1);
addlistener(hPlotObj.zLine, 'MovingROI', @Callback_XHair_z);
                        
hPlotObj.xLine = images.roi.Line(hA, 'Position',[0, 0; 0, 0], 'Color', 'r', 'LineWidth', 1);
addlistener(hPlotObj.xLine, 'MovingROI', @Callback_XHair_x);

% Comp.hAxis.Image.XAxisLocation='top';
hold(hA, 'on')

Comp.hAxis.Image = hA;
Comp.hPlotObj = hPlotObj;