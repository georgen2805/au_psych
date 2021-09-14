%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ContextualCueing.m Feb 12, 2019 Yuhong V. Jiang
%   (yuhong.jiang@gmail.com) %few edits by Nithin George
%
%   This script runs the standard spatial contextual cueing using the
%   T-among-L task. It closely follows the method described in Jiang &
%   Sisk's (2019) chapter on contextual cueing. The script was written on a Mac
%   and should be run on a Mac. If running off a windows computer, the
%   coder needs to revise the array "responseKeys" based on the windows mapping.
%
%   To run practice, enter 99 as the subject number. This runs 12 trials.
%   Then re-run the script with a subject number that is not 99. This will
%   run (by default) 30 blocks of trials, 24 trials/block. Each block
%   contains 12 repeated and 12 novel displays. All items are white against
%   a gray background. Set size is fixed at 12.
%
%   The script controls for target eccentricity between the repeated and
%   novel displays. For any target location {x,y} used for an old display, there
%   is a target location at {-x, -y} for a new display. Items are evenly
%   distributed across quadrants.
%
%   The task is to find the T and report which direction the tip points to by
%   pressing the left or right arrow key. The instructions are for
%   incidental learning (no mention about display repetition).
%
%   Explicit awareness is assessed at the completion of the task with the
%   configuration recognition (old or new) task. Press O or N to respond.
%
%   The program is set up to pause at critical points when experimenter
%   instructions are needed. The program appears to hang, but it's just
%   waiting for several mouse clicks. Don't tell your participants about
%   that!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experimental parameters
clear all;
PsychJavaTrouble();
Screen('Preference', 'SkipSyncTests', 1) 
res = get(0,'screensize');
screenNumber = max(Screen('Screens'));% if using two monitors. Otherwise this line can be commented out
TextInfo.FontSize = 24;
rand('state', sum(100*clock));
KbName('UnifyKeyNames');

spaceKey = KbName('space'); escKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow'); rightKey = KbName('RightArrow');
oldKey = KbName('o'); newKey = KbName('n');
yesKey = KbName('y'); noKey = KbName('n');

if ~IsWin
    responseKeys = [80 79 28 17 18 17]; % correspond to: leftarrow, rightarrow, Y(yes), N (no), O (old), N (new)
else
    disp('You are running the script on a windows computer. Adjust responseKeys, then you can comment out this annoying line.');
    %Speak('You are running the script on a windows computer. Adjust responseKeys, then you can comment out this annoying line.', 'Alex', 300);
    responseKeys = [80 79 28 17 18 17]; % Use KbDemo to find out the Windows keycodes for leftarrow, rightarrow, Y, N, O, N and put them here in order
end

gray = [127 127 127]; white = [255 255 255]; black = [0 0 0]; bgcolor = gray; textcolor = white;

% some parameters about the search trials
ntrials = 24; % 24 trials per block, 12 old and 12 new
nconds = 2; % just 2 conditions
nTrialsPerCond = ntrials./nconds;
setsize = 12; % set size
numPerQuad = setsize./4; % number of items per quadrant

nblocks = 2; % number of blocks
iti = 0.5; % inter-trial interval
ErrorDelay = 2; % add a 2s timeout after an incorrect response
itemsize = 40; % size of the search items

% tones used to provide accuracy feedback
BeepFreq = [800 1300 2000 400]; BeepDur = [.1 .1 .1 .2];
Beep1 = MakeBeep(BeepFreq(4), BeepDur(4));
Beep2 = MakeBeep(BeepFreq(2), BeepDur(2));
Beep3 = MakeBeep(BeepFreq(3), BeepDur(3));
Beep0 = MakeBeep(BeepFreq(1), BeepDur(1));
Beep4 = [Beep0 Beep2 Beep3];

%   Login screen
prompt = {'Outputfile', 'Subject number', 'age', 'gender', 'number of blocks'};
defaults = {'CCBasic', '99', '18', 'F', '24'};
answer = inputdlg(prompt, 'CCBasic', 2, defaults);
[output, subnum, subage, gender, nblocks] = deal(answer{:});

outputname = [output 's' subnum gender subage '.xls'];

if str2num(subnum)~=99 && exist(outputname)==2
    fileproblem = input('That file already exists! Append a .x (1), overwrite (2), or break (3/default)?');
    if isempty(fileproblem) || fileproblem==3
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end

outfile = fopen(outputname,'w');

