currentFolder = pwd;
sub_no = input('Enter the subject ID - ');

defaultFileName = fullfile(currentFolder, '*.xlsx');
[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a filename ');

Screen('Preference', 'SkipSyncTests', 2);

[wPtr,rect]=Screen('OpenWindow', 0 ,[], [0 0 840 680]);

KbName('UnifyKeyNames');
% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
xcenter = rect(3)/2;
ycenter = rect(4)/2;
white = WhiteIndex(screenNumber);
grey = white / 2;
Screen('FillRect',wPtr,grey);
Screen(wPtr, 'Flip');

xc=xcenter;
yc=ycenter;
colormat=[255 255 0;255 0 0;0 0 255;0 255 0];
relcue=[];
expcue=[];
conLevels=[];
kc_X = KbName('X');
kc_Z = KbName('Z');
A_key = 'A';
Z_key = 'Z';
T_key1= 'Left';
T_key2= 'Right';
kc_A = KbName('A');
kc_Z = KbName('Z');
kc_L = KbName('leftarrow');
kc_R = KbName('rightarrow');
D_key='down';

relcue=[];
expcue=[];
conLevels=[];
con=[];
time=[];
keys=[];
co=[];
yup=[];sub=[];
f=[]; c=[]; m=[]; h=[]; ya=[]; ore=[]; locc=[]; locc2=[];bl=[];
sigpp=[];locres=[];nlevel=[];acu=[];cont=[];


locL= [(xc-70) (yc-250) (xc+70) (yc-110)];
locR= [(xc-70) (yc+110) (xc+70) (yc+250)];
locL2= [(xc-250) (yc-70) (xc-110) (yc+70)];

locR2= [(xc+110) (yc-70) (xc+250) (yc+70)];
kr = KbName('rightarrow');
kl = KbName('leftarrow');


text = 'Press any key when ready...';
width2=RectWidth(Screen('TextBounds',wPtr,text));
Screen('DrawText', wPtr,text , xc-width2/2,300, [255 255 255]);
Screen(wPtr, 'Flip');
a = .5;
b = 1;
r = (b-a).*rand(1801,1) + a;
KbWait;
[keyIsDown, t, keyCode ] = KbCheck;
cenrect=[xc-5,yc-5,xc+5,yc+5];
xx=30;
loc=[locL;locR];
pink=[255 20 147];
blue=[0 255 255];
%--------------------------------------------------------------------------
%%%%%%%%%%%titeration%%%
nb=1;
nbb=randperm(8);
nsd2=0.2;
ph=0:1:5;
UD = PAL_AMUD_setupUD('up', 1, 'down', 2, 'stepsizeup', 0.01, 'stepsizedown', 0.01,'xMin',0.01);
UD = PAL_AMUD_setupUD(UD, 'stopcriterion', 'trials','stoprule', 100);
UD = PAL_AMUD_setupUD(UD, 'startvalue', 0.2);

while ~ UD.stop
    con = UD.xCurrent;
    phran=randperm(6);
    phr=phran(1);
    phase=ph(phr);
 
    orient=10;
    lran=randperm(2);
    lo1=lran(1);
    lo2=lran(2);
    l1=loc(lo1,:);
    l2=loc(lo2,:);
   
    Screen('FillRect',wPtr,grey);
    Screen(wPtr, 'Flip');
    tic
    while toc<1;
    end
    Screen('DrawLine', wPtr,[255 255 255], xcenter-15,ycenter,xcenter+15,ycenter,[3]);
    Screen('DrawLine', wPtr,[255 255 255], xcenter,ycenter-15,xcenter,ycenter+15,[3]);
    Screen(wPtr, 'Flip');
    tic
    while toc<1;
    end
    Screen('FillRect',wPtr,grey);
    Screen(wPtr, 'Flip');
    tic
    while toc<0.5;
    end
    Screen('DrawLine', wPtr,[255 255 255], xcenter-15,ycenter,xcenter+15,ycenter,[3]);
    Screen('DrawLine', wPtr,[255 255 255], xcenter,ycenter-15,xcenter,ycenter+15,[3]);
    Screen(wPtr, 'Flip');
    startSecs = GetSecs;
    timeSecs = KbWait;
    
    Screen('FillRect',wPtr,grey);
    Screen(wPtr, 'Flip');
    
    while 1
        [keyIsDown, t, keyCode]= KbCheck;
        if keyCode(kc_L)|| keyCode(kc_R)
            break
        end
    end
  
    
    
    aacon=randperm(100);
    acon=aacon(1);
    
    pexx=1;
    bexx=2;
    
    keyCode(kc_L)
    if acon<76
        or=45;
        exp=1;
    elseif acon>75
        or=-45;
        exp=2;
    end
    
    
    if keyCode(kc_R)
        if acon<76
            or=-45;
            exp=1;
        elseif acon>75
            or=45;
            exp=2;
        end
    end
    
    
    aconr=randperm(100);
    acon=aconr(1);
    Screen('DrawLine', wPtr,[255 255 255], xcenter-15,ycenter,xcenter+15,ycenter,[3]);
    Screen('DrawLine', wPtr,[255 255 255], xcenter,ycenter-15,xcenter,ycenter+15,[3]);
    Screen('FrameRect', wPtr, pink, l1);
    Screen('FrameRect', wPtr, blue, l2);
    Screen(wPtr, 'Flip');
    WaitSecs(0.3);
    
    Gabo=Patch([140 140],6,or,phase,37 , 1, con);
    noi=normrnd(1,nsd2,[140 140]);
    Gabor22=Gabo.*noi;
    ave=mean2(Gabor22);
    sd=std2(Gabor22);
    rgbImage = repmat(uint8(127.5.*Gabor22),[1 1 3]);
    %Gabor1=imgaussfilt(rgbImage);
    gabortex=Screen(wPtr,'MakeTexture',rgbImage);
    
    noi=normrnd(ave,sd,[140 140]);
    noiseImage = repmat(uint8(127.5.*noi),[1 1 3]);
    %noi11=imgaussfilt(noiseImage);
    noisetex=Screen(wPtr,'MakeTexture',noiseImage);
    
    
    nnrel=randperm(150);
    nrel=nnrel(1);
    
    if nrel<76 && pexx==1
        loca=l1;
        rel=3;
        col=pink;
    elseif nrel<76 && bexx==1
        loca=l2;
        rel=3;
        col=blue;
    elseif nrel>75 && pexx==1
        loca=l2;
        rel=3;
        col=blue;
    elseif nrel>75 && bexx==1
        loca=l1;
        rel=3;
        col=pink;
    end
    
    
    
    
    
    
    
    sigran=randperm(2);
    sigr=sigran(1);
    if sigr==1
        Screen('DrawTextures', wPtr, gabortex, [],loca,90);
    else
        Screen('DrawTextures', wPtr, noisetex, [],loca,90);
    end
    Screen('DrawLine', wPtr,[255 255 255], xcenter-15,ycenter,xcenter+15,ycenter,[3]);
    Screen('DrawLine', wPtr,[255 255 255], xcenter,ycenter-15,xcenter,ycenter+15,[3]);
    if or==45
        Screen('DrawLine', wPtr,col, loca(3),loca(4),loca(3)+25,loca(4)+25,[3]);
        Screen('DrawLine', wPtr,col, loca(1),loca(2),loca(1)-25,loca(2)-25,[3]);
    elseif or==-45
        Screen('DrawLine', wPtr,col, loca(1),loca(4),loca(1)-25,loca(4)+25,[3]);
        Screen('DrawLine', wPtr,col, loca(3),loca(2),loca(3)+25,loca(2)-25,[3]);
    end
    Screen('FrameRect', wPtr, pink, l1);
    Screen('FrameRect', wPtr, blue, l2);
    Screen(wPtr, 'Flip');
    WaitSecs(0.05);
    
    Screen('FillRect',wPtr,grey);
    Screen(wPtr, 'Flip');
    
    
    
    
    startSecs = GetSecs;
    stopSecs = KbWait();
    
    [keyIsDown, t, keyCode ] = KbCheck;
    
    while 1
        [keyIsDown, t, keyCode ] = KbCheck;
        if keyCode(kc_A)%yes
            resp='A';
            break;
        elseif keyCode(kc_Z)%no
            resp='Z';
            break;
        end
    end
    
    if sigr==1
        if resp=='A'
            acc=1;
            hi=1;
            mi=0;
            fa=0;
            cr=0;
        elseif resp=='Z'
            acc=0;
            hi=0;
            mi=1;
            fa=0;
            cr=0;
        end
    elseif sigr== 2
        if resp=='A'
            acc=0;
            hi=0;
            mi=0;
            fa=1;
            cr=0;
        elseif resp== 'Z'
            acc=1;
            hi=0;
            mi=0;
            fa=0;
            cr=1;
        end
    end
    
    t1 = (stopSecs - startSecs);
    keys = strvcat(keys,resp);%keypress
    time = cat(1,time,t1);%rt
    acu=cat(1,acu,acc);%accuracy
    f=cat(1,f,fa);
    h=cat(1,h,hi);
    m=cat(1,m,mi);
    c=cat(1,c,cr);
    relcue=cat(1,relcue,rel);%relevance;1-relevant;2-irrelevent;3-neutral
    expcue=cat(1,expcue,exp);%1-expected;2-unexpected;3-neutral
    cont=cat(1,cont,con);%snr
    sigpp=cat(1,sigpp,sigr);%signal presence; 1 is present;2 is absent
    sub=cat(1,sub,sub_no);
    UD = PAL_AMUD_updateUD(UD, acc);

    
end


Screen('TextSize', wPtr, 22);
Screen('TextStyle', wPtr , 1);
thank_text = 'Experiment Finished...Thanks!';
width_thank=RectWidth(Screen('TextBounds',wPtr,thank_text));
wait_text = 'Data is being written up in the file...please wait';
width_wait=RectWidth(Screen('TextBounds',wPtr,wait_text));
Screen('DrawText', wPtr,thank_text , xc-width_thank/2,300, [255 255 255]);
Screen('DrawText', wPtr,wait_text , xc-width_wait/2,400, [255 255 255]);
Screen(wPtr, 'Flip');
pause(3);

filename = fullfile(folder, baseFileName);



% saving data no action data in sheet1
colheaders1={'Subjectno','keypress','rt','accuracy','fa','hit','miss','cr','relcue','expcue','contrast','phase'};
xlswrite(filename,colheaders1,1,'A1');

xlswrite(filename,sub,1,'A2:A100');
xlswrite(filename,keys,1,'B2:B100');
xlswrite(filename,time,1,'C2:C100');
xlswrite(filename,acu,1,'D2:D100');
xlswrite(filename,f,1,'E2:E100');
xlswrite(filename,h,1,'F2:F100');
xlswrite(filename,m,1,'G2:G100');
xlswrite(filename,c,1,'H2:H100');
xlswrite(filename,relcue,1,'I2:I100');
xlswrite(filename,expcue,1,'J2:J100');
xlswrite(filename,cont,1,'K2:K100');
xlswrite(filename,sigpp,1,'L2:L100');





Screen('CloseAll');