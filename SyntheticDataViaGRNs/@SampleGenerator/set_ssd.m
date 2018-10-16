function self = set_ssd( self )
%
% C. Sima simachao@tamu.edu
% June 19, 2017

    
%ssd_pis: ssd's are computed [2 x 2^G]


    fprintf('loading from %s\n',self.ssd_pi_matfile);
    loaded_ssd = load(self.ssd_pi_matfile);
    ssd_pis = loaded_ssd.ssd_pis;
    
    self.ssd_pi = ssd_pis;


end

