import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

class DownloadInfo {
  id: string;
  title: string;
  artist: string;
  coverUrl: string;
  status: string;
  progress: number;
  totalSize: string;
  downloadedSize: string;

  constructor(id: string, title: string, artist: string, coverUrl: string, status: string, progress: number, totalSize: string, downloadedSize: string) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.coverUrl = coverUrl;
    this.status = status;
    this.progress = progress;
    this.totalSize = totalSize;
    this.downloadedSize = downloadedSize;
  }
}

@Entry
@Component
struct DownloadPage {
  @State currentTab: number = 0;
  @State tabs: string[] = ['下载中', '已下载', '下载视频'];

  @State downloading: DownloadInfo[] = [
    new DownloadInfo('1', '晴天', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', 'downloading', 75, '8.5MB', '6.4MB'),
    new DownloadInfo('2', '告白气球', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', 'downloading', 45, '6.8MB', '3.1MB'),
    new DownloadInfo('3', '演员', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001ZorFn27mJ8F_3.jpg', 'waiting', 0, '8.1MB', '0MB'),
  ];

  @State downloaded: DownloadInfo[] = [
    new DownloadInfo('4', '稻香', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Neh8l0uciQZ_3.jpg', 'completed', 100, '7.1MB', '7.1MB'),
    new DownloadInfo('5', '七里香', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192x5y_3.jpg', 'completed', 100, '9.2MB', '9.2MB'),
    new DownloadInfo('6', '小幸运', '田馥甄', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001CBQA12BjV74_3.jpg', 'completed', 100, '8.4MB', '8.4MB'),
    new DownloadInfo('7', '后来', '刘若英', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', 'completed', 100, '8.0MB', '8.0MB'),
    new DownloadInfo('8', '刚刚好', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003Z2hNS1Z1Vz8_3.jpg', 'completed', 100, '7.8MB', '7.8MB'),
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
      Text('下载管理').fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
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
  DownloadingBuilder() {
    Column() {
      Row() {
        Text(`正在下载 ${this.downloading.filter(item => item.status === 'downloading').length} 个`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('全部暂停')
          .fontSize(14).fontColor('#C20C0C')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      ForEach(this.downloading, (item: DownloadInfo) => {
        Row() {
          Image(item.coverUrl)
            .width(50).height(50).borderRadius(6).objectFit(ImageFit.Cover).margin({ right: 12 })
          Column() {
            Row() {
              Text(item.title)
                .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
                .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
              Text(item.status === 'downloading' ? '下载中' : '等待中')
                .fontSize(11).fontColor(item.status === 'downloading' ? '#C20C0C' : '#999999')
            }
            .width('100%')
            Text(item.artist).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
            Row() {
              Progress({ value: item.progress, total: 100, type: ProgressType.Linear })
                .width('70%').height(4).color('#C20C0C').backgroundColor('#E0E0E0')
              Text(`${item.progress}%`)
                .fontSize(11).fontColor('#999999').margin({ left: 8 })
            }
            .margin({ top: 6 }).width('100%')
            Text(`${item.downloadedSize} / ${item.totalSize}`)
              .fontSize(11).fontColor('#999999').margin({ top: 2 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Column() {
            Text(item.status === 'downloading' ? '⏸' : '▶')
              .fontSize(16).fontColor('#C20C0C')
          }
          .width(36).height(36).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5').borderRadius(18)
        }
        .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
        .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
      })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  DownloadedBuilder() {
    Column() {
      Row() {
        Text(`已下载 ${this.downloaded.length} 首`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('批量管理')
          .fontSize(14).fontColor('#999999')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      ForEach(this.downloaded, (item: DownloadInfo) => {
        Row() {
          Image(item.coverUrl)
            .width(50).height(50).borderRadius(6).objectFit(ImageFit.Cover).margin({ right: 12 })
          Column() {
            Text(item.title)
              .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
            Text(item.artist).fontSize(12).fontColor('#666666').margin({ top: 4 }).width('100%')
            Text(item.totalSize).fontSize(11).fontColor('#999999').margin({ top: 4 }).width('100%')
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Column() {
            Text('▶').fontSize(16).fontColor('#C20C0C')
          }
          .width(36).height(36).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5').borderRadius(18)
        }
        .width('100%').padding(12).backgroundColor('#FFFFFF').borderRadius(12)
        .margin({ bottom: 10 }).shadow({ radius: 2, color: '#1F000000', offsetX: 0, offsetY: 1 })
      })

      Column().width('100%').height(100)
    }
    .width('100%')
  }

  @Builder
  VideoBuilder() {
    Column() {
      Text('下载的视频')
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
            Text('已下载').fontSize(12).fontColor('#4ECDC4').margin({ top: 4 }).width('100%')
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
  ContentBuilder() {
    Scroll() {
      Column() {
        this.TabBuilder()
        if (this.currentTab === 0) {
          this.DownloadingBuilder()
        } else if (this.currentTab === 1) {
          this.DownloadedBuilder()
        } else {
          this.VideoBuilder()
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
