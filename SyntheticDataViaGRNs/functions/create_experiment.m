function experiment = create_experiment( params )
%
% C. Sima simachao@tamu.edu
% June 19, 2017


experiment = cell(1,3);

 
%% tier 1: params.nGenes
 
 x1 = ndgrid(1:length(params.nGenes));
 D = params.nGenes(x1(:));
 experiment{1} = table(D(:),'VariableNames',{'D'});
 
 
%% tier 2: params.nSamples, params.nCells
 
 [x3,x4] = ndgrid(...
     1:length(params.nSamples),...
     1:length(params.nCells));

 N = params.nSamples(x3(:));
 nC = params.nCells(x4(:));
 
 experiment{2} = table(N(:),nC(:),'VariableNames',{'N' 'nC'});
 
 
%% tier 3

 [x5,x6] = ndgrid(...
     1:length(params.classifiers),...
     1:length(params.error_estimators));


 classifiers = params.classifiers(x5(:));
 errorEstimators = params.error_estimators(x6(:));
 

 experiment{3} = table(classifiers(:),errorEstimators(:),...
    'VariableNames',{'CL' 'ER'});


%% show
%     for i=1:3
%         disp(experiment{i});
%         
%         %     D 
%         %     __
%         % 
%         %     10
%         % 
%         %     N     nC 
%         %     __    ___
%         % 
%         %     25    200
%         %     50    200
%         % 
%         %      CL         ER   
%         %     _____    ________
%         % 
%         %     'LDA'    'True'
%         %     'QDA'    'True'
%     
%     end


end

