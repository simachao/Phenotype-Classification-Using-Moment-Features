function self = generate_samples(self,sampleType)
%
% C. Sima simachao@tamu.edu
% June 19, 2017


    % data
    % --- m1 ---|--- m2 ---|--- m3 ---| --- m11 ---| 
    % |
    % |
    % |  class 1 (nSamples)
    % |
    % |
    % _______________________________________________
    % |
    % |
    % |  class 2 (nSamples)
    % |
    % |
    
    % label
    % 1
    % 1
    % 1
    % 1
    % 1
    % --
    % 2
    % 2
    % 2
    % 2
    % 2
    
    

    %N: each class
    switch sampleType
        case 'training'
            N = self.nSamples; 
        case 'testing'
            N = self.nSamplesTest;
        case 'training+testing'
            N = self.nSamples+self.nSamplesTest;
    end


    data = zeros(self.nClass*N,self.nFeatureSize_full);
    label = zeros(self.nClass*N,1);
    
    for c=1:self.nClass
        
        ssd = self.ssd_pi(c,:);
        
        %first moment
        data1 = zeros(N,self.nGenes);
        %second moment
        data2 = data1;
        %third moment
        data3 = data1;
        %mix moment
        data11 = zeros(N,self.nMixMoments);
        
        
        for i=1:N
            %generate "nC" cells
            nC = self.nCells + floor(2*self.nCellsDither*rand(1)-self.nCellsDither);
            
            mnrv = mnrnd(1,ssd,nC);
            rownum = 1:nC;
            stateAsDec = splitapply(@find,mnrv',findgroups(rownum)); %1xN vector
            stateAsDec = stateAsDec - 1;
            stateAsBin = dec2bin(stateAsDec,self.nGenes); %NxG char
            stateAs01 = stateAsBin == '1';%NxG bool
            
            
            mu_full = ~stateAs01.*repmat(self.muG(1,:),nC,1) + stateAs01.*repmat(self.muG(2,:),nC,1);
            sig_full = ~stateAs01.*repmat(self.sigG(1,:),nC,1) + stateAs01.*repmat(self.sigG(2,:),nC,1);
            
            x = randn(nC,self.nGenes).*sig_full + mu_full;
            
            covM = cov(x);
            diagM = diag(covM);
            data1(i,:) = mean(x,1);
            data2(i,:) = diagM(:)'; %std(x,[],1);
            data3(i,:) = skewness(x);
            
            upperM = triu(covM,1);
            upperM = upperM(:);
            upperM = upperM(upperM ~= 0);
            data11(i,:) = upperM(:)';
        end
        
        
        
        
        
        data((c-1)*N+1:c*N,:) = [data1 data2 data3 data11];
        label((c-1)*N+1:c*N) = c;
        
    end
    
    
    
    self.sampleType = sampleType;
    self.data = data;
    self.label = label;
    
end

