import pandas as pd

# 读取电站数据函数
def read_station_data(station_id, generation_file, environment_file, weather_file, capacity):
    # 读取数据
    generation_data = pd.read_excel(generation_file)
    environment_data = pd.read_excel(environment_file)
    weather_data = pd.read_excel(weather_file)
    
    # 统一时间格式，并按小时聚合
    generation_data['时间'] = pd.to_datetime(generation_data['时间']).dt.round('H')
    environment_data['时间'] = pd.to_datetime(environment_data['时间']).dt.round('H')
    weather_data['时间'] = pd.to_datetime(weather_data['时间']).dt.round('H')

    # 处理负值，将其视为缺失值（NaN）
    generation_data['当日累计发电量kwh'] = generation_data['当日累计发电量kwh'].apply(lambda x: x if x >= 0 else None)
    environment_data['辐照强度w/m2'] = environment_data['辐照强度w/m2'].apply(lambda x: x if x >= 0 else None)
    weather_data[['当前温度', '最高温度', '最低温度', '风速', '湿度']] = weather_data[['当前温度', '最高温度', '最低温度', '风速', '湿度']].applymap(lambda x: x if x >= 0 else None)

    # 填充缺失值，使用线性插值法
    generation_data['当日累计发电量kwh'] = generation_data['当日累计发电量kwh'].interpolate()
    environment_data['辐照强度w/m2'] = environment_data['辐照强度w/m2'].interpolate()
    weather_data[['当前温度', '最高温度', '最低温度', '风速', '湿度']] = weather_data[['当前温度', '最高温度', '最低温度', '风速', '湿度']].interpolate()

    # 按小时聚合数据
    generation_data = generation_data.groupby('时间').agg({'当日累计发电量kwh': 'sum'}).reset_index()
    environment_data = environment_data.groupby('时间').agg({'辐照强度w/m2': 'mean'}).reset_index()
    weather_data = weather_data.groupby('时间').agg({'当前温度': 'mean', '最高温度': 'mean', '最低温度': 'mean', '风速': 'mean', '湿度': 'mean'}).reset_index()

    # 合并数据
    merged_data = pd.merge(generation_data, environment_data, on='时间', how='inner')
    merged_data = pd.merge(merged_data, weather_data, on='时间', how='inner')

    # 添加电站编号和装机容量
    merged_data['电站编号'] = station_id
    merged_data['装机容量'] = capacity
    
    return merged_data

# 电站1的装机容量与数据文件路径
station_1_capacity = 4998.30
station_1_generation_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站1发电数据.xlsx'
station_1_environment_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站1环境检测仪数据.xlsx'
station_1_weather_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站1天气数据.xlsx'

# 电站2的装机容量与数据文件路径
station_2_capacity = 5581.00
station_2_generation_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站2发电数据.xlsx'
station_2_environment_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站2环境检测仪数据.xlsx'
station_2_weather_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站2天气数据.xlsx'

# 电站3的装机容量与数据文件路径
station_3_capacity = 4456.00
station_3_generation_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站3发电数据.xlsx'
station_3_environment_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站3环境检测仪数据.xlsx'
station_3_weather_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站3天气数据.xlsx'

# 电站4的装机容量与数据文件路径
station_4_capacity = 1794.61
station_4_generation_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站4发电数据.xlsx'
station_4_environment_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站4环境监测仪数据.xlsx'
station_4_weather_file = r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\电站4天气数据.xlsx'

# 处理每个电站的数据
station_1_data = read_station_data(1, station_1_generation_file, station_1_environment_file, station_1_weather_file, station_1_capacity)
station_2_data = read_station_data(2, station_2_generation_file, station_2_environment_file, station_2_weather_file, station_2_capacity)
station_3_data = read_station_data(3, station_3_generation_file, station_3_environment_file, station_3_weather_file, station_3_capacity)
station_4_data = read_station_data(4, station_4_generation_file, station_4_environment_file, station_4_weather_file, station_4_capacity)

# 合并四个电站的数据
final_merged_data = pd.concat([station_1_data, station_2_data, station_3_data, station_4_data], ignore_index=True)

# 查看处理后的数据
print(final_merged_data.head())

# 保存清洗后的数据为新的 Excel 文件
final_merged_data.to_excel(r'C:\Users\Lanyi\Desktop\Project\Mathematical_modeling\2025\2025_A题\附件\四电站_清洗后数据.xlsx', index=False)