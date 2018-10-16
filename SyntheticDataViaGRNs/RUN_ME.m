%% Entry file for simulation on PN1 and PN2
% generate estimation errors; this will produced mat files
%   "PN1.mat" and "PN2.mat"
%
% C. Sima simachao@tamu.edu
% June 19, 2017


%% Add path "functions"
clc;close all; clearvars;
func_dir = fullfile('.','functions');
addpath(genpath(func_dir));

tic




%% Run

for pn=1:2

    params = set_params(pn); 
    experiment = create_experiment(params);

    sg = SampleGenerator(params);
    sg = sg.set_ssd();

    caseOfGenes = height(experiment{1});
    caseOfNnC = height(experiment{2});
    caseOfSimulations = height(experiment{3});

    caseCounter = 1;
    caseTotal = caseOfGenes*caseOfNnC*caseOfSimulations*numel(params.nGenesSelect);
    errs = cell(1,caseTotal);
    caseStrings = cell(1,caseTotal);

    for i=1:caseOfGenes 
        assert(experiment{1}.D(i) == sg.nGenes);

        sg = sg.set_generator_parameters();

        for j=1:caseOfNnC
            sg.nSamples = experiment{2}.N(j);
            sg.nCells = experiment{2}.nC(j);



            % setup cv and options
            cvk = params.cvk;
            opts = statset('display','off','UseParallel',true);
 
            for k=1:caseOfSimulations

                switch experiment{3}.CL{k}
                    case 'LDA'
                        fun = @(XT,yT,Xt,yt) (sum(yt ~= classify(Xt,XT,yT,'linear')));
                    case 'QDA'
                        fun = @(XT,yT,Xt,yt) (sum(yt ~= classify(Xt,XT,yT,'quadratic')));
                end

                errorRates = zeros(params.repeats,3,numel(params.nGenesSelect));
                fprintf('Processing: D=%d,N=%d,nC=%d,%s [clock %s]\n',sg.nGenes,sg.nSamples,sg.nCells,experiment{3}.CL{k},string(datetime('now')));
                for r=1:params.repeats
                    if mod(r,params.printInfoMod)==0
                        fprintf('%s (%d out of %d)\n',string(datetime('now')),r,params.repeats);
                    end

                    sg = sg.generate_samples('training');
                    c = cvpartition(sg.label,'k',cvk);
                    
                    dMax = max(params.nGenesSelect);
                    history = cell(1,3);
                    [~,history{1}] = sequentialfs(fun,sg.data,sg.label,'cv',c,'options',opts,'nfeatures',dMax,'keepout',~sg.bool_moment1);
                    [~,history{2}] = sequentialfs(fun,sg.data,sg.label,'cv',c,'options',opts,'nfeatures',dMax,'keepout',~(sg.bool_moment1|sg.bool_moment2|sg.bool_moment3));
                    [~,history{3}] = sequentialfs(fun,sg.data,sg.label,'cv',c,'options',opts,'nfeatures',dMax);
                    
                    sgt = sg.generate_samples('testing');%true error
                    for d=1:numel(params.nGenesSelect)
                                             
                        for h=1:3                          
                            %true error: %[history1.In(end,:); history2.In(end,:); history3.In(end,:)]
                            boolFeatures = history{h}.In(params.nGenesSelect(d),:);
                            errorRates(r,h,d) = fun(sg.data(:,boolFeatures),sg.label,sgt.data(:,boolFeatures),sgt.label)/params.nSamplesTest;
                        end                              
                    end
             
                end
                
                for d=1:numel(params.nGenesSelect)

                    errs{caseCounter} = squeeze(errorRates(:,:,d)); 
                    caseStrings{caseCounter} = sprintf('D=%d,d=%d,N=%d,nC=%d,%s',sg.nGenes,params.nGenesSelect(d),sg.nSamples,sg.nCells,experiment{3}.CL{k});

                    caseCounter = caseCounter + 1;
                end
 
            end
        end
 
    end



    save(['PN' num2str(pn) '.mat'],'errs','caseStrings');


end

%% Clean up: remove path "functions"
rmpath(genpath(func_dir));
toc
    





