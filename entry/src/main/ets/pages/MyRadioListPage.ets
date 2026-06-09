import router from '@ohos.router';
import { MiniPlayer } from '../view/MiniPlayer';

class RadioListInfo {
  id: string;
  name: string;
  category: string;
  coverUrl: string;
  description: string;
  listenerCount: number;
  isLive: boolean;
  updateTime: string;

  constructor(id: string, name: string, category: string, coverUrl: string, description: string, listenerCount: number, isLive: boolean, updateTime: string) {
    this.id = id;
    this.name = name;
    this.category = category;
    this.coverUrl = coverUrl;
    this.description = description;
    this.listenerCount = listenerCount;
    this.isLive = isLive;
    this.updateTime = updateTime;
  }
}

@Entry
@Component
struct MyRadioListPage {
  @State currentTab: number = 0;
  @State tabs: string[] = ['全部电台', '正在直播', '订阅更新'];

  @State radios: RadioListInfo[] = [
    new RadioListInfo('1', '网易云音乐电台', '音乐', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200&h=200&fit=crop', '官方精选音乐电台，24小时不间断', 12580, true, '直播中'),
    new RadioListInfo('2', '深夜情感电台', '情感', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=200&h=200&fit=crop', '深夜里的心灵慰藉', 8920, true, '直播中'),
    new RadioListInfo('3', '搞笑脱口秀', '脱口秀', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=200&h=200&fit=crop', '每日精选搞笑段子', 5670, false, '2小时前'),
    new RadioListInfo('4', '悬疑有声书', '有声书', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=200&h=200&fit=crop', '精选悬疑推理小说', 3450, false, '昨天'),
    new RadioListInfo('5', '郭德纲相声集', '相声', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&h=200&fit=crop', '经典相声段子', 7890, false, '3天前'),
    new RadioListInfo('6', '轻音乐放松', '音乐', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', '工作学习时的最佳伴侣', 4560, true, '直播中'),
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
      Text('我的电台').fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
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
  RadioCardBuilder(radio: RadioListInfo) {
    Row() {
      Stack() {
        Image(radio.coverUrl)
          .width(70).height(70).borderRadius(8).objectFit(ImageFit.Cover)
        if (radio.isLive) {
          Column() {
            Text('LIVE').fontSize(9).fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
          }
          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          .backgroundColor('#FF0000').borderRadius(6)
          .position({ x: 4, y: 4 })
        }
      }
      .width(70).height(70).margin({ right: 12 })

      Column() {
        Row() {
          Text(radio.name)
            .fontSize(15).fontColor('#000000').fontWeight(FontWeight.Bold)
            .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
          Text(radio.category)
            .fontSize(10).fontColor('#C20C0C')
            .padding({ left: 6, right: 6, top: 1, bottom: 1 })
            .border({ width: 1, color: '#C20C0C' }).borderRadius(8).margin({ left: 8 })
        }
        .width('100%')
        Text(radio.description)
          .fontSize(12).fontColor('#666666').margin({ top: 4 })
          .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
        Row() {
          Text('▶').fontSize(10).fontColor('#999999').margin({ right: 4 })
          Text(`${this.formatNumber(radio.listenerCount)}`).fontSize(11).fontColor('#999999')
          Text('·').fontSize(11).fontColor('#999999').margin({ left: 6, right: 6 })
          Text(radio.updateTime).fontSize(11).fontColor('#999999')
        }
        .margin({ top: 6 }).width('100%')
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
    .onClick(() => { console.info('点击电台:', radio.name); })
  }

  @Builder
  AllRadioBuilder() {
    Column() {
      Row() {
        Text(`共 ${this.radios.length} 个电台`)
          .fontSize(14).fontColor('#666666')
        Blank()
        Text('管理订阅')
          .fontSize(14).fontColor('#999999')
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 12 })

      ForEach(this.radios, (radio: RadioListInfo) => {
        this.RadioCardBuilder(radio)
      })

      Column().width('100%').height(100)
    }
    .width('100%').padding({ left: 16, right: 16 })
  }

  @Builder
  LiveRadioBuilder() {
    Column() {
      Text('正在直播')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      ForEach(this.radios.filter(item => item.isLive), (radio: RadioListInfo) => {
        this.RadioCardBuilder(radio)
      })

      Column().width('100%').height(100)
    }
    .width('100%').padding({ left: 16, right: 16 })
  }

  @Builder
  UpdatedRadioBuilder() {
    Column() {
      Text('最近更新')
        .fontSize(18).fontColor('#000000').fontWeight(FontWeight.Bold)
        .margin({ left: 16, bottom: 12, top: 8 }).width('100%').textAlign(TextAlign.Start)

      ForEach(this.radios.filter(item => !item.isLive), (radio: RadioListInfo) => {
        this.RadioCardBuilder(radio)
      })

      Column().width('100%').height(100)
    }
    .width('100%').padding({ left: 16, right: 16 })
  }

  @Builder
  ContentBuilder() {
    Scroll() {
      Column() {
        this.TabBuilder()
        if (this.currentTab === 0) {
          this.AllRadioBuilder()
        } else if (this.currentTab === 1) {
          this.LiveRadioBuilder()
        } else {
          this.UpdatedRadioBuilder()
        }
      }
      .width('100%')
    }
    .width('100%').layoutWeight(1).scrollBar(BarState.Auto)
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
