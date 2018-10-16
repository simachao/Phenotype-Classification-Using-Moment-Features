classdef SampleGenerator
%
% C. Sima simachao@tamu.edu
% June 19, 2017

    properties
        nSamples
        nCells
    end
    
    properties %param
        nGenes
        
        nClass
        nMoments
        
        %mu
        state_mu_base
        state_mu_dither
        %sig
        state_sig_base
        state_sig_dither
        
        %ssd
        ssd_pi_matfile
        
        nCellsDither
        nSamplesTest
    end
    
    properties
        ssd_pi
        
        muG
        sigG
        
        nMixMoments
    end
    
    properties % sample data
        nFeatureSize_full
        bool_moment1
        bool_moment2
        bool_moment3
        feature_names
        
        sampleType
        data
        label
    end
    
    
    methods
        function self = SampleGenerator(iParam)
            self.nGenes = iParam.nGenes;
            self.nClass = iParam.nClass;
            self.nMoments = iParam.nMoments;

            %mu
            self.state_mu_base = iParam.state_mu_base;
            self.state_mu_dither = iParam.state_mu_dither;
            %sig
            self.state_sig_base = iParam.state_sig_base;
            self.state_sig_dither = iParam.state_sig_dither ;

            %ssd
            self.ssd_pi_matfile = iParam.ssd_pi_matfile;

            self.nCellsDither = iParam.nCellsDither;
            self.nSamplesTest = iParam.nSamplesTest;
        end
    end
end

