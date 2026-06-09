import router from '@ohos.router';
import { CommonConstants } from '../common/constants/CommonConstants';
import { DetailListComponent } from '../view/DetailListComponent';
import { MiniPlayer } from '../view/MiniPlayer';
import { RecommendView } from '../view/RecommendView';
import { YuncunView } from '../view/YuncunView';
import { PlayerService } from '../common/service/PlayerService';
import { TestData } from '../common/constants/TestData';

/**
 * Detail page to display more information.
 */
@Entry
@Component
struct IndexPage {
  private titleParam: Resource = $r('app.string.detail_default_title');
  private controller: TabsController = new TabsController()
  private swiperController: SwiperController = new SwiperController()
  @State currentIndex: number = 0
  private playerService: PlayerService = PlayerService.getInstance();

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (params && params[CommonConstants.KEY_PARAM_DATA]) {
      this.titleParam = params[CommonConstants.KEY_PARAM_DATA] as Resource;
    }
    
    // 初始化播放器和播放列表
    this.initPlayerAndPlaylist();
  }
  
  /**
   * 初始化播放器和播放列表
   */
  private async initPlayerAndPlaylist(): Promise<void> {
    try {
      console.info('IndexPage: Initializing player...');
      console.info('PlayerService instance:', this.playerService);
      await this.playerService.initPlayer();
      console.info('IndexPage: Player initialized');
      
      // 初始化测试播放列表
      const testSongs = TestData.getTestSongs();
      console.info('IndexPage: Test songs:', testSongs.length);
      console.info('IndexPage: First song:', testSongs[0]?.name, testSongs[0]?.playUrl);
      this.playerService.setPlayList(testSongs, 0);
      console.info('IndexPage: Playlist initialized');
    } catch (error) {
      console.error('IndexPage: Initialization failed:', JSON.stringify(error));
      console.error('IndexPage: Error details:', error);
    }
  }

  @Builder TabTextBuilder(text: string,index:number) {
    Text(text)
      .fontSize(this.currentIndex===index?18:16)
      .fontColor(this.currentIndex===index?'#000':'#888')
      .fontWeight(this.currentIndex===index?800:400)
  }

  @Builder TabMyContent(){
    Scroll(){
      Column(){
        // 用户信息入口卡片
        Row() {
          Image('https://y.gtimg.cn/music/photo_new/T001R300x300M000002azErJ0U8zd4_3.jpg')
            .width(56)
            .height(56)
            .borderRadius(28)
            .margin({ right: 12 })

          Column() {
            Text('网易云音乐用户')
              .fontSize(18)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)

            Text('LV.8')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('›')
            .fontSize(24)
            .fontColor('#CCCCCC')
            .margin({ right: 8 })
        }
        .width('100%')
        .height(80)
        .padding({ left: 16, right: 16 })
        .alignItems(VerticalAlign.Center)
        .backgroundColor('#FFFFFF')
        .onClick(() => {
          router.pushUrl({
            url: CommonConstants.PROFILE_PAGE
          });
        })

        // 测试播放按钮
        Row() {
          Button('播放测试歌曲')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF0000')
            .borderRadius(20)
            .width(200)
            .height(40)
            .onClick(async () => {
              console.info('Button clicked: Play test song');
              console.info('Current player service:', this.playerService);
              try {
                const testSong = TestData.getFirstTestSong();
                console.info('Test song:', testSong.name, testSong.artist);
                console.info('Play URL:', testSong.playUrl);
                console.info('Song object:', JSON.stringify(testSong));
                await this.playerService.playSong(testSong);
                console.info('playSong called successfully');
              } catch (error) {
                console.error('Button click error:', JSON.stringify(error));
                console.error('Button click error details:', error);
              }
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20, bottom: 20 })
        
        Row() {
          // 私人FM
          Column(){
            Image($r('app.media.my_nav_icon1'))
              .width(38)
              .height(38)
              .margin({bottom:9})
            Text('私人FM').fontSize(12).fontColor('#000')
          }
          .width('20%')
          .height(70)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5')
          .borderRadius(8)
          .onClick(() => {
            console.info('点击私人FM按钮');
            router.pushUrl({
              url: 'pages/PrivateFMPage'
            }).catch((err: Error) => {
              console.error('跳转私人FM失败:', err.message);
            });
          })

          // 心动模式
          Column(){
            Image($r('app.media.my_nav_icon1'))
              .width(38)
              .height(38)
              .margin({bottom:9})
            Text('心动模式').fontSize(12).fontColor('#000')
          }
          .width('20%')
          .height(70)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5')
          .borderRadius(8)
          .onClick(() => {
            console.info('点击心动模式按钮');
            router.pushUrl({
              url: 'pages/HeartModePage'
            }).catch((err: Error) => {
              console.error('跳转心动模式失败:', err.message);
            });
          })

          // 私人电台
          Column(){
            Image($r('app.media.my_nav_icon1'))
              .width(38)
              .height(38)
              .margin({bottom:9})
            Text('私人电台').fontSize(12).fontColor('#000')
          }
          .width('20%')
          .height(70)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5')
          .borderRadius(8)
          .onClick(() => {
            console.info('点击私人电台按钮');
            router.pushUrl({
              url: 'pages/PrivateRadioPage'
            }).catch((err: Error) => {
              console.error('跳转私人电台失败:', err.message);
            });
          })

          // 跑步FM
          Column(){
            Image($r('app.media.my_nav_icon1'))
              .width(38)
              .height(38)
              .margin({bottom:9})
            Text('跑步FM').fontSize(12).fontColor('#000')
          }
          .width('20%')
          .height(70)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#FFF5F5')
          .borderRadius(8)
          .onClick(() => {
            console.info('点击跑步FM按钮');
            router.pushUrl({
              url: 'pages/RunningFMPage'
            }).catch((err: Error) => {
              console.error('跳转跑步FM失败:', err.message);
            });
          })

          // 睡眠模式
          Column(){
            Image($r('app.media.my_nav_icon1'))
              .width(38)
              .height(38)
              .margin({bottom:9})
            Text('睡眠模式').fontSize(12).fontColor('#000')
          }
          .width('20%')
          .height(70)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#E8F4FD')
          .borderRadius(8)
          .onClick(() => {
            console.info('点击睡眠模式按钮');
            router.pushUrl({
              url: 'pages/SleepModePage'
            }).catch((err: Error) => {
              console.error('跳转睡眠模式失败:', err.message);
            });
          })
        }
        .width('100%')
        .height(86)
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(VerticalAlign.Center)
        .backgroundColor('#FFFFFF')
        Column(){
          Row(){
            Image($r('app.media.music_icon'))
              .width(21)
              .height(25)
            Text('本地音乐')
              .fontSize(16)
              .fontColor('#000')
              .margin({left:8})
          }
          .width('100%')
          .height(47)
          .alignItems(VerticalAlign.Center)
          .border({width:{bottom:1},color:'#dcdcdc',})
          .padding({left:13})
          .onClick(() => {
            router.pushUrl({ url: 'pages/LocalMusicPage' });
          })

          Row(){
            Image($r('app.media.music_icon'))
              .width(21)
              .height(25)
            Text('最近播放')
              .fontSize(16)
              .fontColor('#000')
              .margin({left:8})
          }
          .width('100%')
          .height(47)
          .alignItems(VerticalAlign.Center)
          .border({width:{bottom:1},color:'#dcdcdc',})
          .padding({left:13})
          .onClick(() => {
            router.pushUrl({ url: 'pages/RecentPlayPage' });
          })

          Row(){
            Image($r('app.media.music_icon'))
              .width(21)
              .height(25)
            Text('下载管理')
              .fontSize(16)
              .fontColor('#000')
              .margin({left:8})
          }
          .width('100%')
          .height(47)
          .alignItems(VerticalAlign.Center)
          .border({width:{bottom:1},color:'#dcdcdc',})
          .padding({left:13})
          .onClick(() => {
            router.pushUrl({ url: 'pages/DownloadPage' });
          })

          Row(){
            Image($r('app.media.music_icon'))
              .width(21)
              .height(25)
            Text('我的电台')
              .fontSize(16)
              .fontColor('#000')
              .margin({left:8})
          }
          .width('100%')
          .height(47)
          .alignItems(VerticalAlign.Center)
          .border({width:{bottom:1},color:'#dcdcdc',})
          .padding({left:13})
          .onClick(() => {
            router.pushUrl({ url: 'pages/MyRadioListPage' });
          })

          Row(){
            Image($r('app.media.music_icon'))
              .width(21)
              .height(25)
            Text('我的收藏')
              .fontSize(16)
              .fontColor('#000')
              .margin({left:8})
          }
          .width('100%')
          .height(47)
          .alignItems(VerticalAlign.Center)
          .border({width:{bottom:1},color:'#dcdcdc',})
          .padding({left:13})
          .onClick(() => {
            router.pushUrl({ url: 'pages/MyCollectionPage' });
          })
        }
        Divider()
        .strokeWidth(9)
        .color('#dcdcdc')
        Column(){
          Text('创建的歌单')
            .fontSize(16)
            .fontColor('#000')
            .fontWeight(800)
            .margin({bottom:4})
          Row(){
            Image('https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=56&h=56&fit=crop')
              .width(56)
              .height(56)
              .margin({right:12})
            Column(){
              Text('linwu-hi喜欢的音乐')
                .fontSize(14)
                .fontColor('#000')
              Text('14首')
                .fontSize(12)
                .fontColor('#666')
                .margin({top:4})
            }
            .alignItems(HorizontalAlign.Start)
          }
        }
        .width('100%')
        .padding({left:13,top:6})
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
    }
  }

  build() {
    Column() {
      Stack() {
        Tabs({index:this.currentIndex,controller: this.controller }) {
          TabContent() {
             this.TabMyContent()
          }
          .tabBar(this.TabTextBuilder('我的',0))
          .align(Alignment.TopStart)

          TabContent() {
            YuncunView()
          }
          .tabBar(this.TabTextBuilder('云村',1))

          TabContent() {
            RecommendView()
          }
          .tabBar(this.TabTextBuilder('推荐',2))

          TabContent() {
            Scroll(){
              Column(){
                Swiper(this.swiperController) {
                  Image('https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=349&h=145&fit=crop')
                    .width(349)
                    .height(145)
                  Image('https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=349&h=145&fit=crop')
                    .width(349)
                    .height(145)
                  Image('https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=349&h=145&fit=crop')
                    .width(349)
                    .height(145)
                }
                .width(349)
                .height(145)
                .loop(true)
                .autoPlay(true)
                Flex({ direction: FlexDirection.Row,justifyContent:FlexAlign.SpaceAround,alignItems:ItemAlign.Center }){
                  Column(){
                    Image($r('app.media.nav_icon1'))
                      .width(43)
                      .height(43)
                      .margin({bottom:9})
                    Text('每日推荐').fontSize(12).fontColor('#000')
                  }
                  Column(){
                    Image($r('app.media.nav_icon1'))
                      .width(43)
                      .height(43)
                      .margin({bottom:9})
                    Text('歌单').fontSize(12).fontColor('#000')
                  }
                  Column(){
                    Image($r('app.media.nav_icon1'))
                      .width(43)
                      .height(43)
                      .margin({bottom:9})
                    Text('排行榜').fontSize(12).fontColor('#000')
                  }
                  Column(){
                    Image($r('app.media.nav_icon1'))
                      .width(43)
                      .height(43)
                      .margin({bottom:9})
                    Text('电台').fontSize(12).fontColor('#000')
                  }
                }
                .height(98)
                .margin({top:9})
                Column(){
                  Flex({ direction: FlexDirection.Row,justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center }){
                    Text('推荐歌单')
                      .fontSize(16)
                      .fontColor('#000')
                      .fontWeight(800)
                    Text('歌单广场')
                      .padding({top:2,right:6,bottom:2,left:2})
                      .border({width:1,color:'#ccc'})
                      .borderRadius(18)
                      .fontSize(10)
                      .fontColor('#000')
                  }
                  .padding({left:9,right:9})
                  Flex({ direction: FlexDirection.Row,wrap:FlexWrap.Wrap,justifyContent:FlexAlign.SpaceAround }){
                    Column(){
                      Image('https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('听一首把自己感动的歌').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('我知道风里有诗，那正是民谣的歌').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('[国电新势力] 网易电子音乐人精选').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('听一首把自己感动的歌').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('我知道风里有诗，那正是民谣的歌').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('[国电新势力] 网易电子音乐人精选').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                  }
                  .margin({top:13})
                }

                Column(){
                  Flex({ direction: FlexDirection.Row,justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center }){
                    Text('新碟')
                      .fontSize(16)
                      .fontColor('#000')
                      .fontWeight(800)
                    Text('更多新碟')
                      .padding({top:2,right:6,bottom:2,left:2})
                      .border({width:1,color:'#ccc'})
                      .borderRadius(18)
                      .fontSize(10)
                      .fontColor('#000')
                  }
                  .padding({left:9,right:9})
                  Flex({ direction: FlexDirection.Row,wrap:FlexWrap.Wrap,justifyContent:FlexAlign.SpaceAround }){
                    Column(){
                      Image('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('暗流').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('도화').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                    Column(){
                      Image('https://images.unsplash.com/photo-1447752875204-b2f9798c641c?w=107&h=107&fit=crop')
                        .width(107)
                        .margin({bottom:4})
                      Text('Practice Make Perfect').fontSize(12).fontColor('#000')
                    }
                    .width(107)
                    .margin({bottom:13})
                  }
                  .margin({top:13})
                }

                Column(){
                  Flex({ direction: FlexDirection.Row,justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center }){
                    Text('最新MV')
                      .fontSize(16)
                      .fontColor('#000')
                      .fontWeight(800)
                    Text('查看更多')
                      .padding({top:2,right:6,bottom:2,left:2})
                      .border({width:1,color:'#ccc'})
                      .borderRadius(18)
                      .fontSize(10)
                      .fontColor('#000')
                  }
                  .padding({left:9,right:9})
                  Column(){
                    Image('https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=337&h=213&fit=crop')
                      .width(337)
                      .height(213)
                      .margin({top:9,bottom:4})
                      .borderRadius(12)
                    Text('덤더럼(Dumhdurum)')
                      .fontSize(16)
                      .fontColor('#000')
                      .fontWeight(800)
                      .height(42)
                      .margin({left:12})
                  }
                  .borderRadius({topLeft:12,topRight:12})
                  .backgroundColor('#efefef')
                  .alignItems(HorizontalAlign.Start)
                  .width(337)
                  .margin({bottom:13})
                  Flex({ direction: FlexDirection.Row,justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center }){
                    Row(){
                      Image($r('app.media.like'))
                        .width(17)
                        .height(20)
                      Text('220000')
                        .fontSize(16)
                        .fontColor('#000')
                        .margin({left:2,right:4})
                      Image($r('app.media.comment'))
                        .width(17)
                        .height(20)
                      Text('320000')
                        .fontSize(16)
                        .fontColor('#000')
                        .margin({left:2})
                    }
                    .alignItems(VerticalAlign.Center)
                    Image($r('app.media.more_menu'))
                      .width(12)
                      .height(14)
                  }
                  .padding({left:20,right:20})
                }
              }
            }
          }
          .height('100%')
          .tabBar(this.TabTextBuilder('发现',3))
        }
        .onChange((index:number)=>{
          this.currentIndex=index
        })
        .barWidth(286)
        .barHeight(45)
        // .padding({left:32,right:32})
        .width('100%')
        .scrollable(true)
        // .backgroundColor('red')
        
        Image($r("app.media.menu"))
          .width(22)
          .height(22)
          .position({
            x:10,
            y:14
          })
        
        Image($r("app.media.search"))
          .width(22)
          .height(22)
          .position({
            x:328,
            y:14
          })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/SearchPage'
            });
          })
      }
      .width('100%')
      .layoutWeight(1)

      // 底部迷你播放栏
      MiniPlayer()
    }
  }
}