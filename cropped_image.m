Screen('Preference', 'SkipSyncTests', 1);

% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

bgColor = [0.5 0.5 0.5]; % �w�i�F 
ListenChar(2); % Matlab�ɑ΂���L�[���͂𖳌�
if IsWin
    myKeyCheck; % �O���֐��@windows�ł͕K�v�����B
end

screenNumber = max(Screen('Screens'));

% full screen
%[windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor);

% window mode
[windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor, [10 50 850 750]);

% �摜�̈ꕔ���������߂ɓ����F�������܂��B���̂��߂ɕK�v�ȂP�s
Screen(windowPtr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% ��ʂ̒����̍��W
[centerX, centerY] = RectCenter(windowRect);

imgFileName = 'personA.png';

%�摜�����e�N�X�`����
imdata = imread(imgFileName);
imageHeight = size(imdata, 1);
imageWidth = size(imdata, 2);
imagetex = Screen('MakeTexture', windowPtr, imdata);


%% �~�`�̃}�X�N
% AlphaImageDemo���Q�l�ɍ���Ă��܂� �B

% We create a Luminance+Alpha matrix for use as transparency mask:
% Layer 1 (Luminance) is filled with luminance value 'gray' of the
% background.
[x, y] = meshgrid(-imageWidth/2:imageWidth/2, -imageHeight/2:imageHeight/2);
mask = ones(imageHeight+1, imageWidth+1, 4); % 4�̈Ӗ��́ARGBA�̂S���
mask(:, :, 1) = bgColor(1); % R (��)
mask(:, :, 2) = bgColor(2); % G (��)
mask(:, :, 3) = bgColor(3); % B (��)

ellipse_a = 100; % http://www.geisya.or.jp/~mwm48961/kou3/quadratic_1.htm �� �}�P��a
ellipse_b = 120; % http://www.geisya.or.jp/~mwm48961/kou3/quadratic_1.htm �� �}�P��b

% �����x�i�A���t�@�j��1�̂Ƃ���̓}�X�N���\�������
% �ȉ~�̊O���̓����x��1�A�����̓����x��0�ɂ���
mask(:, :, 4) = (x.^2)./(ellipse_a.^2) + (y.^2)./(ellipse_b.^2) > 1;

% �ȉ��̃R�����g���������Ă݂�ƁA�����F���������₷��
%mask(:, :, 4) = ((x.^2)./(ellipse_a.^2) + (y.^2)./(ellipse_b.^2) > 1) * 0.5;

masktex=Screen('MakeTexture', windowPtr, mask);

% �摜�̒掦
tRect = Screen('Rect', imagetex); % �e�N�X�`���̃��N�g�𒲂ׂ�B
dstRect = CenterRectOnPoint(tRect, centerX, centerY);
Screen('DrawTexture', windowPtr, imagetex, [], dstRect);

% �}�X�N�̒掦
tRect = Screen('Rect', masktex);
dstRect = CenterRectOnPoint(tRect, centerX, centerY);
Screen('DrawTexture', windowPtr, masktex, [], dstRect);

Screen('Flip', windowPtr);
KbStrokeWait;

Screen('Close');

%�I������
Screen('CloseAll');
ShowCursor;
ListenChar(0);
Priority(0);
