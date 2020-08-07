function MAXIM2

%% global 
global hFig hFig2

data.Color.FC_PB = [255 255 102]/255;
data.Color.BC_PB = [1 1 1]*0.25;

% global stopSlither
% global reContL
% global contrastRectLim

%% main window
hFig = figure('MenuBar',            'none', ...
                    'Toolbar',              'none', ...
                    'HandleVisibility',  'callback', ...
                    'Name',                'MAXIM-II - Department of Radiation Oncology, Washington University in St. Louis', ...
                    'NumberTitle',      'off', ...
                    'Units',                 'normalized',...
                    'Position',             [0.1 0.1 0.8 0.8],...
                    'Color',                 'black', ...
                    'CloseRequestFcn', @figCloseReq, ...
                    'Visible',               'on');

guidata(hFig, data);
               
addToolbar(hFig);
                
data.Panel = addPanel(hFig);
data.Panel.Patient.Comp = addComponents2Panel_Patient(data.Panel.Patient.hPanel);
data.Panel.D2.Comp = addComponents2Panel_D2(data.Panel.D2.hPanel);

data.Panel.AxialView.Comp = addComponents2Panel_AxialView(data.Panel.AxialView.hPanel);
data.Panel.SagitalView.Comp = addComponents2Panel_SagitalView(data.Panel.SagitalView.hPanel);
data.Panel.CoronalView.Comp = addComponents2Panel_CoronalView(data.Panel.CoronalView.hPanel);
data.Panel.D2View.Comp = addComponents2Panel_D2View(data.Panel.D2View.hPanel);

guidata(hFig, data);

% data.Panel.View.Comp = addComponents2Panel_View(data.Panel.View.hPanel);
% data.Panel.Snake.Comp = addComponents2Panel_Snake(data.Panel.Snake.hPanel);
% data.Panel.ContrastBar.Comp = addComponents2Panel_ContrastBar(data.Panel.ContrastBar.hPanel);
% data.Panel.SliceSlider.Comp = addComponents2Panel_SliceSlider(data.Panel.SliceSlider.hPanel);
% 
% data.Panel.Point.Comp = addComponents2Panel_Point(data.Panel.Point.hPanel);
% data.Panel.Tumor.Comp = addComponents2Panel_Tumor(data.Panel.Tumor.hPanel);
% 
% data.Panel.About.Comp = addComponents2Panel_About(data.Panel.About.hPanel);


% %% point fig
% hFig2 = figure('MenuBar',            'none', ...
%                     'Toolbar',              'none', ...
%                     'HandleVisibility',  'callback', ...
%                     'Name',                'MAXIM - Measurement', ...
%                     'NumberTitle',      'off', ...
%                     'Units',                 'normalized',...
%                     'Position',             [0.05 0.05 0.9 0.85],...
%                     'Color',                 'black', ...
%                     'CloseRequestFcn', @fig2CloseReq, ...
%                     'Visible',               'off');
% 
% addToolbar(hFig2);
% data2.Panel = addPanel2(hFig2);
% data2.Panel.View.Comp = addComponents2Panel2_View(data2.Panel.View.hPanel);
% data2.Panel.Tumor.Comp = addComponents2Panel2_Tumor(data2.Panel.Tumor.hPanel);
% data2.Panel.Button.Comp = addComponents2Panel2_Button(data2.Panel.Button.hPanel);
% data2.Panel.Button1.Comp = addComponents2Panel2_Button1(data2.Panel.Button1.hPanel);
% data2.Panel.Profile.Comp = addComponents2Panel2_Profile(data2.Panel.Profile.hPanel);
% guidata(hFig2, data2);
                               
