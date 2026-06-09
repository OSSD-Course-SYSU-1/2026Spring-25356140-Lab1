import router from '@ohos.router';
import { SongInfo } from '../common/bean/SongInfo';
import { PlayerService } from '../common/service/PlayerService';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 歌单详情页
 * 展示歌单信息和歌曲列表
 */
@Entry
@Component
struct PlaylistDetailPage {
  // 播放器服务
  private playerService: PlayerService = PlayerService.getInstance();

  // 页面参数
  @State playlistId: string = '';
  @State playlistTitle: string = '歌单';
  @State playlistCover: string = '';
  @State playlistDescription: string = '';

  // 歌曲列表
  @State songs: SongInfo[] = [];

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      this.playlistId = params['playlistId'] as string || '';
      this.playlistTitle = params['title'] as string || '歌单';
      this.playlistCover = params['cover'] as string || '';
      this.playlistDescription = params['description'] as string || '';
    }

    // 根据歌单ID加载歌曲
    this.loadSongs();
  }

  /**
   * 加载歌曲列表
   */
  private loadSongs(): void {
    if (this.playlistId === 'liked') {
      // 我喜欢的音乐
      this.songs = this.playerService.likedSongs;
    } else {
      // 其他歌单，使用Mock数据
      this.songs = this.getMockSongs();
    }
  }

  /**
   * 获取Mock歌曲数据
   */
  private getMockSongs(): SongInfo[] {
    return [
      new SongInfo(
        '101',
        '测试歌曲1',
        '测试歌手',
        '测试专辑',
        'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg',
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        325000
      ),
      new SongInfo(
        '102',
        '测试歌曲2',
        '测试歌手',
        '测试专辑',
        'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192x5y_3.jpg',
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        269000
      ),
      new SongInfo(
        '103',
        '测试歌曲3',
        '测试歌手',
        '测试专辑',
        'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Neh8l0uciQZ_3.jpg',
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        300000
      ),
    ];
  }

  /**
   * 播放指定歌曲
   */
  private async playSong(song: SongInfo): Promise<void> {
    try {
      await this.playerService.playSong(song);
    } catch (error) {
      console.error('播放失败:', error);
    }
  }

  /**
   * 播放全部歌曲
   */
  private playAll(): void {
    if (this.songs.length > 0) {
      this.playerService.setPlayList(this.songs, 0);
      this.playerService.playSong(this.songs[0]);
    }
  }

  /**
   * 格式化时间
   */
  private formatTime(ms: number): string {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
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

        Text(this.playlistTitle)
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

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

      // 歌单信息区
      Column() {
        Row() {
          // 歌单封面
          if (this.playlistId === 'liked') {
            Column() {
              Text('♥')
                .fontSize(48)
                .fontColor('#FFFFFF')
            }
            .width(120)
            .height(120)
            .backgroundColor('#C20C0C')
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .margin({ right: 16 })
          } else {
            Image(this.playlistCover)
              .width(120)
              .height(120)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)
              .margin({ right: 16 })
          }

          // 歌单信息
          Column() {
            Text(this.playlistTitle)
              .fontSize(18)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.songs.length + '首歌曲')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 8 })

            if (this.playlistDescription) {
              Text(this.playlistDescription)
                .fontSize(12)
                .fontColor('#999999')
                .margin({ top: 8 })
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .padding(16)
        .alignItems(VerticalAlign.Center)

        // 播放全部按钮
        Row() {
          Image($r('app.media.icon'))
            .width(20)
            .height(20)
            .margin({ right: 8 })

          Text('播放全部')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .width('90%')
        .height(44)
        .backgroundColor('#C20C0C')
        .borderRadius(22)
        .justifyContent(FlexAlign.Center)
        .margin({ top: 8, bottom: 8 })
        .onClick(() => {
          this.playAll();
        })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')

      // 歌曲列表
      List() {
        ForEach(this.songs, (song: SongInfo, index: number) => {
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
            .height(60)
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

      // 空状态
      if (this.songs.length === 0) {
        Column() {
          Text('暂无歌曲')
            .fontSize(16)
            .fontColor('#888888')
            .margin({ top: 50 })

          Text('去播放页面收藏喜欢的音乐吧')
            .fontSize(14)
            .fontColor('#AAAAAA')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
      }

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
