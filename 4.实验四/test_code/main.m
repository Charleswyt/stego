clc;
clear all;
close all;

% 真阳性率、真阴性率、准确率
TP_F5  = zeros(1,3);
TF_F5  = zeros(1,3);
acc_F5 = zeros(1,3);

TP_OTGS  = zeros(1,3);
TF_OTGS  = zeros(1,3);
acc_OTGS = zeros(1,3);

%% F5隐写分析
[TP_F5(1),TF_F5(1),acc_F5(1)] = SVM('F5',2,10,0); % 0.05bpac
[TP_F5(2),TF_F5(2),acc_F5(2)] = SVM('F5',3,10,0); % 0.1bpac
[TP_F5(3),TF_F5(3),acc_F5(3)] = SVM('F5',4,10,0); % 0.2bpac

%% OTGS隐写分析
[TP_OTGS(1),TF_OTGS(1),acc_OTGS(1)] = SVM('OTGS',6,10,0); % 0.05bpac
[TP_OTGS(2),TF_OTGS(2),acc_OTGS(2)] = SVM('OTGS',7,10,0); % 0.1bpac
[TP_OTGS(3),TF_OTGS(3),acc_OTGS(3)] = SVM('OTGS',8,10,0); % 0.2bpac

figure(1);
rate = [0.05,0.1,0.2];
subplot(222);plot(rate,TP_F5,'.','markersize',20);title('TP 真阳性率');
subplot(223);plot(rate,TP_F5,'.','markersize',20);title('TF 真阴性率');
subplot(224);plot(rate,TP_F5,'.','markersize',20);title('ACC 准确率');
axes('position',[0,0,1,1],'visible','off');
tx = text(0.2,0.78,'F5');
set(tx,'fontweight','bold');

figure(2);
rate = [0.05,0.1,0.2];
subplot(222);plot(TP_F5,'.','markersize',20);title('TP 真阳性率');
subplot(223);plot(TP_F5,'.','markersize',20);title('TF 真阴性率');
subplot(224);plot(TP_F5,'.','markersize',20);title('ACC 准确率');
axes('position',[0,0,1,1],'visible','off');
tx = text(0.2,0.78,'OTGS');
set(tx,'fontweight','bold');
