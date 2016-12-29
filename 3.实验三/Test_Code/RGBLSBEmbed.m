%% RGB的LSB算法
function RGB = RGBLSBEmbed(RGB, percent)
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);
msgMaxSize  = size(RGB, 1)*size(RGB, 2)*3;
msgRealSize = floor(percent * msgMaxSize);
MSG = floor(rand(1, msgRealSize) * 2);
rand('state', 1234);
zhihuan = randperm(size(RGB, 1) * size(RGB, 2));
%% 在RGB中进行LSB嵌入
for i = 1 : msgRealSize/3
    j  = (i - 1) * 3;
    k = zhihuan(i); 
    %%R分量
    R(k) = R(k) - mod(R(k), 2)  + MSG(j + 1);
    G(k) = G(k) - mod(G(k), 2) + MSG(j + 2);
    B(k) = B(k) -  mod(B(k), 2) + MSG(j + 3);
end
%% 合成三维数组
RGB(:,:,1) =  R;
RGB(:,:,2) =  G;
RGB(:,:,3) =  B;
end
