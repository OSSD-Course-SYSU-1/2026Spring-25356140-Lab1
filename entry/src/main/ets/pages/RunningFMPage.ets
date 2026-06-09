import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 跑步歌曲信息
 */
class RunningSongInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  bpm: number;
  duration: string;

  constructor(id: string, title: string, artist: string, coverUrl: string, bpm: number, duration: string) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.bpm = bpm;
    this.duration = duration;
  }
}

/**
 * 跑步计划信息
 */
class RunningPlanInfo {
  id: string;
  name: string;
  description: string;
  coverUrl: string;
  duration: string;
  distance: string;
  difficulty: string;
  calories: number;

  constructor(id: string, name: string, description: string, coverUrl: string, duration: string, distance: string, difficulty: string, calories: number) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.coverUrl = coverUrl;
    this.duration = duration;
    this.distance = distance;
    this.difficulty = difficulty;
    this.calories = calories;
  }
}

/**
 * 运动记录信息
 */
class SportRecordInfo {
  id: string;
  date: string;
  duration: string;
  distance: string;
  calories: number;
  avgPace: string;
  bpm: number;

  constructor(id: string, date: string, duration: string, distance: string, calories: number, avgPace: string, bpm: number) {
    this.id = id;
    this.date = date;
    this.duration = duration;
    this.distance = distance;
    this.calories = calories;
    this.avgPace = avgPace;
    this.bpm = bpm;
  }
}

/**
 * 音乐风格信息
 */
class MusicStyleInfo {
  id: string;
  name: string;
  coverUrl: string;
  bpmRange: string;
  description: string;
  songCount: number;
  color: string;

  constructor(id: string, name: string, coverUrl: string, bpmRange: string, description: string, songCount: number, color: string) {
    this.id = id;
    this.name = name;
    this.coverUrl = coverUrl;
    this.bpmRange = bpmRange;
    this.description = description;
    this.songCount = songCount;
    this.color = color;
  }
}

/**
 * 跑步FM页面
 * 包含可滑动的spectrum：跑步音乐、训练计划、运动记录、音乐风格
 */
@Entry
@Component
struct RunningFMPage {
  // 当前选中的spectrum索引
  @State currentSpectrumIndex: number = 0;

  // Spectrum数据
  @State spectrumItems: string[] = ['跑步音乐', '训练计划', '运动记录', '音乐风格'];

