import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

class SleepSongInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  duration: string;
  type: string;

  constructor(id: string, title: string, artist: string, coverUrl: string, duration: string, type: string) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.duration = duration;
    this.type = type;
  }
}

class SleepStoryInfo {
  id: string;
  title: string;
  narrator: string;
  coverUrl: string;
  duration: string;
  category: string;

  constructor(id: string, title: string, narrator: string, coverUrl: string, duration: string, category: string) {
    this.id = id;
    this.title = title;
    this.narrator = narrator;
    this.coverUrl = coverUrl;
    this.duration = duration;
    this.category = category;
  }
}

@Entry
@Component
struct SleepModePage {
  @State currentSpectrumIndex: number = 0;
  @State spectrumItems: string[] = ['助眠音乐', '睡前故事', '白噪音', '冥想引导'];
  @State isPlaying: boolean = false;
  @State currentSongIndex: number = 0;
  @State timerMinutes: number = 30;
  @State isTimerOn: boolean = false;

  @State sleepSongs: SleepSongInfo[] = [
    new SleepSongInfo('1', '月光奏鸣曲', '贝多芬', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=300&h=300&fit=crop', '5:32', '古典'),
    new SleepSongInfo('2', '雨的印记', 'Yiruma', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=300&h=300&fit=crop', '3:40', '钢琴'),
    new SleepSongInfo('3', '星空', '理查德·克莱德曼', 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=300&h=300&fit=crop', '4:15', '轻音乐'),
    new SleepSongInfo('4', '摇篮曲', '莫扎特', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop', '3:08', '古典'),
    new SleepSongInfo('5', '深海', '班得瑞', 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=300&h=300&fit=crop', '6:20', '自然'),
  ];

  @State sleepStories: SleepStoryInfo[] = [
    new SleepStoryInfo('1', '小王子的星球之旅', '林夕', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&h=200&fit=crop', '15:30', '童话'),
    new SleepStoryInfo('2', '深夜食堂', '安倍夜郎', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', '12:45', '治愈'),
    new SleepStoryInfo('3', '星空下的约定', '宫崎骏', 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200&h=200&fit=crop', '18:20', '温情'),
    new SleepStoryInfo('4', '森林里的秘密', '安徒生', 'https://images.unsplash.com/photo-1447752875204-b2f9798c641c?w=200&h=200&fit=crop', '10:15', '童话'),
    new SleepStoryInfo('5', '海边的卡夫卡', '村上春树', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=200&h=200&fit=crop', '20:00', '文学'),
  ];

  @State whiteNoises: string[] = ['雨声', '海浪', '森林', '篝火', '风声', '溪流'];
  @State currentNoise: number = 0;

  @State meditations: SleepStoryInfo[] = [
    new SleepStoryInfo('1', '身体扫描放松', '李老师', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=200&h=200&fit=crop', '10:00', '放松'),
    new SleepStoryInfo('2', '呼吸冥想', '张老师', 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=200&h=200&fit=crop', '8:30', '冥想'),
    new SleepStoryInfo('3', '睡前感恩练习', '王老师', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=200&h=200&fit=crop', '12:00', '感恩'),
    new SleepStoryInfo('4', '渐进式肌肉放松', '陈老师', 'https://images.unsplash.com/photo-1508672019048-805c276e7e5a?w=200&h=200&fit=crop', '15:00', '放松'),
  ];

  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  @Builder
  NavBarBuilder() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(24).height(24).margin({ left: 15 })
        .onClick(() => { router.back(); })
      Blank()
      Text('睡眠模式').fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
      Blank()
      Image($r('app.media.more_menu')).width(24).height(24).margin({ right: 15 })
    }
    .width('100%').height(50).backgroundColor('#FFFFFF')
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
                .fontColor(this.currentSpectrumIndex === index ? '#4A90D9' : '#666666')
                .fontWeight(this.currentSpectrumIndex === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              if (this.currentSpectrumIndex === index) {
                Column().width(20).height(3).backgroundColor('#4A90D9').borderRadius(2)
              }
            }
            .onClick(() => { this.currentSpectrumIndex = index; })
          })
        }
        .padding({ left: 8, right: 8 })
      }
      .scrollBar(BarState.Off).scrollable(ScrollDirection.Horizontal)
    }
    .width('100%').margin({ top: 8, bottom: 8 })
    .backgroundColor('#FFFFFF').padding({ top: 8, bottom: 8 })
  }

  @Builder
  TimerBuilder() {
    Column() {
      Text('定时关闭')
        .fontSize(16).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ bottom: 12 }).width('100%').textAlign(TextAlign.Start)

      Row() {
        Text('-').fontSize(24).fontColor('#4A90D9').fontWeight(FontWeight.Bold)
          .onClick(() => { if (this.timerMinutes > 5) this.timerMinutes -= 5; })

        Column() {
          Text(`${this.timerMinutes}`).fontSize(36).fontColor('#4A90D9').fontWeight(FontWeight.Bold)
          Text('分钟').fontSize(12).fontColor('#666666')
        }
        .margin({ left: 40, right: 40 })

        Text('+').fontSize(24).fontColor('#4A90D9').fontWeight(FontWeight.Bold)
          .onClick(() => { if (this.timerMinutes < 120) this.timerMinutes += 5; })
      }
      .justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Center)

      Button(this.isTimerOn ? '关闭定时' : '开启定时')
        .fontSize(14).fontColor('#FFFFFF')
        .backgroundColor(this.isTimerOn ? '#FF6B6B' : '#4A90D9')
        .borderRadius(20).width(120).height(36)
        .margin({ top: 12 })
        .onClick(() => { this.isTimerOn = !this.isTimerOn; })
    }
    .width('100%').padding(16).backgroundColor('#FFFFFF').margin({ bottom: 12 })
  }

  @Builder
  SleepMusicBuilder() {
    Column() {
      this.TimerBuilder()

      Text('助眠音乐')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12 }).width('100%').textAlign(TextAlign.Start)

      Column() {
        ForEach(this.sleepSongs, (song: SleepSongInfo, index: number) => {
          Row() {
            Image(song.coverUrl).width(60).height(60).borderRadius(8).objectFit(ImageFit.Cover).margin({ right: 12 })
            Column() {
              Row() {
                Text(song.title).fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
                  .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
                Text(song.type).fontSize(10).fontColor('#4A90D9')
                  .padding({ left: 6, right: 6, top: 1, bottom: 1 })
                  .border({ width: 1, color: '#4A90D9' }).borderRadius(8).margin({ left: 8 })
              }
              .width('100%')
              Text(song.artist).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
              Text(song.duration).fontSize(11).fontColor('#999999').margin({ top: 4 }).width('100%')
            }
            .layoutWeight(1).alignItems(HorizontalAlign.Start)
            Column() {
              Text(index === this.currentSongIndex && this.isPlaying ? '⏸' : '▶')
                .fontSize(16).fontColor('#4A90D9')
            }
            .width(36).height(36).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
            .backgroundColor('#E8F4FD').borderRadius(18)
            .onClick(() => {
              this.currentSongIndex = index;
              this.isPlaying = !this.isPlaying;
            })
          }
          .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
          .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
        })
      }
      .width('100%').padding({ left: 16, right: 16 })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  SleepStoryBuilder() {
    Column() {
      Text('睡前故事')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      Column() {
        ForEach(this.sleepStories, (story: SleepStoryInfo) => {
          Row() {
            Image(story.coverUrl).width(70).height(70).borderRadius(8).objectFit(ImageFit.Cover).margin({ right: 12 })
            Column() {
              Row() {
                Text(story.title).fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
                  .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
                Text(story.category).fontSize(10).fontColor('#4A90D9')
                  .padding({ left: 6, right: 6, top: 1, bottom: 1 })
                  .border({ width: 1, color: '#4A90D9' }).borderRadius(8).margin({ left: 8 })
              }
              .width('100%')
              Text(story.narrator).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
              Text(story.duration).fontSize(11).fontColor('#999999').margin({ top: 4 }).width('100%')
            }
            .layoutWeight(1).alignItems(HorizontalAlign.Start)
            Column() {
              Text('▶').fontSize(16).fontColor('#4A90D9')
            }
            .width(36).height(36).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
            .backgroundColor('#E8F4FD').borderRadius(18)
          }
          .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
          .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
        })
      }
      .width('100%').padding({ left: 16, right: 16 })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  WhiteNoiseBuilder() {
    Column() {
      Text('白噪音')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.whiteNoises, (noise: string, index: number) => {
          Column() {
            Stack() {
              Image(`https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop`)
                .width('100%').aspectRatio(1).borderRadius(12).objectFit(ImageFit.Cover)
              Column()
                .width('100%').height('100%').backgroundColor('#4A90D940').borderRadius(12)
                .position({ x: 0, y: 0 })
              Column() {
                Text(this.currentNoise === index ? '⏸' : '▶')
                  .fontSize(24).fontColor('#FFFFFF')
              }
              .width(48).height(48).backgroundColor('#40000000').borderRadius(24)
              .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
              .position({ x: '50%', y: '50%' }).margin({ left: -24, top: -24 })
            }
            .width('100%')
            Text(noise).fontSize(14).fontColor('#000000').fontWeight(FontWeight.Bold)
              .margin({ top: 8 }).width('100%').textAlign(TextAlign.Center)
          }
          .width('30%').margin({ bottom: 16 })
          .onClick(() => { this.currentNoise = index; })
        })
      }
      .width('100%').padding({ left: 16, right: 16 })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  MeditationBuilder() {
    Column() {
      Text('冥想引导')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      Column() {
        ForEach(this.meditations, (meditation: SleepStoryInfo) => {
          Row() {
            Image(meditation.coverUrl).width(60).height(60).borderRadius(8).objectFit(ImageFit.Cover).margin({ right: 12 })
            Column() {
              Row() {
                Text(meditation.title).fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
                  .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
                Text(meditation.category).fontSize(10).fontColor('#4A90D9')
                  .padding({ left: 6, right: 6, top: 1, bottom: 1 })
                  .border({ width: 1, color: '#4A90D9' }).borderRadius(8).margin({ left: 8 })
              }
              .width('100%')
              Text(meditation.narrator).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
              Text(meditation.duration).fontSize(11).fontColor('#999999').margin({ top: 4 }).width('100%')
            }
            .layoutWeight(1).alignItems(HorizontalAlign.Start)
            Column() {
              Text('▶').fontSize(16).fontColor('#4A90D9')
            }
            .width(36).height(36).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
            .backgroundColor('#E8F4FD').borderRadius(18)
          }
          .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
          .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
        })
      }
      .width('100%').padding({ left: 16, right: 16 })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  ContentBuilder() {
    Scroll() {
      Column() {
        this.SpectrumBuilder()
        if (this.currentSpectrumIndex === 0) {
          this.SleepMusicBuilder()
        } else if (this.currentSpectrumIndex === 1) {
          this.SleepStoryBuilder()
        } else if (this.currentSpectrumIndex === 2) {
          this.WhiteNoiseBuilder()
        } else {
          this.MeditationBuilder()
        }
      }
      .width('100%')
    }
    .width('100%').layoutWeight(1).scrollBar(BarState.Auto)
  }

  build() {
    Column() {
      this.NavBarBuilder()
      this.ContentBuilder()
      MiniPlayer()
      this.GestureBackArea()
    }
    .width('100%').height('100%').backgroundColor('#F5F5F5')
  }

  @Builder
  GestureBackArea() {
    Column()
      .width(80).height('100%').position({ x: 0, y: 0 }).backgroundColor('transparent')
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
            if (deltaY > 100) { this.isInBackZone = false; return; }
            if (deltaX > 50) { this.isInBackZone = false; router.back(); }
          })
          .onActionEnd(() => { this.isInBackZone = false; })
      )
  }
}
