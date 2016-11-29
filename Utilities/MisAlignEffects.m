clc;clear;
windVel = [3:11,11.3,12:25]';
windRat = 11.3;
load('matlabPlotConfiguration');
load('Norway5');
MODEL2NAME = 'SNL300';
QoiChannels = [15:20,31,33,49,50,55:60];
% QoiChannels = [15:20,31,45,46,65,66,81,82,97:98,113,114,129,130,145,146];
NseaStates = 24;
Nsim     = 10;
BETAWAVE = {[MODEL2NAME,num2str(00, '%02.0f'),num2str(Nsim, '%02.0f')], ...
            [MODEL2NAME,num2str(30, '%02.0f'),num2str(Nsim, '%02.0f')], ...
            [MODEL2NAME,num2str(60, '%02.0f'),num2str(Nsim, '%02.0f')], ...
            [MODEL2NAME,num2str(90, '%02.0f'),num2str(Nsim, '%02.0f')]};
for ibeta = 1 : size(BETAWAVE,2)
    MODELNAME = BETAWAVE{1,ibeta};
    load(MODELNAME);
    
    Max4AllChannels = MODEL.max(:, QoiChannels);
    % reset all 0 values to NaN
%     Max4AllChannels(Max4AllChannels==0) = NaN;
    % Four statistics for each sea states [max, mean, std, Nsamples, median, 90 percentile]
    MaxStats4AllChannels = zeros(NseaStates , size(QoiChannels,2)* 6);
    
    for iseaState = 1 : NseaStates
        dataTemp = Max4AllChannels((iseaState-1)*Nsim +1:iseaState*Nsim, :);
        sizeTemp = size(QoiChannels,2);
        MaxStats4AllChannels( iseaState, sizeTemp*0+1:sizeTemp*1) = max (dataTemp,[],  'omitnan');
        MaxStats4AllChannels( iseaState, sizeTemp*1+1:sizeTemp*2) = mean(dataTemp,     'omitnan');
        MaxStats4AllChannels( iseaState, sizeTemp*2+1:sizeTemp*3) = std (dataTemp,     'omitnan');
        MaxStats4AllChannels( iseaState, sizeTemp*3+1:sizeTemp*4) = Nsim - sum(isnan(dataTemp), 1);
        MaxStats4AllChannels( iseaState, sizeTemp*4+1:sizeTemp*5) = prctile(dataTemp,50);
        MaxStats4AllChannels( iseaState, sizeTemp*5+1:sizeTemp*6) = prctile(dataTemp,90);
    end
    MaxStats4Models{ibeta, 1} = MaxStats4AllChannels;
end

