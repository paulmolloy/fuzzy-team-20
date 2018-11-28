fis = newfis('gearbox');
fis.name
fis.input
fis = setfis(fis,'defuzzmethod','mom')
fis = addInput(fis, [0, 150], "Name", "fluid_temp");
fis = addMF(fis,"fluid_temp","trapmf",[0 0 90 110],'Name',"normal");
fis = addMF(fis,"fluid_temp","trapmf",[90 110 150 150],'Name',"high");

fis = addInput(fis, [0, 150], "Name", "speed");
fis = addMF(fis,"speed","gaussmf",[8 0],'Name',"very slow");
fis = addMF(fis,"speed","gaussmf",[15 20],'Name',"slow");
fis = addMF(fis,"speed","gaussmf",[15 40],'Name',"moderate");
fis = addMF(fis,"speed","gaussmf",[15 60],'Name',"fast");
fis = addMF(fis,"speed","gaussmf",[65 120],'Name',"very fast");

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
rulesList= [
    1 1 3 1 1 1; % if normal temp && very slow && closed_throttle-? first
    1 1 2 1 1 1; % if normal temp && very slow && p_open_throttle-? first
    1 1 1 1 1 1; % if normal temp && very slow && open_throttle-? first
    2 1 3 1 1 1; % if high temp && very slow && closed_throttle-? first
    2 1 2 2 1 1; % if high temp && very slow && p__throttle-? second
    2 1 1 2 1 1; % if high temp && very slow && open_throttle-? second
    
    1 2 3 1 1 1; % if normal temp &&  slow && closed_throttle-? first
    1 2 2 2 1 1; % if normal temp &&  slow && p_open_throttle-? second
    1 2 1 2 1 1; % if normal temp &&  slow && open_throttle-? second
    2 2 3 2 1 1; % if high temp &&  slow && closed_throttle-? second
    2 2 2 3 1 1; % if high temp &&  slow && p__throttle-? third
    2 2 1 3 1 1; % if high temp &&  slow && open_throttle-? third
    
    1 3 3 2 1 1; % if normal temp && moderate && closed_throttle-? second
    1 3 2 3 1 1; % if normal temp && moderate && p_open_throttle-? third
    1 3 1 3 1 1; % if normal temp && moderate && open_throttle-? third
    2 3 3 3 1 1; % if high temp && moderate && closed_throttle-? third
    2 3 2 4 1 1; % if high temp && moderate && p__throttle-? fourth
    2 3 1 4 1 1; % if high temp && moderate && open_throttle-? fourth
    
    1 4 3 3 1 1; % if normal temp && fast && closed_throttle-? third
    1 4 2 4 1 1; % if normal temp && fast && p_open_throttle-? fourth
    1 4 1 4 1 1; % if normal temp && fast && open_throttle-? fourh
    2 4 3 4 1 1; % if high temp && fast && closed_throttle-? fourth
    2 4 2 5 1 1; % if high temp && fast && p__throttle-? fifth
    2 4 1 5 1 1; % if high temp && fast && open_throttle-? fifth
    
    1 5 3 4 1 1; % if normal temp && very fast && closed_throttle-? fourth
    1 5 2 5 1 1; % if normal temp && very fast && p_open_throttle-? fifth
    1 5 1 5 1 1; % if normal temp && very fast && open_throttle-? fifth
    2 5 3 5 1 1; % if high temp && very fast && closed_throttle-? fifth
    2 5 2 5 1 1; % if high temp && very fast && p__throttle-? fifth
    2 5 1 5 1 1;] % if high temp && very fast && open_throttle-? fifth
    
    
    
    
           
             
          
fis = addRule(fis, rulesList);

fis.output
plotmf(fis,"output",1)

        % Temp  Speed  Throttle expected_gear  
inputs = [
          0 15 0 2;
          1 1 0 1;
          40 1 0 1;
          40 1 4.5 1; % normal temp, very slow, throttle open, rough
          120 15 4.5 1; % high temp, very slow, throttle open, rough
          60 49 4.5 3; % normal temp, slow, throttle open, rough
          60 140 4.5 5; % normal temp, very fast, throttle open, rough
    ]
inputs(:, 1:end-1)
showrule(fis,'Format','symbolic')
results = evalfis(fis, [60 49 4.5])
rounded_gear = round(results)
%plotfis(fis)
surfview(fis)
inputs(:, end) == rounded_gear