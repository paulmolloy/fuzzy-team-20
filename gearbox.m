fis = newfis('gearbox')
fis.name
fis.input
fis = addInput(fis, [0, 150], "Name", "fluid_temp");
fis = addMF(fis,"fluid_temp","gaussmf",[50 25],'Name',"low");
fis = addMF(fis,"fluid_temp","gaussmf",[50 75],'Name',"normal");
fis = addMF(fis,"fluid_temp","gaussmf",[50 125],'Name',"high");

fis = addInput(fis, [0, 150], "Name", "speed");
fis = addMF(fis,"speed","gaussmf",[15 15],'Name',"very slow");
fis = addMF(fis,"speed","gaussmf",[15 45],'Name',"slow");
fis = addMF(fis,"speed","gaussmf",[15 75],'Name',"moderate");
fis = addMF(fis,"speed","gaussmf",[15 105],'Name',"fast");
fis = addMF(fis,"speed","gaussmf",[15 135],'Name',"very fast");

fis = addInput(fis, [0, 5], "Name", "throttle");
fis = addMF(fis,"throttle","gaussmf",[1 4],'Name',"open");
fis = addMF(fis,"throttle","gaussmf",[1 2.5],'Name',"partially open");
fis = addMF(fis,"throttle","gaussmf",[.35 .35],'Name',"closed");

fis = addInput(fis, [0, 1], "Name", "friction");
fis = addMF(fis,"friction","gaussmf",[.2 .2],'Name',"slippy");
fis = addMF(fis,"friction","gaussmf",[.2 .5],'Name',"stable");
fis = addMF(fis,"friction","gaussmf",[.2 .8],'Name',"rough");

plotmf(fis,"input",4)