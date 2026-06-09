import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

class CollectionInfo {
  id: string;
  title: string;
  subtitle: string;
  coverUrl: string;
  type: string;
  count: number;

  constructor(id: string, title: string, subtitle: string, coverUrl: string, type: string, count: number) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.coverUrl = coverUrl;
    this.type = type;
    this.count = count;
  }
}

@Entry
@Component
struct MyCollectionPage {
  @State currentTab: number = 0;
  @State tabs: string[] = ['歌曲', '歌单', '专辑', '艺人'];

  @State songs: CollectionInfo[] = [
    new CollectionInfo('1', '晴天', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', 'song', 0),
    new CollectionInfo('2', '告白气球', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', 'song', 0),
    new CollectionInfo('3', '演员', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001ZorFn27mJ8F_3.jpg', 'song', 0),
    new CollectionInfo('4', '小幸运', '田馥甄', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001CBQA12BjV74_3.jpg', 'song', 0),
    new CollectionInfo('5', '后来', '刘若英', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', 'song', 0),
  ];

  @State playlists: CollectionInfo[] = [
    new CollectionInfo('1', '华语经典', '128首', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', 'playlist', 128),
    new CollectionInfo('2', '深夜emo', '56首', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', 'playlist', 56),
    new CollectionInfo('3', '运动节奏', '89首', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', 'playlist', 89),
    new CollectionInfo('4', '轻音乐', '234首', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', 'playlist', 234),
  ];

  @State albums: CollectionInfo[] = [
    new CollectionInfo('1', '叶惠美', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', 'album', 10),
    new CollectionInfo('2', '七里香', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192x5y_3.jpg', 'album', 10),
    new CollectionInfo('3', '初学者', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001ZorFn27mJ8F_3.jpg', 'album', 9),
    new CollectionInfo('4', '我等你', '刘若英', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', 'album', 10),
  ];

  @State artists: CollectionInfo[] = [
    new CollectionInfo('1', '周杰伦', '256首', 'https://y.gtimg.cn/music/photo_new/T001R300x300M0000025NhlN2YWrP4_3.jpg', 'artist', 256),
    new CollectionInfo('2', '薛之谦', '128首', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000002azErJ0U8zd4_3.jpg', 'artist', 128),
    new CollectionInfo('3', '田馥甄', '89首', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000001t94rh4Opouw_3.jpg', 'artist', 89),
    new CollectionInfo('4', '刘若英', '67首', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000000hwnSh3XzMWf_3.jpg', 'artist', 67),
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
      Text('我的收藏').fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
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

      ForEach(this.songs, (song: CollectionInfo, index: number) => {
        Row() {
          Text((index + 1).toString())
            .fontSize(14).fontColor('#999999').width(30).textAlign(TextAlign.Center)
          Image(song.coverUrl)
            .width(50).height(50).borderRadius(6).objectFit(ImageFit.Cover).margin({ left: 8, right: 12 })
          Column() {
            Text(song.title)
              .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
            Text(song.subtitle).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Column() {
            Text('▶').fontSize(16).fontColor('#C20C0C')
          }
          .width(36).height(36).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5').borderRadius(18)
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
  PlaylistGridBuilder() {
    Column() {
      Row() {
        Text(`共 ${this.playlists.length} 个歌单`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('管理')
          .fontSize(14).fontColor('#999999')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.playlists, (playlist: CollectionInfo) => {
          Column() {
            Image(playlist.coverUrl)
              .width('100%').aspectRatio(1).borderRadius(8).objectFit(ImageFit.Cover)
            Text(playlist.title)
              .fontSize(14).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 8 }).width('100%')
            Text(playlist.subtitle)
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
  AlbumGridBuilder() {
    Column() {
      Row() {
        Text(`共 ${this.albums.length} 张专辑`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('管理')
          .fontSize(14).fontColor('#999999')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.albums, (album: CollectionInfo) => {
          Column() {
            Image(album.coverUrl)
              .width('100%').aspectRatio(1).borderRadius(8).objectFit(ImageFit.Cover)
            Text(album.title)
              .fontSize(14).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 8 }).width('100%')
            Text(album.subtitle)
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
  ArtistGridBuilder() {
    Column() {
      Row() {
        Text(`共 ${this.artists.length} 位艺人`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('管理')
          .fontSize(14).fontColor('#999999')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.artists, (artist: CollectionInfo) => {
          Column() {
            Image(artist.coverUrl)
              .width('100%').aspectRatio(1).borderRadius(8).objectFit(ImageFit.Cover)
            Text(artist.title)
              .fontSize(14).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 8 }).width('100%')
            Text(artist.subtitle)
              .fontSize(11).fontColor('#666666').margin({ top: 2 }).width('100%')
          }
          .width('30%').margin({ bottom: 16 })
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
          this.PlaylistGridBuilder()
        } else if (this.currentTab === 2) {
          this.AlbumGridBuilder()
        } else {
          this.ArtistGridBuilder()
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
