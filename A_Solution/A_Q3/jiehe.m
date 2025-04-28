% 假设已经加载了四个电站的数据并计算了实际发电量与理论发电量差异
combined_data = readtable('C:\Users\CC\Desktop\A题第二小问\Combined_Station_Data.xlsx');

% 检查是否有缺失值（NaN），并删除包含NaN的行
combined_data = rmmissing(combined_data);

% 假设清洗成本为每次清洗的固定成本
cleaning_cost_per_cleaning = 500;  % 假设清洗一次的成本为500元

% 清洗频率（单位：天）
cleaning_frequencies = [1, 2, 3, 5, 7];  % 1天，2天，3天，5天，7天清洗频率

% 假设清洗价格的变化
cleaning_prices = [300, 500, 700];  % 清洗价格：300元、500元、700元

% 初始化存储
total_costs = zeros(length(cleaning_prices), length(cleaning_frequencies));
total_energy = zeros(length(cleaning_prices), length(cleaning_frequencies));

% 设定权重
w1 = 0.5;  % 清洗成本权重
w2 = 0.5;  % 发电损失成本权重

% 循环处理电价变化
for price_idx = 1:length(cleaning_prices)
    cleaning_price = cleaning_prices(price_idx);
    
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
                total_cleaning_cost = total_cleaning_cost + cleaning_price;  % 累计清洗成本
            end
            
            % 累加发电量
            total_generation = total_generation + actual_energy;
        end
        
        % 计算综合成本：清洗成本和发电损失成本
        total_cost = w1 * total_cleaning_cost + w2 * total_loss_cost;
        total_costs(price_idx, cleaning_idx) = total_cost;
        total_energy(price_idx, cleaning_idx) = total_generation;
    end
end

% 调试：查看计算结果
disp('Total Costs:');
disp(total_costs);
disp('Total Energy:');
disp(total_energy);

% 绘制图表：不同清洗价格与清洗频率的关系
figure;
hold on;

for price_idx = 1:length(cleaning_prices)
    plot(cleaning_frequencies, total_energy(price_idx, :), 'LineWidth', 2);
end
hold off;

legend(arrayfun(@(x) ['Price: ', num2str(x)], cleaning_prices, 'UniformOutput', false));
xlabel('Cleaning Frequency (days)');
ylabel('Total Energy (kWh)');
title('Effect of Cleaning Frequency and Price on Energy Production');

% 绘制图表：不同清洗价格与清洗频率的总成本关系
figure;
hold on;

for price_idx = 1:length(cleaning_prices)
    plot(cleaning_frequencies, total_costs(price_idx, :), 'LineWidth', 2);
end
hold off;

legend(arrayfun(@(x) ['Price: ', num2str(x)], cleaning_prices, 'UniformOutput', false));
xlabel('Cleaning Frequency (days)');
ylabel('Total Cost (Yuan)');
title('Effect of Cleaning Frequency and Price on Total Cost');

% 输出结果：最优清洗频率
[~, optimal_idx] = min(total_costs, [], 2);
optimal_cleaning_frequencies = cleaning_frequencies(optimal_idx);
disp('Optimal cleaning frequencies for each price:');
disp(optimal_cleaning_frequencies);
