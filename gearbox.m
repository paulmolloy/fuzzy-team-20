fis = newfis('gearbox');
fis.name
fis.input
fis = addInput(fis, [0, 150], "Name", "fluid_temp");
fis = addMF(fis,"fluid_temp","trapmf",[0 0 90 110],'Name',"normal");
fis = addMF(fis,"fluid_temp","trapmf",[90 110 150 150],'Name',"high");

fis = addInput(fis, [0, 150], "Name", "speed");
fis = addMF(fis,"speed","gaussmf",[30 0],'Name',"very slow");
fis = addMF(fis,"speed","gaussmf",[30 30],'Name',"slow");
fis = addMF(fis,"speed","gaussmf",[30 60],'Name',"moderate");
fis = addMF(fis,"speed","gaussmf",[30 100],'Name',"fast");
fis = addMF(fis,"speed","gaussmf",[40 150],'Name',"very fast");

fis = addInput(fis, [0, 5], "Name", "throttle"); % Volts
fis = addMF(fis,"throttle","gaussmf",[1 5],'Name',"open");
fis = addMF(fis,"throttle","gaussmf",[2 2.5],'Name',"partially open");
fis = addMF(fis,"throttle","gaussmf",[1 0],'Name',"closed");

fis = addOutput(fis,[0.5 5.5],'Name',"gear");
fis = addMF(fis,"gear","trimf",[0.5 1 1.5],'Name',"first");
fis = addMF(fis,"gear","trimf",[1.5 2 2.5],'Name',"second");
fis = addMF(fis,"gear","trimf",[2.5 3 3.5],'Name',"third");
fis = addMF(fis,"gear","trimf",[3.5 4 4.5],'Name',"fourth");
fis = addMF(fis,"gear","trimf",[4.5 5 5.5],'Name',"fifth");


% (fluid temp) param 1 idx of membership function,
% (speed) param 2 idx, 
% (throttle) param 3 idx,
% idx of membership function of output (gear number), 
% rule weight  or 1,
% fuzzy operator 1==AND 2==OR
% TODO: Add more rules.
rulesList = [1 1 0 1 1 1;  % if very_slow && normal temp-≥ first
             2 1 0 2 1 1;  % if very_slow && high temp -> second
             
             0 2 0 2 1 1; % if slow -> second
             0 5 0 5 1 1]; % if very_fast -> fifth
fis = addRule(fis, rulesList);

fis.output
plotmf(fis,"output",1)

        % Temp  Speed  Throttle expected_gear  
inputs = [
          1 0 0 1;
          1 1 0 1;
          40 1 0 1;
          40 1 4.5 1; % normal temp, very slow, throttle open, rough
          120 15 4.5 1; % high temp, very slow, throttle open, rough
          60 50 4.5 3; % normal temp, slow, throttle open, rough
          60 140 4.5 5; % normal temp, very fast, throttle open, rough
    ]
inputs(:, 1:end-1)
results = evalfis(fis, inputs(:, 1:end-1))
rounded_gear = round(results)
%plotfis(fis)
surfview(fis)
inputs(:, end) == rounded_gear