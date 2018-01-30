% This code was obtained from an open source online and modified by the
% Capstone team.
% Title: imshow3D
% Author: Maysam Shahedi
% Availability: http://www.mathworks.com/matlabcentral/fileexchange/41334-imshow3d--3d-imshow--new-version-released--see--imshow3dfull-

function imshow3D( Img, disprange)
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

%       imshow3D(Image) 
%
%       % Display the image, adjust the display range
%       figure,
%       imshow3D(Image,[20 100]);
%
%   See also IMSHOW.

%
% - Maysam Shahedi (mshahedi@gmail.com)
% - Released: 1.0.0   Date: 2013/04/15
% - Revision: 1.1.0   Date: 2013/04/19
% 
scale = size(Img,1);
sno = size(Img,3);  % number of slices
S = round(sno/2);
global NewArray;
global InitialTime;
InitialTime = 0;
MinV = 0;
MaxV = max(Img(:));
LevV = (double(MaxV) + double(MinV)) / 2;
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
volume_image = Img;
FigPos = get(gcf,'Position');
Stxt_Pos = [15 65 uint16(FigPos(3)/5) 20];
Btn_Pos = [250 780 150 30];
Btn_Pos1 = [250 580 150 30];
Btn_Pos2 = [220 330 180 30];
Btn_Pos3 = [200 100 200 30];

stxthand = uicontrol('Style', 'text','Position', Stxt_Pos,'String'...
    ,sprintf('Slice# %d / %d',S, sno), 'BackgroundColor', [0.8 0.8 0.8], 'FontSize', SFntSz);
Begin_Exam = uicontrol('Style', 'pushbutton','Position', Btn_Pos,...
    'String','Begin New Exam', 'FontSize', BtnSz, 'FontSize', SFntSz, 'Callback' , @StartTime);
End_Exam = uicontrol(gcf,'Style', 'pushbutton','Enable','off','Position', Btn_Pos1,...
    'String','End Exam', 'FontSize', BtnSz,'FontSize', SFntSz, 'Callback' , @EndTime);
Import_Gaze = uicontrol('Style', 'pushbutton','Enable','off','Position', Btn_Pos2,...
    'String','Import Raw Gaze Data', 'FontSize', BtnSz, 'FontSize', SFntSz,'Callback' , {@ExitRecord,scale,volume_image});
Exit_Record = uicontrol('Style', 'pushbutton','Position', Btn_Pos3,...
    'String','Back to Main Menu', 'FontSize', BtnSz, 'FontSize', SFntSz,'Callback' , @ExitFigure);

