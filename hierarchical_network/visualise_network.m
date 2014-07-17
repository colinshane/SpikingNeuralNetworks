% GUI for displaying DVS image side-by-side with neural network activity,
% and for modifying network parameters dynamically. 
% 
% What is current does: 
%     It can't do any param adjustments dynamically because neural activity
%     is pre-generated with all the dvs data then displayed. 
%
% What it should eventually do: 
%     Show a video of the DVS images.
%     Show a graph or some sort of visualisation of the neurons in the network
%     which change colour when they fire.
%     Allow user to change parameters of network dynamically.
%     Show the membrane potential trace or other activity of some representative
%     neuron.
% 
% Credit:
%     Cobbling by Alex Lee.
%     Some code may have been taken from Izhikevich (2003) Which neuron model
%     Some code may have been taken from Robert Quinn's DVS work, in particular
%     displayingdata.m

% Load DVS events into matrix otf [x, y, pol, t]
events = getEvents()

% The amount of time between each frame? Hard-coded to 10000 microseconds
% in Rob's original code.
global FRAMETIME = 10000;

%get dimensions of events matrix
[xsize, ysize] = size(events);
%set figure properties
video = figure('color','white');
%find out the starting timestamp (in microseconds)
plottime = events(1,4)

%set entire events matrix to int32
% Not sure why this is necessary.
events = int32(events);

%set figure to grayscale
colormap(gray)

for j = 1:xsize
    % Break data into FRAMETIME microsecond blocks
    ind = find(events(:,4) >= plottime & events(:,4)<=plottime+FRAMETIME);
    plottime = plottime + FRAMETIME;
    
    %set up the background for the matrix to display
    background = zeros(128,128);
   
   %for each set of FRAMETIME microsecond blocks of data, adjust the zeros
   %matrix to account for the changed events in that time block (-1 or 1)
   %and finally adjust to values between 0 and 255 (grayscale values)
   for k = ind(1,1):ind(size(ind),1)
       background(events(k,2)+1, events(k,1)+1) = events(k,3);
   end
   
   %set up the escape root for the for loop (I need to change this)
    if plottime > events(xsize,4)
        break;
    end
    %end
    %set the size of the image
    xlim([0, 128])
    ylim([0, 128])
    
    %display the stuff in real time (not sure if necessary yet)
    drawnow;
    %flip the images the correct way around again
    background = flipud(background);
    %actually display the images at the speed of the for loop
    imagesc(background);
end