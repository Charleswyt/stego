clc;
clear all;
close all;

h = figure;
image_cover = imread('lopez.bmp');                                                                    % ÒþÐ´Ç°Í¼Æ¬
image_stego = imread('lopez_MME_90_StegoMessage_CatKing.jpg');              % ÒþÐ´ºóÍ¼Æ¬
subplot(121);imshow(image_cover);title('Cover');
subplot(122);imshow(image_stego);title('Stego');
D = image_cover - image_stego;
MSE = sum(D(:).*D(:))/numel(image_cover);
annotation(h,'textbox',[0.4 0.8 0.2 0.05],'String',['MSE=' num2str(MSE)]);