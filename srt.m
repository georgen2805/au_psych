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
Screen('TextSize', wPtr, 22);
Screen('TextStyle', wPtr , 1);
ins1_text = 'Four lines will appear and an X will flash in one of the lines';
width_ins1=RectWidth(Screen('TextBounds',wPtr,ins1_text));
wait_ins2 = 'Press the spatially corresponding key; V for extreme left and M for extreme right; B and N for middle left and middle right';
width_ins2=RectWidth(Screen('TextBounds',wPtr,wait_ins2));
Screen('DrawText', wPtr,ins1_text , xcenter-width_ins1/2,300, [255 255 255]);
Screen('DrawText', wPtr,wait_ins2 , xcenter-width_ins2/2,400, [255 255 255]);
Screen(wPtr, 'Flip');
KbWait();

kc_V = KbName('V');
kc_B = KbName('B');
kc_N = KbName('N');
kc_M = KbName('M');

time = []; acc = []; keys = []; block = [];cond = [];sub = [];

seqA = ['b' 'd' 'a' 'c' 'd' 'b' 'c' 'a' 'd' 'b' 'a' 'c'];
seqB = ['c' 'a' 'b' 'd' 'a' 'c' 'd' 'b' 'a' 'c' 'b' 'd'];
seqRan = ['a' 'b' 'c' 'd' 'a' 'b' 'c' 'd' 'a' 'b' 'c' 'd'];
seqR = Shuffle(seqRan);
for k = 1:15
    seqR = Shuffle(seqRan);
    if k == 1 || k == 7 || k == 13 || k == 15
        seq = seqR;
        bt = 1;
    elseif k == 2 || k == 3 || k == 4 || k == 5 || k == 6
        seq = seqA;
        bt = 2;
    elseif k == 8 || k == 9 || k == 10 || k == 11 || k == 12 || k == 14
        seq = seqB;
        bt = 2;
    end
    if bt == 1
        for i = 1:84
            Screen('FillRect',wPtr,grey);
            
            Screen('DrawLine', wPtr,[255 255 255], xcenter-150,ycenter-50,xcenter-150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter-50,ycenter-50,xcenter-50,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+150,ycenter-50,xcenter+150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+50,ycenter-50,xcenter+50,ycenter+50,[7]);
            Screen(wPtr, 'Flip');
            pause(0.1)
            
            Screen('DrawLine', wPtr,[255 255 255], xcenter-150,ycenter-50,xcenter-150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter-50,ycenter-50,xcenter-50,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+150,ycenter-50,xcenter+150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+50,ycenter-50,xcenter+50,ycenter+50,[7]);
            
            if i == 1
                rep = 0;
            elseif i == 13
                rep = 1;
            elseif i == 25
                rep = 2;
            elseif i == 37
                rep = 3;
            elseif i == 49
                rep = 4;
            elseif i == 61
                rep = 5;
            elseif i == 73
                rep = 6;
            end
            
            
            Screen('TextSize', wPtr, 60);
            
            str = i - 12*rep;
            
            tar_loc = seq(str);
            
            if tar_loc == 'a'
                tar_con = 'a';
                Screen('DrawText', wPtr,'X' , xcenter-150-21,ycenter-50+25, [255 255 255]);%a
            elseif tar_loc == 'b'
                tar_con = 'b';
                Screen('DrawText', wPtr,'X' , xcenter-50-21,ycenter-50+25, [255 255 255]);%b
            elseif tar_loc == 'c'
                tar_con = 'c';
                Screen('DrawText', wPtr,'X' , xcenter+50-21,ycenter-50+25, [255 255 255]);%c
            elseif tar_loc == 'd'
                tar_con = 'd';
                Screen('DrawText', wPtr,'X' , xcenter+150-21,ycenter-50+25, [255 255 255]);%d
            end
            
            Screen(wPtr, 'Flip');
            
            
            startSecs = GetSecs;
            stopSecs = KbWait();
            
            [keyIsDown, t, keyCode ] = KbCheck;
            
            while 1
                [keyIsDown, t, keyCode ] = KbCheck;
                if keyCode(kc_V)
                    resp='V';
                    break;
                elseif keyCode(kc_B)
                    resp='B';
                    break;
                elseif keyCode(kc_N)
                    resp='N';
                    break;
                elseif keyCode(kc_M)
                    resp='M';
                    break;
                end
            end
            if resp == 'V' && tar_loc == 'a'
                acu = 1;
            elseif resp == 'B' && tar_loc == 'b'
                acu = 1;
            elseif resp == 'N' && tar_loc == 'c'
                acu = 1;
            elseif resp == 'M' && tar_loc == 'd'
                acu = 1;
            else
                acu = 0;
            end
            t1 = (stopSecs - startSecs);
            keys = strvcat(keys,resp);%keypress
            time = cat(1,time,t1);%rt
            acc=cat(1,acc,acu);%accuracy
            block=cat(1,block,k);%block number
            cond=cat(1,cond,bt);%random - bt = 1; sequence - bt = 2  
            sub = cat(1,sub,sub_no);
            pause(0.1);
        end
        
        
    elseif bt == 2
        for j = 1:84
            Screen('TextSize', wPtr, 60);
            Screen('FillRect',wPtr,grey);
            
            Screen('DrawLine', wPtr,[255 255 255], xcenter-150,ycenter-50,xcenter-150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter-50,ycenter-50,xcenter-50,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+150,ycenter-50,xcenter+150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+50,ycenter-50,xcenter+50,ycenter+50,[7]);
            Screen(wPtr, 'Flip');
            pause(0.1)
            
            Screen('DrawLine', wPtr,[255 255 255], xcenter-150,ycenter-50,xcenter-150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter-50,ycenter-50,xcenter-50,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+150,ycenter-50,xcenter+150,ycenter+50,[7]);
            Screen('DrawLine', wPtr,[255 255 255], xcenter+50,ycenter-50,xcenter+50,ycenter+50,[7]);
            
            if j == 1
                rep = 0;
            elseif j == 13
                rep = 1;
            elseif j == 25
                rep = 2;
            elseif j == 37
                rep = 3;
            elseif j == 49
                rep = 4;
            elseif j == 61
                rep = 5;
            elseif j == 73
                rep = 6;
            end
            
            str = j - 12*rep;
            
            tar_loc = seq(str);
            
            if tar_loc == 'a'
                tar_con = 'a';
                Screen('DrawText', wPtr,'X' , xcenter-150-21,ycenter-50+25, [255 255 255]);%a
            elseif tar_loc == 'b'
                tar_con = 'b';
                Screen('DrawText', wPtr,'X' , xcenter-50-21,ycenter-50+25, [255 255 255]);%b
            elseif tar_loc == 'c'
                tar_con = 'c';
                Screen('DrawText', wPtr,'X' , xcenter+50-21,ycenter-50+25, [255 255 255]);%c
            elseif tar_loc == 'd'
                tar_con = 'd';
                Screen('DrawText', wPtr,'X' , xcenter+150-21,ycenter-50+25, [255 255 255]);%d
            end
            
            Screen(wPtr, 'Flip');
            
            
            startSecs = GetSecs;
            stopSecs = KbWait();
            
            [keyIsDown, t, keyCode ] = KbCheck;
            
            while 1
                [keyIsDown, t, keyCode ] = KbCheck;
                if keyCode(kc_V)
                    resp='V';
                    break;
                elseif keyCode(kc_B)
                    resp='B';
                    break;
                elseif keyCode(kc_N)
                    resp='N';
                    break;
                elseif keyCode(kc_M)
                    resp='M';
                    break;
                end
            end
            if resp == 'V' && tar_loc == 'a'
                acu = 1;
            elseif resp == 'B' && tar_loc == 'b'
                acu = 1;
            elseif resp == 'N' && tar_loc == 'c'
                acu = 1;
            elseif resp == 'M' && tar_loc == 'd'
                acu = 1;
            else
                acu = 0;
            end
            t1 = (stopSecs - startSecs);
            keys = strvcat(keys,resp);%keypress
            time = cat(1,time,t1);%rt
            acc=cat(1,acc,acu);%accuracy
            block=cat(1,block,k);%block number
            cond=cat(1,cond,bt);%random - bt = 1; sequence - bt = 2
            sub = cat(1,sub,sub_no);
            pause(0.1);
        end
        
    end
end

Screen('TextSize', wPtr, 22);
Screen('TextStyle', wPtr , 1);
thank_text = 'Experiment Finished...Thanks!';
width_thank=RectWidth(Screen('TextBounds',wPtr,thank_text));
wait_text = 'Data is being written up in the file...please wait';
width_wait=RectWidth(Screen('TextBounds',wPtr,wait_text));
Screen('DrawText', wPtr,thank_text , xcenter-width_thank/2,300, [255 255 255]);
Screen('DrawText', wPtr,wait_text , xcenter-width_wait/2,400, [255 255 255]);
Screen(wPtr, 'Flip');
pause(3);

filename = fullfile(folder, baseFileName);


% saving data no action data in sheet1
colheaders1={'Subjectno','keypress','rt','accuracy','condition','block'};
xlswrite(filename,colheaders1,1,'A1');

xlswrite(filename,sub,1,'A2:A1261');
xlswrite(filename,keys,1,'B2:B1261');
xlswrite(filename,time,1,'C2:C1261');
xlswrite(filename,acc,1,'D2:D1261');
xlswrite(filename,cond,1,'E2:E1261');
xlswrite(filename,block,1,'F2:F1261');

Screen('CloseAll');