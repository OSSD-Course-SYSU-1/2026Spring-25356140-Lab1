import { SongInfo } from '../common/bean/SongInfo';
import { PlayState, PlayMode } from '../common/bean/PlayerState';
import { LyricInfo } from '../common/bean/LyricInfo';
import { PlayerService } from '../common/service/PlayerService';
import { LyricView } from '../view/LyricView';
import { PlayListView } from '../view/PlayListView';
import { GestureBack } from '../view/GestureBack';
import router from '@ohos.router';

/**
 * 完整播放器页面
 * 显示歌曲详细信息、播放控制、歌词和播放列表
 */
@Entry
@Component
struct PlayerPage {
  // 播放器服务
  private playerService: PlayerService = PlayerService.getInstance();

  // 状态
  @State currentSong: SongInfo | null = null;
  @State playState: PlayState = PlayState.IDLE;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State playMode: PlayMode = PlayMode.LIST_LOOP;
  @State sliderValue: number = 0;
  @State currentLyric: LyricInfo = new LyricInfo();
  @State showPlayList: boolean = false;
  @State showLyric: boolean = true;
  @State showTranslation: boolean = false;
  @State isCurrentSongLiked: boolean = false;

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  // 回调引用存储，用于后续移除
  private onSongChangeCallback: ((song: SongInfo | null) => void) | null = null;
  private onStateChangeCallback: ((state: PlayState) => void) | null = null;
  private onTimeUpdateCallback: ((currentTime: number, duration: number) => void) | null = null;
  private onLyricChangeCallback: ((lyric: LyricInfo) => void) | null = null;
  private onLikedSongsChangeCallback: ((songs: SongInfo[]) => void) | null = null;

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
        this.sliderValue = (currentTime / duration) * 100;
      }
    };

    this.onLyricChangeCallback = (lyric: LyricInfo) => {
      this.currentLyric = lyric;
    };

    this.onLikedSongsChangeCallback = () => {
      this.isCurrentSongLiked = this.playerService.isSongLiked(this.currentSong);
    };

    // 添加监听器（支持多监听器，不会互相覆盖）
    this.playerService.addOnSongChange(this.onSongChangeCallback);
    this.playerService.addOnStateChange(this.onStateChangeCallback);
    this.playerService.addOnTimeUpdate(this.onTimeUpdateCallback);
    this.playerService.addOnLyricChange(this.onLyricChangeCallback);
    this.playerService.addOnLikedSongsChange(this.onLikedSongsChangeCallback);

    // 获取当前状态
    this.currentSong = this.playerService.currentSong;
    this.playState = this.playerService.playState;
    this.currentTime = this.playerService.currentTime;
    this.duration = this.playerService.duration;
    this.playMode = this.playerService.playMode;
    this.currentLyric = this.playerService.currentLyric;
    this.isCurrentSongLiked = this.playerService.isSongLiked(this.currentSong);
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
    if (this.onLyricChangeCallback) {
      this.playerService.removeOnLyricChange(this.onLyricChangeCallback);
    }
    if (this.onLikedSongsChangeCallback) {
      this.playerService.removeOnLikedSongsChange(this.onLikedSongsChangeCallback);
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

  /**
   * 获取播放模式图标
   */
  private getPlayModeIcon(): string {
    switch (this.playMode) {
      case PlayMode.SINGLE_LOOP:
        return '🔂';
      case PlayMode.SHUFFLE:
        return '🔀';
      default:
        return '🔁';
    }
  }

  build() {
    Stack() {
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.icon'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back();
            })

          Text('正在播放')
            .fontSize(18)
            .fontColor('#000000')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Row() {
            // 歌词/封面切换
            Text(this.showLyric ? '封面' : '歌词')
              .fontSize(14)
              .fontColor('#666666')
              .padding(8)
              .onClick(() => {
                this.showLyric = !this.showLyric;
              })

            // 播放列表
            Text('列表')
              .fontSize(14)
              .fontColor('#666666')
              .padding(8)
              .onClick(() => {
                this.showPlayList = true;
              })
          }
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 8 })

        if (this.currentSong) {
          // 中间内容区域（封面或歌词）
          if (this.showLyric && this.currentLyric.lines.length > 0) {
            // 显示歌词
            Column() {
              LyricView({
                lyricInfo: this.currentLyric,
                currentTime: this.currentTime,
                showTranslation: this.showTranslation
              })

              // 翻译开关
              if (this.currentLyric.hasTranslation()) {
                Row() {
                  Text(this.showTranslation ? '隐藏翻译' : '显示翻译')
                    .fontSize(12)
                    .fontColor('#888888')
                    .onClick(() => {
                      this.showTranslation = !this.showTranslation;
                    })
                }
                .margin({ top: 8 })
              }
            }
            .layoutWeight(1)
          } else {
            // 显示封面
            Column() {
              Image(this.currentSong.coverUrl)
                .width(280)
                .height(280)
                .borderRadius(12)
                .shadow({ radius: 20, color: '#40000000', offsetX: 0, offsetY: 10 })
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          }

          // 歌曲信息
          Column() {
            Text(this.currentSong.name)
              .fontSize(20)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.currentSong.artist + ' - ' + this.currentSong.album)
              .fontSize(14)
              .fontColor('#888888')
              .margin({ top: 8 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .padding({ left: 32, right: 32, top: 16, bottom: 16 })

          // 进度条
          Column() {
            Slider({
              value: this.sliderValue,
              min: 0,
              max: 100,
              step: 1
            })
              .blockColor('#FF0000')
              .trackColor('#E0E0E0')
              .selectedColor('#FF0000')
              .width('100%')
              .onChange((value: number) => {
                if (this.duration > 0) {
                  const seekTime = (value / 100) * this.duration;
                  this.playerService.seekTo(seekTime);
                }
              })

            Row() {
              Text(this.formatTime(this.currentTime))
                .fontSize(12)
                .fontColor('#888888')

              Text(this.formatTime(this.duration))
                .fontSize(12)
                .fontColor('#888888')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 8 })
          }
          .width('100%')
          .padding({ left: 32, right: 32, top: 16, bottom: 16 })

          // 播放控制按钮
          Row() {
            // 播放模式
            Text(this.getPlayModeIcon())
              .fontSize(24)
              .onClick(() => {
                this.playerService.togglePlayMode();
                this.playMode = this.playerService.playMode;
              })

            // 上一首
            Text('⏮')
              .fontSize(32)
              .onClick(() => {
                this.playerService.playPrevious();
              })

            // 播放/暂停
            Text(this.playState === PlayState.PLAYING ? '⏸' : '▶')
              .fontSize(64)
              .onClick(() => {
                this.playerService.togglePlay();
              })

            // 下一首
            Text('⏭')
              .fontSize(32)
              .onClick(() => {
                this.playerService.playNext();
              })

            // 喜欢/取消喜欢
            Text(this.isCurrentSongLiked ? '♥' : '♡')
              .fontSize(28)
              .fontColor(this.isCurrentSongLiked ? '#C20C0C' : '#888888')
              .onClick(() => {
                if (this.currentSong) {
                  this.isCurrentSongLiked = this.playerService.toggleLikeSong(this.currentSong);
                }
              })
          }
          .width('100%')
          .height(100)
          .justifyContent(FlexAlign.SpaceEvenly)
          .alignItems(VerticalAlign.Center)
          .padding({ bottom: 32 })
        } else {
          // 无歌曲时显示占位
          Column() {
            Text('暂无播放')
              .fontSize(18)
              .fontColor('#888888')
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')

      // 播放列表弹层
      if (this.showPlayList) {
        Column() {
          // 遮罩层
          Column()
            .width('100%')
            .layoutWeight(1)
            .backgroundColor('#40000000')
            .onClick(() => {
              this.showPlayList = false;
            })

          // 播放列表
          PlayListView({ isShow: $showPlayList })
        }
        .width('100%')
        .height('100%')
      }

      // 左侧手势返回区域
      this.GestureBackArea()
    }
    .width('100%')
    .height('100%')
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

            // 如果垂直偏移太大，取消返回
            if (deltaY > 100) {
              this.isInBackZone = false;
              return;
            }

            // 如果水平滑动距离足够，执行返回
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
