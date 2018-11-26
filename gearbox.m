fis = newfis('gearbox')
fis.name
fis.input
fis = addInput(fis, [0, 150], "Name", "fluid_temp");
fis = addMF(fis,"fluid_temp","gaussmf",[50 25],'Name',"low");
fis = addMF(fis,"fluid_temp","gaussmf",[50 75],'Name',"normal");
fis = addMF(fis,"fluid_temp","gaussmf",[50 125],'Name',"high");


plotmf(fis,"input",1)