writeData(outfile, {'subnum', 'subage', 'gender', 'block', 'trial', 'configurationNumber', 'targlocation', 'distlocation1', 'distlocation2',...
    'distlocation3', 'distlocation4', 'distlocation5', 'distlocation6', 'distlocation7', 'distlocation8', 'distlocation9', 'distlocation10',...
    'distlocation11', 'configuration_condition', 'correctanswer', 'keypressed', 'accuracy', 'rt'}, '\t');

if str2num(subnum)==99
    nblocks = 1; finalBlock = nblocks; nPracticeTrials = 12; % 1 block of practice
else
    nblocks = str2num(nblocks);  finalBlock = nblocks+1; %plus 1 recognition block
end

% Screen parameters
[mainwin, screenrect] = Screen('OpenWindow',screenNumber, gray);

Screen('FillRect', mainwin, bgcolor);
center = [screenrect(3)/2 screenrect(4)/2];
fixsi = 20; fixRect = CenterRect([0 0 fixsi fixsi], screenrect);
Screen(mainwin, 'Flip');

% instructions
instructions = ['Welcome to the visual search task. You will be searching for a rotated letter T presented among L-shaped letters. The experiment is divided into several hundred trials, each taking seconds to complete. On each trial, you will first see a small dot at the center of the display. Please keep your eyes on this dot. Then, a display of letters will appear and remain on the display until you make a response. You can move your eyes if you want to, to help you find the T. There is one T turned sideways with its tail pointing either to the left or to the right. As soon as you spot the T, press an arrow key to indicate its direction: left arrow if the tail points to the left, or right arrow if the tail points to the right. Please respond as accurately and as quickly as you can. Minimize errors to no more than one per block. \n\n We will start with a few trials as practice. In the experiment, you will be given a short break once every 1-2 minutes. The entire task takes about 50 minutes to complete. \n\n Please ask the experimenter now if you have questions. Otherwise, click the mouse to start.']; % change this if needed
DrawFormattedText(mainwin, instructions, 'center', 'center', textcolor, 70);
Screen('Flip', mainwin);
GetClicks;

% load T/L
distName = 'L1.png'; im1 = imread(distName);
targName = 'T1.png'; im2 = imread(targName);
for i = 1:190
    for j = 1:190
        for k = 1:3
            if im1(i,j,k)<250, im1(i,j,k)=255; else, im1(i,j,k)=bgcolor(1); end
            if im2(i,j,k)<250, im2(i,j,k)=255; else, im2(i,j,k)=bgcolor(1);end
        end
    end
end
Dist= Screen('MakeTexture',mainwin,im1);
Target=  Screen('MakeTexture',mainwin,im2);

% set the item locations. 10x10 matrix, 25 locations per quadrant. The
% centers of the cell are jittered so that they don't align up perfectly
nrow = 10; ncolumn = 10;
cellsize = 80; cellsize1 = cellsize-20;
itemJitterX = [-10:1:10, -10:1:10, -10:1:10, -10:1:10,-10:1:10];
itemJitterY = itemJitterX;
itemJitterX = Shuffle(itemJitterX);
itemJitterY = Shuffle(itemJitterY);

for ncells = 1:nrow.*ncolumn
    xnum = (mod(ncells-1, ncolumn)+1)-(ncolumn/2)-0.5;
    ynum = ceil(ncells/ncolumn)-(nrow/2)-0.5;
    cellcenter(ncells,1) = center(1)+xnum.*cellsize1 + itemJitterX(ncells);
    cellcenter(ncells,2) = center(2)+ynum.*cellsize1 + itemJitterY(ncells);
end

quad1 = [6 7 8 9 10 16 17 18 19 20 26 27 28 29 30 36 37 38 39 40 46 47 48 49 50]; %upper right
quad2 = [1 2 3 4 5 11 12 13 14 15 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45]; %upper left
quad3 = [51 52 53 54 55 61 62 63 64 65 71 72 73 74 75 81 82 83 84 85 91 92 93 94 95]; %lower left
quad4 = [56 57 58 59 60 66 67 68 69 70 76 77 78 79 80 86 87 88 89 90 96 97 98 99 100]; %lower right

matrixloc = [quad1; quad2; quad3; quad4];

% now figure out where to place the items
itemloc = zeros(setsize, 4); % the x1,y1,x2,y2 for each of the setsize number of items

