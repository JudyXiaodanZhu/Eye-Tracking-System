function main_gui
   figure('Name','Eye Tracking System for Research','NumberTitle','off')
   %  Construct the components.
   SFntSz = 12;
   mTextBoxTitle = uicontrol('style','text','Position',[30,360,480,30],'FontSize', 16);
   set(mTextBoxTitle,'String',...
       'Sunnybrook Eye Tracking System for Research')
   mTextBox = uicontrol('style','text','Position',[130,280,300,60],'FontSize', SFntSz);
   set(mTextBox,'String',...
       'Please make sure the eye tracker is properly set up and calibrated before image examination.')
   
   hload = uicontrol('Style','pushbutton','String','Load Medical Image for Examination',...
           'Position',[130,230,300,40],'FontSize', SFntSz,...
             'Callback',@hload_Callback);
   hdisplay = uicontrol('Style','pushbutton',...
           'String','Display Current Visualization',...
           'Position',[130,140,300,40],'FontSize', SFntSz,...
             'Callback',@hdisplay_Callback);
   hretrieve = uicontrol('Style','pushbutton',...
           'String','Retrieve Saved Visualization',...
           'Position',[130,50,300,40],'FontSize', SFntSz,...
             'Callback',@hretrieve_Callback);
    
   align([hload,mTextBox, hdisplay,hretrieve],'Center','None');
  end

 function hload_Callback(~,~) 
[volume_image, ~,~] = dicom23D;
s = get(0, 'ScreenSize');
s
figure('Name','Record Examination','NumberTitle','off','Position', [0 0.04*s(4) s(3) s(4)-0.1*s(4)])
imshow3D(volume_image,[]);
 end
 
function hdisplay_Callback(~,~)
    try
        load volume_image.mat
        catch
        msgbox('There are no saved visualizations. Please load Medical Image for examination.');
        return
    end
    s = get(0, 'ScreenSize');
    figure('Name','Display most recently saved Visualization','NumberTitle','off','Position', [0 0.04*s(4) s(3) s(4)-0.1*s(4)])
    imshow3Dnew(volume_image,[])
end

function hretrieve_Callback(~,~)
newfilename = uigetfile('*.mat', 'Select Visualization');
load(newfilename)
s = get(0, 'ScreenSize')
s
figure('Name','Display Saved Visualization','NumberTitle','off','Position', [0 0.04*s(4) s(3) s(4)-0.1*s(4)])
str1 = 'Current Gaze Visualization:';
str2 = newfilename;
s = strcat(str1,{' '},str2);
mTextBox = uicontrol('style','text','Position',[20,1000,380,20],'FontSize', 12,'HorizontalAlignment','Left');
set(mTextBox,'String',s);
imshow3Dnew(volume_image,[]) ;
end
