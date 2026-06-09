import router from '@ohos.router';
import { SongInfo } from '../common/bean/SongInfo';
import { SearchHistoryService } from '../common/service/SearchHistoryService';
import { PlayerService } from '../common/service/PlayerService';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 搜索页面
 * 支持搜索歌曲、歌手，保留搜索历史
 */
@Entry
@Component
struct SearchPage {
  private searchService: SearchHistoryService = SearchHistoryService.getInstance();
  private playerService: PlayerService = PlayerService.getInstance();

  // 搜索状态
  @State searchKeyword: string = '';
  @State searchHistory: string[] = [];
  @State hotSearches: string[] = [];
  @State searchResults: SongInfo[] = [];
  @State isSearching: boolean = false;
  @State hasSearched: boolean = false;

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  aboutToAppear() {
    // 加载搜索历史和热门搜索
    this.searchHistory = this.searchService.getSearchHistory();
    this.hotSearches = this.searchService.getHotSearches();
  }

  /**
   * 执行搜索
   */
  private performSearch(keyword: string): void {
    if (!keyword || keyword.trim() === '') {
      return;
    }

    this.searchKeyword = keyword.trim();
    this.isSearching = true;
    this.hasSearched = true;

    // 保存搜索历史
    this.searchService.addSearchHistory(this.searchKeyword);
    this.searchHistory = this.searchService.getSearchHistory();

    // 执行搜索
    this.searchResults = this.searchService.searchSongs(this.searchKeyword);
    this.isSearching = false;
  }

  /**
   * 清除搜索
   */
  private clearSearch(): void {
    this.searchKeyword = '';
    this.searchResults = [];
    this.hasSearched = false;
  }

  /**
   * 删除单个搜索历史
   */
  private removeHistoryItem(keyword: string): void {
    this.searchService.removeSearchHistory(keyword);
    this.searchHistory = this.searchService.getSearchHistory();
  }

  /**
   * 清空所有搜索历史
   */
  private clearAllHistory(): void {
    this.searchService.clearSearchHistory();
    this.searchHistory = [];
  }

  /**
   * 播放歌曲
   */
  private async playSong(song: SongInfo): Promise<void> {
    await this.playerService.playSong(song);
  }

  build() {
    Column() {
      // 顶部搜索栏
      Row() {
        // 返回按钮
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .margin({ left: 15 })
          .onClick(() => {
            router.back();
          })

        // 搜索输入框
        Row() {
          Image($r('app.media.icon'))
            .width(18)
            .height(18)
            .margin({ left: 12 })
            .fillColor('#999999')

          TextInput({ placeholder: '搜索歌曲、歌手', text: $$this.searchKeyword })
            .placeholderColor('#999999')
            .fontSize(14)
            .height(40)
            .backgroundColor('transparent')
            .layoutWeight(1)
            .onSubmit(() => {
              this.performSearch(this.searchKeyword);
            })

          // 清除按钮
          if (this.searchKeyword !== '') {
            Text('✕')
              .fontSize(16)
              .fontColor('#999999')
              .margin({ right: 12 })
              .onClick(() => {
                this.clearSearch();
              })
          }
        }
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .layoutWeight(1)
        .margin({ left: 12, right: 15 })

        // 搜索按钮
        Text('搜索')
          .fontSize(14)
          .fontColor('#C20C0C')
          .margin({ right: 15 })
          .onClick(() => {
            this.performSearch(this.searchKeyword);
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })
      .alignItems(VerticalAlign.Center)

      // 搜索内容区域
      if (this.hasSearched) {
        // 搜索结果页面
        this.SearchResultBuilder()
      } else {
        // 搜索历史和热门搜索
        this.SearchHomeBuilder()
      }

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

  /**
   * 搜索首页（历史和热门）
   */
  @Builder
  SearchHomeBuilder() {
    Scroll() {
      Column() {
        // 搜索历史
        if (this.searchHistory.length > 0) {
          Column() {
            // 标题栏
            Row() {
              Text('历史记录')
                .fontSize(16)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)

              Blank()

              Text('清空')
                .fontSize(14)
                .fontColor('#666666')
                .onClick(() => {
                  this.clearAllHistory();
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 12 })

            // 历史标签
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              ForEach(this.searchHistory, (keyword: string) => {
                Row() {
                  Text(keyword)
                    .fontSize(13)
                    .fontColor('#333333')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text('✕')
                    .fontSize(12)
                    .fontColor('#999999')
                    .margin({ left: 6 })
                    .onClick(() => {
                      this.removeHistoryItem(keyword);
                    })
                }
                .height(32)
                .padding({ left: 12, right: 12 })
                .backgroundColor('#F5F5F5')
                .borderRadius(16)
                .margin({ right: 8, bottom: 8 })
                .onClick(() => {
                  this.performSearch(keyword);
                })
              })
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
          }
          .width('100%')
          .margin({ top: 16, bottom: 24 })
        }

        // 热门搜索
        Column() {
          // 标题栏
          Row() {
            Text('热门搜索')
              .fontSize(16)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)

            Blank()
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 12 })

          // 热门标签
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            ForEach(this.hotSearches, (keyword: string, index: number) => {
              Row() {
                // 排名
                Text((index + 1).toString())
                  .fontSize(12)
                  .fontColor(index < 3 ? '#C20C0C' : '#999999')
                  .fontWeight(index < 3 ? FontWeight.Bold : FontWeight.Normal)
                  .margin({ right: 6 })

                Text(keyword)
                  .fontSize(13)
                  .fontColor('#333333')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .height(32)
              .padding({ left: 12, right: 12 })
              .backgroundColor('#F5F5F5')
              .borderRadius(16)
              .margin({ right: 8, bottom: 8 })
              .onClick(() => {
                this.performSearch(keyword);
              })
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
        .width('100%')
      }
      .width('100%')
      .padding({ bottom: 20 })
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
  }

  /**
   * 搜索结果页面
   */
  @Builder
  SearchResultBuilder() {
    Column() {
      // 搜索结果统计
      Row() {
        Text('搜索 "' + this.searchKeyword + '"')
          .fontSize(14)
          .fontColor('#666666')

        Text(' 共' + this.searchResults.length + '首')
          .fontSize(14)
          .fontColor('#999999')

        Blank()

        // 播放全部
        if (this.searchResults.length > 0) {
          Row() {
            Image($r('app.media.icon'))
              .width(16)
              .height(16)
              .margin({ right: 4 })
              .fillColor('#C20C0C')

            Text('播放全部')
              .fontSize(14)
              .fontColor('#C20C0C')
          }
          .onClick(() => {
            this.playerService.setPlayList(this.searchResults, 0);
            this.playerService.playSong(this.searchResults[0]);
          })
        }
      }
      .width('100%')
      .height(48)
      .padding({ left: 16, right: 16 })
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })
      .alignItems(VerticalAlign.Center)

      // 搜索结果列表
      if (this.searchResults.length > 0) {
        List() {
          ForEach(this.searchResults, (song: SongInfo, index: number) => {
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
      } else {
        // 无结果
        Column() {
          Text('暂无搜索结果')
            .fontSize(16)
            .fontColor('#888888')
            .margin({ top: 50 })

          Text('换个关键词试试吧')
            .fontSize(14)
            .fontColor('#AAAAAA')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
}
