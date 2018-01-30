% This code was obtained from an open source online and modified by the
% Capstone team.
% Title: imshow3D
% Author: Maysam Shahedi
% Availability: http://www.mathworks.com/matlabcentral/fileexchange/41334-imshow3d--3d-imshow--new-version-released--see--imshow3dfull-

function  imshow3Dnew( Img, disprange )
%IMSHOW3D displays 3D grayscale images in slice by slice fashion with mouse
%based slice browsing and window and level adjustment control.
%
% Usage:
% imshow3D ( Image )
% imshow3D ( Image , [] )
% imshow3D ( Image , [LOW HIGH] )
%   
%    Image:      3D image MxNxK (K slices of MxN images) 
%    [LOW HIGH]: display range that controls the display intensity range of
%                a grayscale image (default: the widest available range)
%
% Use the scroll bar or mouse scroll wheel to switch between slices. To
% adjust window and level values keep the mouse right button pressed and
% drag the mouse up and down (for level adjustment) or right and left (for
% window adjustment). 
% 
% "Auto W/L" button adjust the window and level automatically 
%
% While "Fine Tune" check box is checked the window/level adjustment gets
% 16 times less sensitive to mouse movement, to make it easier to control
% display intensity rang.
%
% Note: The sensitivity of mouse based window and level adjustment is set
% based on the user defined display intensity range; the wider the range
% the more sensitivity to mouse drag.
% 
% 
%   Example
%   --------
%       % Display an image (MRI example)
%       load mri 
%       Image = squeeze(D); 
%       figure, 
%       imshow3Dnew(Image) 
%
%       % Display the image, adjust the display range
%       figure,
%       imshow3Dnew(Image,[20 100]);
%
%   See also IMSHOW.

%
% - Maysam Shahedi (mshahedi@gmail.com)
% - Released: 1.0.0   Date: 2013/04/15
% - Revision: 1.1.0   Date: 2013/04/19
% 

sno = size(Img,3);  % number of slices
S = round(sno/2);
MinV = 0;
MaxV = max(Img(:));
LevV = (double( MaxV) + double(MinV)) / 2;
Win = double(MaxV) - double(MinV);

