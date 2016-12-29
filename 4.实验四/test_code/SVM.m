function [TP_mean,TF_mean,ACC_mean] = SVM(algorithm_type, stego_number, times,plot)
%algorithm_type = 'F5';stego_number = 2;times = 10;
if times > 11
    times = 11;
end

%% 特征提取
feature_matrix = load_feature();                           % 构造特征矩阵 200 * 275 * 8
feature_matrix_size = size(feature_matrix);         % 计算特征矩阵尺寸
image_count = feature_matrix_size(1);                % 每个图像集中图像的个数
feature_dimension = feature_matrix_size(2)-1;   % 特征维度 PEV-274
image_file_count = feature_matrix_size(3);         % 图像集个数
element_count = image_count / 2;                        % 每次从每个图像集中取出一半用于训练和测试

str = {'stego_number不应该大于',...
    '所分析算法和隐写图像集不匹配',...
    '当前隐写算法无法分析'};                                   % Output Error
algorithm = {'F5','OTGS'};                                      % 隐写算法

if stego_number > image_file_count
    string = strcat(str{1},num2str(image_file_count));
    disp(string);
else
    if strcmp(algorithm_type,algorithm{1}) == 1
        Nonstego_number = 1;
        if stego_number > 4
            disp(str{2});
        end
    elseif strcmp(algorithm_type,algorithm{2}) == 1
        Nonstego_number = 5;
        if stego_number < 6
            disp(str{2});
        end
    else
        disp(str{3});
    end
    
    % 特征集
    feature_Nonstego = feature_matrix(:,1:feature_dimension,Nonstego_number);
    feature_stego = feature_matrix(:,1:feature_dimension,stego_number);
    
    %% 标签集  训练集和测试集标签相同
    % 前一半为未隐写，标签为1；后一半为隐写，标签为2
    trainSetLabel(1:element_count,1) = 1;
    trainSetLabel(element_count+1:image_count,1) = 2;
    testSetLabel = trainSetLabel;
    
    trainSet = zeros(image_count,feature_dimension);
    testSet = zeros(image_count,feature_dimension);
    trainSet_norm = zeros(image_count, feature_dimension);
    testSet_norm = zeros(image_count, feature_dimension);
    feature_Nonstego_temp = feature_Nonstego;
    feature_stego_temp = feature_stego;
    TF = zeros(1,times);TP = zeros(1,times);ACC = zeros(1,times);
    
    for i = 1:times
        %% 数据集
        % 前一半为未隐写，后一半为隐写，成对出现
        trainSet(1:element_count,:) = feature_Nonstego_temp(1:element_count,:);
        trainSet(element_count+1:image_count,:) = feature_stego_temp(1:element_count,:);
        testSet(1:element_count,:) = feature_Nonstego_temp(element_count+1:image_count,:);
        testSet(element_count+1:image_count,:) = feature_stego_temp(element_count+1:image_count,:);
        
        %% 归一化
        % 每维特征进行0均值，1方差处理，即对列标准化
        for k = 1 : feature_dimension
            trainSet_norm(:,k) = zscore(trainSet(:,k));
            testSet_norm(:,k)  = zscore(testSet(:,k));
        end
        
        % SVM训练
        % libsvmtrain的调用参数为libsvmtrain(trainSetLabel, trainSet, svmParams)，
        % 其中，trainSetLabel 表示训练集标签，trainSet 为训练集特征，支持向量机训练参
        % 数为svmParams = '-s 0 -t 2 -g 0.00014 -c 20000'
        % 取前一半用于训练
        svmParams = '-s 0 -t 2 -g 0.00014 -c 20000';                  % SVM训练参数
        model = libsvmtrain(trainSetLabel, trainSet_norm, svmParams);
        
        % 预测
        % libsvmpredict 的调用参数为libsvmpredict(testSetLabel, testSet, model)
        % testSetLabel 表示测试集标签， testSet 为测试集特征， model 为支持向量机分类器
        resultLabel = libsvmpredict(testSetLabel, testSet_norm, model);
        TF(i) = length(find(testSetLabel(1:element_count,1) == resultLabel(1:element_count,1))) / element_count;
        TP(i) = length(find(testSetLabel(element_count + 1:image_count,1) == resultLabel(element_count + 1:image_count,1))) / element_count;
        ACC(i) = (TP(i) + TF(i)) / 2;
        
        % 矩阵下移10行
        feature_Nonstego_temp = circshift(feature_Nonstego_temp,-10);
        feature_stego_temp = circshift(feature_stego_temp,-10);
    end
end
TP_mean = mean(TP);
TF_mean = mean(TF);
ACC_mean = mean(ACC);

%% 画图
if plot == 1
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
end