  // ========== 跑步音乐数据 ==========
  @State currentBPM: number = 120;
  @State isRunning: boolean = false;
  @State currentSongIndex: number = 0;
  @State songs: RunningSongInfo[] = [
    new RunningSongInfo('1', 'Runaway Baby', 'Bruno Mars', 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=200&h=200&fit=crop', 128, '2:28'),
    new RunningSongInfo('2', 'Eye of the Tiger', 'Survivor', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&h=200&fit=crop', 109, '4:05'),
    new RunningSongInfo('3', 'Can\'t Hold Us', 'Macklemore', 'https://images.unsplash.com/photo-1571008887538-b33bb05ff3ff?w=200&h=200&fit=crop', 146, '4:18'),
    new RunningSongInfo('4', 'Stronger', 'Kelly Clarkson', 'https://images.unsplash.com/photo-1552674605-4694c0427e43?w=200&h=200&fit=crop', 130, '3:41'),
    new RunningSongInfo('5', 'Titanium', 'David Guetta', 'https://images.unsplash.com/photo-1574680096141-1cddd32e04ca?w=200&h=200&fit=crop', 126, '4:05'),
    new RunningSongInfo('6', 'Wake Me Up', 'Avicii', 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=200&h=200&fit=crop', 124, '4:09'),
    new RunningSongInfo('7', 'Uptown Funk', 'Mark Ronson', 'https://images.unsplash.com/photo-1532444458054-01a7dd3e95a3?w=200&h=200&fit=crop', 115, '4:30'),
    new RunningSongInfo('8', 'Shut Up and Dance', 'WALK THE MOON', 'https://images.unsplash.com/photo-1502904550040-7534597429ae?w=200&h=200&fit=crop', 128, '3:19'),
  ];

  // ========== 训练计划数据 ==========
  @State runningPlans: RunningPlanInfo[] = [
    new RunningPlanInfo('1', '初级燃脂跑', '适合初学者的燃脂训练', 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=200&h=200&fit=crop', '30分钟', '3公里', '简单', 280),
    new RunningPlanInfo('2', '5公里挑战', '循序渐进完成5公里', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&h=200&fit=crop', '45分钟', '5公里', '中等', 420),
    new RunningPlanInfo('3', '间歇跑训练', '高强度间歇训练提升耐力', 'https://images.unsplash.com/photo-1571008887538-b33bb05ff3ff?w=200&h=200&fit=crop', '40分钟', '4公里', '困难', 380),
    new RunningPlanInfo('4', '10公里进阶', '挑战10公里的长跑计划', 'https://images.unsplash.com/photo-1552674605-4694c0427e43?w=200&h=200&fit=crop', '60分钟', '10公里', '困难', 650),
    new RunningPlanInfo('5', '马拉松备战', '全马备战训练计划', 'https://images.unsplash.com/photo-1574680096141-1cddd32e04ca?w=200&h=200&fit=crop', '90分钟', '15公里', '极难', 950),
  ];

  // ========== 运动记录数据 ==========
  @State sportRecords: SportRecordInfo[] = [
    new SportRecordInfo('1', '今天', '30:25', '4.2公里', 320, '7\'15"', 135),
    new SportRecordInfo('2', '昨天', '45:10', '6.5公里', 480, '6\'56"', 142),
    new SportRecordInfo('3', '06月06日', '25:30', '3.8公里', 260, '6\'42"', 128),
    new SportRecordInfo('4', '06月05日', '60:00', '9.2公里', 720, '6\'31"', 145),
    new SportRecordInfo('5', '06月04日', '35:45', '5.1公里', 380, '7\'00"', 138),
  ];

  // ========== 音乐风格数据 ==========
  @State musicStyles: MusicStyleInfo[] = [
    new MusicStyleInfo('1', '动感电子', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', '120-140', '节奏强劲的电子音乐', 256, '#FF6B6B'),
    new MusicStyleInfo('2', '摇滚动力', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', '130-150', '激情澎湃的摇滚乐', 189, '#4ECDC4'),
    new MusicStyleInfo('3', '流行节拍', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', '110-130', '朗朗上口的流行歌曲', 312, '#45B7D1'),
    new MusicStyleInfo('4', '嘻哈节奏', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', '90-110', '节奏感强的嘻哈音乐', 156, '#96CEB4'),
    new MusicStyleInfo('5', '拉丁热舞', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', '120-140', '热情奔放的拉丁音乐', 98, '#FFEAA7'),
    new MusicStyleInfo('6', '古典韵律', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', '100-120', '优雅古典的跑步伴侣', 67, '#DDA0DD'),
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

      Text('跑步FM')
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

  // ==================== 跑步音乐（保留原有设计）====================
  @Builder
  RunningMusicBuilder() {
    Column() {
      // BPM控制
      Column() {
        Text('当前节奏')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        Row() {
          Text('-')
            .fontSize(24)
            .fontColor('#C20C0C')
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              if (this.currentBPM > 60) {
                this.currentBPM -= 5;
              }
            })

          Column() {
            Text(this.currentBPM.toString())
              .fontSize(48)
              .fontColor('#C20C0C')
              .fontWeight(FontWeight.Bold)

            Text('BPM')
              .fontSize(14)
              .fontColor('#666666')
          }
          .margin({ left: 40, right: 40 })

          Text('+')
            .fontSize(24)
            .fontColor('#C20C0C')
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              if (this.currentBPM < 200) {
                this.currentBPM += 5;
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        Slider({
          value: this.currentBPM,
          min: 60,
          max: 200,
          step: 5
        })
          .width('80%')
          .margin({ top: 16 })
          .onChange((value: number) => {
            this.currentBPM = value;
          })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 12 })

      // 跑步状态
      Row() {
        Column() {
          Text('00:00')
            .fontSize(24)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)

          Text('跑步时长')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text('0.00')
            .fontSize(24)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)

          Text('公里')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text('0')
            .fontSize(24)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)

          Text('千卡')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 12 })

      // 当前播放
      Column() {
        Text('正在播放')
          .fontSize(16)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 12 })
          .width('100%')
          .textAlign(TextAlign.Start)

        Row() {
          Image(this.songs[this.currentSongIndex].coverUrl)
            .width(70)
            .height(70)
            .borderRadius(10)
            .objectFit(ImageFit.Cover)
            .margin({ right: 12 })

          Column() {
            Text(this.songs[this.currentSongIndex].title)
              .fontSize(16)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')

            Text(this.songs[this.currentSongIndex].artist)
              .fontSize(13)
              .fontColor('#666666')
              .margin({ top: 4 })
              .width('100%')

            Row() {
              Text(`${this.songs[this.currentSongIndex].bpm} BPM`)
                .fontSize(12)
                .fontColor('#C20C0C')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('#FFF5F5')
                .borderRadius(8)

              Text(this.songs[this.currentSongIndex].duration)
                .fontSize(12)
                .fontColor('#999999')
                .margin({ left: 8 })
            }
            .margin({ top: 8 })
            .width('100%')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text(this.isRunning ? '⏸' : '▶')
              .fontSize(24)
              .fontColor('#FFFFFF')
          }
          .width(50)
          .height(50)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#C20C0C')
          .borderRadius(25)
          .onClick(() => {
            this.isRunning = !this.isRunning;
          })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
      .margin({ bottom: 12 })

      // 跑步歌单
      Column() {
        Text('跑步歌单')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16, bottom: 12, top: 8 })
          .width('100%')
          .textAlign(TextAlign.Start)

        ForEach(this.songs, (song: RunningSongInfo, index: number) => {
          Row() {
            Text((index + 1).toString())
              .fontSize(16)
              .fontColor(index === this.currentSongIndex ? '#C20C0C' : '#999999')
              .fontWeight(index === this.currentSongIndex ? FontWeight.Bold : FontWeight.Normal)
              .width(30)

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
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')

              Text(song.artist)
                .fontSize(12)
                .fontColor('#666666')
                .margin({ top: 4 })
                .width('100%')
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Text(`${song.bpm} BPM`)
              .fontSize(12)
              .fontColor('#C20C0C')
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 10, bottom: 10 })
          .backgroundColor(index === this.currentSongIndex ? '#FFF5F5' : '#FFFFFF')
          .onClick(() => {
            this.currentSongIndex = index;
          })
        })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius({ topLeft: 20, topRight: 20 })
      .padding({ top: 16, bottom: 100 })
    }
    .width('100%')
  }

  // ==================== 训练计划（卡片列表）====================
  @Builder
  TrainingPlanBuilder() {
    Column() {
      Text('选择训练计划')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Column() {
        ForEach(this.runningPlans, (plan: RunningPlanInfo) => {
          this.PlanCardBuilder(plan)
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
  PlanCardBuilder(plan: RunningPlanInfo) {
    Column() {
      Row() {
        Image(plan.coverUrl)
          .width(80)
          .height(80)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)
          .margin({ right: 12 })

        Column() {
          Row() {
            Text(plan.name)
              .fontSize(16)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)

            Text(plan.difficulty)
              .fontSize(10)
              .fontColor('#FFFFFF')
              .padding({ left: 6, right: 6, top: 1, bottom: 1 })
              .backgroundColor(
                plan.difficulty === '简单' ? '#4ECDC4' :
                plan.difficulty === '中等' ? '#45B7D1' :
                plan.difficulty === '困难' ? '#FF6B6B' : '#C20C0C'
              )
              .borderRadius(8)
          }
          .width('100%')

          Text(plan.description)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 4 })
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')

          Row() {
            Text(`⏱ ${plan.duration}`)
              .fontSize(11)
              .fontColor('#999999')

            Text('·')
              .fontSize(11)
              .fontColor('#999999')
              .margin({ left: 8, right: 8 })

            Text(`📍 ${plan.distance}`)
              .fontSize(11)
              .fontColor('#999999')

            Text('·')
              .fontSize(11)
              .fontColor('#999999')
              .margin({ left: 8, right: 8 })

            Text(`🔥 ${plan.calories}千卡`)
              .fontSize(11)
              .fontColor('#999999')
          }
          .margin({ top: 6 })
          .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 12 })
      .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })
      .onClick(() => {
        console.info('点击计划:', plan.name);
      })
    }
    .width('100%')
  }

  // ==================== 运动记录（统计卡片+列表）====================
  @Builder
  SportRecordBuilder() {
    Column() {
      // 本周统计
      Row() {
        Column() {
          Text('本周运动')
            .fontSize(14)
            .fontColor('#666666')

          Text('5次')
            .fontSize(24)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text('总距离')
            .fontSize(14)
            .fontColor('#666666')

          Text('28.8公里')
            .fontSize(24)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        Column() {
          Text('总消耗')
            .fontSize(14)
            .fontColor('#666666')

          Text('2160千卡')
            .fontSize(24)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ bottom: 12 })

      Text('运动记录')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Column() {
        ForEach(this.sportRecords, (record: SportRecordInfo) => {
          this.RecordItemBuilder(record)
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
  RecordItemBuilder(record: SportRecordInfo) {
    Row() {
      Column() {
        Text(record.date)
          .fontSize(14)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .width(60)

        Text(record.duration)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .width(60)
      }
      .width(60)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(record.distance)
          .fontSize(18)
          .fontColor('#C20C0C')
          .fontWeight(FontWeight.Bold)
          .width('100%')

        Text('距离')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(`${record.calories}`)
          .fontSize(18)
          .fontColor('#FF9500')
          .fontWeight(FontWeight.Bold)
          .width('100%')

        Text('千卡')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(record.avgPace)
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .width('100%')

        Text('配速')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(`${record.bpm}`)
          .fontSize(18)
          .fontColor('#666666')
          .fontWeight(FontWeight.Bold)
          .width('100%')

        Text('BPM')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 10 })
    .shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
    .onClick(() => {
      console.info('点击记录:', record.date);
    })
  }

  // ==================== 音乐风格（彩色卡片网格）====================
  @Builder
  MusicStyleBuilder() {
    Column() {
      Text('选择音乐风格')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.musicStyles, (style: MusicStyleInfo) => {
          this.StyleCardBuilder(style)
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
  StyleCardBuilder(style: MusicStyleInfo) {
    Column() {
      Stack() {
        Image(style.coverUrl)
          .width('100%')
          .aspectRatio(1)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)

        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(style.color + '80')
          .borderRadius(12)
          .position({ x: 0, y: 0 })

        Column() {
          Text(style.name)
            .fontSize(18)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)

          Text(style.bpmRange)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .margin({ top: 4 })

          Text(style.description)
            .fontSize(11)
            .fontColor('#FFFFFF')
            .margin({ top: 4 })
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Center)
            .padding({ left: 8, right: 8 })

          Text(`${style.songCount}首`)
            .fontSize(11)
            .fontColor('#FFFFFF')
            .margin({ top: 4 })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: '50%', y: '50%' })
        .margin({ left: -50, top: -40 })
      }
      .width('100%')
    }
    .width('48%')
    .margin({ bottom: 16 })
    .onClick(() => {
      console.info('点击风格:', style.name);
    })
  }

  // ==================== 内容区域分发器 ====================
  @Builder
  ContentBuilder() {
    Scroll() {
      Column() {
        this.SpectrumBuilder()

        if (this.currentSpectrumIndex === 0) {
          this.RunningMusicBuilder()
        } else if (this.currentSpectrumIndex === 1) {
          this.TrainingPlanBuilder()
        } else if (this.currentSpectrumIndex === 2) {
          this.SportRecordBuilder()
        } else {
          this.MusicStyleBuilder()
        }
      }
      .width('100%')
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
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
