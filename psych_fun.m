StimLevels = [.01 .03 .05 .07 .09 .11];
NumPos = [59 53 68 83 92 99];
OutOfNum = [100 100 100 100 100 100];

PF = @PAL_Logistic;
paramsFree = [1 1 0 0];

searchGrid.alpha = [0.01:0.001:0.11];
searchGrid.beta = logspace(0,3,101);
searchGrid.gamma = 0.5;
searchGrid.lambda = 0.02;


[paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels, NumPos, OutOfNum,searchGrid, paramsFree,PF);

PropCorrectData = NumPos./OutOfNum;
StimLevelsFine = [min(StimLevels):(max(StimLevels)- min(StimLevels))./1000:max(StimLevels)];
Fit = PF(paramsValues, StimLevelsFine);
plot(StimLevelsFine,Fit,'g-','linewidth',2);
hold on;
plot(StimLevels, PropCorrectData,'k.','markersize',40);
set(gca, 'fontsize',12);
axis([0 .12 .4 1]);








