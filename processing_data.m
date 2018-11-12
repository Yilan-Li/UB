%Script to read out data from multiple FluEgg results files
%-----------------------------------------------------------
clear,clc
depth(:,1)=linspace(-3,0,50);

%This for loop iterates for the number of files you want to read data from.
%The files from the batch process are labeled as
%"Results_What-you-called-the-file_time_dt_run #-of-run.mat"
for i=1:3
    %Turn the number into a string so we can read the file name
    numofrun=num2str(i)
    %The files are located in the folder that FluEgg saves them to, so the
    %below line is the name of the folder and then the name of an
    %individual file
    file=fullfile('results\Results_Test_1h_6s',sprintf('Results_Test_1h_6srun %s.mat',numofrun))
    %load the file into MatLab
    load(file)
    %Read in the size of the arrays I will be saving in order to allocate
    %space to my variable arrays
    [m n]=size(ResultsSim.Z);
    %Saving the vertical position of the eggs at the final simulated time.
    EggPos=ResultsSim.Z(m,:);
    %Calculating the histogram of the vertical egg position
    h=histogram(EggPos,50,'BinLimits',[-3 0]);
    %Translate number of eggs in histogram to fraction of eggs
    per_of_eggs(:,i)=(get(h,'Values'))./n;
    %save time array
    time(:,1)=ResultsSim.time;
    for j=1:m
        %Save the longitudinal and vertical centroids from each file
        Xcentroid(j,i)=mean(ResultsSim.X(j,:));
        ZHcentroid(j,i)=mean(ResultsSim.Z(j,:))/3;
    end
end

%Find average + std.dev. of vertical distribution
for i=1:50
    per_of_eggs_ave(i,1)=mean(per_of_eggs(i,:));
    std_vert_dist(i,1)=std(per_of_eggs(i,:));
end

%Find average + std.dev. x and z of centroids
for i=1:m
    Xcentroid_ave(i,1)=mean(Xcentroid(i,:));
    std_x_cent(i,1)=std(Xcentroid(i,:));
    ZHcentroid_ave(i,1)=mean(ZHcentroid(i,:));
    std_zh_cent(i,1)=std(ZHcentroid(i,:));
end


