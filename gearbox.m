fis = newfis('gearbox')
fis.name
fis.input
fis = addInput(fis, [0, 150], "Name", "fluid_temp");
%fis = addMF(fis,"fluid_temp","gaussmf",[50 25],'Name',"low");
fis = addMF(fis,"fluid_temp","trapmf",[-2 0 90 110],'Name',"normal");
fis = addMF(fis,"fluid_temp","trapmf",[90 110 150 150],'Name',"high");

fis = addInput(fis, [0, 150], "Name", "speed");
fis = addMF(fis,"speed","gaussmf",[15 15],'Name',"very slow");
fis = addMF(fis,"speed","gaussmf",[15 45],'Name',"slow");
fis = addMF(fis,"speed","gaussmf",[15 75],'Name',"moderate");
fis = addMF(fis,"speed","gaussmf",[15 105],'Name',"fast");
fis = addMF(fis,"speed","gaussmf",[15 135],'Name',"very fast");

fis = addInput(fis, [0, 5], "Name", "throttle"); % Volts
fis = addMF(fis,"throttle","gaussmf",[1 4],'Name',"open");
fis = addMF(fis,"throttle","gaussmf",[1 2.5],'Name',"partially open");
fis = addMF(fis,"throttle","gaussmf",[.35 .35],'Name',"closed");

fis = addInput(fis, [0, 1], "Name", "friction");
fis = addMF(fis,"friction","gaussmf",[.2 .2],'Name',"slippy");
fis = addMF(fis,"friction","gaussmf",[.2 .5],'Name',"stable");
fis = addMF(fis,"friction","gaussmf",[.2 .8],'Name',"rough");

fis = addOutput(fis,[1 5],'Name',"gear");
fis = addMF(fis,"gear","trimf",[1 1 1.5],'Name',"first");
fis = addMF(fis,"gear","trimf",[1.5 2 2.5],'Name',"second");
fis = addMF(fis,"gear","trimf",[2.5 3 3.5],'Name',"third");
fis = addMF(fis,"gear","trimf",[3.5 4 4.5],'Name',"fourth");
fis = addMF(fis,"gear","trimf",[4.5 5 6],'Name',"fifth");


% (fluid temp) param 1 idx of membership function,
% (speed) param 2 idx, 
% (throttle) param 3 idx,
% (friction) param 4 idx,
% idx of membership function of output (gear number), 
% rule wright 0 or 1,
% fuzzy operator 1==AND 2==OR
rulesList = [2 1 0 0 2 1 1;  % if very_slow && high temp -> second
             1 1 0 0 1 1 1;  % if very_slow && normal temp-≥ first 
             
             0 2 0 0 2 1 1; % if slow -> second
             0 5 0 0 5 1 1]; % if very_fast -> fifth
fis = addRule(fis, rulesList);
fis.output
plotmf(fis,"input",1)

inputs = [60 15 4.5 .78; % normal temp, very slow, throttle open, rough
          102 15 4.5 .78; % high temp, very slow, throttle open, rough
          60 50 4.5 .78; % normal temp, slow, throttle open, rough
          60 140 4.5 .78; % normal temp, very fast, throttle open, rough
    ]
results = evalfis(fis, inputs)
rounded_gear = round(results)