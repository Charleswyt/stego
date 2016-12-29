clc;
clear all;

% 图像集路径
file_path_LSBR_000 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_000\\';
file_path_LSBR_100 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_100\\';
file_path_LSBR_300 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_300\\';
file_path_LSBR_500 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_500\\';
file_path = {file_path_LSBR_000, file_path_LSBR_100, file_path_LSBR_300, file_path_LSBR_500};
file_path_count = length(file_path);                                   % 图像集个数
num = 1;

% 测试图像集
file_path_test = 'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\TestFile\\Test_';

for i = 1 : file_path_count
    image_path_list = dir(strcat(file_path{i}, '*.bmp'));    % 获取该文件夹中所有jpg格式的图像
    image_num = length(image_path_list);                     % 获取图像总数量
    k = 1;                                                                            % 分组数
    num = 1 + (i-1) * 20;
    
    if image_num > 0                                                        % 有满足条件的图像
        for j = 1:image_num                                                % 逐一读取图像，j表示图像序号
            image_name = image_path_list(j).name;          % 图像名
            image_path = strcat(file_path{i},image_name);% 图像路径
            image = imread(image_path);

            % 输出路径
            file_path_test_temp = strcat(file_path_test, num2str(k));
            file_path_test_temp = strcat(file_path_test_temp, '\\');
            file_path_test_temp = strcat(file_path_test_temp, num2str(num));
            file_path_test_temp = strcat(file_path_test_temp, '.bmp');
            imwrite(image,file_path_test_temp,'bmp');
            num = num + 1;
            if mod(num-1, 20) == 0
                k = k + 1;
                num = 1 + (i-1) * 20;                                    % 图像编号
            end
        end
    end
end