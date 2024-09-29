% Load the video files
original = VideoReader('original.mp4');
alg1 = VideoReader('sin_ruido_alg1.mp4');
alg2 = VideoReader('sin_ruido_alg2.mp4');

function avg_ssim = compare_videos(video1_path, video2_path)
    video1 = VideoReader(video1_path);
    video2 = VideoReader(video2_path);

    numFrames1 = video1.NumberOfFrames;
    numFrames2 = video2.NumberOfFrames;

    if numFrames1 ~= numFrames2
        error('The two videos have different numbers of frames.');
    end
    frameIdx = 0;
    ssimValues = zeros(1, numFrames1);

    while hasFrame(video1)
        frameIdx =frameIdx+1;
        img1 = readFrame(video1);
        img2 = readFrame(video2);

        img1Gray = rgb2gray(img1);
        img2Gray = rgb2gray(img2);

        [mssim, ~] = ssim(img1Gray, img2Gray);
        ssimValues(frameIdx) = mssim;
    end

    avg_ssim = mean(ssimValues);
end

result1 = compare_videos('original.mp4', 'sin_ruido_alg1.mp4');
result2 = compare_videos('original.mp4', 'sin_ruido_alg2.mp4');

fprintf('El SSIM promedio para el algoritmo 1 es: %f\n', result1);
fprintf('El SSIM promedio para el algoritmo 2 es: %f\n', result2);

