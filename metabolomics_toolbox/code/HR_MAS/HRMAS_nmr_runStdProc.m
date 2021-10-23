function [data] = HRMAS_nmr_runStdProc(sampleInfo,sample,expType,doRef,refppm,refthresh)
%% HRMAS_nmr_runStdProc
% 
% Run standard basic processing on a dataset (easy to put in a loop). Facilitates
% concatenation (hopefully). Built from HRMAS_nmr_processAndStoreData4.m
% 
% MJ 13APR2018
% YW 10/04/2018 add local storing 
% MJ 10/2020 rework for processCIVMdata()

%% handle inputs

    % Initialize all as empty
        [spectra.real,...
        spectra.ppm,...
        spectra.Title,...
        spectra.FileName,...
        spectra.startTime,...
        spectra.experiment,...
        spectra.sample] = deal([]);
    data.pulseWidthP0 = [];
    data.timePoints = [];
    data.spectra = spectra;


    if expType == 0
        return
    end
    
    
    specList = sampleInfo.sample(sample).expType(expType);

    if ~exist('doRef','var')
        doRef = 0;
    end
    
    if ~exist('refppm','var')
        refppm = 0;
    end

%% Take care of filepath stuff

    data_directory = specList.paths.ft;
    rawData = specList.paths.raw;
    
%% PROCESSING
    %% Load the Processed data from ft files
        % Load all the ft files as spectra
            cd(data_directory)
                d = dir('*.ft');
                data = struct();
                
                if ~isempty({d.name}) % Handle empty cases (data not processed)
                    % If data are there
                        loadallft();

                            % Get timepoints from acqu files
                                dataDir = {spectra.Title}';
                                cd(rawData)
                                [startTimes,~] = getRunTimes_NMR(dataDir);
                                timePoints = startTimes - startTimes(1); % these are in hours
                            % Get pulsewidths too
                                [P0] = getP0_NMR(dataDir);            

                        % Referencing
                        if doRef
                            data.spectra = ref_spectra(spectra,refthresh,refppm);   %% need to make dynamic (deal(refparams)?)
                            close(gcf)
                            % Correct the offset
                                for s = 1:length(data.spectra)
                                    data.spectra(s).ppm = data.spectra(s).ppm + refppm;
                                end
                        else
                            data.spectra = spectra;
                        end
                    
                    % STORAGE

                    % Add in fields for sample and experiment so we can concatenate with
                    % other data later on
                        [data.spectra(:).sample] = deal(sampleInfo.sample(sample).name);
                        [data.spectra(:).experiment] = deal(sampleInfo.sample(sample).expTypes{expType});
                    for i = 1:length(spectra)
                        data.spectra(i).startTime = startTimes(i);
                    end
                    data.pulseWidthP0 = P0;
                    data.timePoints = timePoints;

                else
                    warning(['"',cd(),'" contains no .ft data files. Use processCIVMdata() to process these with NMRPipe. Skipping this sample and initializing as empty fields.'])

                    % Initialize what we can:
                        spectra.sample = sampleInfo.sample(sample).name;
                        spectra.experiment = specList.type;

                    % Initialize the rest as an empty
                        [spectra.real,...
                        spectra.ppm,...
                        spectra.Title,...
                        spectra.FileName,...
                        spectra.startTime] = deal([]);
                    data.pulseWidthP0 = [];
                    data.timePoints = [];
                    data.spectra = spectra;
                end

end
