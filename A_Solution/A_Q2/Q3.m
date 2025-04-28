z% 光伏电站清洗策略优化仿真（第三小问 MATLAB 版）
% 建模比赛答辩用 · 作者：你

clc; clear;

%% 1. 数据导入（Excel 表格请使用英文列名！）
data = readtable('GDI.xlsx'); % ⚠ 确保文件在当前目录，列名是英文！

% 变量提取（建议提前处理为英文列名）
GDI       = data.GDI;
Temp      = data.Temp;
Humidity  = data.Humidity;
Radiation = data.Radiation;
PowerReal = data.PowerReal;
PowerPred = data.PowerPred;
Cap       = data.Capacity;

% 基本参数
N      = height(data);   % 数据长度
Price  = 1;              % 电价（元/kWh）
Cost   = Cap * 2;        % 清洗成本 = 装机容量 × 2元

%% 2. 设置清洗策略（阈值判断逻辑）
A = GDI > 0.025;    % 策略A：推荐 GDI 阈值
B = Temp > 34.5;    % 策略B：推荐温度阈值
C = Humidity < 17.5; % 策略C：推荐湿度阈值
D = Radiation > 975; % 策略D：推荐辐照阈值
E = GDI > 0.15;     % 策略E：GDI 行业经验阈值

% 用结构体方式封装策略，便于遍历
strategies = struct( ...
    'A_GDIRecom', A, ...
    'B_temp',    B, ...
    'C_humidity',    C, ...
    'D_Radiation',    D, ...
    'E_GDI', E );

strategyNames = fieldnames(strategies);  % 提取字段名（策略名）

%% 3. 模拟清洗收益计算
netProfits    = zeros(length(strategyNames), 1); % 净收益
triggerCounts = zeros(length(strategyNames), 1); % 触发次数

% 遍历每个策略进行模拟计算
for i = 1:length(strategyNames)
    cond = strategies.(strategyNames{i});                 % 当前策略触发条件
    Restore = max(PowerPred - PowerReal, 0);              % 发电恢复量（非负）
    Income = Restore .* Price;                            % 恢复带来的收益
    CostNow = Cost;                                       % 清洗成本
    profit = zeros(N, 1);                                 % 初始化收益
    profit(cond) = Income(cond) - CostNow(cond);          % 只有清洗时才计入收益
    netProfits(i) = sum(profit);                          % 总净收益
    triggerCounts(i) = sum(cond);                         % 清洗总次数
end

%% 4. 结果展示（表格 + 图）
T = table(strategyNames, triggerCounts, netProfits);  % 输出为表格
disp(T)

% 绘图1：策略净收益对比图
figure;
bar(netProfits);
set(gca, 'XTickLabel', strategyNames, 'XTickLabelRotation', 45);
ylabel('净收益 (元)');
title('各清洗策略净收益对比');

% 绘图2：触发清洗次数图
figure;
bar(triggerCounts);
set(gca, 'XTickLabel', strategyNames, 'XTickLabelRotation', 45);
ylabel('清洗触发次数');
title('各策略触发次数对比');

%% 5
[~, bestIdx] = max(netProfits);
fprintf('\n✅ 推荐策略为：[%s]，净收益最大，约为 %.2f 元\n', ...
    strategyNames{bestIdx}, netProfits(bestIdx));