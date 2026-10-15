# 溪云智管 · 智慧景区设施管理平台

面向景区运维人员的 HarmonyOS 设施管理应用：把分散在各片区的照明、空调、SOS 求助、水浸、门磁、温湿度等设备收进一个手机，完成「看设备 — 做控制 — 处理告警 — 定位设备」的日常运维闭环。

![HarmonyOS](https://img.shields.io/badge/HarmonyOS-API%2012%2B-007DFF)
![ArkTS](https://img.shields.io/badge/ArkTS-ArkUI-512BD4)
![DevEco Studio](https://img.shields.io/badge/DevEco%20Studio-6%2B-green)
![License](https://img.shields.io/badge/License-Apache--2.0-blue)

## 功能概览

| 模块 | 说明 | 状态 |
| --- | --- | --- |
| 登录与会话 | 免网关演示登录；网关登录接口已封装（Cookie 会话） | 已实现 |
| 设备总览 | 卡片流展示设备状态，支持显示设置与归属区域 | 已实现 |
| 设备详情与远程控制 | 智能插座开关、功率、电量、信号与传感器属性 | 已实现 |
| 告警中心 | 离线、低电量、水浸、SOS 告警的查看、确认与忽略，含未读角标 | 已实现 |
| 地图三图层 | 游客导览 / 设施分类 / 设备定位，可逐台定位设备 | 已实现 |
| 园区环境卡 | 温度、湿度、风力展示，无网络时使用演示数据 | 已实现 |
| 演示模式 | 网关不可达时自动回退内置数据，可离线完整体验 | 已实现 |

## 仓库结构

```
溪云智管/
├── OxHornCampus/                 # HarmonyOS 工程（用 DevEco Studio 打开此目录）
│   ├── entry/src/main/ets/       # 页面、组件、视图模型与网关接口
│   ├── entry/src/main/resources/ # 图片、字符串、颜色等资源
│   ├── docs/                     # 产品文档（6 份）
│   ├── screenshots/              # 运行截图
│   └── README.md                 # 工程说明与功能状态明细
├── 原型/                          # 原型文件（Figma 导出、PDF、Axure、截图）
└── .gitignore
```

## 快速开始

1. 用 DevEco Studio 打开 `OxHornCampus` 目录；
2. 等待 ohpm 自动安装依赖；
3. `File → Project Structure → Signing Configs` 勾选自动签名；
4. 选择设备或模拟器，运行 `entry`。

没有网关环境也可以完整体验：应用会自动回退到内置演示数据，覆盖设备查看、开关控制、告警处理与地图定位。

## 产品文档

| 文档 | 内容 |
| --- | --- |
| [01 产品需求文档](OxHornCampus/docs/01-PRD-产品需求文档.md) | 背景与目标、用户故事、功能优先级、流程、字段、权限、异常、埋点与验收 |
| [02 竞品分析报告](OxHornCampus/docs/02-竞品分析报告.md) | 竞品选择、功能对比、优劣势、机会点 |
| [03 用户调研报告](OxHornCampus/docs/03-用户调研报告.md) | 调研方法、关键发现、需求转化 |
| [04 需求池与优先级矩阵](OxHornCampus/docs/04-需求池与优先级矩阵.md) | KANO、RICE、四象限与版本规划 |
| [05 数据埋点与指标定义](OxHornCampus/docs/05-数据埋点与指标定义.md) | 指标体系、埋点事件、数据看板 |
| [06 项目复盘](OxHornCampus/docs/06-项目复盘.md) | 目标与结果、原因分析、下一步迭代 |

## 技术要点

- ArkTS / ArkUI 声明式 UI，HarmonyOS API 12+，适配手机与平板；
- 通过景区内网网关接入 ZigBee 设备，涉及登录、设备列表、插座控制三类接口；
- 网关不可达时统一回退演示数据，保证功能可完整体验；
- 地图支持游客导览、设施分类、设备定位三个图层。

## 说明

- 仓库中的网关地址、账号与设备数据均为演示占位，不含真实账号、密钥或内网信息；
- 项目采用 Apache-2.0 协议，详见 [LICENSE](OxHornCampus/LICENSE)。