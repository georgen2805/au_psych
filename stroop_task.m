%Scripted by Nithin George

%Stroop task

% making sure that we are starting on a clear workspace
close all;
clearvars;
sca;

% This will setup all necessary psychtoolbox functionalities
PsychDefaultSetup(2);

% initialising the random seed;
rand('seed', sum(100 * clock));

% Skipping some diagnistic tests so as to bypass some errors. Use this line
% only when you are debugging/preparing/testing the script. These are necessary
% tests when you do a real experiment. So remove this line when you are
% doing serious stuff. 
Screen('Preference', 'SkipSyncTests', 1) 

screenNumber = max(Screen('Screens')); % This will set the screen number to external monitor, if there is one.

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);
res = get(0,'screensize');

%this line will open the psychtoolbox screen
[window,windowRect]=PsychImaging('OpenWindow', screenNumber ,grey, [0 0 res(3)/2 res(4)/2]);

% a very important line; this is necessary to present/draw stimulus from background to the monitor screen 
Screen('Flip', window);

% Flip interval is the time taken to refresh the screen. For a monitor with
% 60 Hz refresh rate, the flip interval will be 0.0167 seconds, or 16 milliseconds
ifi = Screen('GetFlipInterval', window);

% Font size of the test; 60 is very high; 22 is a small readable size
Screen('TextSize', window, 60);

% Checking the maximum priority level; this should ideally be 1 for windows and Linux, 9
% for MacOS,
topPriorityLevel = MaxPriority(window);

% storing the cordinates of the centre of the screen
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%initialisation
rt_vector = [];
accuracy_vector = [];
trial_vector = [];
key_vector = [];
condition_vector = [];
color_vector = [];
word_vector = [];

% Defining some keys for later use
esc = KbName('ESCAPE');
lKey = KbName('LeftArrow');
rKey = KbName('RightArrow');
dKey = KbName('DownArrow');

%giving 'words' a name for later use
rword = 'Red';
gword = 'Green';
bword = 'Blue';

allwords = {rword gword bword};

%giving colors a name for later use
rcolor = [255 0 0];
gcolor = [0 255 0];
bcolor = [0 0 255];

%one matrix for all colors
allcolors = cat(1, rcolor, gcolor, bcolor);


% the trial loop starts here. Each iteration in tbis loop is one trial.
for i=1:10
    
    Screen('FillRect',window,grey);
    Screen(window, 'Flip');
    
    Screen('DrawLine', window,[255 255 255], xCenter-15,yCenter,xCenter+15,yCenter,[3]);
    Screen('DrawLine', window,[255 255 255], xCenter,yCenter-15,xCenter,yCenter+15,[3]);
    Screen(window, 'Flip');
    WaitSecs(0.5);
    
    % random selection of a color for this trial
    cran3 = randperm(3);
    cran1 = cran3(1);
    
    if cran1 == 1
        color_name = 1;
        color = allcolors(1,:);
        cname = 'r';
    elseif cran1 == 2
        color_name = 2;
        color = allcolors(2,:);
        cname = 'g';
    elseif cran1 == 3
        color_name = 3;
        color = allcolors(3,:);
        cname = 'b';
    end
    
    %random selection of the word for this trial
    wran3 = randperm(3);
    wran1 = wran3(1);
    
    if wran1 == 1
        word_name = 1;
        word = allwords{1};
        wname = 'r';
    elseif wran1 == 2
        word_name = 2;
        word = allwords{2};
        wname = 'g';
    elseif wran1 == 3
        word_name = 3;
        word = allwords{3};
        wname = 'b';
    end
    
    tStart = GetSecs;
    
    %Calling the stimulus on the screen
    DrawFormattedText(window, char(word), xCenter, yCenter, color);
    Screen('Flip', window);
    
    if word_name == color_name
        condition = 'congruent';
        congruency = 1; % this is congruent trial 
    else
        condition = 'incongrnt';
        congruency = 2; % this is an incongruent trial
        
    end
        
    % Waiting for the keyboard response. This function will collect the
    % response
    KbWait();
    [keyIsDown, secs, keyCode] = KbCheck;
    
    tEnd = GetSecs;
    
    if keyCode(esc) %takes you out of the experiment
        ShowCursor;
        sca;
        return
        
    elseif keyCode(lKey)
        key_response = 1;
        key = 'left';
        
    elseif keyCode(dKey)
        key_response = 2;
        key = 'down';
        
    elseif keyCode(rKey)
        key_response = 3;
        key = 'rigt';
    end
    
    % checking if the response is correct
    if color_name == 1
        correct_response = 1;
        
        
    elseif color_name == 2
        correct_response = 2;
        
    elseif color_name == 3
        correct_response = 3;
    end
    
    if key_response == correct_response
        accuracy = 1; % correct response
    else
        accuracy = 0; % incorrect response
        
    end
    
    rt = tEnd - tStart; % calculating the Reaction Time of this trial
    rt_vector = cat(1,rt_vector,rt); % Storing RT values to a vector
    accuracy_vector = cat(1,accuracy_vector,accuracy);
    trial_vector = cat(1,trial_vector,i);
    key_vector = cat(1,key_vector,key);
    condition_vector = cat(1,condition_vector,condition);
    color_vector = cat(1,color_vector,cname);
    word_vector = cat(1,word_vector,wname);
    
    pause(1);

end

DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca;