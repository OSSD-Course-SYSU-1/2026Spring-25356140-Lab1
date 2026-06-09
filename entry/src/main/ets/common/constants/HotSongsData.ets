import { SongInfo } from '../bean/SongInfo';

/**
 * 热门歌曲数据 - 50首主流歌手热门歌曲
 * 仅包含歌曲信息，无音频URL（用于展示和推荐）
 */
export class HotSongsData {
  /**
   * 获取50首热门歌曲
   */
  static getHotSongs(): SongInfo[] {
    const songs: SongInfo[] = [
      // 周杰伦
      new SongInfo('101', '晴天', '周杰伦', '叶惠美', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG_3.jpg', '', 269000),
      new SongInfo('102', '七里香', '周杰伦', '七里香', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192x5y_3.jpg', '', 300000),
      new SongInfo('103', '稻香', '周杰伦', '魔杰座', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Neh8l0uciQZ_3.jpg', '', 223000),
      new SongInfo('104', '夜曲', '周杰伦', '十一月的萧邦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M0000024bjiL2aocxT_3.jpg', '', 226000),
      new SongInfo('105', '告白气球', '周杰伦', '周杰伦的床边故事', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RMaRI1iFoYd_3.jpg', '', 215000),
      
      // 林俊杰
      new SongInfo('201', '江南', '林俊杰', '第二天堂', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000I5BJ32EFqRo_3.jpg', '', 267000),
      new SongInfo('202', '可惜没如果', '林俊杰', '新地球', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001IV22P1RDX7o_3.jpg', '', 298000),
      new SongInfo('203', '修炼爱情', '林俊杰', '因你而在', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003c61612iC0QZ_3.jpg', '', 286000),
      new SongInfo('204', '她说', '林俊杰', '她说', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001CBQA12BjV74_3.jpg', '', 316000),
      new SongInfo('205', '不为谁而作的歌', '林俊杰', '和自己对话', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001mTkmb4GJlh4_3.jpg', '', 325000),
      
      // 陈奕迅
      new SongInfo('301', '十年', '陈奕迅', '黑白灰', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003Z2hNS1Z1Vz8_3.jpg', '', 206000),
      new SongInfo('302', '浮夸', '陈奕迅', 'U87', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003JUsUO1XJ4qV_3.jpg', '', 287000),
      new SongInfo('303', '红玫瑰', '陈奕迅', '认了吧', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 241000),
      new SongInfo('304', '好久不见', '陈奕迅', '认了吧', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 251000),
      new SongInfo('305', '爱情转移', '陈奕迅', '认了吧', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 258000),
      
      // 薛之谦
      new SongInfo('401', '演员', '薛之谦', '初学者', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003y8dsJ2QbqlV_3.jpg', '', 261000),
      new SongInfo('402', '认真的雪', '薛之谦', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Q2A7j2B6yE8_3.jpg', '', 262000),
      new SongInfo('403', '丑八怪', '薛之谦', '意外', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003XrmUf3Ajy4F_3.jpg', '', 253000),
      new SongInfo('404', '刚刚好', '薛之谦', '初学者', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003y8dsJ2QbqlV_3.jpg', '', 241000),
      new SongInfo('405', '绅士', '薛之谦', '绅士', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000004eHs8y0ZAXSp_3.jpg', '', 285000),
      
      // 毛不易
      new SongInfo('501', '消愁', '毛不易', '平凡的一天', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000QgJmW4J7I7o_3.jpg', '', 262000),
      new SongInfo('502', '像我这样的人', '毛不易', '平凡的一天', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000QgJmW4J7I7o_3.jpg', '', 203000),
      new SongInfo('503', '平凡的一天', '毛不易', '平凡的一天', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000000QgJmW4J7I7o_3.jpg', '', 251000),
      new SongInfo('504', '借', '毛不易', '借', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 286000),
      new SongInfo('505', '无问', '毛不易', '无问', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 278000),
      
      // 邓紫棋
      new SongInfo('601', '光年之外', '邓紫棋', '光年之外', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', '', 236000),
      new SongInfo('602', '倒数', '邓紫棋', '另一个童话', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000004Fimy419OEAU_3.jpg', '', 229000),
      new SongInfo('603', '来自天堂的魔鬼', '邓紫棋', '新的心跳', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', '', 256000),
      new SongInfo('604', '泡沫', '邓紫棋', 'Xposed', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', '', 258000),
      new SongInfo('605', '画', '邓紫棋', '画', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003RxTdZ0s4m5O_3.jpg', '', 203000),
      
      // 李荣浩
      new SongInfo('701', '年少有为', '李荣浩', '耳朵', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000004QnEHc3WV8yT_3.jpg', '', 262000),
      new SongInfo('702', '不将就', '李荣浩', '有理想', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001Z0J7l09Jxvq_3.jpg', '', 309000),
      new SongInfo('703', '戒烟', '李荣浩', '嗯', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001x69pN0yL9X4_3.jpg', '', 276000),
      new SongInfo('704', '模特', '李荣浩', '模特', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 256000),
      new SongInfo('705', '爸爸妈妈', '李荣浩', '有理想', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000001Z0J7l09Jxvq_3.jpg', '', 262000),
      
      // 张杰
      new SongInfo('801', '逆战', '张杰', 'One Chance', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 232000),
      new SongInfo('802', '这就是爱', '张杰', '这，就是爱', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 291000),
      new SongInfo('803', '他不懂', '张杰', '爱，不解释', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 237000),
      new SongInfo('804', '天下', '张杰', '明天过后', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 231000),
      new SongInfo('805', '最美的太阳', '张杰', '最美的太阳', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000003bSL0v4bpC0l_3.jpg', '', 238000),
      
      // 许嵩
      new SongInfo('901', '有何不可', '许嵩', '自定义', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 241000),
      new SongInfo('902', '雅俗共赏', '许嵩', '青年晚报', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 249000),
      new SongInfo('903', '惊鸿一面', '许嵩', '不如吃茶去', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 257000),
      new SongInfo('904', '素颜', '许嵩', '寻雾启示', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 239000),
      new SongInfo('905', '千百度', '许嵩', '苏格拉没有底', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 236000),
      
      // 汪苏泷
      new SongInfo('1001', '有点甜', '汪苏泷', '万有引力', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 237000),
      new SongInfo('1002', '不分手的恋爱', '汪苏泷', '好安静', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 213000),
      new SongInfo('1003', '一笑倾城', '汪苏泷', '一笑倾城', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 236000),
      new SongInfo('1004', '年轮', '汪苏泷', '花千骨电视剧原声带', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 263000),
      new SongInfo('1005', '小星星', '汪苏泷', '慢慢懂', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000002BWGhe1l7zVP_3.jpg', '', 182000),
    ];
    return songs;
  }

  /**
   * 获取热门歌手列表
   */
  static getHotArtists(): ArtistInfo[] {
    return [
      new ArtistInfo('1', '周杰伦', 'https://y.gtimg.cn/music/photo_new/T001R300x300M0000025NhlN2YWrP8_3.jpg'),
      new ArtistInfo('2', '林俊杰', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000001BLpXF2DyJe2_3.jpg'),
      new ArtistInfo('3', '陈奕迅', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000003Nz2So3XXYek_3.jpg'),
      new ArtistInfo('4', '薛之谦', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000002J4UUk29y8BY_3.jpg'),
      new ArtistInfo('5', '毛不易', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000003AfDK34H82GU_3.jpg'),
      new ArtistInfo('6', '邓紫棋', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000001fNHEf1SFqVy_3.jpg'),
      new ArtistInfo('7', '李荣浩', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000002azErJ0U8zd4_3.jpg'),
      new ArtistInfo('8', '张杰', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000002azErJ0U8zd4_3.jpg'),
      new ArtistInfo('9', '许嵩', 'https://y.gtimg.cn/music/photo_new/T001R300x300M00000235pCx2tY6gm_3.jpg'),
      new ArtistInfo('10', '汪苏泷', 'https://y.gtimg.cn/music/photo_new/T001R300x300M000001z2Rxn1wPnzO_3.jpg'),
    ];
  }

  /**
   * 获取推荐歌单
   */
  static getRecommendedPlaylists(): PlaylistInfo[] {
    return [
      new PlaylistInfo('1', '华语流行经典', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 50),
      new PlaylistInfo('2', '深夜emo专用', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 32),
      new PlaylistInfo('3', '运动节奏控', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 28),
      new PlaylistInfo('4', '学习专注BGM', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 45),
      new PlaylistInfo('5', '开车必听', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 36),
      new PlaylistInfo('6', 'KTV必点金曲', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', 52),
    ];
  }

  /**
   * 获取Banner数据
   */
  static getBanners(): BannerInfo[] {
    return [
      new BannerInfo('1', '每日推荐', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=350&h=145&fit=crop', 'pages/DailyRecommendPage'),
      new BannerInfo('2', '新歌首发', 'https://images.unsplash.com/photo-1459749411177-047381bb3ece?w=350&h=145&fit=crop', ''),
      new BannerInfo('3', '精选歌单', 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=350&h=145&fit=crop', ''),
      new BannerInfo('4', '热门歌手', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=350&h=145&fit=crop', ''),
      new BannerInfo('5', '独家专访', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=350&h=145&fit=crop', ''),
    ];
  }
}

/**
 * 歌手信息
 */
export class ArtistInfo {
  id: string;
  name: string;
  avatarUrl: string;

  constructor(id: string, name: string, avatarUrl: string) {
    this.id = id;
    this.name = name;
    this.avatarUrl = avatarUrl;
  }
}

/**
 * 歌单信息
 */
export class PlaylistInfo {
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

/**
 * Banner信息
 */
export class BannerInfo {
  id: string;
  title: string;
  imageUrl: string;
  targetPage: string;

  constructor(id: string, title: string, imageUrl: string, targetPage: string) {
    this.id = id;
    this.title = title;
    this.imageUrl = imageUrl;
    this.targetPage = targetPage;
  }
}
