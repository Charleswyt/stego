function [TP_mean,TF_mean,ACC_mean] = SVM_beat(algorithm_type, stego_number, times)

%% 特征提取
feature_matrix = load_feature();                                           % 构造特征矩阵 200 * 275 * 8
feature_matrix_size = size(feature_matrix);                        % 计算特征矩阵尺寸
image_count = feature_matrix_size(1);                               % 每个图像集中图像的个数
feature_dimension = feature_matrix_size(2)-1;                  % 特征维度 PEV-274
image_file_count = feature_matrix_size(3);                        % 图像集个数

if stego_number > image_file_count
    disp('stego_number不应该大于8');
else
    % Nonstego_number初始化
    if strcmp(algorithm_type,'F5') == 1
        Nonstego_number = 1;
        if stego_number > 4
            disp('所分析算法和隐写图像集不匹配');
        end
    elseif strcmp(algorithm_type,'OTGS') == 1
        Nonstego_number = 5;
        if stego_number < 6
            disp('所分析算法和隐写图像集不匹配');
        end
    else
        disp('当前隐写算法无法分析');
    end
    %% 训练集
    % 制备训练标签集
    trainSetLabel = zeros(image_count,1);                             % 训练集标签初始化
    trainSetLabel(1 : image_count / 2) = 1;                             % 前一半为未隐写图像
    trainSetLabel(image_count / 2 + 1 : image_count) = 2;   % 后一半为隐写图像
    
    % 制备训练集                                                                      %与训练标签集对应
    trainSet(1:image_count / 2,1:feature_dimension) = feature_matrix(1:image_count / 2,1:feature_dimension, Nonstego_number);
    trainSet(image_count / 2 + 1 : image_count,1:feature_dimension) = feature_matrix(1:image_count / 2,1:feature_dimension, stego_number);
    
    % 归一化
    % 每维特征进行0均值，1方差处理，即对列标准化
    % 训练集归一化
    trainSet_norm = zeros(image_count, feature_dimension);
    for i = 1 : feature_dimension
        trainSet_norm(:,i) = zscore(trainSet(:,i));
    end
    
    %% SVM训练
    % libsvmtrain的调用参数为libsvmtrain(trainSetLabel, trainSet, svmParams)，
    % 其中，trainSetLabel 表示训练集标签，trainSet 为训练集特征，支持向量机训练参
    % 数为svmParams = '-s 0 -t 2 -g 0.00014 -c 20000'
    % 取前一半用于训练
    svmParams = '-s 0 -t 2 -g 0.00014 -c 20000';                  % SVM训练参数
    model = libsvmtrain(trainSetLabel, trainSet_norm, svmParams);
    
    %% 测试集
    % 制备测试集
    % 根据计算次数times进行测试集制备，将剩下的100张图像分成times组，用于模型测试
    % times可取4 5 10 20等可被整除的数
    if times > 10
        times = 10;
    end
    
    element_count = image_count / times;                                             % 200（100张隐写+100张未隐写）张图像分成10组，每组20个
    testSetLabel = zeros(element_count,1,times);                                % 测试集标签
    testSet = zeros(element_count,feature_dimension,times);            % 测试集
    testSet_norm = zeros(element_count, feature_dimension,times);% 测试集归一化
    TP = zeros(1,times);TF = zeros(1,times);ACC = zeros(1,times);  % 真阳性率、真阴性率、准确率
    
    testSetLabel_temp1(1:image_count / 2,1)...                                                                                       % 未隐写图像标签集
        = trainSetLabel(1:image_count / 2);
    testSetLabel_temp2(1:image_count / 2,1)...                                                                                       % 隐写图像标签集
        = trainSetLabel(image_count / 2+1:image_count,1);
    
    testSet_temp1(1:image_count / 2,1:feature_dimension)...
        = feature_matrix(image_count / 2+1:image_count,1:feature_dimension,Nonstego_number);    %未隐写图像特征集
    testSet_temp2(1:image_count / 2,1:feature_dimension)...
        = feature_matrix(image_count / 2+1:image_count,1:feature_dimension,stego_number);           % 隐写图像特征集
    
    start = 1;
    
    for i = 1:times
        % 测试标签集
        testSetLabel(1:element_count / 2,1,i) = testSetLabel_temp1(1:element_count / 2,1);
        testSetLabel(element_count / 2 + 1:element_count,1,i) = testSetLabel_temp2(1:element_count / 2,1);
        % 测试集
        testSet(1:element_count / 2,:,i)   = testSet_temp1(start:start + element_count / 2 - 1,:);
        testSet(element_count / 2 + 1:element_count,:,i) = testSet_temp2(start:start + element_count / 2 - 1,:);
        start = start + element_count / 2;
        
        % 测试集归一化
        for k = 1 : feature_dimension
            testSet_norm(:,k,i) = zscore(testSet(:,k,i));
        end
        
        %% 预测
        % libsvmpredict 的调用参数为libsvmpredict(testSetLabel, testSet, model)
        % testSetLabel 表示测试集标签， testSet 为测试集特征， model 为支持向量机分类器
        resultLabel = libsvmpredict(testSetLabel(:,1,i), testSet_norm(:,:,i), model);
        TF(i) = length(find(testSetLabel(1:element_count / 2,1,i) == resultLabel(1:element_count / 2))) / (element_count / 2);
        TP(i) = length(find(testSetLabel(element_count / 2 + 1:element_count,1,i) == resultLabel(element_count / 2 + 1:element_count))) / (element_count / 2);
        ACC(i) = (TP(i) + TF(i)) / 2;
    end
end
TP_mean = mean(TP);
TF_mean = mean(TF);
ACC_mean = mean(ACC);
%% 画图
rate = {'0.05bpac','0.1bpac','0.2bpac'};
if stego_number < 5
    string = strcat(algorithm_type,32,rate{stego_number-1});
else
    string = strcat(algorithm_type,32,rate{stego_number-5});
end
figure;
subplot(222);plot(TP,'.','markersize',20);title('TP 真阳性率');
subplot(223);plot(TF,'.','markersize',20);title('TF 真阴性率');
subplot(224);plot(ACC,'.','markersize',20);title('ACC 准确率');
axes('position',[0,0,1,1],'visible','off');
tx = text(0.2,0.78,string);
set(tx,'fontweight','bold');
end