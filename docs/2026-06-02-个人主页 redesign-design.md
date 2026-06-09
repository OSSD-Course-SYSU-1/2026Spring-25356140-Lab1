# 仿网易云音乐新版个人主页设计文档

> **日期**: 2026-06-02  
> **主题**: ProfilePage 重新设计 + "我喜欢的音乐"收藏功能  
> **状态**: 已确认，待实现

---

## 一、设计目标

1. 将现有 `ProfilePage` 升级为仿网易云音乐新版个人主页风格
2. 实现"我喜欢的音乐"收藏功能（PlayerPage 点击喜欢 → 加入收藏列表）
3. 保持与现有项目架构一致，复用已有组件和模式

---

## 二、整体布局

```
┌─────────────────────────────────────┐
│  [←] 个人主页        [更多菜单 ⋮]    │  ← 顶部导航栏 (50px)
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │      背景图片（模糊+遮罩）      │   │  ← 头部信息区 (~45%屏幕)
│  │                             │   │
│  │    ┌────┐                  │   │
│  │    │头像│                  │   │
│  │    └────┘                  │   │
│  │    用户名                   │   │
│  │    这个人很懒，什么都没留下  │   │
│  │                             │   │
│  │  256  │ 128  │ LV.8 │ 1,248h│   │
│  │  关注  │ 粉丝  │ 等级  │ 听歌时长│   │
│  │                             │   │
│  │    [  编辑资料  ]            │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────────┐│
│  │  音乐    动态    播客            ││  ← Tab 栏
│  │  ────                            ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │  ┌──────────┐  ┌──────────┐    ││
│  │  │ ❤️       │  │ [封面]   │    ││  ← 歌单网格 (2列)
│  │  │ 我喜欢的  │  │ 创建歌单1│    ││
│  │  │ 音乐 14首│  │ 10首     │    ││
│  │  └──────────┘  └──────────┘    ││
│  │  ┌──────────┐  ┌──────────┐    ││
│  │  │ [封面]   │  │ [封面]   │    ││
│  │  │ 收藏歌单1│  │ 收藏歌单2│    ││
│  │  │ 15首     │  │ 20首     │    ││
│  │  └──────────┘  └──────────┘    ││
│  └─────────────────────────────────┘│
│                                     │
└─────────────────────────────────────┘
```

---

## 三、页面结构

### 3.1 顶部导航栏

| 元素 | 样式 |
|------|------|
| 返回按钮 | 左侧，24x24 图标 |
| 标题"个人主页" | 居中，18px，黑色粗体 |
| 更多菜单 | 右侧，24x24 图标 |
| 背景 | 白色，底部 1px #F0F0F0 边框 |
| 高度 | 50px |

### 3.2 头部信息区

| 元素 | 样式 |
|------|------|
| 背景图 | 全宽，占屏幕高度 45%，Cover 填充，blur(8) 毛玻璃，叠加 `#80000000` 黑色遮罩 |
| 更换背景按钮 | 左上角，半透明圆角按钮，白色文字 |
| 头像 | 80x80，圆形，白色 3px 边框 |
| 头像更换按钮 | 头像右下角，24x24，白色背景圆形 |
| 用户名 | 20px，白色，粗体 |
| 个性签名 | 14px，`#CCCCCC`，最多 2 行，省略号 |
| 统计数据 | 横向等分 4 列，数字 18px 白色粗体，标签 12px `#CCCCCC` |
| 编辑资料按钮 | 120x36，14px 白色文字，`#C20C0C` 背景，圆角 18px |

### 3.3 Tab 切换栏

| 元素 | 样式 |
|------|------|
| Tab 项 | "音乐" / "动态" / "播客" |
| 未选中 | 14px，`#666666`，普通字重 |
| 选中 | 16px，`#C20C0C`，粗体，底部 2px 红色指示条 |
| 布局 | 横向居中排列，等间距 |

### 3.4 音乐 Tab 内容

**歌单网格布局（2列）**

| 元素 | 样式 |
|------|------|
| 卡片尺寸 | 宽度 = (屏幕宽 - 48px) / 2，高度自适应 |
| 卡片间距 | 左右 16px，上下 12px |
| 封面图 | 正方形，圆角 8px |
| "我喜欢的音乐"特殊封面 | 红色渐变背景 + 白色心形图标 ♥ |
| 歌单名称 | 14px，黑色，最多 1 行，省略号 |
| 歌曲数量 | 12px，`#666666` |

**歌单分类顺序：**
1. 我喜欢的音乐（固定首位，特殊样式）
2. 创建的歌单
3. 收藏的歌单

---

## 四、"我喜欢的音乐"功能逻辑

### 4.1 数据模型

```typescript
// PlayerService 新增字段
private _likedSongs: SongInfo[] = [];  // 我喜欢的音乐列表
private onLikedSongsChangeListeners: ((songs: SongInfo[]) => void)[] = [];
```

### 4.2 接口方法