if isa(Img,'uint8')
    MaxV = uint8(Inf);
    MinV = uint8(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    
elseif isa(Img,'uint16')
    MaxV = uint16(Inf);
    MinV = uint16(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
    
elseif isa(Img,'uint32')
    MaxV = uint32(Inf);
    MinV = uint32(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
   
elseif isa(Img,'uint64')
    MaxV = uint64(Inf);
    MinV = uint64(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
 
elseif isa(Img,'int8')
    MaxV = int8(Inf);
    MinV = int8(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
  
elseif isa(Img,'int16')
    MaxV = int16(Inf);
    MinV = int16(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
   
elseif isa(Img,'int32')
    MaxV = int32(Inf);
    MinV = int32(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
 
elseif isa(Img,'int64')
    MaxV = int64(Inf);
    MinV = int64(-Inf);
    LevV = (double( MaxV) + double(MinV)) / 2;
    Win = double(MaxV) - double(MinV);
   
elseif isa(Img,'logical')
    LevV =0.5;
    Win = 1;
end

SFntSz = 12;
BtnSz = 10;
if (nargin < 2)
    [Rmin,Rmax] = WL2R(Win, LevV);
elseif numel(disprange) == 0
    [Rmin,Rmax] = WL2R(Win, LevV);
else
    LevV = (double(disprange(2)) + double(disprange(1))) / 2;
    Win = double(disprange(2)) - double(disprange(1));
    [Rmin,Rmax] = WL2R(Win, LevV);
end

axes('position',[0,0,1,1]), imshow(Img(:,:,S), [Rmin Rmax])

FigPos = get(gcf,'Position');
Stxt_Pos = [15 65 uint16(FigPos(3)/5) 20];
BtnStPnt1 = uint16(FigPos(3)/12)+1;
Btn_Pos = [100,860,200,30];
Btn_Pos2 = [220 100 170 20];
if sno > 1
    stxthand = uicontrol('Style', 'text','Position', Stxt_Pos,'String',sprintf('Slice# %d / %d',S, sno), 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', 11);
else
    stxthand = uicontrol('Style', 'text','Position', Stxt_Pos,'String','2D image', 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', 11);
end    

Area_of_interest = uicontrol('Style', 'pushbutton','Position', Btn_Pos,'String','Select AOI', 'FontSize', BtnSz, 'FontSize', SFntSz,'Callback' , @AOI);
Exit_Record = uicontrol('Style', 'pushbutton','Position', Btn_Pos2,...
    'String','Back to Main Menu', 'FontSize', BtnSz,'FontSize', SFntSz, 'Callback' , @ExitFigure);

mTextBox = uicontrol('style','text','Position',[20,900,380,20],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox,'String',...
'1. To select a polygonal Area of Interest (AOI), please click:');

mTextBox2 = uicontrol('style','text','Position',[20,780,380,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox2,'String',...
'2. Using the mouse, specify the AOI region by selecting vertices of the polygon.');

mTextBox3 = uicontrol('style','text','Position',[20,730,380,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox3,'String',...
'3. Double click within each polygon to display the analytics results.');

mTextBox4 = uicontrol('style','text','Position',[20,650,350,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox4,'String',...
'Note 1: You can move or resize the polygon using the mouse. ');

mTextBox5 = uicontrol('style','text','Position',[20,570,350,70],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox5,'String',...
'Note 2: To add another AOI, click on the "Select AOI" button again to define another polygon.');

set (gcf, 'WindowScrollWheelFcn', @mouseScroll);
set(gcf,'ResizeFcn', @figureResized)
GPAnnotation(S)

  function AOI (~,~)
       fixation = AreaSelection();
       figure       
       FontSize = 15;
       Btn_Pos1 = [100 330 200 80];
       Btn_Pos2 =  [300 330 100 80];
       Btn_Pos3 = [100 250 200 80];
       Btn_Pos4 =  [300 250 100 80];
       Btn_Pos5 = [100 170 200 80];
       Btn_Pos6 =  [300 170 100 80];
       fixation_number = uicontrol('Style','text','Position', Btn_Pos1,'String','# of fixation within AOI:','FontSize', FontSize);
       number = uicontrol('Style','text','Position', Btn_Pos2,'String',num2str(fixation(1)),'FontSize', FontSize);
       sum_time = uicontrol('Style','text','Position', Btn_Pos3,'String','sum of fixation time within AOI:','FontSize', FontSize);
       time = uicontrol('Style','text','Position', Btn_Pos4,'String',num2str(fixation(2)),'FontSize', FontSize);
       percentage = uicontrol('Style','text','Position', Btn_Pos5,'String','% of fixation time within AOI:','FontSize', FontSize);
       %align([fixation_number,number,sum_time,time,percentage],'Center','None');
       per= num2str(fixation(2)/fixation(3)*100);
       st = '%';
       str=strcat(per,st);
       uicontrol('Style','text','Position', Btn_Pos6,'String',str,'FontSize', FontSize);      
  end

 function ExitFigure(~,~)
        promptMessage = sprintf('Are you sure you want to return to the \nmain menu?');
        button = questdlg(promptMessage, 'Choose Action', 'Yes', 'Cancel', 'Yes');
        if strcmpi(button, 'Cancel')
            return; % Or break or continue
        end
        close
 end

% -=< Figure resize callback function >=-
    function figureResized(~,~)
        FigPos = get(gcf,'Position');
        Stxt_Pos = [15 65 uint16(FigPos(3)/5) 15];
        BtnStPnt1 = uint16(FigPos(3)/12)+1;
        Btn_Pos1 = [120 100 BtnStPnt1 20];
        set(stxthand,'Position', Stxt_Pos);
    end

    function mouseScroll (~, eventdata)
        UPDN = eventdata.VerticalScrollCount;
        S = S - UPDN;
        if (S < 1)
            S = 1;
        elseif (S > sno)
            S = sno;
        end
   
        if sno > 1
            set(stxthand, 'String', sprintf('Slice# %d / %d',S, sno));
        else
            set(stxthand, 'String', '2D image');
        end
        axes('position',[0,0,1,1]), imshow(Img(:,:,S), [Rmin Rmax])
        set(get(gca,'children'),'cdata',Img(:,:,S));
        GPAnnotation(S)
      end

% -=< Window and level to range conversion >=-
    function [Rmn,Rmx] = WL2R(W,L)
        Rmn = L - (W/2);
        Rmx = L + (W/2);
       if (Rmn >= Rmx)
            Rmx = Rmn + 1;
        end
    end

end
% -=< Maysam Shahedi (mshahedi@gmail.com), April 19, 2013>=-


function GPAnnotation(pg)
global GPData
double(pg);
hold on
% Process Gazepoint Data 
GP = [];
j=1;
k = 1;
for i=1:length(GPData)
    if (GPData(i,5)== pg)
        GP(j,1)=GPData(i,2);
        GP(j,2)=GPData(i,3);
        GP(j,3)=GPData(i,4);
        j = j +1;
        if (i+1>size(GPData,1)||GPData(i+1,5)~=pg)
            plotpoints(GP,k)
            k = k+1;
            GP = [];
            j=1;
        end
   
    end
end

end

function plotpoints(GP,k)
a = size(GP,1);
x = [-100 -100];
y = [-100 -120];
my_colour = [250 167 17] ./ 255;
my_colour_start = [95 183 121] ./ 255;
my_colour_end = [243 60 33] ./ 255;
plot(x,y,'-','Color',my_colour,'MarkerSize',6, 'LineWidth',1.5);
plot(-100,-100,'o','Color',my_colour_start,'MarkerSize',6, 'LineWidth',1.5);
plot(-100,-100,'o','Color',my_colour,'MarkerSize',6, 'LineWidth',1.5);
plot(-100,-100,'o','Color',my_colour_end,'MarkerSize',6, 'LineWidth',1.5);
legend({'Scanpath','First Fixation','Fixation(s)','Last Fixation'},'FontSize',10,'FontWeight','bold');
if (isempty(GP) ==0)
   plot(GP(:,1),GP(:,2),'-','Color',my_colour,'MarkerSize',0.01,'LineWidth',2);
    for i = 1:a
        if (i ==1)
            plot(GP(i,1),GP(i,2),'o','Color',my_colour_start,'MarkerSize',40*GP(i,3), 'LineWidth',1.8);
            text1 = num2str(k);
            text2 = 'visit';
            s = strcat(text2,{' '},text1);
            text(GP(i,1)+8,GP(i,2)+5,s,'Color','white','FontSize', 24)
            hold on
        elseif (i == a)
            plot(GP(i,1),GP(i,2),'-o','Color',my_colour_end,'MarkerSize',40*GP(i,3), 'LineWidth',1.5);
           hold on
        else
            plot(GP(i,1),GP(i,2),'-o','Color',my_colour,'MarkerSize',40*GP(i,3), 'LineWidth',1.8);
            hold on
        end
    end
end

end

%%%% This function lets tou select desired region on an image%%%%%%%%%%%
function [fixation_num] = AreaSelection(~,~)
hold on
global GPData
 [~,xi, yi] =  roipoly;
 xmin = min(xi);
 xmax = max(xi);
 ymin = min(yi);
 ymax = max(yi);
 fixation_num = zeros(1,3);
 for i = 1:length(GPData)
     if (xmin<=GPData(i,2) && GPData(i,2)<=xmax && ymin<=GPData(i,3) && GPData(i,3)<=ymax )
         fixation_num(1)= fixation_num(1)+1;
         fixation_num(2) = GPData(i,4)+fixation_num(2);
     end
     fixation_num(3)= fixation_num(3)+GPData(i,4);
 end
end