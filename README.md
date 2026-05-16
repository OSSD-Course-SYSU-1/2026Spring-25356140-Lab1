<<<<<<< HEAD
# 网易云音乐
🎅❄️🎶Optimization project

## 鸿蒙ArkTs仿网易云音乐

- [api来源](https://github.com/Binaryify/NeteaseCloudMusicApi)

- [源码地址](https://github.com/linwu-hi/open_neteasy_cloud)




## 功能介绍

- 登陆
- 首页
- 每日推荐
- 歌单广场
- 排行榜
- 云村热评
- 视频
- MV详情页
- 我的
- 电台模块【电台首页，电台详情, 电台排行榜】
- 搜索【支持单曲，MV，专辑，歌单，电台】
- 播放页【歌词，播放列表，上一首，下一首】

## 部分功能效果图

![](https://github.com/linwu-hi/release-dev-offline/blob/main/docs/20231123164849.jpg)
![](https://github.com/linwu-hi/release-dev-offline/blob/main/docs/20231123164921.jpg)

## 原版修改说明
为了能在虚拟机中正常运行，在升级功能之前，对原版代码进行了如下安全性修改：
### 1. 类属性初始化问题 (4个错误)
ListItemData.ets: 将 title、summary、imageArrow 改为可选属性 (?)
Category.ets: 将 title、categoryContent 改为可选属性 (?)
### 2. 类型安全问题 (3个错误)
DetailListComponent.ets: 为 ForEach 回调参数添加显式类型声明
HomePage.ets: 修复路由参数访问，使用 Record<string, Object> 类型
IndexPage.ets: 同样修复路由参数访问方式
DailyRecommendPage.ets: 同样修复路由参数访问方式

## 虚拟机录频01
展示了原版项目在虚拟机上运行的录频。

### **持续更新中...**

