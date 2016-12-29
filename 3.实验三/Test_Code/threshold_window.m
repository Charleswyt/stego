clc;
clear all;
tic;

% 图像文件夹路径
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_000\\';
file_num = 5;

window_count = 10;                                                       % var.width = 10:10:100 var.height = 10:10:100
var.startX = 10;                                                               % 检测窗口的水平偏移量
var.startY = 10;                                                               % 检测窗口的竖直偏移量

% 二次嵌入前后Q值比例值，R = Q2/Q1
R = zeros(file_num, window_count);
R_mean = zeros(1,window_count);

% 参数配置：var初始化
var.rate = 0.05;                                                               % 二次嵌入的嵌入率
var.width = 10;                                                                % 检测窗口宽度
var.height = 10;                                                               % 检测窗口高度

for i = 1 : window_count
    img_path_list = dir(strcat(file_path, '*.bmp'));    % 获取该文件夹中所有bmp格式的图像
    img_num = length(img_path_list);                         % 获取图像总数量
    
    if img_num > 0                                                         % 有满足条件的图像
        for j = 1:file_num                                                  % 逐一读取图像
            image_name = img_path_list(j).name;           % 图像名
            image_path = strcat(file_path,image_name); % 图像路径
            R(j, i) = analysis(image_path,var);                   % RQP分析
        end
    end
    var.width = var.width +10;                                        % 检测窗口宽度
    var.height = var.height + 10;                                    % 检测窗口高度
        R_mean(i) = mean(R(:,i));
end
plot(R_mean);title('rate = 0.05');
toc;