mTextBox = uicontrol('style','text','Position',[20,900,380,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox,'String',...
'1. Go to Gazepoint Analysis Software, press "Start Record"');

mTextBox1 = uicontrol('style','text','Position',[20,800,210,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox1,'String',...
'2. Return to current page, press');

mTextBox2 = uicontrol('style','text','Position',[20,700,380,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox2,'String',...
'3. Perform examination task.');

mTextBox3 = uicontrol('style','text','Position',[20,600,220,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox3,'String',...
'4. When examination is completed, press')

mTextBox4 = uicontrol('style','text','Position',[20,480,380,60],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox4,'String',...
'5. Go to Gazepoint Analysis Software, press "Stop Record". Export .csv raw data to previously configured directory.')

mTextBox5 = uicontrol('style','text','Position',[20,380,380,30],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox5,'String',...
'6. Import .csv raw data into the current page.')

mTextBox6 = uicontrol('style','text','Position',[20,200,380,40],'FontSize', SFntSz,'HorizontalAlignment','Left');
set(mTextBox6,'String',...
'If you wish to start a new exam with the same file, repeat process 1-6.')

set (gcf, 'WindowScrollWheelFcn', @mouseScroll);

    function StartTime (~,~)
        tic
        NewArray = zeros(0,2);
        c = clock;
        InitialTime = c;
        elapsed_time_array = [S,toc];
        NewArray = [NewArray;elapsed_time_array];
        
        h = findobj(End_Exam,'Enable','off');
        set(h,'Enable','on')
        current = findobj(Begin_Exam,'Enable','on');
        set(current,'Enable','off');
        I = findobj(Import_Gaze,'Enable','on');
        set(I,'Enable','off')
    end

    function EndTime (hObject, eventdata)
         toc;
         elapsed_time_array = [S,toc];
         NewArray = [NewArray;elapsed_time_array];
         save InitialTime(Do not delete).mat InitialTime NewArray
         InitialTime = 0;
         
         h = findobj(Begin_Exam,'Enable','off');
         set(h,'Enable','on')
         current = findobj(End_Exam,'Enable','on');
         set(current,'Enable','off');
         I = findobj(Import_Gaze,'Enable','off');
         set(I,'Enable','on')
     end
    
    function ExitFigure(~,~)
        promptMessage = sprintf('Are you sure you want to return to the \nmain menu?');
        button = questdlg(promptMessage, 'Choose Action', 'Yes', 'Cancel', 'Yes');
        if strcmpi(button, 'Cancel')
            return; % Or break or continue
        end
        close
    end
  
% -=< Mouse scroll wheel callback function >=-
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
           if(InitialTime~=0)
                toc;
                elapsed_time_array = [S,toc];
                NewArray = [NewArray;elapsed_time_array];
           end
        else
            set(stxthand, 'String', '2D image');
        end
        set(get(gca,'children'),'cdata',Img(:,:,S));
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


function ExitRecord(~,~,scale,volume_image)
global GPData;
try
    [filename,pathname] = uigetfile([pwd '\Gazepoint Raw Data\*.csv'], 'Select file');
    path = strcat(pathname,filename);
    h = waitbar(0, 'Importing data...', 'WindowStyle', 'modal');
    GPRaw = csvread(path,1,3);
    fid   = fopen(path);
    paramIds = textscan(fid,'%s%s%s%s',1,'HeaderLines',0,'Delimiter',',');
    GPDate = cell2mat(paramIds{4});
catch
   close(h)
   if isequal( path, 0 )
   msgbox('Error occurred! Please make sure the import data is in .csv format!');
   return
   end
end

GPDate(1:5)=[];
formatIn = 'yyyy/mm/dd HH:MM:SS.FFF';
GPStartTime = datevec(GPDate,formatIn);

%Match Time
%delete GPRaw, its replaced with GPData
%Process imported .csv Data
GPData = GPRaw(:,[1 3:4 6]);
NegValue=[];
load ('InitialTime(Do not delete).mat');

%%%%This is a dummy matlab InitialTime used to
%%%%test the code with User 14_fixations.csv. Please uncomment if eye
%%%%tracker hardware is not used and testing is conducted with User
%%%%14_fixations.csv.
%InitialTime = [2016 1 21 11 35 05]; 
TimeDiff = etime(InitialTime,GPStartTime);
DeleteValue=[];

for i = 1:length(GPData)
    if (GPData(i,1)<TimeDiff)
        DeleteValue(end+1)= i;
    end
end

%Delete GPdata that was recorded before Matlab InitialTime
GPData(DeleteValue,:) = [];

%Subtract the TimeDiff from the GPData time, so now the elapse time in
%Matlab is the same as elapse time in GPData
for i = 1:length(GPData)
GPData(i,1)= GPData(i,1)-TimeDiff;
end

NewCoord = [0.25;0.75;0.06;0.97];
for i=1:length(GPData)
   if(GPData(i,1)>=3600||GPData(i,2)<NewCoord(1)||GPData(i,2)>=NewCoord(2))
   NegValue(end+1)=i;
   elseif(GPData(i,3)<NewCoord(3)||GPData(i,3)>=NewCoord(4))
   NegValue(end+1)=i;
   else
   GPData(i,2)=(GPData(i,2)-NewCoord(1))/ (NewCoord(2)-NewCoord(1));
   GPData(i,3)=(GPData(i,3)-NewCoord(3))/ (NewCoord(4)-NewCoord(3));
   end
end
GPData(NegValue,:) = [];
GPData(:,2:3)= GPData(:,2:3).*scale;

for i = 1:length(GPData)
    Slicenumber = MatchSlice(GPData(i,1),NewArray);
    GPData(i,5) = Slicenumber;
end
DeleteValue = [];
for i = 1:length(GPData)
    if (GPData(i,5)==0)
        DeleteValue(end+1)= i;
    end
end
GPData(DeleteValue,:) = [];
close(h)

promptMessage = sprintf('Import has ended. \n\nPlease save the processed data as a .mat file under the current directory.');
button = questdlg(promptMessage, 'Choose Action', 'Ok', 'Cancel', 'Yes');
if strcmpi(button, 'Cancel')
   return; 
end
newfilename = strtok(filename, '.');
uisave({'GPData','volume_image'},newfilename);
save volume_image.mat GPData volume_image
end

function [Slicenumber] = MatchSlice(GPTime,NewArray)
%add the slice number to the NewArray
ArraySize = length(NewArray);
    for i = 1:ArraySize 
        if (i<ArraySize && (NewArray(i,2) <= GPTime) && (GPTime < NewArray(i+1,2)))
            Slicenumber = NewArray(i,1);
            return
        elseif ((i == ArraySize )&& (GPTime < NewArray(i,2)))
            Slicenumber = NewArray(i-1,1);
            return
        else
            Slicenumber = 0;
        end
    end
end

% -=< Maysam Shahedi (mshahedi@gmail.com), April 19, 2013>=-
