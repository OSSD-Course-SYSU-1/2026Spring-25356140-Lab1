import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 播客信息
 */
class PodcastInfo {
  id: string;
  title: string;
  subtitle: string;
  coverUrl: string;
  description: string;
  episodeCount: number;

  constructor(id: string, title: string, subtitle: string, coverUrl: string, description: string, episodeCount: number) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.coverUrl = coverUrl;
    this.description = description;
    this.episodeCount = episodeCount;
  }
}

/**
 * 电台信息
 */
class RadioStationInfo {
  id: string;
  name: string;
  category: string;
  coverUrl: string;
  description: string;
  listenerCount: number;
  isLive: boolean;
  color: string;

  constructor(id: string, name: string, category: string, coverUrl: string, description: string, listenerCount: number, isLive: boolean, color: string) {
    this.id = id;
    this.name = name;
    this.category = category;
    this.coverUrl = coverUrl;
    this.description = description;
    this.listenerCount = listenerCount;
    this.isLive = isLive;
    this.color = color;
  }
}

/**
 * 有声书信息
 */
class AudiobookInfo {
  id: string;
  title: string;
  author: string;
  coverUrl: string;
  description: string;
  totalChapters: number;
  progress: number;
  rating: number;
  category: string;

  constructor(id: string, title: string, author: string, coverUrl: string, description: string, totalChapters: number, progress: number, rating: number, category: string) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.coverUrl = coverUrl;
    this.description = description;
    this.totalChapters = totalChapters;
    this.progress = progress;
    this.rating = rating;
    this.category = category;
  }
}

/**
 * 相声评书信息
 */
class CrosstalkInfo {
  id: string;
  title: string;
  performer: string;
  coverUrl: string;
  type: string;
  duration: string;
  playCount: number;
  isClassic: boolean;

  constructor(id: string, title: string, performer: string, coverUrl: string, type: string, duration: string, playCount: number, isClassic: boolean) {
    this.id = id;
    this.title = title;
    this.performer = performer;
    this.coverUrl = coverUrl;
    this.type = type;
    this.duration = duration;
    this.playCount = playCount;
    this.isClassic = isClassic;
  }
}

/**
 * 私人FM页面
 * 包含可滑动的spectrum：私人播客、推荐电台、有声书、相声评书
 * 每个子页面有不同的布局设计
 */
@Entry
@Component
struct PrivateFMPage {
  // 当前选中的spectrum索引
  @State currentSpectrumIndex: number = 0;

  // Spectrum数据
  @State spectrumItems: string[] = ['私人播客', '推荐电台', '有声书', '相声评书'];

