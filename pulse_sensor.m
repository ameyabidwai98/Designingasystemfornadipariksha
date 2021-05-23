

clear
clc


    if ~isempty(instrfind)
       fclose(instrfind);
       delete(instrfind);
    end

 

speed_control = 8 % value=1 is faster increase till 80 slower    
    
port = 'COM3';
Baud_Rate = 115200;
Data_Bits = 8;
Stop_Bits = 1;
ser_comm = serial('COM3','BaudRate',Baud_Rate,'DataBits',Data_Bits,'StopBits',Stop_Bits);
%User Defined Properties 
% a = arduino('Com5')             % define the Arduino Communication port
figh1 = figure(1); 


plotTitle = 'Arduino Data Log';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
% % yLabel = 'Pulse';      % y-axis label
yLabel1 = 'VATA'
yLabel2 = 'PITTA'
yLabel3 = 'KAPHA'
yMax  = 999                           %y Maximum Value
yMin  = 0                       %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = 300;                         % set y-min
max = 700;                        % set y-max
delay = .000001;                     % make sure sample faster than resolution 

%Define Function Variables
time = 0;
data = 0;
data1 = 0;
data2 = 0;
count = 0;
% acount = 0;
% bcount = 0;
% ccount = 0;
% tiledlayout(3,1)
%Set up Plot
ax1 = subplot(3,1,1);
% btn = uibutton();
title(plotTitle,'FontSize',15);
plotGraph = plot(ax1,time,data,'-r' )  % every AnalogRead needs to be on its own Plotgraph
ylabel(yLabel1,'FontSize',8);
grid(plotGrid);
% hold on                            %hold on makes sure all of the channels are plotted
ax2 = subplot(3,1,2)
plotGraph1 = plot(ax2,time,data1,'-b')
ylabel(yLabel2,'FontSize',8);
grid(plotGrid);
ax3 = subplot(3,1,3)
plotGraph2 = plot(ax3,time, data2,'-g' )

xlabel(xLabel,'FontSize',8);
ylabel(yLabel3,'FontSize',8);
% legend(legend3)
% axis auto
axis([yMin yMax min inf]);
grid(plotGrid);
% btn = uibutton(fig);
% ylim auto 
tic
    
    fopen(ser_comm);
while ishandle(plotGraph) %Loop when Plot is Active will run until plot is closed

y=fscanf(ser_comm)


B = regexp(y,'\d*','Match');

         count = count + 1;    
         time(count) = toc;    

         data(count) = str2double(B(1)); 
         data1(count) = str2double(B(2));
         data2(count) = str2double(B(3));
%          data(count) =  str2num(B(1)); 
%          data1(count) = str2num(B(2));
%          data2(count) = str2num(B(3));
         
        if count>=80
          set(plotGraph,'XData',time,'YData',data);
          axis(ax1,[time(count)-speed_control time(count) min inf]);
%           axis auto; 
        end
         
        if count>=80  
          set(plotGraph1,'XData',time,'YData',data1);
          axis(ax2,[time(count)-speed_control time(count) min inf]);
%           axis auto;
        end

        if count>=80
           set(plotGraph2,'XData',time,'YData',data2);
           axis(ax3,[time(count)-speed_control time(count) min inf]);
%            axis auto;
        end
        

        pause(delay);


  end


  
fclose(ser_comm);
disp('Plot Closed and arduino serial object has been deleted')