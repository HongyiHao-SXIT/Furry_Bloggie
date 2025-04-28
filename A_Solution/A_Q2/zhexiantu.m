% Load the data
data1 = readtable('C:\Users\CC\Desktop\A题第一小问\station1_hourly_data.xlsx'); % Please replace with actual file path
data2 = readtable('C:\Users\CC\Desktop\A题第一小问\station2_hourly_data.xlsx');
data3 = readtable('C:\Users\CC\Desktop\A题第一小问\station3_hourly_data.xlsx');
data4 = readtable('C:\Users\CC\Desktop\A题第一小问\station4_hourly_data.xlsx');

% Calculate the theoretical energy generation
% Assume the conversion efficiency is 1, and the installed capacity is 5000 kWp (adjust according to actual data)
installed_capacity = 5000; % Installed capacity in kWp
conversion_efficiency = 1; % Assume conversion efficiency is 1

% Theoretical energy generation = Irradiance * Installed capacity * Conversion efficiency
data1.TheoreticalEnergy_kWh = data1.Irradiance_w_m2 * installed_capacity * conversion_efficiency;
data2.TheoreticalEnergy_kWh = data2.Irradiance_w_m2 * installed_capacity * conversion_efficiency;
data3.TheoreticalEnergy_kWh = data3.Irradiance_w_m2 * installed_capacity * conversion_efficiency;
data4.TheoreticalEnergy_kWh = data4.Irradiance_w_m2 * installed_capacity * conversion_efficiency;

% Calculate PR (Performance Ratio)
data1.PR = data1.ActualEnergy_kWh ./ data1.TheoreticalEnergy_kWh;
data2.PR = data2.ActualEnergy_kWh ./ data2.TheoreticalEnergy_kWh;
data3.PR = data3.ActualEnergy_kWh ./ data3.TheoreticalEnergy_kWh;
data4.PR = data4.ActualEnergy_kWh ./ data4.TheoreticalEnergy_kWh;

% Calculate the difference between actual energy and theoretical energy
data1.EnergyDifference = data1.TheoreticalEnergy_kWh - data1.ActualEnergy_kWh;
data2.EnergyDifference = data2.TheoreticalEnergy_kWh - data2.ActualEnergy_kWh;
data3.EnergyDifference = data3.TheoreticalEnergy_kWh - data3.ActualEnergy_kWh;
data4.EnergyDifference = data4.TheoreticalEnergy_kWh - data4.ActualEnergy_kWh;

% Plot the graphs: 5 graphs for each station
figure;
subplot(5, 1, 1); plot(data1.Hour, data1.PR); title('Station 1 PR Value'); xlabel('Time'); ylabel('PR Value');
subplot(5, 1, 2); plot(data1.Hour, data1.EnergyDifference); title('Station 1 Energy Difference'); xlabel('Time'); ylabel('Difference (kWh)');
subplot(5, 1, 3); plot(data1.Hour, data1.Irradiance_w_m2); title('Station 1 Irradiance'); xlabel('Time'); ylabel('Irradiance (W/m²)');
subplot(5, 1, 4); plot(data1.Hour, data1.CurrentTemperature); title('Station 1 Current Temperature'); xlabel('Time'); ylabel('Temperature (°C)');
subplot(5, 1, 5); plot(data1.Hour, data1.Humidity); title('Station 1 Humidity'); xlabel('Time'); ylabel('Humidity (%)');

figure;
subplot(5, 1, 1); plot(data2.Hour, data2.PR); title('Station 2 PR Value'); xlabel('Time'); ylabel('PR Value');
subplot(5, 1, 2); plot(data2.Hour, data2.EnergyDifference); title('Station 2 Energy Difference'); xlabel('Time'); ylabel('Difference (kWh)');
subplot(5, 1, 3); plot(data2.Hour, data2.Irradiance_w_m2); title('Station 2 Irradiance'); xlabel('Time'); ylabel('Irradiance (W/m²)');
subplot(5, 1, 4); plot(data2.Hour, data2.CurrentTemperature); title('Station 2 Current Temperature'); xlabel('Time'); ylabel('Temperature (°C)');
subplot(5, 1, 5); plot(data2.Hour, data2.Humidity); title('Station 2 Humidity'); xlabel('Time'); ylabel('Humidity (%)');

figure;
subplot(5, 1, 1); plot(data3.Hour, data3.PR); title('Station 3 PR Value'); xlabel('Time'); ylabel('PR Value');
subplot(5, 1, 2); plot(data3.Hour, data3.EnergyDifference); title('Station 3 Energy Difference'); xlabel('Time'); ylabel('Difference (kWh)');
subplot(5, 1, 3); plot(data3.Hour, data3.Irradiance_w_m2); title('Station 3 Irradiance'); xlabel('Time'); ylabel('Irradiance (W/m²)');
subplot(5, 1, 4); plot(data3.Hour, data3.CurrentTemperature); title('Station 3 Current Temperature'); xlabel('Time'); ylabel('Temperature (°C)');
subplot(5, 1, 5); plot(data3.Hour, data3.Humidity); title('Station 3 Humidity'); xlabel('Time'); ylabel('Humidity (%)');

figure;
subplot(5, 1, 1); plot(data4.Hour, data4.PR); title('Station 4 PR Value'); xlabel('Time'); ylabel('PR Value');
subplot(5, 1, 2); plot(data4.Hour, data4.EnergyDifference); title('Station 4 Energy Difference'); xlabel('Time'); ylabel('Difference (kWh)');
subplot(5, 1, 3); plot(data4.Hour, data4.Irradiance_w_m2); title('Station 4 Irradiance'); xlabel('Time'); ylabel('Irradiance (W/m²)');
subplot(5, 1, 4); plot(data4.Hour, data4.CurrentTemperature); title('Station 4 Current Temperature'); xlabel('Time'); ylabel('Temperature (°C)');
subplot(5, 1, 5); plot(data4.Hour, data4.Humidity); title('Station 4 Humidity'); xlabel('Time'); ylabel('Humidity (%)');
