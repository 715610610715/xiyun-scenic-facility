# 溪云智管 · 智慧景区设施管理平台（HarmonyOS 原生应用）


一款**面向景区管理/运维人员**的 HarmonyOS（ArkTS / ArkUI）原生 App：
把散布在景区各处的照明、空调、SOS 求助、水浸/门磁/温湿度等设施设备**收进一个手机**，
实现「设备总览 + 远程控制 + 告警处理 + 地图定位」的轻量管理闭环，并保留游客导览资产。

![HarmonyOS](https://img.shields.io/badge/HarmonyOS-API%2012%2B-007DFF)
![ArkTS](https://img.shields.io/badge/ArkTS-ArkUI-512BD4)
![DevEco Studio](https://img.shields.io/badge/DevEco%20Studio-6%2B-green)
![License](https://img.shields.io/badge/License-Apache--2.0-blue)

---

## 功能全景与实现状态

| 模块     | 功能                                   | 状态          | 说明                                                                           | 主要代码位置                                                   |
| ------ | ------------------------------------ | ----------- | ---------------------------------------------------------------------------- | -------------------------------------------------------- |
| 登录/会话  | 账号登录、Cookie 会话、协议勾选                  | ✅ 已实现（演示版）  | 免网关演示登录；网关直连登录接口已封装                                                          | `pages/LogIn.ets`、`utils/ApiService.ets`                 |
| 设备总览   | 3D 卡片轮播、实时状态文本（电量/信号/传感器值）、显隐筛选、归属区域 | ✅ 已实现       | 数据源：内网网关 `/api/room/allDevAndProcess`；网关不可达自动回退演示 Mock                       | `view/ZonesComponent.ets`、`viewmodel/ZonesViewModel.ets` |
| 设备详情   | 智能插座远程开关、功率、电量/信号、传感器属性、所属区域         | ✅ 已实现       | 控制接口 `/api/terminal/zigbee/sock/ctrl`；离线时开关走本地模拟                             | `pages/ZoneDetailPage.ets`                               |
| 设备显隐   | “我的”页按设备开关是否在总览展示                    | ✅ 已实现       | 演示“按需关注”                                                                     | `view/ProfilePage.ets`                                   |
| 告警中心   | 离线/低电量/水浸/SOS 告警列表、待处理/全部、确认/忽略、未读角标 | ✅ 已实现（演示版）  | 本地演示告警数据（未接平台推送，推送为后续项）；入口在“我的”页                                             | `pages/AlertsPage.ets`、`viewmodel/AlertsModel.ets`       |
| 地图     | 园区底图缩放/拖拽；**游客导览 / 设施分类 / 设备定位 三图层** | ✅ 已实现（演示点位） | 游客向 POI 保留；设施分类含配电/水泵/照明/环境/SOS/安防点位；**设备定位**可逐台查看插座/传感器所在位置（图标为演示占位，点击自动定位） | `view/MapComponent.ets`、`viewmodel/MapModel.ets`         |
| 园区环境卡  | 顶部半透明环境卡                             | ✅ 已改造       | 已去除“青岛”写死，改为“溪云谷”环境卡 + 离线 Mock 兜底                                            | `view/WeatherCard.ets`                                   |
| 动态开屏   | 按早/晚/夜切换轮播                           | ✅ 保留        | 欢迎语已统一为“溪云谷”语境                                                               | `pages/Splash.ets`                                       |
| 游客服务资产 | 观光小火车动画、建筑介绍页                        | ✅ 保留        | 游客向遗留完整保留，作为“游客服务/导览”模块                                                      | `view/TrainsComponent.ets` 等                             |
| 文案/命名  | App 名、登录/我的/总览页文案                    | ✅ 已统一       | 示例文案已景区化（溪云谷 · 溪云智管）                                                         | 资源 `string.json`、`CommonConstants.ets`                   |
| 演示模式   | 无网关自动回退 Mock 设备/告警/环境数据              | ✅ 已实现       | 登录免网关 + 数据 Mock，可离线完整体验主链路                                                   | `utils/ApiService.ets`、`viewmodel/AlertsModel.ets`       |
|        |                                      |             |                                                                              |                                                          |
|        |                                      |             |                                                                              |                                                          |
|        |                                      |             |                                                                              |                                                          |





## 快速开始

### 环境要求

- DevEco Studio 6.0+（内置 ohpm / hvigor / Node.js）
- HarmonyOS SDK API 12（5.0.0）及以上
- 运行目标：HarmonyOS 手机 / 平板 / DevEco Studio 模拟器

### 运行步骤

1. 用 DevEco Studio 打开工程根目录；
2. 等待 ohpm 自动安装依赖（`@ohos/axios`、`@ohos/crypto-js`、`@ohos/hypium`）；
3. `File → Project Structure → Signing Configs` 勾选 **Automatically generate signature**；
4. 选择真机或模拟器，点击 **Run 'entry'**。

### 演示说明

- 默认进入即**演示登录**（不请求网关）；设备/告警/环境数据在网关不可达时自动使用 **Mock 数据**，可离线完整体验；
- 接入真实网关：将 `common/utils/ApiService.ets` 的 `BASE` 改为景区内网网关地址，并把 `DEMO_MODE_FALLBACK` 置为 `false`。

---

演示路径

1. 打开 App → 演示登录进入；
2. “我的”页：看到告警中心未读角标 → 进入告警中心，处理（确认/忽略）水浸、离线等告警；
3. 设备总览：滑动 3D 卡片查看各设备实时状态与归属区域；
4. 进入“智能插座”详情 → 远程开启/关闭 → 状态即时反馈；
5. 地图页：切换“游客导览 / 设施图层”，查看设施点位（游客导览资产保留）。

---



## 目录结构

```
├── AppScope/                 # 应用级配置（应用名、图标等）
├── entry/
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── pages/        # 登录 / 主框架 / 设备详情 / 告警中心 等页面
│   │   │   ├── view/         # 地图 / 设备卡片 / 环境卡 / 我的 等组件
│   │   │   ├── viewmodel/    # 数据模型（设备/告警/地图/区域）
│   │   │   ├── controller/   # 地图手势与坐标控制器
│   │   │   ├── entryability/ # 入口 Ability
│   │   │   └── common/       # 常量、网关 API、日志、动画、屏幕适配
│   │   └── resources/        # 图片 / 多语言字符串 / 颜色 / 尺寸
│   └── src/test/             # 单元测试（hypium）
├── docs/                     # 产品与设计文档（本仓库）
├── screenshots/              # 截图与演示素材
├── build-profile.json5
└── hvigorfile.ts
```

---

## 声明

- 本项目为**个人学习作品**：素材与示例代码部分取自公开 HarmonyOS 示例工程，仅用于演示
- 网关地址、账号口令均为**演示占位**，请勿用于生产环境。
- 采用 [Apache-2.0](LICENSE) 协议（如有需要可更换为 MIT）。
