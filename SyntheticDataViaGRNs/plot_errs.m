%% Plotting script for PN1 and PN2
% plot estimation error distributions
% This will read "PN1.mat" or "PN2.mat" produced by RUN_ME.m and
% generate plots in folder PN1 or PN2.
%
% C. Sima simachao@tamu.edu
% June 19, 2017


close all; clearvars;

PN_select = 1;
switch PN_select
    case 1
        matfile = 'PN1.mat';
        fig_folder = 'PN1/';
    case 2
        matfile = 'PN2.mat';
        fig_folder = 'PN2/';
end

%load
loaded = load(matfile);
errs = loaded.errs;
caseStrings = loaded.caseStrings;
assert(length(errs) == length(caseStrings));


% figure settings
line_colors = [...
    0    0.4470    0.7410;...
    0.8500    0.3250    0.0980;...
    0.9290    0.6940    0.1250;...
    ];
avgBarHeight = 1;
avgFontSize = 12;
%run
for i=1:length(caseStrings)
    
    matchStruct = regexp(caseStrings{i},'N=(?<N>\d+),','names');
    N = matchStruct.N;
    
    
    switch PN_select
        case 1
            switch str2double(N)
                case 25
                    xticks = 0:0.05:0.5;
                case {50,100}
                    xticks = 0:0.05:0.3;
            end
        case 2
            switch str2double(N)
                case 25
                    xticks = 0:0.03:0.24;
                case {50,100}
                    xticks = 0:0.02:0.14;
            end
    end
    

        
    
    avg = mean(errs{i},1);
    %sd = std(errs{i},[],1);

    % density
    figure;hold on;
    for j=1:3
        errThis = errs{i}(:,j);
        [fi,xi] = ksdensity(errThis);
        plot(xi,fi,'LineWidth',5,'Color',line_colors(j,:));
    end
    
    % legend
    legendTxt = cell(1,3);
    for j=1:3
        %legendTxt{j} = sprintf('$\\mathcal{D}_%d (\\mu=%.4f)$',j,avg(j));
        legendTxt{j} = sprintf('$\\mathcal{D}_%d$',j);
    end
    %legendTxt
    %h=legend({'$\mathcal{D}_1$','$\mathcal{D}_2$','$\mathcal{D}_3$'},'Interpreter','latex');
    h=legend(legendTxt,'Interpreter','latex');
    set(h,'FontSize',20); 
    
    % mean label
    for j=1:3      
        plot([avg(j) avg(j)],[0 avgBarHeight],'LineWidth',2,'Color',line_colors(j,:));
    end
	hold off;
    
    
    xlim(xticks([1 end]));
    set(gca,'YTick',[],'XTick',xticks);
    saveas(gcf,[fig_folder caseStrings{i}],'epsc');
    close(gcf);
    
    
    %latex
    if mod(i,3)==1
        fprintf('\n%s',caseStrings{i});
    end
    for j=1:3    
        fprintf('&%.4f',avg(j));
    end

end
fprintf('\n');