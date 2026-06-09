import { SongInfo } from '../common/bean/SongInfo';
import { PlayerService } from '../common/service/PlayerService';

/**
 * 播放列表组件
 * 显示当前播放队列，支持删除、点击播放
 */
@Component
export struct PlayListView {
  /**
   * 播放器服务
   */
  private playerService: PlayerService = PlayerService.getInstance();

  /**
   * 播放列表
   */
  @State playList: SongInfo[] = [];

  /**
   * 当前播放索引
   */
  @State currentIndex: number = -1;

  /**
   * 是否显示
   */
  @Link isShow: boolean;

  /**
   * 列表滚动控制器
   */
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    this.playList = this.playerService.playList;
    this.currentIndex = this.playerService.currentIndex;
  }

  /**
   * 播放指定歌曲
   */
  private playSong(index: number) {
    this.playerService.playSongByIndex(index);
    this.currentIndex = index;
  }

  /**
   * 从列表中移除歌曲
   */
  private removeSong(index: number) {
    if (index === this.currentIndex) {
      // 如果移除的是当前播放的歌曲，播放下一首
      this.playerService.playNext();
    }
    this.playerService.removeFromPlayList(index);
    this.playList = [...this.playerService.playList];
    if (index < this.currentIndex) {
      this.currentIndex--;
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('播放列表')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text(`${this.playList.length}首`)
          .fontSize(14)
          .fontColor('#888888')
          .margin({ right: 16 })

        Text('✕')
          .fontSize(20)
          .fontColor('#888888')
          .onClick(() => {
            this.isShow = false;
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })

      // 播放列表
      if (this.playList.length === 0) {
        Column() {
          Text('播放列表为空')
            .fontSize(16)
            .fontColor('#888888')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ scroller: this.scroller }) {
          ForEach(this.playList, (song: SongInfo, index: number) => {
            ListItem() {
              Row() {
                // 当前播放标识
                if (index === this.currentIndex) {
                  Text('▶')
                    .fontSize(14)
                    .fontColor('#FF0000')
                    .width(24)
                } else {
                  Text(`${index + 1}`)
                    .fontSize(14)
                    .fontColor('#888888')
                    .width(24)
                }

                // 歌曲封面
                Image(song.coverUrl)
                  .width(44)
                  .height(44)
                  .borderRadius(6)
                  .objectFit(ImageFit.Cover)
                  .margin({ left: 8, right: 10 })

                // 歌曲信息
                Column() {
                  Text(song.name)
                    .fontSize(14)
                    .fontColor(index === this.currentIndex ? '#FF0000' : '#000000')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(song.artist)
                    .fontSize(12)
                    .fontColor('#888888')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                // 删除按钮
                Text('✕')
                  .fontSize(16)
                  .fontColor('#CCCCCC')
                  .padding(8)
                  .onClick(() => {
                    this.removeSong(index);
                  })
              }
              .width('100%')
              .height(60)
              .padding({ left: 16, right: 8 })
            }
            .onClick(() => {
              this.playSong(index);
            })
          }, (song: SongInfo) => song.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }

      // 底部操作栏
      Row() {
        Text('清空列表')
          .fontSize(14)
          .fontColor('#888888')
          .onClick(() => {
            this.playerService.clearPlayList();
            this.playList = [];
            this.currentIndex = -1;
          })
      }
      .width('100%')
      .height(48)
      .justifyContent(FlexAlign.Center)
      .border({ width: { top: 1 }, color: '#E0E0E0' })
    }
    .width('100%')
    .height('70%')
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 16, topRight: 16 })
    .shadow({ radius: 20, color: '#40000000', offsetX: 0, offsetY: -5 })
  }
}
