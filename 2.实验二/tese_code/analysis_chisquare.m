clc;
clear all;

% 图像集路径
file_path_JSTEG_000 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_000\\';
file_path_JSTEG_500 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_500\\';
file_path_OTGS_000 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_000\\';
file_path_OTGS_500 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_500\\';

file_path = {file_path_JSTEG_000, file_path_JSTEG_500, file_path_OTGS_000, file_path_OTGS_500};
file_path_count = length(file_path);                                   % 图像集个数
count_cal = 20  ;                                                                 % 变更DCT系数检测区间的次数
p = zeros(400, count_cal);                                                 % 记录每张图像的卡方分析结果
p_mean_JSTEG = zeros(1, count_cal);                           % 储存JSTEG算法的卡方分析结果均值
p_mean_OTGS = zeros(1, count_cal);                             % 储存OTGS算法的卡方分析结果均值

% 分析参数配置，设置卡方分析的量化DCT系数检测区间
var.WinUp = 3;                                                                    % 2i+1
var.WinDown = 2;                                                               % 2i

for k = 1:count_cal                                                              % k表示对var的更改次数
    for i = 1 : file_path_count                                                % i表示图像集序号
        
        img_path_list = dir(strcat(file_path{i}, '*.jpg'));          % 获取该文件夹中所有jpg格式的图像
        img_num = length(img_path_list);                             % 获取图像总数量
        
        % 文件遍历并进行卡方分析
        if img_num > 0                                                            % 有满足条件的图像
            for j = 1:img_num                                                    % 逐一读取图像，j表示图像序号
                image_name = img_path_list(j).name;              % 图像名
                image_path = strcat(file_path{i},image_name);% 图像路径
                %---------------- 图像处理过程 ----------------%
                p(j,k) = analysis(image_path,var);                       % 卡方分析
                %-------------------- End --------------------%
            end
        end
        std.mean(i,k) = mean(p(:,k));                                       % 卡方分析值均值
        std.max(i,k) = max(p(:,k));                                            % 卡方分析值最大值
        std.min(i,k) = min(p(:,k));                                              % 卡方分析值最小值
    end
    var.WinDown = var.WinDown + 2;                                  % 改变DCT系数检测窗口下界
    var.WinUp = var.WinUp + 2;                                            % 改变DCT系数检测窗口上界
    p_mean_JSTEG(k) = std.mean(2, k) - std.mean(1,k);  % JSTEG隐写算法卡方分析值走向 
    p_mean_OTGS(k) = std.mean(4, k) - std.mean(3,k);    % OTGS隐写算法卡方分析值走向 
end

figure(1);
subplot(211);plot(p_mean_JSTEG);
title('JSTEG隐写算法卡方分析值走向');
subplot(212);plot(p_mean_OTGS);
title('OTGS隐写算法卡方分析值走向');

p_max_JSTEG = max(p_mean_JSTEG);
p_max_JSTEG_index = find(p_max_JSTEG);
p_max_OTGS = max(p_mean_OTGS);
p_max_OTGS_index = find(p_max_OTGS);