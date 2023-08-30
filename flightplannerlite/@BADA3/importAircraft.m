function importAircraft(obj)
rawdata = importdata(['+source/Data/' obj.id '.opf']);

% General
datarow = strsplit(rawdata{14});
obj.ACM.type = datarow{5};
obj.ACM.PFM.n_eng = str2double(datarow{3});
obj.ACM.description = 'none';
datarow = strsplit(rawdata{15});
obj.ACM.engine = datarow{5};

% AFCM
datarow = strsplit(rawdata{26});
obj.ACM.AFCM.S = str2double(datarow{3});  % m2

datarow = strsplit(rawdata{29});
obj.ACM.AFCM.Configuration(1).phase = datarow{3};
obj.ACM.AFCM.Configuration(1).name = datarow{4};
obj.ACM.AFCM.Configuration(1).vstall = str2double(datarow{5}); % KCAS
obj.ACM.AFCM.Configuration(1).cd0 = str2double(datarow{6});
obj.ACM.AFCM.Configuration(1).cd2 = str2double(datarow{7});

datarow = strsplit(rawdata{30});
obj.ACM.AFCM.Configuration(2).phase = datarow{3};
obj.ACM.AFCM.Configuration(2).name = datarow{4};
obj.ACM.AFCM.Configuration(2).vstall = str2double(datarow{5}); % KCAS
obj.ACM.AFCM.Configuration(2).cd0 = str2double(datarow{6});
obj.ACM.AFCM.Configuration(2).cd2 = str2double(datarow{7});

datarow = strsplit(rawdata{31});
obj.ACM.AFCM.Configuration(3).phase = datarow{3};
obj.ACM.AFCM.Configuration(3).name = datarow{4};
obj.ACM.AFCM.Configuration(3).vstall = str2double(datarow{5}); % KCAS
obj.ACM.AFCM.Configuration(3).cd0 = str2double(datarow{6});
obj.ACM.AFCM.Configuration(3).cd2 = str2double(datarow{7});

datarow = strsplit(rawdata{32});
obj.ACM.AFCM.Configuration(4).phase = datarow{3};
obj.ACM.AFCM.Configuration(4).name = datarow{4};
obj.ACM.AFCM.Configuration(4).vstall = str2double(datarow{5}); % KCAS
obj.ACM.AFCM.Configuration(4).cd0 = str2double(datarow{6});
obj.ACM.AFCM.Configuration(4).cd2 = str2double(datarow{7});

datarow = strsplit(rawdata{33});
obj.ACM.AFCM.Configuration(5).phase = datarow{3};
obj.ACM.AFCM.Configuration(5).name = datarow{4};
obj.ACM.AFCM.Configuration(5).vstall = str2double(datarow{5}); % KCAS
obj.ACM.AFCM.Configuration(5).cd0 = str2double(datarow{6});
obj.ACM.AFCM.Configuration(5).cd2 = str2double(datarow{7});

for i = 1 : 5
    if strcmp(obj.ACM.AFCM.Configuration(i).name,'Clean')
        obj.ACM.AFCM.Configuration(i).name = 'Flap0';
    end
    obj.ACM.AFCM.Configuration(i).HLPosition = str2double(erase(obj.ACM.AFCM.Configuration(i).name,'Flap'));
end

datarow = strsplit(rawdata{39});
obj.ACM.AFCM.dLGDN = str2double(datarow{4});

% ALM
datarow = strsplit(rawdata{22});
obj.ACM.ALM.KLM.vmo = str2double(datarow{2}); % KCAS     
obj.ACM.ALM.KLM.mmo  = str2double(datarow{3}); % Mach
obj.ACM.ALM.GLM.hmo =  str2double(datarow{4}); % Ceiling ft

massrow = strsplit(rawdata{19});
obj.ACM.PFM.MREF = str2double(massrow{2})*1e3;
obj.ACM.ALM.DLM.OEW = str2double(massrow{3})*1e3;
obj.ACM.ALM.DLM.MTOW = str2double(massrow{4})*1e3;
obj.ACM.ALM.DLM.MPL =  str2double(massrow{5})*1e3;

% Ground
datarow = strsplit(rawdata{59});
obj.ACM.Ground.Runway.TOL = str2double(datarow{2});
obj.ACM.Ground.Runway.LDL = str2double(datarow{3});
obj.ACM.Ground.Dimensions.Span = str2double(datarow{4});
obj.ACM.Ground.Dimensions.Length = str2double(datarow{5});

% ARPM
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(1).name = 'Climb';
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(1).CAS1 = 300;
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(1).CAS2 = 300;
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(1).M = 0.78;

obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(2).name = 'Cruise';
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(2).CAS1 = 280;
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(2).CAS2 = 280;
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(2).M = 0.78;

obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(3).name = 'Descent';
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(3).CAS1 = 290;
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(3).CAS2 = 290;
obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(3).M = 0.78;

% ICAO
datarow = strsplit(rawdata{14});
obj.ACM.ICAO.designator = obj.id;
obj.ACM.ICAO.WTC = datarow{6};

% PFM
obj.ACM.PFM.LHV = 43217000;
obj.ACM.PFM.rho = 810;

datarow = strsplit(rawdata{45});
for i = 1 : 5
    obj.ACM.PFM.CT(i) = str2double(datarow{i+1});
end
obj.ACM.PFM.CTCR = 0.95;

datarow = strsplit(rawdata{47});
obj.ACM.PFM.LIDL.DescLow = str2double(datarow{2});
obj.ACM.PFM.LIDL.DescHigh = str2double(datarow{3});
obj.ACM.PFM.LIDL.DescLevel = str2double(datarow{4});
obj.ACM.PFM.LIDL.DescApp = str2double(datarow{5});
obj.ACM.PFM.LIDL.DescLd = str2double(datarow{6});

% CF
datarow = strsplit(rawdata{52});
obj.ACM.PFM.CF(1) = str2double(datarow{2});
obj.ACM.PFM.CF(2) = str2double(datarow{3});
datarow = strsplit(rawdata{54});
obj.ACM.PFM.CFidle(1) = str2double(datarow{2});
obj.ACM.PFM.CFidle(2) = str2double(datarow{3});
datarow = strsplit(rawdata{56});
obj.ACM.PFM.CFCR = str2double(datarow{2});

end

