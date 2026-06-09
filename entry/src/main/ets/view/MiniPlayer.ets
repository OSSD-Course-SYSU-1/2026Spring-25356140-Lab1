import { SongInfo } from '../common/bean/SongInfo';
import { PlayState } from '../common/bean/PlayerState';
import { PlayerService } from '../common/service/PlayerService';
import router from '@ohos.router';

/**
 * 底部迷你播放栏组件 - 永久显示
 */
@Component
export struct MiniPlayer {
  // 播放器服务
  private playerService: PlayerService = PlayerService.getInstance();

  // 状态
  @State currentSong: SongInfo | null = null;
  @State playState: PlayState = PlayState.IDLE;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State progressPercent: number = 0;

  // 回调引用存储，用于后续移除
  private onSongChangeCallback: ((song: SongInfo | null) => void) | null = null;
  private onStateChangeCallback: ((state: PlayState) => void) | null = null;
  private onTimeUpdateCallback: ((currentTime: number, duration: number) => void) | null = null;

  aboutToAppear() {
    // 定义回调函数
    this.onSongChangeCallback = (song: SongInfo | null) => {
      this.currentSong = song;
    };

    this.onStateChangeCallback = (state: PlayState) => {
      this.playState = state;
    };

    this.onTimeUpdateCallback = (currentTime: number, duration: number) => {
      this.currentTime = currentTime;
      this.duration = duration;
      if (duration > 0) {
        this.progressPercent = (currentTime / duration) * 100;
      }
    };

    // 添加监听器（支持多监听器，不会互相覆盖）
    this.playerService.addOnSongChange(this.onSongChangeCallback);
    this.playerService.addOnStateChange(this.onStateChangeCallback);
    this.playerService.addOnTimeUpdate(this.onTimeUpdateCallback);

    // 获取当前状态
    this.currentSong = this.playerService.currentSong;
    this.playState = this.playerService.playState;
    this.currentTime = this.playerService.currentTime;
    this.duration = this.playerService.duration;
    if (this.duration > 0) {
      this.progressPercent = (this.currentTime / this.duration) * 100;
    }
  }

  aboutToDisappear() {
    // 组件销毁时移除监听器，避免内存泄漏
    if (this.onSongChangeCallback) {
      this.playerService.removeOnSongChange(this.onSongChangeCallback);
    }
    if (this.onStateChangeCallback) {
      this.playerService.removeOnStateChange(this.onStateChangeCallback);
    }
    if (this.onTimeUpdateCallback) {
      this.playerService.removeOnTimeUpdate(this.onTimeUpdateCallback);
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
      // 进度条 - 始终显示
      Progress({
        value: this.progressPercent,
        total: 100,
        type: ProgressType.Linear
      })
        .width('100%')
        .height(2)
        .color('#FF0000')
        .backgroundColor('#E0E0E0')

      Row() {
        // 歌曲封面 - 有歌曲时显示封面，无歌曲时显示默认图标
        if (this.currentSong) {
          Image(this.currentSong.coverUrl)
            .width(48)
            .height(48)
            .borderRadius(6)
            .margin({ left: 12, right: 12 })
        } else {
          Image($r('app.media.music_icon'))
            .width(48)
            .height(48)
            .borderRadius(6)
            .margin({ left: 12, right: 12 })
        }

        // 歌曲信息 - 有歌曲时显示歌名和歌手，无歌曲时显示提示
        Column() {
          if (this.currentSong) {
            Text(this.currentSong.name)
              .fontSize(14)
              .fontColor('#000000')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.currentSong.artist)
              .fontSize(12)
              .fontColor('#888888')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          } else {
            Text('暂无播放')
              .fontSize(14)
              .fontColor('#000000')
              .maxLines(1)

            Text('去发现好音乐')
              .fontSize(12)
              .fontColor('#888888')
              .margin({ top: 4 })
              .maxLines(1)
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 播放控制按钮 - 始终显示
        Row() {
          // 上一首
          Text('⏮')
            .fontSize(22)
            .fontColor(this.currentSong ? '#333333' : '#CCCCCC')
            .onClick(() => {
              if (this.currentSong) {
                this.playerService.playPrevious();
              }
            })

          // 播放/暂停
          Text(this.playState === PlayState.PLAYING ? '⏸' : '▶')
            .fontSize(32)
            .fontColor(this.currentSong ? '#333333' : '#CCCCCC')
            .margin({ left: 16, right: 16 })
            .onClick(() => {
              if (this.currentSong) {
                this.playerService.togglePlay();
              }
            })

          // 下一首
          Text('⏭')
            .fontSize(22)
            .fontColor(this.currentSong ? '#333333' : '#CCCCCC')
            .onClick(() => {
              if (this.currentSong) {
                this.playerService.playNext();
              }
            })
        }
        .margin({ right: 12 })
      }
      .width('100%')
      .height(62)
      .backgroundColor('#FFFFFF')
      .onClick(() => {
        if (this.currentSong) {
          router.pushUrl({
            url: 'pages/PlayerPage'
          });
        }
      })
    }
    .width('100%')
    .height(64)
    .backgroundColor('#FFFFFF')
    .border({ width: { top: 1 }, color: '#E0E0E0' })
  }
}
