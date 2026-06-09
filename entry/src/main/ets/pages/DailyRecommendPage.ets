import router from '@ohos.router';
import { SongInfo } from '../common/bean/SongInfo';
import { RecommendService } from '../common/service/RecommendService';
import { PlayerService } from '../common/service/PlayerService';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 每日推荐页面
 * 基于日期生成固定的推荐歌曲列表
 */
@Entry
@Component
struct DailyRecommendPage {
  private playerService: PlayerService = PlayerService.getInstance();
  private recommendService: RecommendService = RecommendService.getInstance();

  // 日期信息
  @State currentDate: Date = new Date();
  @State dayOfMonth: number = 0;
  @State monthStr: string = '';

  // 推荐歌曲
  @State dailySongs: SongInfo[] = [];

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  aboutToAppear() {
    // 获取当前日期
    this.currentDate = new Date();
    this.dayOfMonth = this.currentDate.getDate();
    this.monthStr = this.getMonthString(this.currentDate.getMonth());

    // 获取每日推荐歌曲
    this.dailySongs = this.recommendService.getDailyRecommend(10);
  }

  /**
   * 获取月份字符串
   */
  private getMonthString(month: number): string {
    const months: string[] = ['一月', '二月', '三月', '四月', '五月', '六月',
                              '七月', '八月', '九月', '十月', '十一月', '十二月'];
    return months[month];
  }

  /**
   * 播放歌曲
   */
  private async playSong(song: SongInfo): Promise<void> {
    await this.playerService.playSong(song);
  }

  /**
   * 播放全部
   */
  private playAll(): void {
    if (this.dailySongs.length > 0) {
      this.playerService.setPlayList(this.dailySongs, 0);
      this.playerService.playSong(this.dailySongs[0]);
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .margin({ left: 15 })
          .onClick(() => {
            router.back();
          })

        Blank()

        Text('每日推荐')
          .fontSize(18)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)

        Blank()

        // 占位保持对称
        Row().width(24).height(24).margin({ right: 15 })
      }
      .width('100%')
      .height(50)
      .backgroundColor('#C20C0C')
      .alignItems(VerticalAlign.Center)

      // 日期头部区域
      Stack() {
        // 背景渐变
        Column()
          .width('100%')
          .height(180)
          .backgroundColor('#C20C0C')

        Column() {
          // 月份
          Text(this.monthStr)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .opacity(0.8)

          // 日期数字
          Text(this.dayOfMonth.toString())
            .fontSize(72)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .margin({ top: -8 })

          // 提示文字
          Text('根据你的音乐口味生成，每天6:00更新')
            .fontSize(12)
            .fontColor('#FFFFFF')
            .opacity(0.7)
            .margin({ top: 8 })
        }
        .width('100%')
        .height(180)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')

      // 播放全部按钮
      Row() {
        Image($r('app.media.icon'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
          .fillColor('#C20C0C')

        Text('播放全部')
          .fontSize(16)
          .fontColor('#C20C0C')
          .fontWeight(FontWeight.Bold)
      }
      .width('90%')
      .height(44)
      .backgroundColor('#FFFFFF')
      .borderRadius(22)
      .border({ width: 1, color: '#C20C0C' })
      .justifyContent(FlexAlign.Center)
      .margin({ top: 16, bottom: 8 })
      .onClick(() => {
        this.playAll();
      })

      // 歌曲列表
      List() {
        ForEach(this.dailySongs, (song: SongInfo, index: number) => {
          ListItem() {
            Row() {
              // 序号
              Text((index + 1).toString())
                .fontSize(14)
                .fontColor('#999999')
                .width(32)
                .textAlign(TextAlign.Center)

              // 歌曲封面
              Image(song.coverUrl)
                .width(48)
                .height(48)
                .borderRadius(6)
                .objectFit(ImageFit.Cover)
                .margin({ left: 8, right: 12 })

              // 歌曲信息
              Column() {
                Text(song.name)
                  .fontSize(15)
                  .fontColor('#000000')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(song.artist + ' - ' + song.album)
                  .fontSize(12)
                  .fontColor('#666666')
                  .margin({ top: 4 })
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              // 更多操作
              Text('⋮')
                .fontSize(20)
                .fontColor('#999999')
                .padding({ left: 8, right: 8 })
            }
            .width('100%')
            .height(64)
            .padding({ left: 12, right: 12 })
            .alignItems(VerticalAlign.Center)
            .border({ width: { bottom: 1 }, color: '#F5F5F5' })
            .onClick(() => {
              this.playSong(song);
            })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 0 })
      .padding({ top: 8 })

      // 底部播放栏
      MiniPlayer()

      // 左侧手势返回区域
      this.GestureBackArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
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
