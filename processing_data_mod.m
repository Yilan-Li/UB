%Script to read out data from multiple FluEgg results files
%-----------------------------------------------------------
clear,clc
%USER INPUTS TO CONTROL READING IN FILES
prompt={'Enter name of Folder containing FluEgg Results:','Enter the total number of files:','Enter the number of any missing files, separated by commas if more than one:'};
dlg_title='INPUT';
num_lines=1;
answer=inputdlg(prompt,dlg_title,num_lines)
dirName=char(answer(1));%name of folder housing files
numOfFiles=str2double(answer(2));%Number of files to process
missingFiles=str2double(answer(3));%array of any missing files

%This for loop iterates for the number of files you want to read data from.
%The files from the batch process are labeled as
%"Results_What-you-called-the-file_time_dt_run #-of-run.mat"
k=0;
for i=1:numOfFiles
    
    %Check if it is a missing file
    flag=0;
    for ii=1:length(missingFiles)
        if i==missingFiles(ii)
            flag=1;
        end
    end
    if flag == 0
        k=k+1;
        %Turn the number into a string so we can read the file name
        numofrun=num2str(i)
        %The files are located in the folder that FluEgg saves them to, so the
        %below line is the name of the folder and then the name of an
        %individual file
        file=fullfile(dirName,strcat(dirName,sprintf('run %s.mat',numofrun)))

        %load the file into MatLab
        load(file)

        %Calculate mean, LE, and TE at last time step
        ProcessedData(k,1)=i;
        ProcessedData(k,2)=mean(ResultsSim.X(end,:));%mean X
        ProcessedData(k,3)=max(ResultsSim.X(end,:));%LE X
        ProcessedData(k,4)=min(ResultsSim.X(end,:));%TE X
        ProcessedData(k,5)=mean(ResultsSim.Y(end,:));%mean Y
        ProcessedData(k,6)=max(ResultsSim.Y(end,:));%LE Y
        ProcessedData(k,7)=min(ResultsSim.Y(end,:));%TE Y
        ProcessedData(k,8)=mean(ResultsSim.Z(end,:));%mean Z
        ProcessedData(k,9)=max(ResultsSim.Z(end,:));%LE Z
        ProcessedData(k,10)=min(ResultsSim.Z(end,:));%TE Z
        ProcessedData(k,11)=ResultsSim.CumlDistance(end);%Cumulative Distance
        ProcessedData(k,12)=ResultsSim.Temp(end);%Temperature
    end
end

data2export=num2cell(ProcessedData);
datawheaders=vertcat([cellstr('Identifier'),cellstr('Mean X (m)'),cellstr('LE X (m)'),cellstr('TE X (m)'),cellstr('Mean Y (m)'),cellstr('LE Y (m)'),cellstr('TE Y (m)'),cellstr('Mean Z (m)'),cellstr('LE Z (m)'),cellstr('TE Z (m)'),cellstr('Cumulative Distance (m)'),cellstr('Temperature (C)')],data2export);
xlswrite(strcat(dirName,'PROCESSED.xls'),datawheaders)

    
    
%     %Saving the vertical position of the eggs at the final simulated time.
%     EggPos=ResultsSim.Z(m,:);
%     %Calculating the histogram of the vertical egg position
%     h=histogram(EggPos,50,'BinLimits',[-3 0]);
%     %Translate number of eggs in histogram to fraction of eggs
%     per_of_eggs(:,i)=(get(h,'Values'))./n;
%     %save time array
%     time(:,1)=ResultsSim.time;
%     for j=1:m
%         %Save the longitudinal and vertical centroids from each file
%         Xcentroid(j,i)=mean(ResultsSim.X(j,:));
%         ZHcentroid(j,i)=mean(ResultsSim.Z(j,:))/3;
%     end
% end
% 
% %Find average + std.dev. of vertical distribution
% for i=1:50
%     per_of_eggs_ave(i,1)=mean(per_of_eggs(i,:));
%     std_vert_dist(i,1)=std(per_of_eggs(i,:));
% end
% 
% %Find average + std.dev. x and z of centroids
% for i=1:m
%     Xcentroid_ave(i,1)=mean(Xcentroid(i,:));
%     std_x_cent(i,1)=std(Xcentroid(i,:));
%     ZHcentroid_ave(i,1)=mean(ZHcentroid(i,:));
%     std_zh_cent(i,1)=std(ZHcentroid(i,:));
% end