%% Variability mean / std
iQoi = 1;
for iQoi = 1 : size(QoiChannels, 2)
    figure('Position',[11 100 800 600])
    % Aligned wind wave as base model
    BaseModel = MaxStats4Models{1, 1};
    BaseMax      = BaseModel(:, iQoi + size(QoiChannels,2)*0);
    BaseMean     = BaseModel(:, iQoi + size(QoiChannels,2)*1);
    BaseStd      = BaseModel(:, iQoi + size(QoiChannels,2)*2);
    % QoiNsamples = BaseModel(:, iQoi + size(QoiChannels,2)*3);
    QoiName = headers{1, QoiChannels(iQoi)};
    QoiUnit = headers{2, QoiChannels(iQoi)};
    ylableLeft = [QoiName,' ',QoiUnit];
    for ibeta = 1 : 4
        QoiStats    = MaxStats4Models{ibeta, 1};
        QoiMax      = QoiStats(:, iQoi + size(QoiChannels,2)*0);
        QoiMean     = QoiStats(:, iQoi + size(QoiChannels,2)*1);
        QoiStd      = QoiStats(:, iQoi + size(QoiChannels,2)*2);
        QoiNsamples = QoiStats(:, iQoi + size(QoiChannels,2)*3);
        yyaxis left
        errorbar(windVel,QoiMean,QoiStd,'-s','MarkerSize',8,'LineWidth', 1,...
        'Color',plotColor{ibeta}, 'MarkerEdgeColor',plotColor{ibeta},'MarkerFaceColor',plotColor{ibeta})
        yyaxis right
        Normed = QoiStd ./ BaseStd;
        plot(windVel, Normed ,'-s','LineWidth', 1, 'Color',plotColor{ibeta},'MarkerSize',4)
        hold on
    end
    legend('\beta = 0   deg','\beta = 30 deg','\beta = 60 deg','\beta = 90 deg')
    % rectangle('Position',[11 0 8 7e4],'EdgeColor','g','LineWidth',1)
    xlim([2.5 25.5])
    % hold on
    % plot(ones(1e5,1)*windRat,(0:1e5)');
    title({'E[Y] ± \sigma[Y] at each wind speed with misaligned wave-wind direction', 'Y: Median of 50-yr extreme value distribution'})
    yyaxis left
    ylabel(ylableLeft)
    yyaxis right
    ylim([0 6])
    % grid on
    ylabel('Normalized \sigma (w.r.t \beta = 0 deg)')
    xlabel('Wind speed [m/s]')
    set(gca,'FontSize',15)
    set(findall(gcf,'type','text'),'FontSize',15)
%     saveas(gcf, [QoiName,'.eps'])
    saveas(gcf, [QoiName,'.png'])
    saveas(gcf, [QoiName,'.fig'])
    close all
end
%% Critical Sea States
%critical sea state, sea state corresponding to the max median.
% beta, Uhub, Hs, Tp
CrtSeaStates = zeros(4 * size(QoiChannels, 2), 4);
for iQoi = 1 : size(QoiChannels, 2)
  
%     QoiName = headers{1, QoiChannels(1, iQoi)};
%     QoiUnit = headers{2, QoiChannels(1, iQoi)};
%     ylableLeft = [QoiName,' ',QoiUnit];
    for ibeta = 1 : 4
        QoiStats    = MaxStats4Models{ibeta, 1};

        Qoi50prc    = QoiStats(:, iQoi + size(QoiChannels,2)*4);

        [CrtVal, CrtInd] = max(Qoi50prc);
        CrtSeaStates(4 * (iQoi -1) + ibeta, :) = [CrtVal, phyRvs(CrtInd, :)];
    end
end
save(['CrtSeaStates',MODEL2NAME(end - 2: end),'.mat'], 'CrtSeaStates')
%% Variability 50/90 percentile
% QoiChannels = [15:20,31,46,51];
% ylimits = [ylimleft_Low, ylimleft_Up, ylimtright_Low, ylimtright_Up]
% ylimits  = zeros(size(headers, 2), 4);
% ylimleft = [6,40; -1,6.5; 1,3; -2,3; 0.5,5; 1,8; 1.5e4,6.5e4;2e5,6e5;2400,4400];
% ylimright= [1,1.9; 1,6.5; 1,2;  1, 2; 1, 2 ; 1,2; 1, 2; 1, 2; 1, 2];
% for iQoi = 1 : size(QoiChannels, 2)
%    ylimits(QoiChannels(1, iQoi), :) = [ylimleft(iQoi, :), ylimright(iQoi, :)];
% end
% close all
load('ylimits')

for iQoi = 1 : size(QoiChannels, 2)
    figure('Position',[11 100 800 600])
    
    QoiName = headers{1, QoiChannels(1, iQoi)};
    QoiUnit = headers{2, QoiChannels(1, iQoi)};
    ylableLeft = [QoiName,' ',QoiUnit];
    for ibeta = 1 : 4
        QoiStats    = MaxStats4Models{ibeta, 1};
        QoiMax      = QoiStats(:, iQoi + size(QoiChannels,2)*0);
        QoiMean     = QoiStats(:, iQoi + size(QoiChannels,2)*1);
        QoiStd      = QoiStats(:, iQoi + size(QoiChannels,2)*2);
        QoiNsamples = QoiStats(:, iQoi + size(QoiChannels,2)*3);
        Qoi50prc    = QoiStats(:, iQoi + size(QoiChannels,2)*4);
        Qoi90prc    = QoiStats(:, iQoi + size(QoiChannels,2)*5);
        QoiPrcRatio = Qoi90prc ./ Qoi50prc;
        [CrtVal, CrtInd] = max(Qoi50prc);
        CrtSeaStates(4 * (iQoi -1) + ibeta, :) = [CrtVal, phyRvs(CrtInd, :)];
        yyaxis left
%         errorbar(windVel,Qoi50prc,Qoi90prc - Qoi50prc,'-s','MarkerSize',8,'LineWidth', 1,...
%         'Color',plotColor{imodel}, 'MarkerEdgeColor',plotColor{imodel},'MarkerFaceColor',plotColor{imodel})
        plot(windVel,Qoi50prc,'-s','MarkerSize',8,'LineWidth', 1,...
        'Color',plotColor{ibeta}, 'MarkerEdgeColor',plotColor{ibeta},'MarkerFaceColor',plotColor{ibeta})
        yyaxis right
%         Normed = QoiStd ./ BaseStd;
        plot(windVel, QoiPrcRatio ,'-s','LineWidth', 1, 'Color',plotColor{ibeta},'MarkerSize',4)
        hold on
%         cmap = colormap(jet(101));
%         
%         plot(windVel, Qoi50prc ,'-','LineWidth', 1, 'Color',plotColor{imodel},'MarkerSize',4)
%         hold on
% %         plot(windVel, Qoi50prc,'.', 'Color', cmap(floor((QoiPrcRatio-min(QoiPrcRatio))/(max(QoiPrcRatio)-min(QoiPrcRatio))*100)+1,:), 'MarkerSize', 30)
%         
%         scatter(windVel, Qoi50prc, 20, QoiPrcRatio, 'filled');
%         colorbar
%         
        
    end
    legend('location','northwest','\beta = 0   deg','\beta = 30 deg','\beta = 60 deg','\beta = 90 deg')
%     legend('location','northwest');
    % rectangle('Position',[11 0 8 7e4],'EdgeColor','g','LineWidth',1)
    xlim([2.5 25.5])

    title({'50^{th}, 90^{th} percentile of Y samples with misaligned wave-wind direction',...
            'y_i: Max value of 2-hour simulation, i = 1,..,10'})
    yyaxis left
%     ylim([-200000,ylimits(QoiChannels(1, iQoi),2)])
%     ylim([ylimits(QoiChannels(1, iQoi),1),ylimits(QoiChannels(1, iQoi),2)])
    ylabel(ylableLeft)
    yyaxis right
%     ylim([ylimits(QoiChannels(1, iQoi),3),ylimits(QoiChannels(1, iQoi),4)])
    grid on
    ylabel('Ratio: [P_{90} / P_{50}]')
    xlabel('Wind speed [m/s]')
    set(gca,'FontSize',15)
    set(findall(gcf,'type','text'),'FontSize',15)
    saveas(gcf, [QoiName,MODEL2NAME(end-2:end),'.eps'],'epsc')
    saveas(gcf, [QoiName,MODEL2NAME(end-2:end),'.png'])
    saveas(gcf, [QoiName,MODEL2NAME(end-2:end),'.fig'])
    close all
end

























