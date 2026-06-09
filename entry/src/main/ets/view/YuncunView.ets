import { MomentInfo, UserInfo, MomentType, UserType } from '../common/bean/MomentInfo';
import { YuncunData } from '../common/constants/YuncunData';
import { PlayerService } from '../common/service/PlayerService';
import { SongInfo } from '../common/bean/SongInfo';
import router from '@ohos.router';

/**
 * 云村视图 - 关注和推荐两个子页面
 */
@Component
export struct YuncunView {
  private playerService: PlayerService = PlayerService.getInstance();
  private swiperController: SwiperController = new SwiperController();

  // 当前选中的Tab（0=关注，1=推荐）
  @State currentTab: number = 1; // 默认显示推荐

  // 数据
  @State followingMoments: MomentInfo[] = [];
  @State recommendMoments: MomentInfo[] = [];

  aboutToAppear() {
    // 加载数据
    this.followingMoments = YuncunData.getFollowingMoments();
    this.recommendMoments = YuncunData.getRecommendMoments();
  }

  /**
   * 播放歌曲
   */
  private async playSong(song: SongInfo | null): Promise<void> {
    if (song) {
      await this.playerService.playSong(song);
    }
  }

  /**
   * 切换Tab
   */
  private switchTab(index: number): void {
    this.currentTab = index;
    this.swiperController.showNext();
  }

  build() {
    Column() {
      // 顶部导航栏
      this.NavBarBuilder()

      // Tab切换栏
      this.TabBarBuilder()

      // Swiper内容区
      Swiper(this.swiperController) {
        // 关注页面
        this.FollowingPageBuilder()

        // 推荐页面
        this.RecommendPageBuilder()
      }
      .index(this.currentTab)
      .loop(false)
      .autoPlay(false)
      .indicator(false)
      .onChange((index: number) => {
        this.currentTab = index;
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 顶部导航栏
   */
  @Builder
  NavBarBuilder() {
    Row() {
      // 占位保持对称
      Row().width(40).height(40)

      Blank()

      Text('云村')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)

      Blank()

      // 发布按钮
      Text('+')
        .fontSize(28)
        .fontColor('#333333')
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          // 发布功能（预留）
          console.info('点击发布');
        })
    }
    .width('100%')
    .height(50)
    .padding({ left: 8, right: 8 })
    .backgroundColor('#FFFFFF')
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
    .alignItems(VerticalAlign.Center)
  }

  /**
   * Tab切换栏
   */
  @Builder
  TabBarBuilder() {
    Row() {
      // 关注Tab
      Column() {
        Text('关注')
          .fontSize(this.currentTab === 0 ? 16 : 14)
          .fontColor(this.currentTab === 0 ? '#000000' : '#666666')
          .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .padding({ left: 20, right: 20, top: 12, bottom: 10 })

        if (this.currentTab === 0) {
          Column()
            .width(20)
            .height(2)
            .backgroundColor('#C20C0C')
            .borderRadius(1)
        }
      }
      .onClick(() => {
        this.switchTab(0);
      })

      // 推荐Tab
      Column() {
        Text('推荐')
          .fontSize(this.currentTab === 1 ? 16 : 14)
          .fontColor(this.currentTab === 1 ? '#000000' : '#666666')
          .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .padding({ left: 20, right: 20, top: 12, bottom: 10 })

        if (this.currentTab === 1) {
          Column()
            .width(20)
            .height(2)
            .backgroundColor('#C20C0C')
            .borderRadius(1)
        }
      }
      .onClick(() => {
        this.switchTab(1);
      })
    }
    .width('100%')
    .height(48)
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.Center)
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
  }

