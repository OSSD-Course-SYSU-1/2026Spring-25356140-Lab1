import router from '@ohos.router';
import { HotSongsData, ArtistInfo, PlaylistInfo, BannerInfo } from '../common/constants/HotSongsData';
import { SongInfo } from '../common/bean/SongInfo';
import { PlayerService } from '../common/service/PlayerService';
import { RecommendService } from '../common/service/RecommendService';
import { MiniPlayer } from './MiniPlayer';

/**
 * 推荐页面视图 - 仿网易云音乐推荐Tab
 * 包含Banner、快捷入口、推荐歌单、新歌速递、热门歌手、推荐歌曲
 */
@Component
export struct RecommendView {
  private playerService: PlayerService = PlayerService.getInstance();
  private recommendService: RecommendService = RecommendService.getInstance();
  private swiperController: SwiperController = new SwiperController();

  // 数据
  @State banners: BannerInfo[] = HotSongsData.getBanners();
  @State playlists: PlaylistInfo[] = HotSongsData.getRecommendedPlaylists();
  @State artists: ArtistInfo[] = HotSongsData.getHotArtists();
  @State hotSongs: SongInfo[] = HotSongsData.getHotSongs();
  @State recommendedSongs: SongInfo[] = [];

  // 快捷入口
  private quickEntries: QuickEntry[] = [
    new QuickEntry('每日推荐', '☀', '#C20C0C', 'pages/DailyRecommendPage'),
    new QuickEntry('歌单', '☰', '#FF6B6B', ''),
    new QuickEntry('排行榜', '☰', '#4ECDC4', ''),
    new QuickEntry('电台', '◎', '#45B7D1', ''),
    new QuickEntry('直播', '◉', '#96CEB4', ''),
  ];

  aboutToAppear() {
    // 使用个性化推荐算法获取推荐歌曲
    this.recommendedSongs = this.recommendService.getRecommendedSongs(20);
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
   * 播放歌曲
   */
  private async playSong(song: SongInfo): Promise<void> {
    await this.playerService.playSong(song);
  }

  build() {
    Scroll() {
      Column() {
        // Banner轮播
        this.BannerBuilder()

        // 快捷入口
        this.QuickEntryBuilder()

        // 推荐歌单
        this.PlaylistSectionBuilder()

        // 新歌速递
        this.NewSongsSectionBuilder()

        // 热门歌手
        this.ArtistSectionBuilder()

        // 推荐歌曲列表
        this.RecommendedSongsSectionBuilder()

        // 底部留白
        Blank().height(20)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
  }

  /**
   * Banner轮播
   */
  @Builder
  BannerBuilder() {
    Swiper(this.swiperController) {
      ForEach(this.banners, (banner: BannerInfo) => {
        Image(banner.imageUrl)
          .width('100%')
          .height(145)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .onClick(() => {
            if (banner.targetPage) {
              router.pushUrl({ url: banner.targetPage });
            }
          })
      })
    }
    .width('94%')
    .height(145)
    .loop(true)
    .autoPlay(true)
    .interval(3000)
    .margin({ top: 12, bottom: 16 })
  }

  /**
   * 快捷入口
   */
  @Builder
  QuickEntryBuilder() {
    Row() {
      ForEach(this.quickEntries, (entry: QuickEntry) => {
        Column() {
          Text(entry.icon)
            .fontSize(28)
            .fontColor(entry.color)
            .width(50)
            .height(50)
            .backgroundColor('#F5F5F5')
            .borderRadius(25)
            .textAlign(TextAlign.Center)

          Text(entry.name)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 6 })
        }
        .width('20%')
        .onClick(() => {
          if (entry.targetPage) {
            router.pushUrl({ url: entry.targetPage });
          }
        })
      })
    }
    .width('100%')
    .padding({ left: 8, right: 8, bottom: 16 })
    .justifyContent(FlexAlign.SpaceAround)
  }

  /**
   * 推荐歌单区域
   */
  @Builder
  PlaylistSectionBuilder() {
    Column() {
      // 标题栏
      Row() {
        Text('推荐歌单')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('更多 ›')
          .fontSize(14)
          .fontColor('#888888')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      // 歌单网格（2行3列）
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.playlists, (playlist: PlaylistInfo) => {
          Column() {
            Image(playlist.coverUrl)
              .width('100%')
              .aspectRatio(1)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)

            Text(playlist.name)
              .fontSize(13)
              .fontColor('#333333')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 6 })
              .height(36)

            Text(playlist.songCount + '首')
              .fontSize(11)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .width('31%')
          .margin({ bottom: 12 })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  /**
   * 新歌速递区域
   */
  @Builder
  NewSongsSectionBuilder() {
    Column() {
      // 标题栏
      Row() {
        Text('新歌速递')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('更多 ›')
          .fontSize(14)
          .fontColor('#888888')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      // 新歌横向滚动
      Scroll() {
        Row() {
          ForEach(this.hotSongs.slice(0, 5), (song: SongInfo) => {
            Column() {
              Image(song.coverUrl)
                .width(100)
                .height(100)
                .borderRadius(8)
                .objectFit(ImageFit.Cover)

              Text(song.name)
                .fontSize(13)
                .fontColor('#333333')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 6 })
                .width(100)

              Text(song.artist)
                .fontSize(11)
                .fontColor('#999999')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 2 })
                .width(100)
            }
            .margin({ right: 12 })
            .onClick(() => {
              this.playSong(song);
            })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  /**
   * 热门歌手区域
   */
  @Builder
  ArtistSectionBuilder() {
    Column() {
      // 标题栏
      Row() {
        Text('热门歌手')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('更多 ›')
          .fontSize(14)
          .fontColor('#888888')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      // 歌手横向滚动
      Scroll() {
        Row() {
          ForEach(this.artists, (artist: ArtistInfo) => {
            Column() {
              Image(artist.avatarUrl)
                .width(70)
                .height(70)
                .borderRadius(35)
                .objectFit(ImageFit.Cover)

              Text(artist.name)
                .fontSize(13)
                .fontColor('#333333')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 8 })
                .width(70)
                .textAlign(TextAlign.Center)
            }
            .margin({ right: 16 })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  /**
   * 推荐歌曲列表区域
   */
  @Builder
  RecommendedSongsSectionBuilder() {
    Column() {
      // 标题栏
      Row() {
        Text('推荐歌曲')
          .fontSize(18)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('播放全部')
          .fontSize(14)
          .fontColor('#C20C0C')
          .onClick(() => {
            if (this.recommendedSongs.length > 0) {
              this.playerService.setPlayList(this.recommendedSongs, 0);
              this.playSong(this.recommendedSongs[0]);
            }
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      // 歌曲列表
      Column() {
        ForEach(this.recommendedSongs, (song: SongInfo, index: number) => {
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
              .margin({ right: 12 })

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
        })
      }
      .width('100%')
      .padding({ left: 4, right: 4 })
    }
    .width('100%')
  }
}

/**
 * 快捷入口数据类
 */
class QuickEntry {
  name: string;
  icon: string;
  color: string;
  targetPage: string;

  constructor(name: string, icon: string, color: string, targetPage: string) {
    this.name = name;
    this.icon = icon;
    this.color = color;
    this.targetPage = targetPage;
  }
}
