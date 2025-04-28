% 加载数据
combined_data = readtable('C:\Users\CC\Desktop\A题第二小问\Combined_Station_Data.xlsx');

% 假设清洗成本为每次清洗的固定成本
cleaning_cost_per_cleaning = 500;  % 假设清洗一次的成本为500元

% 选择输入特征和输出变量
features = {'Humidity', 'Irradiance_w_m2', 'CurrentTemperature', 'PR', 'ActualEnergy_kWh', 'TheoreticalEnergy_kWh'};
target = 'ActualEnergy_kWh';

% 数据预处理：去除缺失值
combined_data = rmmissing(combined_data, 'DataVariables', [features, target]);

% 特征标准化
scaler = @(x) (x - mean(x)) / std(x);  % 标准化函数
for i = 1:length(features)
    combined_data.(features{i}) = scaler(combined_data.(features{i}));
end

% 清洗频率（单位：天）
cleaning_frequencies = [1, 2, 3, 5, 7];  % 1天，2天，3天，5天，7天清洗频率

% 模拟清洗成本和发电量的平衡
total_costs = zeros(1, length(cleaning_frequencies));
total_energy = zeros(1, length(cleaning_frequencies));

% 设定权重
w1 = 0.5;  % 清洗成本权重
w2 = 0.5;  % 发电损失成本权重

% 循环处理清洗频率
for cleaning_idx = 1:length(cleaning_frequencies)
    cleaning_freq = cleaning_frequencies(cleaning_idx);
    
    total_loss_cost = 0;
    total_cleaning_cost = 0;
    total_generation = 0;

    % 循环遍历每一行数据，计算发电量和成本
    for i = 1:height(combined_data)
        theoretical_energy = combined_data.TheoreticalEnergy_kWh(i);
        actual_energy = combined_data.ActualEnergy_kWh(i);
        
        % 判断是否清洗，基于积灰影响
        energy_loss = (theoretical_energy - actual_energy);  % 发电损失
        total_loss_cost = total_loss_cost + energy_loss;
        
        % 每隔指定天数进行清洗
        if mod(i, cleaning_freq) == 0
            total_cleaning_cost = total_cleaning_cost + cleaning_cost_per_cleaning;  % 累计清洗成本
        end
        
        % 累加发电量
        total_generation = total_generation + actual_energy;
    end
    
    % 计算综合成本：清洗成本和发电损失成本
    total_cost = w1 * total_cleaning_cost + w2 * total_loss_cost;
    total_costs(cleaning_idx) = total_cost;
    total_energy(cleaning_idx) = total_generation;
end

% 绘制图表：不同清洗频率下的总成本与发电量变化
figure;
[ax1, h1] = plotyy(cleaning_frequencies, total_costs, cleaning_frequencies, total_energy);
set(h1, 'LineStyle', '--', 'Color', 'g');
xlabel('Cleaning Frequency (days)');
ylabel(ax1(1), 'Total Cost (Yuan)', 'Color', 'b');
ylabel(ax1(2), 'Total Energy (kWh)', 'Color', 'g');
title('Effect of Cleaning Frequency on Total Cost and Energy Production');

% 输出结果：最优清洗频率
[~, optimal_idx] = min(total_costs);
optimal_cleaning_frequency = cleaning_frequencies(optimal_idx);
disp(['The optimal cleaning frequency is every ', num2str(optimal_cleaning_frequency), ' days.']);
