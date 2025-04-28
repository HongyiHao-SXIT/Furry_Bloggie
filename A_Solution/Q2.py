import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ===== 第一步：读取数据 =====
df = pd.read_excel("四电站_GDI数据汇总.xlsx")  # 改成你的文件名

# ===== 第二步：数据清洗 =====
df = df[['GDI', '当日累计发电量kwh']].dropna()
df = df[df['GDI'].between(0, 1)]  # 仅保留正常 GDI 范围

# ===== 第三步：按 GDI 分组，计算平均发电量 =====
bins = np.arange(0, df['GDI'].max() + 0.01, 0.01)  # 每0.01为一个区间
df['GDI区间'] = pd.cut(df['GDI'], bins)
grouped = df.groupby('GDI区间')['当日累计发电量kwh'].mean().reset_index()
grouped['GDI中心值'] = grouped['GDI区间'].apply(lambda x: x.mid)

# ===== 第四步：剔除发电量波动异常的 GDI 区间 =====
rolling_mean = grouped['当日累计发电量kwh'].rolling(window=3, center=True).mean()
rolling_std = grouped['当日累计发电量kwh'].rolling(window=3, center=True).std()
z_scores = (grouped['当日累计发电量kwh'] - rolling_mean) / rolling_std
grouped_clean = grouped[(z_scores.abs() < 2) | (z_scores.isna())].copy()

# ===== 第五步：自动寻找拐点（差分法） =====
grouped_clean = grouped_clean.sort_values('GDI中心值')
grouped_clean['差分'] = grouped_clean['当日累计发电量kwh'].diff()

# 最小差分点 = 推荐清洗 GDI 阈值
min_drop_index = grouped_clean['差分'].idxmin()
threshold_gdi = grouped_clean.loc[min_drop_index, 'GDI中心值']
print(f"✅ 推荐清洗阈值 GDI ≈ {threshold_gdi:.3f}")

# ===== 第六步：可视化 =====
plt.figure(figsize=(10, 6))
plt.plot(grouped_clean['GDI中心值'], grouped_clean['当日累计发电量kwh'], marker='o', label="平均发电量")
plt.axvline(threshold_gdi, color='red', linestyle='--', label=f'推荐清洗阈值 ≈ {threshold_gdi:.3f}')
plt.title("GDI 与平均发电量关系（自动拐点分析）")
plt.xlabel("GDI")
plt.ylabel("平均发电量（kWh）")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig("GDI_Threshold_Point.png")  # 图像保存路径
plt.show()