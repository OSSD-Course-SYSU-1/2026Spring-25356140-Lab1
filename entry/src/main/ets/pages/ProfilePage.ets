import router from '@ohos.router';
import { SongInfo } from '../common/bean/SongInfo';
import { PlayerService } from '../common/service/PlayerService';
import { MiniPlayer } from '../view/MiniPlayer';

/**
 * 个人主页页面 - 仿网易云音乐新版风格
 * 包含头部信息区、Tab切换、歌单网格
 */
@Entry
@Component
struct ProfilePage {
  // 播放器服务
  private playerService: PlayerService = PlayerService.getInstance();

  // 用户信息
  @State userName: string = '网易云音乐用户';
  @State userSignature: string = '这个人很懒，什么都没留下';
  @State avatarUrl: string = 'https://y.gtimg.cn/music/photo_new/T001R300x300M000002azErJ0U8zd4_3.jpg';
  @State backgroundUrl: string = 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=300&fit=crop';

  // 用户统计数据
  @State followers: number = 128;
  @State following: number = 256;
  @State level: number = 8;
  @State listeningTime: string = '1,248小时';

  // 选项卡状态
  @State currentTab: number = 0;
  private tabTitles: string[] = ['音乐', '动态', '播客'];

  // 我喜欢的音乐
  @State likedSongsCount: number = 0;

