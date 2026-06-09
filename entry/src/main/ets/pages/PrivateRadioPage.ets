import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 电台信息
 */
class RadioInfo {
  id: string;
  name: string;
  category: string;
  coverUrl: string;
  description: string;
  listenerCount: number;
  isLive: boolean;

  constructor(id: string, name: string, category: string, coverUrl: string, description: string, listenerCount: number, isLive: boolean) {
    this.id = id;
    this.name = name;
    this.category = category;
    this.coverUrl = coverUrl;
    this.description = description;
    this.listenerCount = listenerCount;
    this.isLive = isLive;
  }
}

/**
 * 播客信息
 */
class RadioPodcastInfo {
  id: string;
  title: string;
  host: string;
  coverUrl: string;
  description: string;
  episodeCount: number;
  updateTime: string;

  constructor(id: string, title: string, host: string, coverUrl: string, description: string, episodeCount: number, updateTime: string) {
    this.id = id;
    this.title = title;
    this.host = host;
    this.coverUrl = coverUrl;
    this.description = description;
    this.episodeCount = episodeCount;
    this.updateTime = updateTime;
  }
}

/**
 * 有声书信息
 */
class RadioAudiobookInfo {
  id: string;
  title: string;
  author: string;
  narrator: string;
  coverUrl: string;
  description: string;
  totalChapters: number;
  progress: number;

  constructor(id: string, title: string, author: string, narrator: string, coverUrl: string, description: string, totalChapters: number, progress: number) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.narrator = narrator;
    this.coverUrl = coverUrl;
    this.description = description;
    this.totalChapters = totalChapters;
    this.progress = progress;
  }
}

/**
 * 音乐分类信息
 */
class MusicCategoryInfo {
  id: string;
  name: string;
  coverUrl: string;
  songCount: number;
  color: string;

  constructor(id: string, name: string, coverUrl: string, songCount: number, color: string) {
    this.id = id;
    this.name = name;
    this.coverUrl = coverUrl;
    this.songCount = songCount;
    this.color = color;
  }
}

/**
 * 私人电台页面
 * 包含可滑动的spectrum：我的电台、播客订阅、有声书库、音乐分类
 */
@Entry
@Component
struct PrivateRadioPage {
  // 当前选中的spectrum索引
  @State currentSpectrumIndex: number = 0;

  // Spectrum数据
  @State spectrumItems: string[] = ['我的电台', '播客订阅', '有声书库', '音乐分类'];

