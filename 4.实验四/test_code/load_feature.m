function feature_matrix = load_feature()

feature_file_path = 'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_IV\\Feature_Extract\\';
feature_file_path_list = dir(strcat(feature_file_path, '*.fea'));
feture_file_num = length(feature_file_path_list);

image_num = 200;
feature_dimension = 275;
feature_matrix = zeros(image_num, feature_dimension, feture_file_num);

for i = 1: feture_file_num
    feature_file_name = feature_file_path_list(i).name;
    feature_path = strcat(feature_file_path, feature_file_name);
    feature_matrix(:,:,i) = load(feature_path);
end
    