targlocs = zeros(ntrials, 1); % 24 target locations
distlocs = zeros(ntrials, setsize-1); % for each display, setsize-1 distractors
% choose the target location. If an old display has (x,y), a new one has
% (-x,-y). But make sure that there are really 24 unique target locations
% for the 24 displays

numOfUniqueTargLocs = 0; cycleNum=0;

while 1
    newmatrix = [Shuffle(matrixloc(1,:)); Shuffle(matrixloc(2,:)); Shuffle(matrixloc(3,:)); Shuffle(matrixloc(4,:))];
    
    % for old displays, configurations 1-12, pick target locations
    targlocs(1:nTrialsPerCond./4) = newmatrix(1,1:nTrialsPerCond./4); % draw 3 locations from quadrant 1
    targlocs(nTrialsPerCond./4+1:nTrialsPerCond./2) =  newmatrix(2,1:nTrialsPerCond./4); % draw 3 locations from quadrant 2
    targlocs(nTrialsPerCond./2+1:nTrialsPerCond.*3/4) = newmatrix(3,1:nTrialsPerCond./4); % draw 3 locations from quadrant 3
    targlocs(nTrialsPerCond.*3/4+1:nTrialsPerCond) = newmatrix(4,1:nTrialsPerCond./4); % draw 3 locations from quadrant 4
    
    % for new displays, selection target locations yoked to the old
    % condition, that is, (-x,-y)
    
    for i = 1:nTrialsPerCond
        x = targlocs(i); % the target's location on old trials
        x_unitDigit = mod(x-1, 10)+1; % 1 through 10
        x_tens = floor((x-1)/10);
        
        targlocs(nTrialsPerCond+i) = 101-x; % diagonal position
    end
    
    [numOfUniqueTargLocs, junk] = size(unique(targlocs)); % check the number of unique target locations
    cycleNum = cycleNum+1;
    disp (cycleNum), disp(numOfUniqueTargLocs),
    if numOfUniqueTargLocs == ntrials % break out of the loop when there are 24 unique target locations
        break;
    end
end

% now find out which quadrant the target is in for the 24 configurations
for i = 1:ntrials
    currentTargetLoc = targlocs(i);
    if ~isempty(find(targlocs(i)==quad1))
        targquad(i) = 1; nontargQuads(i,:) = [2, 3, 4];
    elseif ~isempty(find(targlocs(i)==quad2))
        targquad(i) = 2; nontargQuads(i,:) = [1, 3, 4];
    elseif ~isempty(find(targlocs(i)==quad3))
        targquad(i) = 3; nontargQuads(i,:) = [1, 2, 4];
    elseif ~isempty(find(targlocs(i)==quad4))
        targquad(i) = 4; nontargQuads(i,:) = [1, 2, 3];
    end
end

% now choose distractor locations for repeated condition
for i = 1:nTrialsPerCond  % 1-12 for old
    newmatrix = [Shuffle(matrixloc(1,:)); Shuffle(matrixloc(2,:)); Shuffle(matrixloc(3,:)); Shuffle(matrixloc(4,:))];
    currentTargetLoc = targlocs(i);
    
    % choose distractor locations from the three non-target quadrants
    distlocs(i, 1:numPerQuad) = newmatrix(nontargQuads(i,1), 1:numPerQuad);
    distlocs(i, numPerQuad+1:numPerQuad.*2) = newmatrix(nontargQuads(i,2), 1:numPerQuad);
    distlocs(i, numPerQuad.*2+1:numPerQuad.*3) = newmatrix(nontargQuads(i,3), 1:numPerQuad);
    
    % now choose the distractor locations in the target's quadrant.
    distindex=numPerQuad*3+1; % the following loop is to make sure that distractors don't overlap with the target
    for j = 1:numPerQuad
        if newmatrix(targquad(i),j)~=targlocs(i);
            distlocs(i,distindex)=newmatrix(targquad(i),j);
            distindex=(distindex+1);
        end
        if distindex==setsize
            break;
        end
    end
end

%   Experimental trials
HideCursor;

