clc;
clear all;
tic;

% 图像文件夹路径
%file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_000\\';
%file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_100\\';
%file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_300\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_500\\';

file_num = 200;
R = zeros(file_num, 1);                                            % 二次嵌入前后Q值比例值，R = Q2/Q1
stego_num = 0;                                                        % 隐写图像个数

% 参数配置：var初始化
var.rate = 0.04;                                                         % 二次嵌入的嵌入率
var.width = 100;                                                        % 检测窗口宽度
var.height = 100;                                                      % 检测窗口高度
var.startX = 10;                                                         % 检测窗口的水平偏移量
var.startY = 10;                                                         % 检测窗口的竖直偏移量


image_path_list = dir(strcat(file_path, '*.bmp'));    % 获取该文件夹中所有bmp格式的图像
image_num = length(image_path_list);                  % 获取图像总数量

if image_num > 0                                                     % 有满足条件的图像
    for j = 1:file_num                                                  % 逐一读取图像
        image_name = image_path_list(j).name;       % 图像名
        image_path = strcat(file_path,image_name);% 图像路径
        R(j) = analysis(image_path,var);                     % RQP分析
        if R(j) <= 1
            stego_num = stego_num + 1;
        end
    end
end
accuracy = stego_num / image_num;
figure(1);plot(R,'.','markersize',8);title('LSBR 500');
figure(2);hist(R);title('LSBR 500');
toc;