  // ========== 私人播客数据 ==========
  @State podcasts: PodcastInfo[] = [
    new PodcastInfo('1', 'TED Talks学习', '为你推荐的专属播客', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', '精选TED演讲，提升英语与思维', 128),
    new PodcastInfo('2', '汤令山Gareth.T', '为你推荐的专属播客', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', '香港新生代唱作人的音乐世界', 56),
    new PodcastInfo('3', '谈精神生活与自我修养', '为你推荐的专属播客', 'https://images.unsplash.com/photo-1447752875204-b2f9798c641c?w=200&h=200&fit=crop', '探索内心世界，提升生活品质', 89),
    new PodcastInfo('4', '深夜电台', '为你推荐的专属播客', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=200&h=200&fit=crop', '深夜里的温暖陪伴', 234),
    new PodcastInfo('5', '音乐故事', '为你推荐的专属播客', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=200&fit=crop', '每首歌背后都有一个故事', 167),
  ];

  // ========== 推荐电台数据 ==========
  @State radioStations: RadioStationInfo[] = [
    new RadioStationInfo('1', '网易云音乐电台', '音乐', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', '官方精选音乐电台，24小时不间断', 12580, true, '#C20C0C'),
    new RadioStationInfo('2', '深夜情感电台', '情感', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', '深夜里的心灵慰藉，温暖你的每一个夜晚', 8920, true, '#FF6B6B'),
    new RadioStationInfo('3', '搞笑脱口秀', '脱口秀', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', '每日精选搞笑段子，让你笑到停不下来', 5670, false, '#4ECDC4'),
    new RadioStationInfo('4', '悬疑有声书', '有声书', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', '精选悬疑推理小说，声临其境的体验', 3450, false, '#45B7D1'),
    new RadioStationInfo('5', '郭德纲相声集', '相声', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', '经典相声段子，百听不厌', 7890, false, '#96CEB4'),
    new RadioStationInfo('6', '轻音乐放松', '音乐', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', '工作学习时的最佳伴侣', 4560, true, '#FFEAA7'),
  ];

  // ========== 有声书数据 ==========
  @State audiobookCategories: string[] = ['全部', '悬疑推理', '言情', '历史', '科幻', '武侠'];
  @State currentAudiobookCategory: number = 0;
  @State audiobooks: AudiobookInfo[] = [
    new AudiobookInfo('1', '白夜行', '东野圭吾', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=200&h=300&fit=crop', '一段跨越19年的黑暗故事', 35, 0, 9.6, '悬疑推理'),
    new AudiobookInfo('2', '三体', '刘慈欣', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=300&fit=crop', '中国科幻巅峰之作', 90, 45, 9.8, '科幻'),
    new AudiobookInfo('3', '红楼梦', '曹雪芹', 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=200&h=300&fit=crop', '中国古典文学四大名著', 120, 12, 9.9, '历史'),
    new AudiobookInfo('4', '活着', '余华', 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=200&h=300&fit=crop', '一个人一生的故事', 28, 0, 9.5, '言情'),
    new AudiobookInfo('5', '射雕英雄传', '金庸', 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=200&h=300&fit=crop', '武侠经典，侠之大者', 80, 30, 9.7, '武侠'),
    new AudiobookInfo('6', '嫌疑人X的献身', '东野圭吾', 'https://images.unsplash.com/photo-1543002588-66bf7e85d91b?w=200&h=300&fit=crop', '天才数学家的完美犯罪', 25, 0, 9.4, '悬疑推理'),
  ];

  // ========== 相声评书数据 ==========
  @State crosstalkCategories: string[] = ['全部', '相声', '评书', '快板', '大鼓'];
  @State currentCrosstalkCategory: number = 0;
  @State crosstalks: CrosstalkInfo[] = [
    new CrosstalkInfo('1', '报菜名', '郭德纲', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', '相声', '8:32', 12580, true),
    new CrosstalkInfo('2', '三国演义', '单田芳', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', '评书', '45:20', 8920, true),
    new CrosstalkInfo('3', '同仁堂', '岳云鹏', 'https://images.unsplash.com/photo-1447752875204-b2f9798c641c?w=200&h=200&fit=crop', '相声', '12:15', 5670, false),
    new CrosstalkInfo('4', '水浒传', '刘兰芳', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=200&h=200&fit=crop', '评书', '38:45', 3450, true),
    new CrosstalkInfo('5', '玲珑塔', '张云雷', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=200&fit=crop', '快板', '5:30', 7890, false),
    new CrosstalkInfo('6', '西游记', '田连元', 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=200&h=200&fit=crop', '评书', '42:10', 4560, true),
  ];

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  /**
   * 构建顶部导航栏
   */
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

      Text('私人FM')
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

  /**
   * 构建Spectrum滑动选择器
   */
  @Builder
  SpectrumBuilder() {
    Column() {
      // 可滑动的spectrum
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

  // ==================== 私人播客内容（保留原有设计）====================
  @Builder
  PodcastContentBuilder() {
    Column() {
      Text('为你推荐的专属播客')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      // 播客列表
      Column() {
        ForEach(this.podcasts, (podcast: PodcastInfo) => {
          this.PodcastCardBuilder(podcast)
        })
      }
      .width('100%')
      .padding({ left: 12, right: 12 })

      // 底部间距
      Column()
        .width('100%')
        .height(100)
    }
    .width('100%')
  }

  @Builder
  PodcastCardBuilder(podcast: PodcastInfo) {
    Row() {
      Image(podcast.coverUrl)
        .width(80)
        .height(80)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .margin({ right: 12 })

      Column() {
        Text(podcast.title)
          .fontSize(16)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(podcast.subtitle)
          .fontSize(12)
          .fontColor('#C20C0C')
          .margin({ top: 4 })
          .maxLines(1)
          .width('100%')

        Text(podcast.description)
          .fontSize(13)
          .fontColor('#666666')
          .margin({ top: 6 })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(`${podcast.episodeCount}期`)
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 6 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text('▶')
          .fontSize(20)
          .fontColor('#C20C0C')
      }
      .width(40)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .border({ width: 1, color: '#C20C0C' })
      .borderRadius(20)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 12 })
    .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      console.info('点击播客:', podcast.title);
    })
  }

  // ==================== 推荐电台内容（2列网格布局）====================
  @Builder
  RadioStationContentBuilder() {
    Column() {
      // 标题栏
      Row() {
        Text('热门电台')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('全部电台')
          .fontSize(13)
          .fontColor('#666666')
          .padding({ left: 12, right: 12, top: 4, bottom: 4 })
          .border({ width: 1, color: '#CCCCCC' })
          .borderRadius(12)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 12 })

      // 2列网格布局
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.radioStations, (radio: RadioStationInfo) => {
          this.RadioStationCardBuilder(radio)
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
  RadioStationCardBuilder(radio: RadioStationInfo) {
    Column() {
      Stack() {
        Image(radio.coverUrl)
          .width('100%')
          .aspectRatio(1)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)

        // 直播中标签
        if (radio.isLive) {
          Column() {
            Text('LIVE')
              .fontSize(10)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
          }
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor('#FF0000')
          .borderRadius(8)
          .position({ x: 8, y: 8 })
        }

        // 分类色块标签
        Column() {
          Text(radio.category)
            .fontSize(10)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .padding({ left: 6, right: 6, top: 2, bottom: 2 })
        .backgroundColor(radio.color)
        .borderRadius(8)
        .position({ x: 8, y: '100%' })
        .margin({ top: -28 })

        // 播放按钮覆盖层
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

      Text(radio.name)
        .fontSize(14)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width('100%')

      Text(radio.description)
        .fontSize(11)
        .fontColor('#666666')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 4 })
        .width('100%')

      Row() {
        Text('▶')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ right: 2 })

        Text(`${this.formatNumber(radio.listenerCount)}`)
          .fontSize(11)
          .fontColor('#999999')
      }
      .margin({ top: 4 })
      .width('100%')
    }
    .width('48%')
    .margin({ bottom: 16 })
    .onClick(() => {
      console.info('点击电台:', radio.name);
    })
  }

  // ==================== 有声书内容（书架式布局）====================
  @Builder
  AudiobookContentBuilder() {
    Column() {
      // 分类标签
      Scroll() {
        Row() {
          ForEach(this.audiobookCategories, (category: string, index: number) => {
            Column() {
              Text(category)
                .fontSize(this.currentAudiobookCategory === index ? 14 : 13)
                .fontColor(this.currentAudiobookCategory === index ? '#FFFFFF' : '#666666')
                .fontWeight(this.currentAudiobookCategory === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 16, right: 16, top: 6, bottom: 6 })
            }
            .backgroundColor(this.currentAudiobookCategory === index ? '#C20C0C' : '#F5F5F5')
            .borderRadius(16)
            .margin({ right: 8 })
            .onClick(() => {
              this.currentAudiobookCategory = index;
            })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .margin({ top: 8, bottom: 12 })

      // 有声书列表
      Column() {
        ForEach(this.audiobooks, (book: AudiobookInfo) => {
          this.AudiobookCardBuilder(book)
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
  AudiobookCardBuilder(book: AudiobookInfo) {
    Row() {
      // 封面 - 竖版比例
      Stack() {
        Image(book.coverUrl)
          .width(80)
          .height(110)
          .borderRadius(6)
          .objectFit(ImageFit.Cover)

        // 分类标签
        Column() {
          Text(book.category)
            .fontSize(9)
            .fontColor('#FFFFFF')
        }
        .padding({ left: 4, right: 4, top: 1, bottom: 1 })
        .backgroundColor('#C20C0C')
        .borderRadius({ topLeft: 6, bottomRight: 6 })
        .position({ x: 0, y: 0 })
      }
      .width(80)
      .height(110)
      .margin({ right: 12 })

      // 信息区域
      Column() {
        Text(book.title)
          .fontSize(16)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(book.author)
          .fontSize(13)
          .fontColor('#666666')
          .margin({ top: 4 })
          .width('100%')

        Text(book.description)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 6 })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        // 进度条
        if (book.progress > 0) {
          Column() {
            Row() {
              Text(`已读 ${book.progress}/${book.totalChapters} 章`)
                .fontSize(11)
                .fontColor('#666666')

              Text(`${Math.floor((book.progress / book.totalChapters) * 100)}%`)
                .fontSize(11)
                .fontColor('#C20C0C')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Progress({
              value: book.progress,
              total: book.totalChapters,
              type: ProgressType.Linear
            })
              .width('100%')
              .height(4)
              .color('#C20C0C')
              .backgroundColor('#E0E0E0')
              .margin({ top: 4 })
          }
          .margin({ top: 8 })
          .width('100%')
        } else {
          Text(`${book.totalChapters}章全本`)
            .fontSize(11)
            .fontColor('#999999')
            .margin({ top: 8 })
            .width('100%')
        }

        // 评分
        Row() {
          Text('★')
            .fontSize(12)
            .fontColor('#FFD700')
            .margin({ right: 2 })

          Text(`${book.rating}`)
            .fontSize(12)
            .fontColor('#FF9500')
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 6 })
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .height(110)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 12 })
    .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      console.info('点击有声书:', book.title);
    })
  }

  // ==================== 相声评书内容（传统风格）====================
  @Builder
  CrosstalkContentBuilder() {
    Column() {
      // 分类标签
      Scroll() {
        Row() {
          ForEach(this.crosstalkCategories, (category: string, index: number) => {
            Column() {
              Text(category)
                .fontSize(this.currentCrosstalkCategory === index ? 14 : 13)
                .fontColor(this.currentCrosstalkCategory === index ? '#C20C0C' : '#666666')
                .fontWeight(this.currentCrosstalkCategory === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 16, right: 16, top: 6, bottom: 6 })
            }
            .backgroundColor(this.currentCrosstalkCategory === index ? '#FFF5F5' : '#F5F5F5')
            .borderRadius(16)
            .border({ width: this.currentCrosstalkCategory === index ? 1 : 0, color: '#C20C0C' })
            .margin({ right: 8 })
            .onClick(() => {
              this.currentCrosstalkCategory = index;
            })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .margin({ top: 8, bottom: 12 })

      // 经典推荐横幅
      if (this.currentCrosstalkCategory === 0) {
        Column() {
          Text('经典推荐')
            .fontSize(16)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 16, bottom: 8 })
            .width('100%')
            .textAlign(TextAlign.Start)

          Scroll() {
            Row() {
              ForEach(this.crosstalks.filter((item: CrosstalkInfo) => item.isClassic), (item: CrosstalkInfo) => {
                this.CrosstalkClassicCardBuilder(item)
              })
            }
            .padding({ left: 16, right: 16 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .margin({ bottom: 16 })
      }

      // 相声评书列表
      Column() {
        Text('全部节目')
          .fontSize(16)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16, bottom: 8 })
          .width('100%')
          .textAlign(TextAlign.Start)

        ForEach(this.crosstalks, (item: CrosstalkInfo) => {
          this.CrosstalkListItemBuilder(item)
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
  CrosstalkClassicCardBuilder(item: CrosstalkInfo) {
    Column() {
      Stack() {
        Image(item.coverUrl)
          .width(120)
          .height(120)
          .borderRadius(60)
          .objectFit(ImageFit.Cover)
          .border({ width: 3, color: '#C20C0C' })

        // 经典标签
        if (item.isClassic) {
          Column() {
            Text('经典')
              .fontSize(9)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
          }
          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          .backgroundColor('#C20C0C')
          .borderRadius(8)
          .position({ x: 80, y: 0 })
        }
      }
      .width(120)
      .height(120)

      Text(item.title)
        .fontSize(13)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width(120)
        .textAlign(TextAlign.Center)

      Text(item.performer)
        .fontSize(11)
        .fontColor('#666666')
        .margin({ top: 4 })
        .width(120)
        .textAlign(TextAlign.Center)
    }
    .margin({ right: 16 })
    .onClick(() => {
      console.info('点击经典:', item.title);
    })
  }

  @Builder
  CrosstalkListItemBuilder(item: CrosstalkInfo) {
    Row() {
      // 圆形艺人头像
      Image(item.coverUrl)
        .width(50)
        .height(50)
        .borderRadius(25)
        .objectFit(ImageFit.Cover)
        .margin({ right: 12 })

      // 信息
      Column() {
        Row() {
          Text(item.title)
            .fontSize(15)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          // 类型标签
          Text(item.type)
            .fontSize(10)
            .fontColor('#C20C0C')
            .padding({ left: 6, right: 6, top: 1, bottom: 1 })
            .border({ width: 1, color: '#C20C0C' })
            .borderRadius(8)
            .margin({ left: 8 })
        }
        .width('100%')

        Text(item.performer)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .width('100%')

        Row() {
          Text('▶')
            .fontSize(10)
            .fontColor('#999999')
            .margin({ right: 4 })

          Text(`${this.formatNumber(item.playCount)}次播放`)
            .fontSize(11)
            .fontColor('#999999')

          Text('·')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ left: 6, right: 6 })

          Text(item.duration)
            .fontSize(11)
            .fontColor('#999999')
        }
        .margin({ top: 6 })
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 播放按钮
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
      console.info('点击节目:', item.title);
    })
  }

  // ==================== 内容区域分发器 ====================
  @Builder
  ContentBuilder() {
    Scroll() {
      Column() {
        // Spectrum滑动选择器
        this.SpectrumBuilder()

        // 根据当前选中的spectrum显示不同内容
        if (this.currentSpectrumIndex === 0) {
          this.PodcastContentBuilder()
        } else if (this.currentSpectrumIndex === 1) {
          this.RadioStationContentBuilder()
        } else if (this.currentSpectrumIndex === 2) {
          this.AudiobookContentBuilder()
        } else {
          this.CrosstalkContentBuilder()
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
      // 顶部导航栏
      this.NavBarBuilder()

      // 内容区域
      this.ContentBuilder()

      // 迷你播放器
      MiniPlayer()

      // 左侧手势返回区域
      this.GestureBackArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 手势返回区域
   */
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
            if (!this.isInBackZone) {
              return;
            }

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
