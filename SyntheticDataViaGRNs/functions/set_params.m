function params = set_params(pn)
%
% C. Sima simachao@tamu.edu
% June 19, 2017


    params.PN = pn;
    
    switch pn
        case 1
            params.nGenes = 10;       
        case 2
            params.nGenes = 7;
    end

    
    
    params.nGenesSelect = [3 4 5];
    
    %num of samples
    params.nSamples = [25 50 100]; %n1=n2=params.nSamples
    
    %num of cellss
    params.nCells = 200;

    
    
    % classification
    %params.classifiers = {'QDA'};
    params.classifiers = {'LDA','QDA'};
    params.error_estimators = {'True'};
    
    
    
    params.repeats = 500;
    params.cvk = 5;
    
    
    
    %SampleGenerator
    params.nClass = 2;
    params.nMoments = 3;
        
    %mu
    params.state_mu_base = [10 12];
    params.state_mu_dither = [0 0.5];
    %sig
    params.state_sig_base = 1.5*[1 1];
    params.state_sig_dither = [0 0];

    %ssd
    params.ssd_pi_matfile = ['pn' num2str(pn) '_ssd_pi.mat'];

    params.nCellsDither = 25;
    params.nSamplesTest = 1000;
    
    
    params.printInfoMod = floor(params.repeats/5);


end

