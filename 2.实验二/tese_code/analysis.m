function p = analysis(imgPath, var)
    %% 前期处理
    jobj = jpeg_read(imgPath);  % 读取jpg图像
    zall = reshape(jobj.coef_arrays{1,1}, 1, size(jobj.coef_arrays{1,1},1)*size(jobj.coef_arrays{1,1},2));

    %% 分析过程
    z = zall;
    if var.WinDown < var.WinUp
        down = var.WinDown;
        up      = var.WinUp;
    else
        down = var.WinUp;
        up      = var.WinDown;
    end
    
    down = ceil(down / 2) * 2;              % ceil 向上取整 
    up      = floor((up - 1) / 2) * 2 + 1;  % floor向下取整
    if down < -1 && up > 2
        h1 = histc(z, down:-1);
        h2 = histc(z, 2:up);
        advh = [h1,h2];

    elseif down < -1 && up <= 2
    	if up > -1
            up = -1;
        end
        
        advh = histc(z, down:up);
   
    elseif down >= -1
        if down < 2
            down = 2;
        end
        if up > 2
            advh = histc(z, down:up);
        end
    end
    
    pairnum = floor( length(advh) / 2);
    t = length(advh);
    y = ones(pairnum,1);
    yy = ones(pairnum,1);
    for j = 1:1:pairnum
        if advh(2*j-1) + advh(2*j) > 0
            y(j)  = (advh(2*j-1) + advh(2*j) ) / 2;
            yy(j) =  advh(2*j-1);
        else
            t = t - 2;
        end
    end
    xsq = sum( (y(:) - yy(:)).^ 2 ./ y(:) );
%   xsq = xsq / var.Rate;
    p = 1 - chi2cdf( xsq, t/2);
