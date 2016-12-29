function R = analysis(imgPath, var)
RGB = imread(imgPath);  % 读取RGB图像                                               512×512×8 uint8
RGB = im2double(RGB); % 将数据类型由uint8类型转换为double类型  512×512×8 double
RGB = im2uint8(RGB);     % 将数据类型由double类型转换为uint8类型  512×512×8 uint8
if (size(RGB, 3) < 3 || max(max(max(RGB))) > 255)   % 不是RGB图像或者灰度值大于255
    R = 0;                                                                           % R = 0
else
    RGBembed = RGBLSBEmbed(RGB,var.rate);       % 秘密信息嵌入
    RGBembed = im2double(RGBembed);
    RGBembed = im2uint8(RGBembed);
    [p, q, c] = size(RGB);
    %% 截取一定长宽内的数据进行分析,若长宽大于图像长宽，则以图像大小为准
    if (var.startX <= 0 || var.startX > p)  % 起始点X坐标，小于0或者大于图像长度，均按0处理
        var.startX = 0;
    end
    
    if (var.startY <= 0 || var.startY > q)   % 起始点Y坐标，小于0或者大于图像宽度，均按0处理
        var.startY = 0;
    end
    
    if (var.startX + var.width) > p            % 截取长度过大
        var.width = p - var.startX - 1;
    end
    
    if (var.startY + var.height) > q           % 截取宽度过大
        var.height = q - var.startY;
    end
    
    RGB_now = RGB(var.startX : (var.startX + var.width - 1), var.startY : (var.startY + var.height - 1), :);
    RGB_embed_now = RGBembed(var.startX : (var.startX + var.width - 1), var.startY : (var.startY + var.height - 1), :);
    
    %% 获得三种颜色的分量
    R = RGB_now(:,:,1)+1;
    G = RGB_now(:,:,2)+1;
    B = RGB_now(:,:,3)+1;
    
    R2 = RGB_embed_now(:,:,1)+1;
    G2 = RGB_embed_now(:,:,2)+1;
    B2 = RGB_embed_now(:,:,3)+1;
    
    temp1  = zeros(256,256,256);
    temp2 = zeros(256,256,256);
    id = 1;
    id2=1;
    %% 先找出颜色数的个数
    for i = 1:var.width
        for j = 1:var.height
            temp1(R(i,j),G(i,j),B(i,j)) = temp1(R(i,j),G(i,j),B(i,j))+1;
            temp2(R2(i,j),G2(i,j),B2(i,j)) = temp2(R2(i,j),G2(i,j),B2(i,j))+1;
        end
    end
    colorNum = uint32(sum(temp1(:)~=0));
    colorNum = double(colorNum);
    hash         = zeros(colorNum + 1, 4);
    
    colorNum2 = uint32(sum(temp2(:)~=0));
    colorNum2 = double(colorNum2);
    hash2 = zeros(colorNum2 + 1, 4);
    %% 赋值到小范围的数组中
    for i = 1:256
        for j = 1:256
            for k = 1:256
                if(temp1(i,j,k) ~= 0)
                    hash(id,1:4)=[i, j, k, temp1(i,j,k)];
                    id = id + 1;
                end
                
                if(temp2(i,j,k) ~= 0)
                    hash2(id2,1:4)=[i,j,k,temp2(i,j,k)];
                    id2 = id2 + 1;
                end
            end
        end
    end
    % %% 在hash中计算相邻像素对
    AdjacentNum = 0;
    AdjacentNum2 = 0;
    for i = 1 : colorNum
        for j = 1 : i
            if(i == j)
                AdjacentNum = AdjacentNum + hash(i,4)*(hash(i,4)-1)/2;
            else
                t = (abs(hash(i,1) - hash(j,1))<=1 && abs(hash(i,2) - hash(j,2))<=1 && abs(hash(i,3) - hash(j,3))<=1);
                AdjacentNum = AdjacentNum + t*hash(j,4)*hash(i,4)/2;
                
            end
        end
    end
    
    for i = 1:colorNum2
        for j = 1:i
            if(i == j)
                AdjacentNum2 = AdjacentNum2 + hash2(i,4)*(hash2(i,4)-1)/2;
            else
                t =(abs(hash2(i,1) - hash2(j,1))<=1 && abs(hash2(i,2) - hash2(j,2))<=1 && abs(hash2(i,3) - hash2(j,3))<=1);
                AdjacentNum2 = AdjacentNum2 + t*hash2(j,4)*hash2(i,4)/2;
                
            end
        end
    end
    tmp = colorNum*(colorNum-1)/2;
    if(tmp == 0)
        tmp = 1;
    end
    Q = AdjacentNum/tmp;
    
    tmp2 = colorNum2*(colorNum2-1)/2;
    if(tmp2 == 0)
        tmp2 = 1;
    end
    Q2 = AdjacentNum2/tmp2;
    if(Q2 == 0)
        Q2 = 1;
    end
    R = Q/Q2;
end
end
