pkg load video;
pkg load image;

video_in = VideoReader('original.mp4');
video_out_noisy = VideoWriter('con_ruido.mp4');
open(video_out_noisy);

noise_type = 'salt & pepper';
noise_params = 0.05;

while hasFrame(video_in)
    % Read the current frame and convert to grayscale
    frame = readFrame(video_in);
    gray_frame = rgb2gray(frame);

    noisy_frame = imnoise(gray_frame, noise_type, noise_params);

    noisy_frame_rgb = cat(3, noisy_frame, noisy_frame, noisy_frame);


    writeVideo(video_out_noisy, uint8(noisy_frame_rgb));
end

close(video_out_noisy);
