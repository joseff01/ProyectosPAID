pkg load video;
pkg load image;

function mvdm = mid_value_decision_median(values)
    sorted_values = sort(values, 2);
    mvdm = sorted_values(:, 2);
end

video_in = VideoReader('con_ruido.mp4');
video_out = VideoWriter('sin_ruido_alg1.mp4');
open(video_out);

filter_size = [3, 3];

while hasFrame(video_in)
    gray_frame = readFrame(video_in);

    if size(gray_frame, 3) == 3
        gray_frame = rgb2gray(gray_frame);
    end

    filtered_frame = medfilt2(gray_frame, filter_size);

    writeVideo(video_out, uint8(filtered_frame));
end

close(video_out);

%IAMFA-I

video_in = VideoReader('con_ruido.mp4');

video_out = VideoWriter('sin_ruido_alg2.mp4');
open(video_out);

while hasFrame(video_in)
    gray_frame = readFrame(video_in);

    [H, W] = size(gray_frame);
    filtered_frame = gray_frame;

    gray_frame = double(gray_frame);

    col1 = mid_value_decision_median([gray_frame(2:end-1, 1), gray_frame(1:end-2, 1), gray_frame(3:end, 1)]);
    col2 = mid_value_decision_median([gray_frame(2:end-1, 2), gray_frame(1:end-2, 2), gray_frame(3:end, 2)]);

    for j = 3:(W-1)
        col3 = mid_value_decision_median([gray_frame(2:end-1, j), gray_frame(1:end-2, j), gray_frame(3:end, j)]);

        filtered_frame(2:end-1, j) = mid_value_decision_median([col1, col2, col3]);

        col1 = col2;
        col2 = col3;
    end

    writeVideo(video_out, uint8(filtered_frame));
end

close(video_out);

