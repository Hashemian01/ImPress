clc;
clear;
close all;
thereshold=0.5;
resizefact=1;
jpegFiles = dir('*.jpg'); 
numfiles = length(jpegFiles);
mydata = cell(1, numfiles);
Flag=3;
color_flag=1; % 1 = monocolor, 2= multicolor
for k = 1:numfiles 
    mydata{k} = imread(jpegFiles(k).name);
    switch color_flag
        case 1
          switch Flag
              case 1
                  mydata{k}=imbinarize(mydata{k},thereshold);
              case 2
                  mydata{k}=imbinarize(mydata{k},'global'); %Otsu Method
              case 3
                  mydata{k}=imbinarize(mydata{k},'adaptive','ForegroundPolarity','dark','Sensitivity',0.4); 
                  % 1- 'Sensitivity' : more sensitivity = Darker
                  % 2- 'ForegroundPolarity' : 'bright',The foreground is brighter than the background. (default)
                  % 'dark' ,The foreground is darker than the background
              case 4 
                  thereshold = adaptthresh(mydata{k},0.5,'ForegroundPolarity','dark','NeighborhoodSize',25);
                  mydata{k}=imbinarize(mydata{k},thereshold);
          end
          mydata{k}=bwmorph(mydata{k},'skel');
          mydata{k}=bwmorph(mydata{k},'thicken');
          mydata{k}=bwmorph(mydata{k},'fill');
          mydata{k}= imresize(mydata{k},resizefact);
          imwrite(mydata{k},[num2str(k) '.bmp']);
          disp([num2str(k) ' from ' num2str(numfiles)])
        case 2
            threshRGB = multithresh(mydata{k},6);
            value = [0 threshRGB(2:end) 255];
            mydata{k} = imquantize(mydata{k}, threshRGB, value);
            mydata{k}= imresize(mydata{k},resizefact);
            imwrite(mydata{k},[num2str(k) '.bmp']);
            disp([num2str(k) ' from ' num2str(numfiles)])
            
    end
end
fclose('all');