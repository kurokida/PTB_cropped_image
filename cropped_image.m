Screen('Preference', 'SkipSyncTests', 1);

% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

bgColor = [0.5 0.5 0.5]; % 背景色 
ListenChar(2); % Matlabに対するキー入力を無効
if IsWin
    myKeyCheck; % 外部関数　windowsでは必要かも。
end

screenNumber = max(Screen('Screens'));

% full screen
%[windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor);

% window mode
[windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor, [10 50 850 750]);

% 画像の一部を消すために透明色を扱います。そのために必要な１行
Screen(windowPtr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% 画面の中央の座標
[centerX, centerY] = RectCenter(windowRect);

imgFileName = 'personA.png';

%画像情報をテクスチャに
imdata = imread(imgFileName);
imageHeight = size(imdata, 1);
imageWidth = size(imdata, 2);
imagetex = Screen('MakeTexture', windowPtr, imdata);


%% 円形のマスク
% AlphaImageDemoを参考に作っています 。

% We create a Luminance+Alpha matrix for use as transparency mask:
% Layer 1 (Luminance) is filled with luminance value 'gray' of the
% background.
[x, y] = meshgrid(-imageWidth/2:imageWidth/2, -imageHeight/2:imageHeight/2);
mask = ones(imageHeight+1, imageWidth+1, 4); % 4の意味は、RGBAの４種類
mask(:, :, 1) = bgColor(1); % R (赤)
mask(:, :, 2) = bgColor(2); % G (緑)
mask(:, :, 3) = bgColor(3); % B (青)

ellipse_a = 100; % http://www.geisya.or.jp/~mwm48961/kou3/quadratic_1.htm の 図１のa
ellipse_b = 120; % http://www.geisya.or.jp/~mwm48961/kou3/quadratic_1.htm の 図１のb

% 透明度（アルファ）が1のところはマスクが表示される
% 楕円の外側の透明度を1、内側の透明度を0にする
mask(:, :, 4) = (x.^2)./(ellipse_a.^2) + (y.^2)./(ellipse_b.^2) > 1;

% 以下のコメントを解除してみると、透明色が理解しやすい
%mask(:, :, 4) = ((x.^2)./(ellipse_a.^2) + (y.^2)./(ellipse_b.^2) > 1) * 0.5;

masktex=Screen('MakeTexture', windowPtr, mask);

% 画像の呈示
tRect = Screen('Rect', imagetex); % テクスチャのレクトを調べる。
dstRect = CenterRectOnPoint(tRect, centerX, centerY);
Screen('DrawTexture', windowPtr, imagetex, [], dstRect);

% マスクの呈示
tRect = Screen('Rect', masktex);
dstRect = CenterRectOnPoint(tRect, centerX, centerY);
Screen('DrawTexture', windowPtr, masktex, [], dstRect);

Screen('Flip', windowPtr);
KbStrokeWait;

Screen('Close');

%終了処理
Screen('CloseAll');
ShowCursor;
ListenChar(0);
Priority(0);
