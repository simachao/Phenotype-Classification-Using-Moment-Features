%test on data

genes = {'ERBB2', 'ERBB3'};

%key parameters

rep = 10;

fold = 10;


for ind = 1 : length(genes)
    
    
    gene = genes{ind};
    
    gene
    
    filename = strcat('./HT-29.VS.HCT116.', gene, '.data.csv');
    
    dataset = csvread(filename, 1, 0);
    
    filename = strcat('./HT-29.VS.HCT116.', gene, '.label.csv');
    
    labelset = csvread(filename, 1, 0);
    
    fun = @(XT,yT,Xt,yt) (sum(yt ~= classify(Xt,XT,yT,'linear')));
        
    
    er = zeros(1, 7);
        
    for i = 1 : rep
        
        i;
        
        cp = cvpartition(labelset,'KFold',fold); % Stratified cross-validation
        
        cfMat = crossval(fun, transpose(dataset(1, :)), labelset, 'partition', cp);
        er(1) = er(1) + sum(cfMat);
        
        cfMat = crossval(fun, transpose(dataset(2, :)), labelset, 'partition', cp);
        er(2) = er(2) + sum(cfMat);
        
        cfMat = crossval(fun, transpose(dataset(3, :)), labelset, 'partition', cp);
        er(3) = er(3) + sum(cfMat);
        
        cfMat = crossval(fun, transpose(dataset(1:2, :)), labelset, 'partition', cp);
        er(4) = er(4) + sum(cfMat);
        
        cfMat = crossval(fun, transpose(dataset([1,3], :)), labelset, 'partition', cp);
        er(5) = er(5) + sum(cfMat);
        
        cfMat = crossval(fun, transpose(dataset(2:3, :)), labelset, 'partition', cp);
        er(6) = er(6) + sum(cfMat);
        
        cfMat = crossval(fun, transpose(dataset), labelset, 'partition', cp);
        er(7) = er(7) + sum(cfMat);
        
    end
    
    %save results as csv file
    
    er = er / rep / length(labelset);
    
    filename = strcat('./HT-29.VS.HCT116.', gene, '.classifierLDA.fold', num2str(fold), '.rep', num2str(rep), '.error.csv');
    
    file = fopen(filename,'w');
    
    fprintf(file, 'mean, var, skew, mean+var, mean+skew, var+skew, mean+var+skew\n');
    
    for i=1:6
        fprintf(file,'%f,',er(i));
    end
    fprintf(file, '%f\n', er(7));
    
    fclose(file);
    
end