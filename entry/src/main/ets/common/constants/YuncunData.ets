import { MomentInfo, UserInfo, MomentType, UserType } from '../bean/MomentInfo';
import { SongInfo } from '../bean/SongInfo';
import { HotSongsData } from './HotSongsData';

/**
 * 云村数据 - Mock数据
 */
export class YuncunData {
  // 热门歌曲，用于分享
  private static hotSongs: SongInfo[] = HotSongsData.getHotSongs();

  /**
   * 获取明星用户列表
   */
  static getStarUsers(): UserInfo[] {
    return [
      new UserInfo('star1', '周杰伦', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop', UserType.STAR, false),
      new UserInfo('star2', '林俊杰', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop', UserType.STAR, false),
      new UserInfo('star3', '邓紫棋', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop', UserType.STAR, false),
      new UserInfo('star4', '薛之谦', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop', UserType.STAR, false),
      new UserInfo('star5', '陈奕迅', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop', UserType.STAR, false),
      new UserInfo('official1', '网易云音乐', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop', UserType.OFFICIAL, false),
    ];
  }

  /**
   * 获取普通用户列表（关注的人）
   */
  static getNormalUsers(): UserInfo[] {
    return [
      new UserInfo('user1', '音乐爱好者小王', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop', UserType.NORMAL, true),
      new UserInfo('user2', '深夜听歌人', 'https://images.unsplash.com/photo-1494790108372-be9c29b29330?w=100&h=100&fit=crop', UserType.NORMAL, true),
      new UserInfo('user3', '周杰伦铁粉', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop', UserType.NORMAL, true),
      new UserInfo('user4', '民谣收藏家', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop', UserType.NORMAL, true),
      new UserInfo('user5', '摇滚青年', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop', UserType.NORMAL, true),
    ];
  }

  /**
   * 获取推荐动态（明星+官方）
   */
  static getRecommendMoments(): MomentInfo[] {
    const starUsers: UserInfo[] = YuncunData.getStarUsers();
    const now: number = Date.now();
    const hour: number = 60 * 60 * 1000;
    const day: number = 24 * hour;

    return [
      new MomentInfo(
        'moment1',
        starUsers[0], // 周杰伦
        '新专辑《最伟大的作品》已经上线！大家快去听吧！',
        MomentType.MUSIC,
        YuncunData.hotSongs[0], // 晴天
        [],
        '',
        now - 2 * hour,
        12580,
        3420,
        890,
        false
      ),
      new MomentInfo(
        'moment2',
        starUsers[1], // 林俊杰
        '感谢大家的支持，新歌《愿与愁》已经发布！',
        MomentType.IMAGE,
        YuncunData.hotSongs[5], // 江南
        ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=300&fit=crop'],
        '',
        now - 5 * hour,
        8960,
        2150,
        560,
        false
      ),
      new MomentInfo(
        'moment3',
        starUsers[2], // 邓紫棋
        '演唱会现场太嗨了！谢谢大家！',
        MomentType.IMAGE,
        null,
        [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=300&fit=crop'
        ],
        '',
        now - 8 * hour,
        15230,
        4280,
        1200,
        false
      ),
      new MomentInfo(
        'moment4',
        starUsers[5], // 网易云音乐官方
        '【音乐推荐】本周必听榜单新鲜出炉！',
        MomentType.TEXT,
        null,
        [],
        '',
        now - 12 * hour,
        5680,
        890,
        2300,
        false
      ),
      new MomentInfo(
        'moment5',
        starUsers[3], // 薛之谦
        '新歌《天外来物》MV上线了！',
        MomentType.VIDEO,
        YuncunData.hotSongs[15], // 演员
        [],
        'https://example.com/video1.mp4',
        now - 1 * day,
        23100,
        5680,
        3200,
        false
      ),
      new MomentInfo(
        'moment6',
        starUsers[4], // 陈奕迅
        '今天心情不错，分享一首喜欢的歌',
        MomentType.MUSIC,
        YuncunData.hotSongs[10], // 十年
        [],
        '',
        now - 1.5 * day,
        8920,
        1860,
        680,
        false
      ),
    ];
  }

  /**
   * 获取关注动态（关注的人）
   */
  static getFollowingMoments(): MomentInfo[] {
    const normalUsers: UserInfo[] = YuncunData.getNormalUsers();
    const now: number = Date.now();
    const hour: number = 60 * 60 * 1000;
    const day: number = 24 * hour;

    return [
      new MomentInfo(
        'fmoment1',
        normalUsers[0], // 音乐爱好者小王
        '今天循环了一天的《晴天》，真的太好听了！',
        MomentType.MUSIC,
        YuncunData.hotSongs[0], // 晴天
        [],
        '',
        now - 30 * 60 * 1000, // 30分钟前
        12,
        3,
        0,
        false
      ),
      new MomentInfo(
        'fmoment2',
        normalUsers[1], // 深夜听歌人
        '深夜emo，有没有推荐的歌曲？',
        MomentType.TEXT,
        null,
        [],
        '',
        now - 2 * hour,
        8,
        15,
        0,
        false
      ),
      new MomentInfo(
        'fmoment3',
        normalUsers[2], // 周杰伦铁粉
        '周杰伦yyds！新专辑每首都好听！',
        MomentType.IMAGE,
        YuncunData.hotSongs[2], // 稻香
        ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=300&fit=crop'],
        '',
        now - 4 * hour,
        45,
        8,
        2,
        false
      ),
      new MomentInfo(
        'fmoment4',
        normalUsers[3], // 民谣收藏家
        '分享一首最近很喜欢的民谣',
        MomentType.MUSIC,
        YuncunData.hotSongs[20], // 消愁
        [],
        '',
        now - 6 * hour,
        23,
        5,
        1,
        false
      ),
      new MomentInfo(
        'fmoment5',
        normalUsers[4], // 摇滚青年
        '摇滚不死！🤘',
        MomentType.TEXT,
        null,
        [],
        '',
        now - 8 * hour,
        56,
        12,
        3,
        false
      ),
      new MomentInfo(
        'fmoment6',
        normalUsers[0], // 音乐爱好者小王
        '今天发现了一首宝藏歌曲',
        MomentType.MUSIC,
        YuncunData.hotSongs[25], // 光年之外
        [],
        '',
        now - 12 * hour,
        18,
        4,
        0,
        false
      ),
    ];
  }

  /**
   * 获取所有动态（推荐+关注）
   */
  static getAllMoments(): MomentInfo[] {
    const recommend: MomentInfo[] = YuncunData.getRecommendMoments();
    const following: MomentInfo[] = YuncunData.getFollowingMoments();
    return recommend.concat(following);
  }
}
