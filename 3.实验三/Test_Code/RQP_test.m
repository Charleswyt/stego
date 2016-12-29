clc;
clear all;
tic;
% 测试图像集
file_path_test = 'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\TestFile\\Test_';
file_test_num = 10;                                                             % 测试图像集个数
R = zeros(80,10);                                                                % RQP分析值
TP = zeros(1,file_test_num);                                              % 真阳性率
FP = zeros(1,file_test_num);                                              % 假阳性率
TF = zeros(1,file_test_num);                                              % 真阴性率

% 参数配置
var.rate = 0.04;                                                                    % 二次嵌入的嵌入率
var.height = 100;var.width = 100;                                       % 检测窗口的高度和宽度
var.startX = 10;var.startY = 10;                                           % 检测窗口的水平和垂直偏移量

for k = 1:file_test_num                                                        % 10个测试图像集
    file_path_test_temp = strcat(file_path_test, num2str(k));
    file_path = strcat(file_path_test_temp, '\\');                   % 测试集图像路径
    
    image_path_list = dir(strcat(file_path, '*.bmp'));           % 获取该文件夹中所有bmp格式的图像
    image_num = length(image_path_list);                         % 获取图像总数量
    TP_num = 0;                                                                   % 真阳性图像个数
    TF_num = 0;                                                                   %  真阴性图像个数
    
    if image_num > 0                                                           % 有满足条件的图像
        for j = 1:image_num                                                   % 逐一读取图像，j表示图像序号
            image_name = image_path_list(j).name;             % 图像名
            image_path = strcat(file_path,image_name);      % 图像路径
            R(j,k) = analysis(image_path,var);                         % RQP分析
            image_name(end-3:end) = [];
            image_number = str2double(image_name);
            if R(j,k) > 1 &&  image_number <= 20                  % 真阴性率
                TF_num = TF_num + 1;
            end
            
            if R(j,k) <= 1 &&  image_number > 20                  % 真阳性率
                TP_num = TP_num + 1;
            end
            
        end
    end
    TF(k) = TF_num / 20;
    TP(k) = TP_num / 60;
end

TF_mean = mean(TF);
TP_mean = mean(TP);
accuracy = (TF_mean + TP_mean) / 2;

figure(1);plot(TP,'.','markersize',20);title('真阳性率 TP');
figure(2);plot(TF,'.','markersize',20);title('真阴性率 TF');

toc;