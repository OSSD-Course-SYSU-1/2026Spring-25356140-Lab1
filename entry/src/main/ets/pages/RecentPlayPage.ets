import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

class RecentSongInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  duration: string;
  playTime: string;
  playCount: number;

  constructor(id: string, title: string, artist: string, coverUrl: string, duration: string, playTime: string, playCount: number) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.duration = duration;
    this.playTime = playTime;
    this.playCount = playCount;
  }
}

@Entry
@Component
struct RecentPlayPage {
  @State currentTab: number = 0;
  @State tabs: string[] = ['歌曲', '视频', '歌单', '专辑'];

  @State recentSongs: RecentSongInfo[] = [
    new RecentSongInfo('1', '晴天', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', '4:29', '10分钟前', 5),
    new RecentSongInfo('2', '告白气球', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', '3:35', '30分钟前', 3),
    new RecentSongInfo('3', '演员', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001ZorFn27mJ8F_3.jpg', '4:20', '1小时前', 8),
    new RecentSongInfo('4', '小幸运', '田馥甄', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001CBQA12BjV74_3.jpg', '4:28', '2小时前', 2),
    new RecentSongInfo('5', '后来', '刘若英', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '4:19', '3小时前', 12),
    new RecentSongInfo('6', '稻香', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Neh8l0uciQZ_3.jpg', '3:43', '昨天', 6),
    new RecentSongInfo('7', '七里香', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192x5y_3.jpg', '4:59', '昨天', 4),
    new RecentSongInfo('8', '刚刚好', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003Z2hNS1Z1Vz8_3.jpg', '4:10', '昨天', 7),
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
      Text('最近播放').fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
      Blank()
      Image($r('app.media.more_menu')).width(24).height(24).margin({ right: 15 })
    }
    .width('100%').height(50).backgroundColor('#FFFFFF')
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  TabBuilder() {
    Row() {
      ForEach(this.tabs, (tab: string, index: number) => {
        Column() {
          Text(tab)
            .fontSize(this.currentTab === index ? 16 : 14)
            .fontColor(this.currentTab === index ? '#C20C0C' : '#666666')
            .fontWeight(this.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          if (this.currentTab === index) {
            Column().width(20).height(3).backgroundColor('#C20C0C').borderRadius(2)
          }
        }
        .onClick(() => { this.currentTab = index; })
      })
    }
    .width('100%').justifyContent(FlexAlign.SpaceAround)
    .backgroundColor('#FFFFFF').padding({ top: 8, bottom: 8 })
  }

  @Builder
  SongListBuilder() {
    Column() {
      Row() {
        Text(`共 ${this.recentSongs.length} 首`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('清空记录')
          .fontSize(14).fontColor('#999999')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      ForEach(this.recentSongs, (song: RecentSongInfo, index: number) => {
        Row() {
          Text((index + 1).toString())
            .fontSize(14).fontColor('#999999').width(30).textAlign(TextAlign.Center)
          Image(song.coverUrl)
            .width(50).height(50).borderRadius(6).objectFit(ImageFit.Cover)
            .margin({ left: 8, right: 12 })
          Column() {
            Text(song.title)
              .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
            Row() {
              Text(song.artist).fontSize(12).fontColor('#666666')
              Text('·').fontSize(12).fontColor('#999999').margin({ left: 4, right: 4 })
              Text(song.playTime).fontSize(12).fontColor('#999999')
            }
            .margin({ top: 4 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Text(`${song.playCount}次`).fontSize(11).fontColor('#999999')
        }
        .width('100%').padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .backgroundColor('#FFFFFF')
        .onClick(() => { console.info('点击歌曲:', song.title); })
      })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  VideoListBuilder() {
    Column() {
      Text('最近播放视频')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      ForEach(['周杰伦 - 晴天MV', '薛之谦 - 演员MV', '田馥甄 - 小幸运MV'], (video: string, index: number) => {
        Row() {
          Stack() {
            Image(`https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=120&fit=crop`)
              .width(120).height(70).borderRadius(8).objectFit(ImageFit.Cover)
            Column() {
              Text('▶').fontSize(16).fontColor('#FFFFFF')
            }
            .width(32).height(32).backgroundColor('#40000000').borderRadius(16)
            .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
            .position({ x: '50%', y: '50%' }).margin({ left: -16, top: -16 })
          }
          .width(120).height(70).margin({ right: 12 })

          Column() {
            Text(video)
              .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
            Text(`${Math.floor(Math.random() * 5 + 1)}分钟前`)
              .fontSize(12).fontColor('#999999').margin({ top: 4 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
        .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
      })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  PlaylistBuilder() {
    Column() {
      Text('最近播放歌单')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      ForEach(['华语经典', '深夜emo', '运动节奏', '轻音乐'], (playlist: string, index: number) => {
        Row() {
          Image(`https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop`)
            .width(60).height(60).borderRadius(8).objectFit(ImageFit.Cover).margin({ right: 12 })
          Column() {
            Text(playlist)
              .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
            Text(`${Math.floor(Math.random() * 50 + 10)}首`).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Text('›').fontSize(20).fontColor('#CCCCCC')
        }
        .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
        .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
      })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  AlbumBuilder() {
    Column() {
      Text('最近播放专辑')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.recentSongs.slice(0, 4), (song: RecentSongInfo) => {
          Column() {
            Image(song.coverUrl)
              .width('100%').aspectRatio(1).borderRadius(8).objectFit(ImageFit.Cover)
            Text(song.title)
              .fontSize(13).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 8 }).width('100%')
            Text(song.artist)
              .fontSize(11).fontColor('#666666').margin({ top: 2 }).width('100%')
          }
          .width('48%').margin({ bottom: 16 })
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
        this.TabBuilder()
        if (this.currentTab === 0) {
          this.SongListBuilder()
        } else if (this.currentTab === 1) {
          this.VideoListBuilder()
        } else if (this.currentTab === 2) {
          this.PlaylistBuilder()
        } else {
          this.AlbumBuilder()
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