  // ========== 我的电台数据 ==========
  @State myRadios: RadioInfo[] = [
    new RadioInfo('1', '网易云音乐电台', '音乐', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', '官方精选音乐电台，24小时不间断', 12580, true),
    new RadioInfo('2', '深夜情感电台', '情感', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', '深夜里的心灵慰藉', 8920, true),
    new RadioInfo('3', '搞笑脱口秀', '脱口秀', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', '每日精选搞笑段子', 5670, false),
    new RadioInfo('4', '悬疑有声书', '有声书', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', '精选悬疑推理小说', 3450, false),
    new RadioInfo('5', '郭德纲相声集', '相声', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', '经典相声段子', 7890, false),
  ];

  // ========== 播客订阅数据 ==========
  @State podcasts: RadioPodcastInfo[] = [
    new RadioPodcastInfo('1', 'TED Talks学习', 'TED', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', '精选TED演讲，提升英语与思维', 128, '2小时前'),
    new RadioPodcastInfo('2', '汤令山Gareth.T', 'Gareth.T', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', '香港新生代唱作人的音乐世界', 56, '昨天'),
    new RadioPodcastInfo('3', '谈精神生活与自我修养', '哲学家', 'https://images.unsplash.com/photo-1447752875204-b2f9798c641c?w=200&h=200&fit=crop', '探索内心世界，提升生活品质', 89, '3天前'),
    new RadioPodcastInfo('4', '深夜电台', 'DJ小明', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=200&h=200&fit=crop', '深夜里的温暖陪伴', 234, '今天'),
    new RadioPodcastInfo('5', '音乐故事', '音乐君', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=200&fit=crop', '每首歌背后都有一个故事', 167, '昨天'),
  ];

  // ========== 有声书库数据 ==========
  @State audiobooks: RadioAudiobookInfo[] = [
    new RadioAudiobookInfo('1', '白夜行', '东野圭吾', '王明军', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=200&h=300&fit=crop', '一段跨越19年的黑暗故事', 35, 0),
    new RadioAudiobookInfo('2', '三体', '刘慈欣', '王明军', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=300&fit=crop', '中国科幻巅峰之作', 90, 45),
    new RadioAudiobookInfo('3', '红楼梦', '曹雪芹', '李野墨', 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=200&h=300&fit=crop', '中国古典文学四大名著', 120, 12),
    new RadioAudiobookInfo('4', '活着', '余华', '李立宏', 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=200&h=300&fit=crop', '一个人一生的故事', 28, 0),
    new RadioAudiobookInfo('5', '射雕英雄传', '金庸', '张少佐', 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=200&h=300&fit=crop', '武侠经典，侠之大者', 80, 30),
  ];

  // ========== 音乐分类数据 ==========
  @State musicCategories: MusicCategoryInfo[] = [
    new MusicCategoryInfo('1', '流行', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', 12580, '#FF6B6B'),
    new MusicCategoryInfo('2', '摇滚', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', 8920, '#4ECDC4'),
    new MusicCategoryInfo('3', '民谣', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', 5670, '#45B7D1'),
    new MusicCategoryInfo('4', '电子', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', 3450, '#96CEB4'),
    new MusicCategoryInfo('5', '古典', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', 7890, '#FFEAA7'),
    new MusicCategoryInfo('6', '爵士', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 4560, '#DDA0DD'),
    new MusicCategoryInfo('7', '说唱', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', 3210, '#98D8C8'),
    new MusicCategoryInfo('8', 'R&B', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', 2340, '#F7DC6F'),
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

      Text('私人电台')
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

  // ==================== 我的电台（保留列表设计）====================
  @Builder
  MyRadioBuilder() {
    Column() {
      Text('我的订阅电台')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Column() {
        ForEach(this.myRadios, (radio: RadioInfo) => {
          this.RadioListItemBuilder(radio)
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
  RadioListItemBuilder(radio: RadioInfo) {
    Row() {
      Stack() {
        Image(radio.coverUrl)
          .width(70)
          .height(70)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        if (radio.isLive) {
          Column() {
            Text('LIVE')
              .fontSize(9)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
          }
          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          .backgroundColor('#FF0000')
          .borderRadius(6)
          .position({ x: 4, y: 4 })
        }
      }
      .width(70)
      .height(70)
      .margin({ right: 12 })

      Column() {
        Text(radio.name)
          .fontSize(15)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(radio.description)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          Text('▶')
            .fontSize(10)
            .fontColor('#999999')
            .margin({ right: 4 })

          Text(`${this.formatNumber(radio.listenerCount)}人在听`)
            .fontSize(11)
            .fontColor('#999999')
        }
        .margin({ top: 6 })
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
      console.info('点击电台:', radio.name);
    })
  }

  // ==================== 播客订阅（横向卡片+列表混合）====================
  @Builder
  PodcastBuilder() {
    Column() {
      // 最近更新
      Text('最近更新')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Scroll() {
        Row() {
          ForEach(this.podcasts.slice(0, 3), (podcast: RadioPodcastInfo) => {
            this.PodcastHorizontalCardBuilder(podcast)
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .margin({ bottom: 16 })

      // 全部播客
      Text('全部播客')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Column() {
        ForEach(this.podcasts, (podcast: RadioPodcastInfo) => {
          this.PodcastListItemBuilder(podcast)
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
  PodcastHorizontalCardBuilder(podcast: RadioPodcastInfo) {
    Column() {
      Stack() {
        Image(podcast.coverUrl)
          .width(140)
          .height(140)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)

        Column() {
          Text('▶')
            .fontSize(24)
            .fontColor('#FFFFFF')
        }
        .width(48)
        .height(48)
        .backgroundColor('#40000000')
        .borderRadius(24)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: '50%', y: '50%' })
        .margin({ left: -24, top: -24 })
      }
      .width(140)
      .height(140)

      Text(podcast.title)
        .fontSize(13)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width(140)

      Text(podcast.host)
        .fontSize(11)
        .fontColor('#666666')
        .margin({ top: 2 })
        .width(140)

      Text(podcast.updateTime)
        .fontSize(10)
        .fontColor('#999999')
        .margin({ top: 2 })
        .width(140)
    }
    .margin({ right: 12 })
    .onClick(() => {
      console.info('点击播客:', podcast.title);
    })
  }

  @Builder
  PodcastListItemBuilder(podcast: RadioPodcastInfo) {
    Row() {
      Image(podcast.coverUrl)
        .width(60)
        .height(60)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .margin({ right: 12 })

      Column() {
        Text(podcast.title)
          .fontSize(15)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(podcast.host)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .width('100%')

        Text(podcast.description)
          .fontSize(11)
          .fontColor('#999999')
          .margin({ top: 4 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          Text(`${podcast.episodeCount}期`)
            .fontSize(11)
            .fontColor('#999999')

          Text('·')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ left: 6, right: 6 })

          Text(podcast.updateTime)
            .fontSize(11)
            .fontColor('#999999')
        }
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
      console.info('点击播客:', podcast.title);
    })
  }

  // ==================== 有声书库（书架式布局）====================
  @Builder
  AudiobookBuilder() {
    Column() {
      Text('我的书架')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      // 书架网格
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.audiobooks, (book: RadioAudiobookInfo) => {
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
  AudiobookCardBuilder(book: RadioAudiobookInfo) {
    Column() {
      Stack() {
        Image(book.coverUrl)
          .width('100%')
          .aspectRatio(0.75)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        if (book.progress > 0) {
          Column() {
            Text(`${Math.floor((book.progress / book.totalChapters) * 100)}%`)
              .fontSize(10)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
          }
          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          .backgroundColor('#C20C0C')
          .borderRadius({ topLeft: 8, bottomRight: 6 })
          .position({ x: 0, y: 0 })
        }
      }
      .width('100%')

      Text(book.title)
        .fontSize(13)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width('100%')

      Text(book.author)
        .fontSize(11)
        .fontColor('#666666')
        .margin({ top: 2 })
        .width('100%')

      Text(`演播：${book.narrator}`)
        .fontSize(10)
        .fontColor('#999999')
        .margin({ top: 2 })
        .width('100%')

      if (book.progress > 0) {
        Progress({
          value: book.progress,
          total: book.totalChapters,
          type: ProgressType.Linear
        })
          .width('100%')
          .height(3)
          .color('#C20C0C')
          .backgroundColor('#E0E0E0')
          .margin({ top: 6 })
      } else {
        Text(`${book.totalChapters}章全本`)
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 6 })
          .width('100%')
      }
    }
    .width('30%')
    .margin({ bottom: 16 })
    .onClick(() => {
      console.info('点击有声书:', book.title);
    })
  }

  // ==================== 音乐分类（彩色网格）====================
  @Builder
  MusicCategoryBuilder() {
    Column() {
      Text('音乐分类')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      // 分类网格
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.musicCategories, (category: MusicCategoryInfo) => {
          this.CategoryCardBuilder(category)
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
  CategoryCardBuilder(category: MusicCategoryInfo) {
    Column() {
      Stack() {
        Image(category.coverUrl)
          .width('100%')
          .aspectRatio(1)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)

        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(category.color + '80')
          .borderRadius(12)
          .position({ x: 0, y: 0 })

        Column() {
          Text(category.name)
            .fontSize(18)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)

          Text(`${this.formatNumber(category.songCount)}首`)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .margin({ top: 4 })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: '50%', y: '50%' })
        .margin({ left: -30, top: -20 })
      }
      .width('100%')
    }
    .width('48%')
    .margin({ bottom: 16 })
    .onClick(() => {
      console.info('点击分类:', category.name);
    })
  }

  // ==================== 内容区域分发器 ====================
  @Builder
  ContentBuilder() {
    Scroll() {
      Column() {
        this.SpectrumBuilder()

        if (this.currentSpectrumIndex === 0) {
          this.MyRadioBuilder()
        } else if (this.currentSpectrumIndex === 1) {
          this.PodcastBuilder()
        } else if (this.currentSpectrumIndex === 2) {
          this.AudiobookBuilder()
        } else {
          this.MusicCategoryBuilder()
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