```typescript
// 切换喜欢状态（喜欢/取消喜欢）
toggleLikeSong(song: SongInfo): boolean

// 检查歌曲是否已喜欢
isSongLiked(song: SongInfo): boolean

// 获取我喜欢的音乐列表
getLikedSongs(): SongInfo[]

// 添加/移除监听器
addOnLikedSongsChange(callback: (songs: SongInfo[]) => void): void
removeOnLikedSongsChange(callback: (songs: SongInfo[]) => void): void
```

### 4.3 交互流程

```
用户正在播放歌曲
    ↓
PlayerPage 右下角显示 [♡] (空心，灰色)
    ↓
用户点击 [♡]
    ↓
PlayerService.toggleLikeSong(currentSong)
    ↓
├─ 如果未收藏：
│   ├─ _likedSongs.push(song)
│   ├─ 通知所有监听器
│   └─ 返回 true (已收藏)
└─ 如果已收藏：
    ├─ _likedSongs.splice(index, 1)
    ├─ 通知所有监听器
    └─ 返回 false (已取消收藏)
    ↓
PlayerPage 更新图标状态
├─ true  → 显示 [♥] (实心，红色 #C20C0C)
└─ false → 显示 [♡] (空心，灰色 #888888)
    ↓
ProfilePage "我喜欢的音乐"卡片更新歌曲数量
```

### 4.4 PlayerPage 修改

**右下角喜欢按钮位置：** 在播放控制按钮区域的最右侧（收藏按钮）。

```typescript
// PlayerPage 新增状态
@State isCurrentSongLiked: boolean = false;

// aboutToAppear 中检查当前歌曲是否已喜欢
this.isCurrentSongLiked = this.playerService.isSongLiked(this.currentSong);

// 喜欢按钮点击
.onClick(() => {
  if (this.currentSong) {
    this.isCurrentSongLiked = this.playerService.toggleLikeSong(this.currentSong);
  }
})
```

**图标显示逻辑：**
- 未喜欢：`Text('♡').fontColor('#888888').fontSize(24)`
- 已喜欢：`Text('♥').fontColor('#C20C0C').fontSize(24)`

### 4.5 ProfilePage "我喜欢的音乐"卡片

```typescript
// 特殊样式卡片
Column() {
  // 红色渐变背景
  Column() {
    Text('♥')
      .fontSize(32)
      .fontColor('#FFFFFF')
  }
  .width('100%')
  .aspectRatio(1)
  .backgroundColor('#C20C0C')  // 网易云红
  .borderRadius(8)
  .justifyContent(FlexAlign.Center)

  Text('我喜欢的音乐')
    .fontSize(14)
    .fontColor('#000000')
    .margin({ top: 6 })

  Text(likedSongsCount + '首')
    .fontSize(12)
    .fontColor('#666666')
    .margin({ top: 2 })
}
.onClick(() => {
  // 跳转歌单详情页（预留）
  router.pushUrl({
    url: 'pages/PlaylistDetailPage',
    params: { playlistId: 'liked', title: '我喜欢的音乐' }
  });
})
```

---

## 五、需要修改的文件清单

| 文件 | 修改类型 | 修改内容 |
|------|---------|---------|
| `PlayerService.ets` | 新增 | `_likedSongs` 数组，喜欢相关方法，监听器 |
| `PlayerPage.ets` | 修改 | 添加喜欢按钮，绑定 toggleLikeSong |
| `ProfilePage.ets` | 重写 | 全新布局，歌单网格，Tab 切换 |
| `SongInfo.ets` | 可选 | 添加 `isLiked` 字段（或保持 ID 比对） |

---

## 六、数据流设计

```
┌──────────────┐     toggleLikeSong      ┌──────────────┐
│  PlayerPage  │ ──────────────────────> │ PlayerService│
│  (喜欢按钮)   │                         │ (_likedSongs) │
└──────────────┘                         └──────┬───────┘
       ↑                                        │
       │         notifyLikedSongsChange         │
       └────────────────────────────────────────┘
                        │
                        ↓
               ┌──────────────┐
               │  ProfilePage  │
               │(我喜欢的音乐)  │
               └──────────────┘
```

---

## 七、颜色规范

| 用途 | 色值 |
|------|------|
| 网易云品牌红 | `#C20C0C` |
| 喜欢图标（已收藏）| `#C20C0C` |
| 喜欢图标（未收藏）| `#888888` |
| 背景遮罩 | `#80000000` |
| 次要文字 | `#666666` |
| 辅助文字 | `#CCCCCC` |
| 分割线 | `#F0F0F0` |
| 页面背景 | `#FFFFFF` |

---

## 八、实现优先级

1. **P0**: PlayerService 添加喜欢功能核心逻辑
2. **P0**: PlayerPage 添加喜欢按钮
3. **P1**: ProfilePage 全新布局实现
4. **P1**: ProfilePage 音乐 Tab 歌单网格
5. **P2**: 动态/播客 Tab 占位内容
6. **P2**: 歌单详情页跳转（预留接口）