for k = 1:finalBlock
    randtrials=Shuffle(1:ntrials); blocknumtrial=ntrials;
    
    
    % Shuffle distractor locations for new displays
    
    for i = nTrialsPerCond+1:ntrials % 13-24 for new
        newmatrix = [Shuffle(matrixloc(1,:)); Shuffle(matrixloc(2,:)); Shuffle(matrixloc(3,:)); Shuffle(matrixloc(4,:))];
        currentTargetLoc = targlocs(i);
        
        % choose distractor locations from the three non-target quadrants
        distlocs(i, 1:numPerQuad) = newmatrix(nontargQuads(i,1), 1:numPerQuad);
        distlocs(i, numPerQuad+1:numPerQuad.*2) = newmatrix(nontargQuads(i,2), 1:numPerQuad);
        distlocs(i, numPerQuad.*2+1:numPerQuad.*3) = newmatrix(nontargQuads(i,3), 1:numPerQuad);
        
        % now choose the distractor locations in the target's quadrant.
        distindex=numPerQuad*3+1; % the following loop is to make sure that distractors don't overlap with the target
        for j = 1:numPerQuad
            if newmatrix(targquad(i),j)~=targlocs(i);
                distlocs(i,distindex)=newmatrix(targquad(i),j);
                distindex=(distindex+1);
            end
            if distindex==setsize
                break;
            end
        end
    end
    
    Screen('FillRect', mainwin, bgcolor);
    Screen('TextSize', mainwin, 16);
    
    Screen('DrawText', mainwin, ['Start block ' num2str(k-1) ' out of ' num2str(nblocks) ' blocks.'], center(1)-300, center(2)-20, textcolor);
    
    if k <finalBlock || str2num(subnum)==99
        Screen('DrawText', mainwin, ['Block ' num2str(k) ' out of ' num2str(finalBlock) ' blocks. Click to start.'], center(1)-300, center(2)-50, textcolor);
        Screen('Flip', mainwin);
        Speak(['Ready to start block ' num2str(k) '. Click to start.'], 'Alex', 300);
        GetClicks;
    else
        Screen('DrawText', mainwin, ['Please get the experimenter.'], center(1)-300, center(2)-50, textcolor);
        Speak(['You have completed the main part of the experiment. Please go get the experimenter for the final part.'], 'Alex', 300);
        Screen('Flip', mainwin);
        GetClicks;
        TextInfo.FontSize = 24;
        instructions = ['You have completed the main part of the experiment. Here are some questions for you. \n\n First, did you notice that some displays are repeatedly presented across blocks? Press Y for yes, N for no if you did not notice any repeated displays.']
        DrawFormattedText(mainwin, instructions, center(1)-400, 'center', textcolor, 70);
        Screen('Flip', mainwin);
        keyIsDown=0;
        while 1
            [keyIsDown, secs, keyCode] = KbCheck;
            FlushEvents('keyDown');
            if keyIsDown
                nKeys = sum(keyCode);
                if nKeys == 1
                    if keyCode(yesKey)||keyCode(noKey)
                        keypressed=find(keyCode);
                        break;
                    elseif keyCode(escKey)
                        ShowCursor(4); fclose(outfile);  Screen('CloseAll'); return
                    end
                end
            end
        end
        
        if keypressed==responseKeys(3)
            report='NoticedRepetition';
        elseif keypressed==responseKeys(4)
            report='DidNotNoticeRep';
        end
        fprintf(outfile, '%d\t %s\t \n', keypressed, report);
        Screen('Flip', mainwin);
        
        instructions = ['Next you will see displays one at a time. We want you to judge whether a display was shown to you before. Press o if the display was shown to you before (it is old), or n if the display seems new to you. Please ask any questions now. Click to start.']
        DrawFormattedText(mainwin, instructions, center(1)-400, 'center', textcolor, 70);
        Screen('Flip', mainwin);
        GetClicks;
    end
    
    % looping trials within a block
    Screen('Flip', mainwin);
    WaitSecs(0.3);
    
    targorient = Shuffle(1:blocknumtrial);
    for l = 1:blocknumtrial
        
        if str2num(subnum)==99 && l > nPracticeTrials
            break; % break after 12 trials of practice
        end
        
        currenttrial = randtrials(l); dispindex=currenttrial;
        if currenttrial<=nTrialsPerCond
            cond='repeated';
        else
            cond='novel';
        end
        Screen('DrawDots', mainwin, [center(1), center(2)], 10,white,[0 0],1);
        Screen('Flip', mainwin);
        WaitSecs(0.5);
        
        for m = 1:setsize-1
            distOrientation = ceil(rand*4)*90; % random orientation
            itemloc(m,:) = [cellcenter(distlocs(dispindex, m),1)-itemsize/2, cellcenter(distlocs(dispindex, m),2)-itemsize/2, cellcenter(distlocs(dispindex, m),1)+itemsize/2, cellcenter(distlocs(dispindex, m),2)+itemsize/2];
            Screen('DrawTexture', mainwin, Dist, [], itemloc(m,:), distOrientation);
        end
        
        currenttarge = [cellcenter(targlocs(dispindex),1)-itemsize/2, cellcenter(targlocs(dispindex),2)-itemsize/2, cellcenter(targlocs(dispindex),1)+itemsize/2, cellcenter(targlocs(dispindex),2)+itemsize/2];
        if mod(targorient(l),2)==1
            targetOrientation = 0;
            answer = responseKeys(1); % left
        else
            targetOrientation = 180;
            answer = responseKeys(2); % right
        end
        Screen('DrawTexture', mainwin, Target, [], currenttarge, targetOrientation);
        
        if k==finalBlock && str2num(subnum)~=99
            Screen('DrawText', mainwin, 'Did you see this display before? o for old, n for new.', 10, 20, textcolor);
        end
        
        Screen('Flip', mainwin);
        
        timeStart = GetSecs;
        keyIsDown=0;
        while 1
            [keyIsDown, secs, keyCode] = KbCheck;
            FlushEvents('keyDown');
            if keyIsDown
                nKeys = sum(keyCode);
                if nKeys==1
                    if (keyCode(oldKey)||keyCode(newKey))|| (keyCode(leftKey)||keyCode(rightKey))
                        rt = 1000.*(GetSecs-timeStart);
                        keypressed=find(keyCode);
                        Screen('FillRect', mainwin, bgcolor);
                        Screen('DrawDots', mainwin, [center(1), center(2)], 10,white,[0 0],1);
                        Screen('Flip', mainwin, [], 1, [], []);
                        break;
                    elseif keyCode(escKey)
                        ShowCursor; fclose(outfile);  Screen('CloseAll'); return
                    end
                    keyIsDown=0; keyCode=0;
                end
            end
        end
        
        if k==finalBlock && str2num(subnum)~=99
            if currenttrial<nTrialsPerCond+1
                if keypressed==responseKeys(5)
                    recognitionResponse='I_think_old';
                    recognitionAccuracy=1;
                else
                    recognitionResponse='I_think_new';
                    recognitionAccuracy=0;
                end
            else
                if keypressed==responseKeys(6)
                    recognitionResponse='I_think_new';
                    recognitionAccuracy=1;
                else
                    recognitionResponse='I_think_old';
                    recognitionAccuracy=0;
                end
            end
            
            writeData(outfile, {subnum, subage, gender,  k, l, dispindex, targlocs(dispindex), distlocs(dispindex,1), distlocs(dispindex,2),...,
                distlocs(dispindex,3), distlocs(dispindex,4), distlocs(dispindex,5), distlocs(dispindex,6), distlocs(dispindex,7),...
                distlocs(dispindex,8), distlocs(dispindex,9), distlocs(dispindex,10), distlocs(dispindex,11),...
                cond, answer, keypressed, recognitionAccuracy, rt, recognitionResponse}, '\t');
            
        else
            if (keypressed==answer)
                cor=1;Snd('Play', Beep4);
            else
                cor=0; Snd('Play', Beep1); WaitSecs(ErrorDelay);
            end
            
            writeData(outfile, {subnum, subage, gender,  k, l, dispindex, targlocs(dispindex), distlocs(dispindex,1), distlocs(dispindex,2),...,
                distlocs(dispindex,3), distlocs(dispindex,4), distlocs(dispindex,5), distlocs(dispindex,6), distlocs(dispindex,7),...
                distlocs(dispindex,8), distlocs(dispindex,9), distlocs(dispindex,10), distlocs(dispindex,11), ...
                cond, answer, keypressed, cor, rt}, '\t');
            
        end
        WaitSecs(iti);
    end  
end

Screen('FillRect', mainwin ,bgcolor);
Screen('TextSize', mainwin, 24);
ShowCursor;
if str2num(subnum)==99
    instructions = ['End of practice. Please get the experimenter.']; % change this please
else
    instructions = ['You have completed the visual search task. Thank you very much. Please get the experiment.']
end

DrawFormattedText(mainwin, instructions, 'center', 'center', textcolor, 70);
Screen('Flip', mainwin);
Speak(instructions, 'Alex', 300);
GetClicks;
Screen('CloseAll');
fclose(outfile);