clc;
clear all;

% 图像集路径
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_000\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_500\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_000\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_500\\';

p = zeros(400, 1);                                                            % 记录每张图像的卡方分析结果
stego_num = 0;                                                                % 隐写文件个数

% 分析参数配置，设置卡方分析的量化DCT系数检测区间
var.WinUp = 5;                                                                 % 2i+1
var.WinDown = 4;                                                            % 2i

img_path_list = dir(strcat(file_path, '*.jpg'));                  % 获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);                                  % 获取图像总数量

% 文件遍历并进行卡方分析
if img_num > 0                                                                 % 有满足条件的图像
    for j = 1:img_num                                                         % 逐一读取图像，j表示图像序号
        image_name = img_path_list(j).name;                   % 图像名
        image_path = strcat(file_path,image_name);        % 图像路径
        %---------------- 图像处理过程 ----------------%
        p(j) = analysis(image_path,var);                              % 卡方分析
        % JSTEG 000图像集的卡方分析值最大为0.086，但仅出现一次，其余均为很小的值，因此T_JSTEG = 0.001
        % T_OTSG = 0.0001为一个较为合适的阈值
        if p(j) >= 0.0001                                                            
            stego_num = stego_num + 1;
        end
        %-------------------- End --------------------%
    end
end
accuracy = stego_num / img_num;                                     % 虚警率/准确率（针对不同的图像集含义不同）