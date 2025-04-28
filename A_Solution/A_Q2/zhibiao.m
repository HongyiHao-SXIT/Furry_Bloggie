% 加载四个电站的数据
station1_data = readtable('C:\Users\CC\Desktop\A题第一小问\station1_hourly_data.xlsx');
station2_data = readtable('C:\Users\CC\Desktop\A题第一小问\station2_hourly_data.xlsx');
station3_data = readtable('C:\Users\CC\Desktop\A题第一小问\station3_hourly_data.xlsx');
station4_data = readtable('C:\Users\CC\Desktop\A题第一小问\station4_hourly_data.xlsx');

% 装机容量的值（可以根据实际装机容量调整）
installed_capacity_station1 = 4998.3;  % 电站1装机容量
installed_capacity_station2 = 5581;  % 电站2装机容量
installed_capacity_station3 = 4456;  % 电站3装机容量
installed_capacity_station4 = 1794.61;  % 电站4装机容量

% 计算每个电站的理论发电量和PR值
station1_data = calculate_theoretical_energy(station1_data, installed_capacity_station1);
station2_data = calculate_theoretical_energy(station2_data, installed_capacity_station2);
station3_data = calculate_theoretical_energy(station3_data, installed_capacity_station3);
station4_data = calculate_theoretical_energy(station4_data, installed_capacity_station4);

station1_data = calculate_pr(station1_data);
station2_data = calculate_pr(station2_data);
station3_data = calculate_pr(station3_data);
station4_data = calculate_pr(station4_data);

% 为每个电站数据添加站点标识
station1_data.Station = repmat({'Station 1'}, height(station1_data), 1);
station2_data.Station = repmat({'Station 2'}, height(station2_data), 1);
station3_data.Station = repmat({'Station 3'}, height(station3_data), 1);
station4_data.Station = repmat({'Station 4'}, height(station4_data), 1);

% 合并所有数据为一个表
combined_data = [station1_data; station2_data; station3_data; station4_data];

% 清洗预警规则（PR值低于0.8，实际发电量与理论发电量差异大，湿度高且辐照强度低）
combined_data.CleaningAlert = cleaning_alert(combined_data, 0.8, 1000, 70, 500);

% 将合并后的数据输出到Excel文件
writetable(combined_data, 'Combined_Station_Data.xlsx');

% 输出清洗预警数据
disp('High Dust Level Alerts:');
disp(combined_data(combined_data.CleaningAlert == true, {'Hour', 'Station', 'PR', 'ActualEnergy_kWh', 'TheoreticalEnergy_kWh', 'Humidity', 'Irradiance_w_m2'}));

% 辅助函数：计算理论发电量
function df = calculate_theoretical_energy(df, installed_capacity)
    % 理论发电量 = 辐照强度 * 装机容量
    df.TheoreticalEnergy_kWh = df.Irradiance_w_m2 * installed_capacity;
end

% 辅助函数：计算PR值
function df = calculate_pr(df)
    % PR值 = 实际发电量 / 理论发电量
    df.PR = df.ActualEnergy_kWh ./ df.TheoreticalEnergy_kWh;
end

% 清洗预警规则函数
function alerts = cleaning_alert(df, pr_threshold, energy_diff_threshold, humidity_threshold, irradiance_threshold)
    alerts = false(height(df), 1);  % 初始化清洗预警列
    for i = 1:height(df)
        % 如果PR值低于阈值
        if df.PR(i) < pr_threshold
            alerts(i) = true;
        % 如果实际发电量与理论发电量的差异较大
        elseif abs(df.ActualEnergy_kWh(i) - df.TheoreticalEnergy_kWh(i)) > energy_diff_threshold
            alerts(i) = true;
        % 如果湿度较高且辐照强度低
        elseif df.Humidity(i) > humidity_threshold && df.Irradiance_w_m2(i) < irradiance_threshold
            alerts(i) = true;
        end
    end
end
