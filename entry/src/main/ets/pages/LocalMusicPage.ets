import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

class LocalSongInfo {
  id: string;
  title: string;
  artist: string;
  album: string;
  coverUrl: string;
  duration: string;
  fileSize: string;

  constructor(id: string, title: string, artist: string, album: string, coverUrl: string, duration: string, fileSize: string) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.album = album;
    this.coverUrl = coverUrl;
    this.duration = duration;
    this.fileSize = fileSize;
  }
}

@Entry
@Component
struct LocalMusicPage {
  @State currentTab: number = 0;
  @State tabs: string[] = ['单曲', '歌手', '专辑', '文件夹'];
  @State songs: LocalSongInfo[] = [
    new LocalSongInfo('1', '晴天', '周杰伦', '叶惠美', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', '4:29', '8.5MB'),
    new LocalSongInfo('2', '七里香', '周杰伦', '七里香', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192x5y_3.jpg', '4:59', '9.2MB'),
    new LocalSongInfo('3', '稻香', '周杰伦', '魔杰座', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Neh8l0uciQZ_3.jpg', '3:43', '7.1MB'),
    new LocalSongInfo('4', '告白气球', '周杰伦', '周杰伦的床边故事', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', '3:35', '6.8MB'),
    new LocalSongInfo('5', '演员', '薛之谦', '初学者', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001ZorFn27mJ8F_3.jpg', '4:20', '8.1MB'),
    new LocalSongInfo('6', '刚刚好', '薛之谦', '初学者', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003Z2hNS1Z1Vz8_3.jpg', '4:10', '7.8MB'),
    new LocalSongInfo('7', '小幸运', '田馥甄', '我的少女时代', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001CBQA12BjV74_3.jpg', '4:28', '8.4MB'),
    new LocalSongInfo('8', '后来', '刘若英', '我等你', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '4:19', '8.0MB'),
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
      Text('本地音乐').fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
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
        Text(`共 ${this.songs.length} 首`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('播放全部')
          .fontSize(14).fontColor('#C20C0C')
          .padding({ left: 12, right: 12, top: 4, bottom: 4 })
          .border({ width: 1, color: '#C20C0C' }).borderRadius(12)
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      ForEach(this.songs, (song: LocalSongInfo, index: number) => {
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
            Text(`${song.artist} - ${song.album}`)
              .fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Text(song.duration)
            .fontSize(12).fontColor('#999999')
        }
        .width('100%').padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .backgroundColor('#FFFFFF')
        .onClick(() => { console.info('点击歌曲:', song.title); })
      })
    }
    .width('100%')
  }

  @Builder
  ArtistListBuilder() {
    Column() {
      Text('本地歌手')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      ForEach(['周杰伦', '薛之谦', '田馥甄', '刘若英'], (artist: string, index: number) => {
        Row() {
          Image(`https://y.gtimg.cn/music/photo_new/T001R300x300M00000${index + 1}azErJ0U8zd4_3.jpg`)
            .width(50).height(50).borderRadius(25).objectFit(ImageFit.Cover).margin({ right: 12 })
          Column() {
            Text(artist).fontSize(16).fontColor('#000000').fontWeight(FontWeight.Bold).width('100%')
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
  AlbumListBuilder() {
    Column() {
      Text('本地专辑')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.songs.slice(0, 4), (song: LocalSongInfo) => {
          Column() {
            Image(song.coverUrl)
              .width('100%').aspectRatio(1).borderRadius(8).objectFit(ImageFit.Cover)
            Text(song.album)
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
  FolderListBuilder() {
    Column() {
      Text('音乐文件夹')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      ForEach(['/storage/music/周杰伦', '/storage/music/薛之谦', '/storage/music/流行歌曲', '/storage/music/下载'], (folder: string) => {
        Row() {
          Column() {
            Text('📁').fontSize(24)
          }
          .width(50).height(50).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
          .backgroundColor('#F5F5F5').borderRadius(8).margin({ right: 12 })

          Column() {
            Text(folder.split('/').pop() || '')
              .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold).width('100%')
            Text(`${Math.floor(Math.random() * 30 + 5)}首`).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
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
  ContentBuilder() {
    Scroll() {
      Column() {
        this.TabBuilder()
        if (this.currentTab === 0) {
          this.SongListBuilder()
        } else if (this.currentTab === 1) {
          this.ArtistListBuilder()
        } else if (this.currentTab === 2) {
          this.AlbumListBuilder()
        } else {
          this.FolderListBuilder()
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
