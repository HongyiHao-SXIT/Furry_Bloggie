% 假设已加载合并后的数据
combined_data = readtable('C:\Users\CC\Desktop\A题第二小问\Combined_Station_Data.xlsx');

% 设置清洗频率（单位：天）
cleaning_frequencies = [1, 2, 3, 5, 7];  % 1天，2天，3天，5天，7天清洗频率
num_days = floor(height(combined_data) / 24);  % 总天数，确保是整数

% 基于PR值和实际发电量模拟清洗后发电量变化
% 清洗前，假设积灰影响PR值和发电量。每次清洗后，PR值会恢复至接近最大值。
base_PR = 1;  % 假设理想PR值
cleaning_effect = 0.15;  % 假设每次清洗后，PR值恢复15%

% 存储不同清洗频率下的发电量
energy_after_cleaning = zeros(length(cleaning_frequencies), num_days);

for j = 1:length(cleaning_frequencies)
    cleaning_freq = cleaning_frequencies(j);
    pr_values = base_PR * ones(num_days, 1);  % 初始PR值假设为1
    actual_energy = zeros(num_days, 1);  % 存储每日发电量

    for i = 1:num_days
        % 假设PR值逐渐下降，积灰会导致PR值下降
        if mod(i, cleaning_freq) == 0
            % 清洗后恢复PR值
            pr_values(i) = pr_values(i) + cleaning_effect;
        else
            % 积灰影响PR值，逐渐下降
            pr_values(i) = pr_values(i) - 0.05;
            if pr_values(i) < 0.3  % 限制PR值不低于0.3
                pr_values(i) = 0.3;
            end
        end
        % 模拟实际发电量与PR值的关系
        actual_energy(i) = pr_values(i) * combined_data.TheoreticalEnergy_kWh(i);  % 使用理论发电量
    end
    energy_after_cleaning(j, :) = actual_energy;
end

% 绘制折线图：不同清洗频率下的发电量变化
figure;
hold on;
for j = 1:length(cleaning_frequencies)
    plot(1:num_days, energy_after_cleaning(j, :), 'DisplayName', ['Clean every ', num2str(cleaning_frequencies(j)), ' days']);
end
xlabel('Days');
ylabel('Actual Energy (kWh)');
title('Effect of Cleaning Frequency on Energy Production');
legend('show');
hold off;