  // 创建的歌单（Mock数据）
  @State createdPlaylists: PlaylistInfo[] = [
    new PlaylistInfo('1', '深夜emo', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003Z2hNS1Z1Vz8_3.jpg', 10),
    new PlaylistInfo('2', '运动节奏', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', 25),
  ];

  // 收藏的歌单（Mock数据）
  @State collectedPlaylists: PlaylistInfo[] = [
    new PlaylistInfo('3', '华语经典', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', 15),
    new PlaylistInfo('4', '欧美流行', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', 20),
    new PlaylistInfo('5', '轻音乐', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001CBQA12BjV74_3.jpg', 30),
  ];

  // 回调引用
  private onLikedSongsChangeCallback: ((songs: SongInfo[]) => void) | null = null;

  // 手势返回状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  aboutToAppear() {
    // 监听我喜欢的音乐变化
    this.onLikedSongsChangeCallback = (songs: SongInfo[]) => {
      this.likedSongsCount = songs.length;
    };
    this.playerService.addOnLikedSongsChange(this.onLikedSongsChangeCallback);

    // 初始化我喜欢的音乐数量
    this.likedSongsCount = this.playerService.likedSongs.length;
  }

  aboutToDisappear() {
    if (this.onLikedSongsChangeCallback) {
      this.playerService.removeOnLikedSongsChange(this.onLikedSongsChangeCallback);
    }
  }

  /**
   * 构建顶部导航栏
   */
  @Builder
  NavBarBuilder() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(24)
        .height(24)
        .margin({ left: 15 })
        .onClick(() => {
          router.back();
        })

      Blank()

      Text('个人主页')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Bold)

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
  }

  /**
   * 构建头部信息区
   */
  @Builder
  ProfileHeaderBuilder() {
    Stack() {
      // 背景图片
      Image(this.backgroundUrl)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .blur(8)

      // 半透明黑色遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#80000000')

      // 更换背景按钮
      Row() {
        Image($r('app.media.icon'))
          .width(16)
          .height(16)
          .margin({ right: 4 })
        Text('更换背景')
          .fontSize(12)
          .fontColor('#FFFFFF')
      }
      .padding({ left: 10, right: 10, top: 5, bottom: 5 })
      .backgroundColor('#40000000')
      .borderRadius(15)
      .position({ x: 16, y: 16 })

      // 用户信息
      Column() {
        // 头像
        Stack() {
          Image(this.avatarUrl)
            .width(80)
            .height(80)
            .borderRadius(40)
            .border({ width: 3, color: '#FFFFFF' })

          // 头像更换按钮
          Image($r('app.media.icon'))
            .width(24)
            .height(24)
            .position({ x: 56, y: 56 })
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
        }

        // 用户名
        Text(this.userName)
          .fontSize(20)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 12 })

        // 个性签名
        Text(this.userSignature)
          .fontSize(14)
          .fontColor('#CCCCCC')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
          .width('80%')
          .textAlign(TextAlign.Center)

        // 统计数据
        Row() {
          this.StatItemBuilder(this.following.toString(), '关注')
          this.StatItemBuilder(this.followers.toString(), '粉丝')
          this.StatItemBuilder('LV.' + this.level, '等级')
          this.StatItemBuilder(this.listeningTime, '听歌时长')
        }
        .width('90%')
        .margin({ top: 20 })
        .justifyContent(FlexAlign.SpaceAround)

        // 编辑资料按钮
        Button('编辑资料')
          .width(120)
          .height(36)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor('#C20C0C')
          .borderRadius(18)
          .margin({ top: 16 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 50, bottom: 24 })
    }
    .width('100%')
    .height('45%')
  }

  /**
   * 构建统计项
   */
  @Builder
  StatItemBuilder(value: string, label: string) {
    Column() {
      Text(value)
        .fontSize(18)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
      Text(label)
        .fontSize(12)
        .fontColor('#CCCCCC')
        .margin({ top: 2 })
    }
  }

  /**
   * 构建Tab栏
   */
  @Builder
  TabBarBuilder() {
    Row() {
      ForEach(this.tabTitles, (title: string, index: number) => {
        Column() {
          Text(title)
            .fontSize(this.currentTab === index ? 16 : 14)
            .fontColor(this.currentTab === index ? '#C20C0C' : '#666666')
            .fontWeight(this.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
            .padding({ left: 16, right: 16, top: 12, bottom: 10 })

          // 底部指示条
          if (this.currentTab === index) {
            Column()
              .width(20)
              .height(2)
              .backgroundColor('#C20C0C')
              .borderRadius(1)
          }
        }
        .onClick(() => {
          this.currentTab = index;
        })
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
  }

  /**
   * 构建音乐内容
   */
  @Builder
  MusicContentBuilder() {
    Scroll() {
      Column() {
        // 歌单网格
        Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          // 我喜欢的音乐（特殊卡片）
          this.LikedMusicCardBuilder()

          // 创建的歌单
          ForEach(this.createdPlaylists, (playlist: PlaylistInfo) => {
            this.PlaylistCardBuilder(playlist)
          })

          // 收藏的歌单
          ForEach(this.collectedPlaylists, (playlist: PlaylistInfo) => {
            this.PlaylistCardBuilder(playlist)
          })
        }
        .padding({ left: 16, right: 16, top: 16 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 构建"我喜欢的音乐"卡片
   */
  @Builder
  LikedMusicCardBuilder() {
    Column() {
      // 红色背景封面
      Column() {
        Text('♥')
          .fontSize(40)
          .fontColor('#FFFFFF')
      }
      .width('100%')
      .aspectRatio(1)
      .backgroundColor('#C20C0C')
      .borderRadius(8)
      .justifyContent(FlexAlign.Center)

      Text('我喜欢的音乐')
        .fontSize(14)
        .fontColor('#000000')
        .margin({ top: 8 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')

      Text(this.likedSongsCount + '首')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ top: 2 })
        .width('100%')
    }
    .width('47%')
    .margin({ bottom: 16 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/PlaylistDetailPage',
        params: {
          playlistId: 'liked',
          title: '我喜欢的音乐',
          description: '收藏喜欢的音乐，随时回味'
        }
      });
    })
  }

  /**
   * 构建歌单卡片
   */
  @Builder
  PlaylistCardBuilder(playlist: PlaylistInfo) {
    Column() {
      Image(playlist.coverUrl)
        .width('100%')
        .aspectRatio(1)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)

      Text(playlist.name)
        .fontSize(14)
        .fontColor('#000000')
        .margin({ top: 8 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')

      Text(playlist.songCount + '首')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ top: 2 })
        .width('100%')
    }
    .width('47%')
    .margin({ bottom: 16 })
    .onClick(() => {
      console.info('点击歌单:', playlist.name);
    })
  }

  /**
   * 构建动态内容
   */
  @Builder
  DynamicContentBuilder() {
    Column() {
      Text('暂无动态')
        .fontSize(16)
        .fontColor('#888888')
        .margin({ top: 50 })
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 构建播客内容
   */
  @Builder
  PodcastContentBuilder() {
    Column() {
      Text('暂无播客')
        .fontSize(16)
        .fontColor('#888888')
        .margin({ top: 50 })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      // 顶部导航栏
      this.NavBarBuilder()

      // 主内容区
      Scroll() {
        Column() {
          // 头部信息区
          this.ProfileHeaderBuilder()

          // Tab栏
          this.TabBarBuilder()

          // Tab内容
          Column() {
            if (this.currentTab === 0) {
              this.MusicContentBuilder()
            } else if (this.currentTab === 1) {
              this.DynamicContentBuilder()
            } else {
              this.PodcastContentBuilder()
            }
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Auto)

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

/**
 * 歌单信息类
 */
class PlaylistInfo {
  id: string;
  name: string;
  coverUrl: string;
  songCount: number;

  constructor(id: string, name: string, coverUrl: string, songCount: number) {
    this.id = id;
    this.name = name;
    this.coverUrl = coverUrl;
    this.songCount = songCount;
  }
}