  /**
   * 关注页面
   */
  @Builder
  FollowingPageBuilder() {
    Scroll() {
      Column() {
        if (this.followingMoments.length === 0) {
          // 空状态
          Column() {
            Text('暂无关注动态')
              .fontSize(16)
              .fontColor('#888888')
              .margin({ top: 50 })

            Text('去关注更多用户吧')
              .fontSize(14)
              .fontColor('#AAAAAA')
              .margin({ top: 8 })
          }
          .width('100%')
        } else {
          // 动态列表
          ForEach(this.followingMoments, (moment: MomentInfo) => {
            this.MomentCardBuilder(moment)
          })
        }

        // 底部留白
        Blank().height(20)
      }
      .width('100%')
      .padding({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
  }

  /**
   * 推荐页面
   */
  @Builder
  RecommendPageBuilder() {
    Scroll() {
      Column() {
        // 动态列表
        ForEach(this.recommendMoments, (moment: MomentInfo) => {
          this.MomentCardBuilder(moment)
        })

        // 底部留白
        Blank().height(20)
      }
      .width('100%')
      .padding({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
  }

  /**
   * 动态卡片
   */
  @Builder
  MomentCardBuilder(moment: MomentInfo) {
    Column() {
      // 用户信息栏
      Row() {
        Image(moment.user.avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .objectFit(ImageFit.Cover)

        Column() {
          Row() {
            Text(moment.user.name)
              .fontSize(15)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)

            // 用户类型标识
            if (moment.user.userType === UserType.STAR) {
              Text('★')
                .fontSize(12)
                .fontColor('#FFD700')
                .margin({ left: 4 })
            } else if (moment.user.userType === UserType.OFFICIAL) {
              Text('官方')
                .fontSize(10)
                .fontColor('#FFFFFF')
                .backgroundColor('#C20C0C')
                .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                .borderRadius(4)
                .margin({ left: 4 })
            }
          }

          Text(moment.getFormattedTime())
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
        .layoutWeight(1)

        // 更多按钮
        Text('⋮')
          .fontSize(20)
          .fontColor('#999999')
          .padding({ left: 8, right: 8 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })
      .alignItems(VerticalAlign.Center)

      // 动态内容
      Text(moment.content)
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .lineHeight(20)

      // 音乐卡片（如果是分享音乐）
      if (moment.type === MomentType.MUSIC && moment.music) {
        this.MusicCardBuilder(moment.music)
      }

      // 图片网格（如果是图片动态）
      if (moment.type === MomentType.IMAGE && moment.images.length > 0) {
        this.ImageGridBuilder(moment.images)
      }

      // 视频（如果是视频动态）
      if (moment.type === MomentType.VIDEO && moment.videoUrl) {
        this.VideoCardBuilder(moment.videoUrl)
      }

      // 操作栏
      Row() {
        // 点赞
        Row() {
          Text(moment.isLiked ? '♥' : '♡')
            .fontSize(18)
            .fontColor(moment.isLiked ? '#C20C0C' : '#666666')

          Text(moment.getFormattedCount(moment.likes))
            .fontSize(13)
            .fontColor('#666666')
            .margin({ left: 4 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          moment.isLiked = !moment.isLiked;
          moment.likes = moment.isLiked ? moment.likes + 1 : moment.likes - 1;
        })

        // 评论
        Row() {
          Text('💬')
            .fontSize(16)
            .fontColor('#666666')

          Text(moment.getFormattedCount(moment.comments))
            .fontSize(13)
            .fontColor('#666666')
            .margin({ left: 4 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)

        // 分享
        Row() {
          Text('↗')
            .fontSize(18)
            .fontColor('#666666')

          Text(moment.getFormattedCount(moment.shares))
            .fontSize(13)
            .fontColor('#666666')
            .margin({ left: 4 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .margin({ top: 8 })
    }
    .width('94%')
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ left: '3%', right: '3%', bottom: 12 })
  }

  /**
   * 音乐卡片
   */
  @Builder
  MusicCardBuilder(music: SongInfo) {
    Row() {
      Image(music.coverUrl)
        .width(50)
        .height(50)
        .borderRadius(6)
        .objectFit(ImageFit.Cover)

      Column() {
        Text(music.name)
          .fontSize(14)
          .fontColor('#000000')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(music.artist)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .layoutWeight(1)

      // 播放按钮
      Text('▶')
        .fontSize(20)
        .fontColor('#C20C0C')
        .width(36)
        .height(36)
        .borderRadius(18)
        .border({ width: 1, color: '#C20C0C' })
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.playSong(music);
        })
    }
    .width('100%')
    .height(66)
    .padding({ left: 12, right: 12 })
    .margin({ left: 16, right: 16, top: 4, bottom: 8 })
    .backgroundColor('#F8F8F8')
    .borderRadius(6)
  }

  /**
   * 图片网格
   */
  @Builder
  ImageGridBuilder(images: string[]) {
    Grid() {
      ForEach(images, (imageUrl: string) => {
        GridItem() {
          Image(imageUrl)
            .width('100%')
            .aspectRatio(1)
            .objectFit(ImageFit.Cover)
            .borderRadius(4)
        }
      })
    }
    .columnsTemplate(images.length === 1 ? '1fr' : images.length === 2 ? '1fr 1fr' : '1fr 1fr 1fr')
    .columnsGap(4)
    .rowsGap(4)
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8 })
    .layoutDirection(GridDirection.Row)
  }

  /**
   * 视频卡片
   */
  @Builder
  VideoCardBuilder(videoUrl: string) {
    Column() {
      // 视频封面（简化版，实际应使用Video组件）
      Stack() {
        Image('https://images.unsplash.com/photo-1515169067868-5387ec356754?w=320&h=180&fit=crop')
          .width('100%')
          .height(180)
          .objectFit(ImageFit.Cover)
          .borderRadius(6)

        // 播放按钮
        Text('▶')
          .fontSize(32)
          .fontColor('#FFFFFF')
          .width(50)
          .height(50)
          .backgroundColor('#40000000')
          .borderRadius(25)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(180)
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8 })
  }
}
