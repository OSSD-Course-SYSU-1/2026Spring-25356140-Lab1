import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 心动歌曲信息
 */
class HeartSongInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  lyric: string;
  heartRate: number;

  constructor(id: string, title: string, artist: string, coverUrl: string, lyric: string, heartRate: number) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.lyric = lyric;
    this.heartRate = heartRate;
  }
}

/**
 * 情歌信息
 */
class LoveSongInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  mood: string;
  lyricPreview: string;
  duration: string;

  constructor(id: string, title: string, artist: string, coverUrl: string, mood: string, lyricPreview: string, duration: string) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.mood = mood;
    this.lyricPreview = lyricPreview;
    this.duration = duration;
  }
}

/**
 * 治愈音乐信息
 */
class HealingMusicInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  scene: string;
  description: string;
  duration: string;

  constructor(id: string, title: string, artist: string, coverUrl: string, scene: string, description: string, duration: string) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.scene = scene;
    this.description = description;
    this.duration = duration;
  }
}

/**
 * 排行榜歌曲信息
 */
class ChartSongInfo {
  id: string;
  rank: number;
  title: string;
  artist: string;
  coverUrl: string;
  playCount: number;
  trend: string; // 'up', 'down', 'stable'
  change: number;

  constructor(id: string, rank: number, title: string, artist: string, coverUrl: string, playCount: number, trend: string, change: number) {
    this.id = id;
    this.rank = rank;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.playCount = playCount;
    this.trend = trend;
    this.change = change;
  }
}

/**
 * 心动模式页面
 * 包含可滑动的spectrum：心动推荐、甜蜜情歌、治愈轻音乐、心动排行榜
 */
@Entry
@Component
struct HeartModePage {
  // 当前选中的spectrum索引
  @State currentSpectrumIndex: number = 0;

  // Spectrum数据
  @State spectrumItems: string[] = ['心动推荐', '甜蜜情歌', '治愈轻音乐', '心动排行榜'];

