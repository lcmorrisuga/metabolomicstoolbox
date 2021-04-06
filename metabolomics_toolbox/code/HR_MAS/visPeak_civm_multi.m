        % Add Public toolbox
            addpath(genpath('/Users/mjudge/Edison_Lab_Shared_Metabolomics_UGA')) 
        % Remove Private toolbox
            rmpath(genpath('/Users/mjudge/Edison_lab_UGA'))
            pause(1),clc

%% Get the datasets

    cd('/Users/mjudge/Dropbox (Edison_Lab@UGA)/Projects/clock/CIVM_paper_2/Acetate_QAX_project/NMRdata/processed')

    experiments = {'civm_ncrassa_qax_02';
                'civm_ncrassa_qax_03';
                'CIVM_ncrassa_qax_06_pgm2_gluc_1';
                'CIVM_ncrassa_qax_08';
                'CIVM_ncrassa_qax_10';
                'CIVM_ncrassa_qax_11';
                'paper_Sample_4'};
            
% Open the above files
%     for e = 1:length(experiments)
%         cd(experiments{e})
%         edit('makeDirs*.m')
%         cd ..
%     end
    
    datasets = struct();    
    
    for d = 1:length(experiments)
        datasets(d).name = experiments{d};
        
        cd(experiments{d})
            temp = dir('*short.mat');
            datasets(d).file = temp(1);
            
        datasets(d).dataStruct = open(datasets(d).file.name);
        
        datasets(d).structName = fields(datasets(d).dataStruct);                      % 
        datasets(d).dataStruct = datasets(d).dataStruct.(datasets(d).structName{:});  % re- assign the unpacked data
        
        cd ..
        
    end

    clear('temp','experiments','d','tempstruct')
    cd ..
    
%% Plot peak from each sample

    plotRegion = [5,5.6];
    plotRes = 30;
    horzshift = -.001;
    vertshift = 0.3;   

    for d = 1:length(datasets)
        
        ppm = datasets(d).dataStruct.ppm;
        reginds = fillRegion(plotRegion,ppm);
        ppm = ppm(reginds);
        matrix = vertcat(datasets(d).dataStruct.smoothedData.data);
        matrix = matrix(:,reginds);
        timepoints = [datasets(d).dataStruct.smoothedData.timepoints];
        
             % Make a Stack Plot of the spectra:

                    [datasets(d).dataStruct.plotInds,datasets(d).dataStruct.plotIndsCat] = calc_stackPlotInds({datasets(d).dataStruct.smoothedData.data},plotRes);

                stackSpectra(matrix,ppm,horzshift,vertshift,datasets(d).dataStruct.plotTitle,...
                             'colors',datasets(d).dataStruct.colorsSmoothed,...
                             'autoVert',...
                             'noWhiteShapes',...
                             'plotSubset',datasets(d).dataStruct.plotIndsCat,...
                             'timeVect',timepoints)
                         legend 'off'
        
    end

%%
    for i = 1:length(sn)  
        for j = 1:length(bs)
            n =  i + (j-1) * length(sn); 
            % Make the ax optOB_out.resultsject
                ax(j,i) = subplot(length(bs),length(sn),n);
                    hold on
                    
                    %% Make a Stack Plot of the spectra:
        
                        matrix = vertcat(pgm2_starve_gluc.Xsmoothed.data);
                        currentppm = pgm2_starve_gluc.ppmcat;
                        pgm2_starve_gluc.plotRes = 50;

                            [pgm2_starve_gluc.plotInds,pgm2_starve_gluc.plotIndsCat] = calc_stackPlotInds({pgm2_starve_gluc.Xsmoothed.data},pgm2_starve_gluc.plotRes);

                        pgm2_starve_gluc.horzshift = .001;
                        pgm2_starve_gluc.vertshift = 0.3;

                        plotTitle = {'pgm2 starved,'; 'glucose pulsed,';' then starved'};        

                        stackSpectra(matrix,currentppm,pgm2_starve_gluc.horzshift,pgm2_starve_gluc.vertshift,plotTitle,...
                                     'colors',pgm2_starve_gluc.colorsSmoothed,...
                                     'autoVert',...
                                     'plotSubset',pgm2_starve_gluc.plotIndsCat)
            
        end
    end
    linkaxes(ax(:),'xy');
        
    % Add a title
        sttl = suptitle('Results for opt_bucket Parameter Optimization','interpreter','none');
    
    % Add one x label across the bottom
        suplabel('Chemical Shift (ppm)','x');
    




