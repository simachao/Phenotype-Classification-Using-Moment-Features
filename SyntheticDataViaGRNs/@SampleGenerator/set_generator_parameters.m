function self = set_generator_parameters( self )
%
% C. Sima simachao@tamu.edu
% June 19, 2017


    %% Gaussian function
    muG = zeros(2,self.nGenes);
    for i=1:2
        for j=1:self.nGenes
            muG(i,j) =self.state_mu_base(i) + 2*self.state_mu_dither(i)*rand(1)-self.state_mu_dither(i);
        end   
    end        
    
    
    sigG = zeros(2,self.nGenes);
    for i=1:2
        for j=1:self.nGenes
            sigG(i,j) =self.state_sig_base(i) + 2*self.state_sig_dither(i)*rand(1)-self.state_sig_dither(i);
        end   
    end        
    
    self.muG = muG;
    self.sigG = sigG;
    
    
    %% moments
    self.nMixMoments = nchoosek(self.nGenes,2);
    self.nFeatureSize_full = self.nMoments*self.nGenes+self.nMixMoments;
    
    assert(self.nMoments==3);
    self.bool_moment1 = false(1,self.nFeatureSize_full);
    self.bool_moment1(1:self.nGenes) = true;
    self.bool_moment2 = false(1,self.nFeatureSize_full);
    self.bool_moment2(1+self.nGenes:2*self.nGenes) = true;
    self.bool_moment3 = false(1,self.nFeatureSize_full);
    self.bool_moment3(1+2*self.nGenes:3*self.nGenes) = true;
    self.feature_names = cell(1,self.nFeatureSize_full);
    counter = 1;
    for i=1:self.nMoments
        for j=1:self.nGenes
            self.feature_names{counter} = ['G' num2str(j,'%.2d') '-' num2str(i)];
            counter = counter+1;
        end
    end
    for j=1:self.nGenes
        for i=1:j-1
            self.feature_names{counter} = ['G' num2str(i,'%.2d') num2str(j,'%.2d')];
            counter = counter+1;
        end
    end
    
    
    
end