  // ========== 心动推荐数据 ==========
  @State currentSongIndex: number = 0;
  @State isPlaying: boolean = false;
  @State heartSongs: HeartSongInfo[] = [
    new HeartSongInfo('1', '刚好遇见你', '李玉刚', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=300&h=300&fit=crop', '因为刚好遇见你，留下足迹才美丽', 85),
    new HeartSongInfo('2', '小幸运', '田馥甄', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=300&h=300&fit=crop', '原来你是我最想留住的幸运', 92),
    new HeartSongInfo('3', '告白气球', '周杰伦', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=300&h=300&fit=crop', '塞纳河畔，左岸的咖啡', 88),
    new HeartSongInfo('4', '演员', '薛之谦', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=300&h=300&fit=crop', '该配合你演出的我演视而不见', 78),
    new HeartSongInfo('5', '说散就散', '袁娅维', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=300&h=300&fit=crop', '抱一抱就当作从没有在一起', 82),
  ];

  // ========== 甜蜜情歌数据 ==========
  @State loveMoods: string[] = ['全部', '甜蜜', '伤感', '浪漫', '暗恋', '失恋'];
  @State currentLoveMood: number = 0;
  @State loveSongs: LoveSongInfo[] = [
    new LoveSongInfo('1', '甜甜的', '周杰伦', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', '甜蜜', '我轻轻地尝一口你说的爱我', '3:52'),
    new LoveSongInfo('2', '简单爱', '周杰伦', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', '浪漫', '我想就这样牵着你的手不放开', '4:30'),
    new LoveSongInfo('3', '晴天', '周杰伦', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', '暗恋', '从前从前有个人爱你很久', '4:29'),
    new LoveSongInfo('4', '后来', '刘若英', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', '伤感', '后来，我总算学会了如何去爱', '4:19'),
    new LoveSongInfo('5', '体面', '于文文', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', '失恋', '分手应该体面，谁都不要说抱歉', '4:12'),
    new LoveSongInfo('6', '遇见', '孙燕姿', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', '浪漫', '我遇见谁会有怎样的对白', '3:30'),
  ];

  // ========== 治愈轻音乐数据 ==========
  @State healingScenes: string[] = ['全部', '睡眠', '学习', '冥想', '雨天', '咖啡'];
  @State currentHealingScene: number = 0;
  @State healingMusic: HealingMusicInfo[] = [
    new HealingMusicInfo('1', '夜的钢琴曲五', '石进', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=200&fit=crop', '睡眠', '静谧夜晚，钢琴轻声诉说', '3:45'),
    new HealingMusicInfo('2', 'River Flows in You', 'Yiruma', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=200&h=200&fit=crop', '学习', '如流水般清澈的钢琴旋律', '3:06'),
    new HealingMusicInfo('3', '天空之城', '久石让', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', '冥想', '宫崎骏动画经典配乐', '2:34'),
    new HealingMusicInfo('4', '雨的印记', 'Yiruma', 'https://images.unsplash.com/photo-1447752875204-b2f9798c641c?w=200&h=200&fit=crop', '雨天', '雨滴落下的温柔旋律', '3:40'),
    new HealingMusicInfo('5', '卡农', '帕赫贝尔', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', '咖啡', '经典复调音乐，温暖午后', '4:25'),
    new HealingMusicInfo('6', '月光', '德彪西', 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=200&h=200&fit=crop', '冥想', '印象派钢琴代表作', '5:10'),
  ];

  // ========== 心动排行榜数据 ==========
  @State chartSongs: ChartSongInfo[] = [
    new ChartSongInfo('1', 1, '刚好遇见你', '李玉刚', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', 125800, 'up', 3),
    new ChartSongInfo('2', 2, '小幸运', '田馥甄', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', 98200, 'stable', 0),
    new ChartSongInfo('3', 3, '告白气球', '周杰伦', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', 87600, 'down', 1),
    new ChartSongInfo('4', 4, '演员', '薛之谦', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', 76500, 'up', 5),
    new ChartSongInfo('5', 5, '说散就散', '袁娅维', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', 65400, 'up', 2),
    new ChartSongInfo('6', 6, '后来', '刘若英', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 54300, 'stable', 0),
    new ChartSongInfo('7', 7, '体面', '于文文', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', 43200, 'down', 2),
    new ChartSongInfo('8', 8, '遇见', '孙燕姿', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', 32100, 'up', 4),
  ];

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  @Builder
  NavBarBuilder() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(24)
        .height(24)
        .margin({ left: 15 })
        .onClick(() => {
          router.back();
        })

      Blank()

      Text('心动模式')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)

      Blank()

      Image($r('app.media.more_menu'))
        .width(24)
        .height(24)
        .margin({ right: 15 })
    }
    .width('100%')
    .height(50)
    .backgroundColor('#FFFFFF')
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  SpectrumBuilder() {
    Column() {
      Scroll() {
        Row() {
          ForEach(this.spectrumItems, (item: string, index: number) => {
            Column() {
              Text(item)
                .fontSize(this.currentSpectrumIndex === index ? 16 : 14)
                .fontColor(this.currentSpectrumIndex === index ? '#C20C0C' : '#666666')
                .fontWeight(this.currentSpectrumIndex === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })

              if (this.currentSpectrumIndex === index) {
                Column()
                  .width(20)
                  .height(3)
                  .backgroundColor('#C20C0C')
                  .borderRadius(2)
              }
            }
            .onClick(() => {
              this.currentSpectrumIndex = index;
            })
          })
        }
        .padding({ left: 8, right: 8 })
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
    }
    .width('100%')
    .margin({ top: 8, bottom: 8 })
    .backgroundColor('#FFFFFF')
    .padding({ top: 8, bottom: 8 })
  }

  // ==================== 心动推荐（保留大封面播放器设计）====================
  @Builder
  HeartRecommendBuilder() {
    Column() {
      // 大封面
      Stack() {
        Image(this.heartSongs[this.currentSongIndex].coverUrl)
          .width(260)
          .height(260)
          .borderRadius(20)
          .objectFit(ImageFit.Cover)
          .shadow({ radius: 20, color: '#3F000000', offsetX: 0, offsetY: 10 })

        // 心动指数标签
        Column() {
          Text(`❤ ${this.heartSongs[this.currentSongIndex].heartRate}%`)
            .fontSize(14)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .padding({ left: 10, right: 10, top: 4, bottom: 4 })
        .backgroundColor('#C20C0C')
        .borderRadius(12)
        .position({ x: 16, y: 16 })
      }
      .width(260)
      .height(260)
      .margin({ top: 20, bottom: 30 })

      // 歌曲信息
      Text(this.heartSongs[this.currentSongIndex].title)
        .fontSize(22)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 })

      Text(this.heartSongs[this.currentSongIndex].artist)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 16 })

      // 歌词预览
      Text(this.heartSongs[this.currentSongIndex].lyric)
        .fontSize(13)
        .fontColor('#999999')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .padding({ left: 40, right: 40 })
        .margin({ bottom: 30 })

      // 进度条
      Slider({
        value: 30,
        min: 0,
        max: 100,
        step: 1
      })
        .width('70%')
        .margin({ bottom: 30 })

      // 播放控制
      Row() {
        // 上一首
        Column() {
          Text('⏮')
            .fontSize(32)
            .fontColor('#333333')
        }
        .onClick(() => {
          if (this.currentSongIndex > 0) {
            this.currentSongIndex--;
          } else {
            this.currentSongIndex = this.heartSongs.length - 1;
          }
        })

        // 播放/暂停
        Column() {
          Text(this.isPlaying ? '⏸' : '▶')
            .fontSize(48)
            .fontColor('#C20C0C')
        }
        .onClick(() => {
          this.isPlaying = !this.isPlaying;
        })

        // 下一首
        Column() {
          Text('⏭')
            .fontSize(32)
            .fontColor('#333333')
        }
        .onClick(() => {
          if (this.currentSongIndex < this.heartSongs.length - 1) {
            this.currentSongIndex++;
          } else {
            this.currentSongIndex = 0;
          }
        })
      }
      .width('60%')
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)

      // 底部间距
      Column()
        .width('100%')
        .height(100)
    }
    .width('100%')
  }

  // ==================== 甜蜜情歌（情绪标签+歌词预览列表）====================
  @Builder
  LoveSongsBuilder() {
    Column() {
      // 情绪标签
      Scroll() {
        Row() {
          ForEach(this.loveMoods, (mood: string, index: number) => {
            Column() {
              Text(mood)
                .fontSize(this.currentLoveMood === index ? 14 : 13)
                .fontColor(this.currentLoveMood === index ? '#FFFFFF' : '#666666')
                .fontWeight(this.currentLoveMood === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 16, right: 16, top: 6, bottom: 6 })
            }
            .backgroundColor(this.currentLoveMood === index ? '#C20C0C' : '#F5F5F5')
            .borderRadius(16)
            .margin({ right: 8 })
            .onClick(() => {
              this.currentLoveMood = index;
            })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .margin({ top: 8, bottom: 12 })

      // 歌曲列表
      Column() {
        ForEach(this.loveSongs, (song: LoveSongInfo) => {
          this.LoveSongCardBuilder(song)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      // 底部间距
      Column()
        .width('100%')
        .height(100)
    }
    .width('100%')
  }

  @Builder
  LoveSongCardBuilder(song: LoveSongInfo) {
    Row() {
      Image(song.coverUrl)
        .width(60)
        .height(60)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .margin({ right: 12 })

      Column() {
        Row() {
          Text(song.title)
            .fontSize(15)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          Text(song.mood)
            .fontSize(10)
            .fontColor('#C20C0C')
            .padding({ left: 6, right: 6, top: 1, bottom: 1 })
            .border({ width: 1, color: '#C20C0C' })
            .borderRadius(8)
            .margin({ left: 8 })
        }
        .width('100%')

        Text(song.artist)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .width('100%')

        // 歌词预览
        Text(`"${song.lyricPreview}"`)
          .fontSize(11)
          .fontColor('#999999')
          .fontStyle(FontStyle.Italic)
          .margin({ top: 6 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(song.duration)
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 4 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text('▶')
          .fontSize(16)
          .fontColor('#C20C0C')
      }
      .width(36)
      .height(36)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#FFF5F5')
      .borderRadius(18)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 10 })
    .shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
    .onClick(() => {
      console.info('点击情歌:', song.title);
    })
  }

  // ==================== 治愈轻音乐（场景卡片网格）====================
  @Builder
  HealingMusicBuilder() {
    Column() {
      // 场景标签
      Scroll() {
        Row() {
          ForEach(this.healingScenes, (scene: string, index: number) => {
            Column() {
              Text(scene)
                .fontSize(this.currentHealingScene === index ? 14 : 13)
                .fontColor(this.currentHealingScene === index ? '#FFFFFF' : '#666666')
                .fontWeight(this.currentHealingScene === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 16, right: 16, top: 6, bottom: 6 })
            }
            .backgroundColor(this.currentHealingScene === index ? '#C20C0C' : '#F5F5F5')
            .borderRadius(16)
            .margin({ right: 8 })
            .onClick(() => {
              this.currentHealingScene = index;
            })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .margin({ top: 8, bottom: 12 })

      // 场景卡片网格
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.healingMusic, (music: HealingMusicInfo) => {
          this.HealingCardBuilder(music)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      // 底部间距
      Column()
        .width('100%')
        .height(100)
    }
    .width('100%')
  }

  @Builder
  HealingCardBuilder(music: HealingMusicInfo) {
    Column() {
      Stack() {
        Image(music.coverUrl)
          .width('100%')
          .aspectRatio(1)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)

        // 场景标签
        Column() {
          Text(music.scene)
            .fontSize(10)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .padding({ left: 6, right: 6, top: 2, bottom: 2 })
        .backgroundColor('#C20C0C')
        .borderRadius(8)
        .position({ x: 8, y: 8 })

        // 播放按钮
        Column() {
          Text('▶')
            .fontSize(20)
            .fontColor('#FFFFFF')
        }
        .width(40)
        .height(40)
        .backgroundColor('#40000000')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: '50%', y: '50%' })
        .margin({ left: -20, top: -20 })
      }
      .width('100%')

      Text(music.title)
        .fontSize(14)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width('100%')

      Text(music.artist)
        .fontSize(11)
        .fontColor('#666666')
        .margin({ top: 2 })
        .width('100%')

      Text(music.description)
        .fontSize(11)
        .fontColor('#999999')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 4 })
        .width('100%')

      Text(music.duration)
        .fontSize(10)
        .fontColor('#999999')
        .margin({ top: 4 })
        .width('100%')
    }
    .width('48%')
    .margin({ bottom: 16 })
    .onClick(() => {
      console.info('点击治愈音乐:', music.title);
    })
  }

  // ==================== 心动排行榜（排名列表）====================
  @Builder
  HeartChartBuilder() {
    Column() {
      // 榜单标题
      Row() {
        Text('心动热榜')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('每日更新')
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 12 })

      // 前三名特殊展示
      Row() {
        ForEach(this.chartSongs.slice(0, 3), (song: ChartSongInfo, index: number) => {
          this.TopThreeCardBuilder(song, index)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ bottom: 16 })

      // 其他排名
      Column() {
        ForEach(this.chartSongs.slice(3), (song: ChartSongInfo) => {
          this.ChartListItemBuilder(song)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      // 底部间距
      Column()
        .width('100%')
        .height(100)
    }
    .width('100%')
  }

  @Builder
  TopThreeCardBuilder(song: ChartSongInfo, index: number) {
    Column() {
      Stack() {
        Image(song.coverUrl)
          .width(80)
          .height(80)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        // 排名徽章
        Column() {
          Text(`${song.rank}`)
            .fontSize(index === 0 ? 16 : 14)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .width(index === 0 ? 28 : 24)
        .height(index === 0 ? 28 : 24)
        .backgroundColor(
          index === 0 ? '#FFD700' :
          index === 1 ? '#C0C0C0' : '#CD7F32'
        )
        .borderRadius(index === 0 ? 14 : 12)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: -8, y: -8 })
      }
      .width(80)
      .height(80)
      .margin({ bottom: 8 })

      Text(song.title)
        .fontSize(12)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(80)
        .textAlign(TextAlign.Center)

      Text(song.artist)
        .fontSize(10)
        .fontColor('#666666')
        .margin({ top: 2 })
        .width(80)
        .textAlign(TextAlign.Center)
    }
    .onClick(() => {
      console.info('点击排行:', song.title);
    })
  }

  @Builder
  ChartListItemBuilder(song: ChartSongInfo) {
    Row() {
      // 排名
      Text(`${song.rank}`)
        .fontSize(16)
        .fontColor(song.rank <= 3 ? '#C20C0C' : '#999999')
        .fontWeight(FontWeight.Bold)
        .width(30)
        .textAlign(TextAlign.Center)

      Image(song.coverUrl)
        .width(50)
        .height(50)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .margin({ left: 8, right: 12 })

      Column() {
        Text(song.title)
          .fontSize(15)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(song.artist)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .width('100%')

        Row() {
          Text('▶')
            .fontSize(10)
            .fontColor('#999999')
            .margin({ right: 4 })

          Text(`${this.formatNumber(song.playCount)}`)
            .fontSize(11)
            .fontColor('#999999')
        }
        .margin({ top: 4 })
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 趋势
      Column() {
        Text(
          song.trend === 'up' ? '↑' :
          song.trend === 'down' ? '↓' : '-'
        )
          .fontSize(16)
          .fontColor(
            song.trend === 'up' ? '#FF0000' :
            song.trend === 'down' ? '#00AA00' : '#999999'
          )
          .fontWeight(FontWeight.Bold)

        if (song.change > 0) {
          Text(`${song.change}`)
            .fontSize(10)
            .fontColor('#FF0000')
        }
      }
      .width(30)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 8 })
    .shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
    .onClick(() => {
      console.info('点击榜单歌曲:', song.title);
    })
  }

  // ==================== 内容区域分发器 ====================
  @Builder
  ContentBuilder() {
    Scroll() {
      Column() {
        this.SpectrumBuilder()

        if (this.currentSpectrumIndex === 0) {
          this.HeartRecommendBuilder()
        } else if (this.currentSpectrumIndex === 1) {
          this.LoveSongsBuilder()
        } else if (this.currentSpectrumIndex === 2) {
          this.HealingMusicBuilder()
        } else {
          this.HeartChartBuilder()
        }
      }
      .width('100%')
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
  }

  private formatNumber(num: number): string {
    if (num >= 10000) {
      return (num / 10000).toFixed(1) + '万';
    }
    return num.toString();
  }

  build() {
    Column() {
      this.NavBarBuilder()
      this.ContentBuilder()
      MiniPlayer()
      this.GestureBackArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  GestureBackArea() {
    Column()
      .width(80)
      .height('100%')
      .position({ x: 0, y: 0 })
      .backgroundColor('transparent')
      .gesture(
        PanGesture({ direction: PanDirection.Right })
          .onActionStart((event: GestureEvent) => {
            this.startX = event.fingerList[0].localX;
            this.startY = event.fingerList[0].localY;
            this.isInBackZone = true;
          })
          .onActionUpdate((event: GestureEvent) => {
            if (!this.isInBackZone) return;
            const currentX: number = event.fingerList[0].localX;
            const currentY: number = event.fingerList[0].localY;
            const deltaX: number = currentX - this.startX;
            const deltaY: number = Math.abs(currentY - this.startY);
            if (deltaY > 100) {
              this.isInBackZone = false;
              return;
            }
            if (deltaX > 50) {
              this.isInBackZone = false;
              router.back();
            }
          })
          .onActionEnd(() => {
            this.isInBackZone = false;
          })
      )
  }
}
