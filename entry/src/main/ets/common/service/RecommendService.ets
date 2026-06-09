import { SongInfo } from '../bean/SongInfo';
import { HotSongsData } from '../constants/HotSongsData';
import { PlayerService } from './PlayerService';

/**
 * 带分数的歌曲
 */
interface ScoredSong {
  song: SongInfo;
  score: number;
}

/**
 * 个性化推荐服务
 * 基于用户行为（播放历史、收藏）进行歌曲推荐
 */
export class RecommendService {
  private static instance: RecommendService;
  private playerService: PlayerService = PlayerService.getInstance();

  // 权重配置
  private readonly PLAY_HISTORY_WEIGHT: number = 0.40;  // 播放历史权重 40%
  private readonly LIKED_WEIGHT: number = 0.30;         // 收藏权重 30%
  private readonly POPULARITY_WEIGHT: number = 0.20;    // 热度权重 20%
  private readonly RANDOM_WEIGHT: number = 0.10;        // 随机权重 10%

  private constructor() {}

  static getInstance(): RecommendService {
    if (!RecommendService.instance) {
      RecommendService.instance = new RecommendService();
    }
    return RecommendService.instance;
  }

  /**
   * 获取个性化推荐歌曲
   * @param count 推荐数量
   * @returns 推荐歌曲列表
   */
  getRecommendedSongs(count: number = 20): SongInfo[] {
    const allSongs: SongInfo[] = HotSongsData.getHotSongs();
    const playHistory: SongInfo[] = this.getPlayHistory();
    const likedSongs: SongInfo[] = this.playerService.likedSongs;

    // 计算每首歌的推荐分数
    const scoredSongs: ScoredSong[] = [];
    for (let i = 0; i < allSongs.length; i++) {
      const song: SongInfo = allSongs[i];
      const score: number = this.calculateScore(song, playHistory, likedSongs);
      const scoredSong: ScoredSong = { song: song, score: score };
      scoredSongs.push(scoredSong);
    }

    // 按分数排序（高到低）
    scoredSongs.sort((a: ScoredSong, b: ScoredSong) => b.score - a.score);

    // 返回前 count 首
    const result: SongInfo[] = [];
    for (let i = 0; i < count && i < scoredSongs.length; i++) {
      result.push(scoredSongs[i].song);
    }
    return result;
  }

  /**
   * 计算歌曲推荐分数
   */
  private calculateScore(
    song: SongInfo,
    playHistory: SongInfo[],
    likedSongs: SongInfo[]
  ): number {
    let score: number = 0;

    // 1. 播放历史权重 (40%)
    const playHistoryScore: number = this.calculatePlayHistoryScore(song, playHistory);
    score = score + playHistoryScore * this.PLAY_HISTORY_WEIGHT;

    // 2. 收藏权重 (30%)
    const likedScore: number = this.calculateLikedScore(song, likedSongs);
    score = score + likedScore * this.LIKED_WEIGHT;

    // 3. 热度权重 (20%) - 基于歌曲ID的伪热度
    const popularityScore: number = this.calculatePopularityScore(song);
    score = score + popularityScore * this.POPULARITY_WEIGHT;

    // 4. 随机权重 (10%) - 增加多样性
    const randomScore: number = Math.random();
    score = score + randomScore * this.RANDOM_WEIGHT;

    return score;
  }

  /**
   * 计算播放历史分数
   * 如果歌曲与播放历史中的歌曲同歌手，则加分
   */
  private calculatePlayHistoryScore(song: SongInfo, playHistory: SongInfo[]): number {
    if (playHistory.length === 0) {
      return 0.5; // 无播放历史时返回中等分数
    }

    let score: number = 0;
    const artistCount: Map<string, number> = new Map<string, number>();

    // 统计播放历史中各歌手的出现次数
    for (let i = 0; i < playHistory.length; i++) {
      const historySong: SongInfo = playHistory[i];
      const currentCount: number = artistCount.get(historySong.artist) || 0;
      artistCount.set(historySong.artist, currentCount + 1);
    }

    // 如果当前歌曲歌手在播放历史中出现，加分
    const songArtistCount: number = artistCount.get(song.artist) || 0;
    if (songArtistCount > 0) {
      // 出现次数越多，分数越高，最高1.0
      score = Math.min(songArtistCount / playHistory.length * 2, 1.0);
    }

    return score;
  }

  /**
   * 计算收藏分数
   * 如果歌曲与收藏的歌曲同歌手，则加分
   */
  private calculateLikedScore(song: SongInfo, likedSongs: SongInfo[]): number {
    if (likedSongs.length === 0) {
      return 0.5; // 无收藏时返回中等分数
    }

    let score: number = 0;
    const artistCount: Map<string, number> = new Map<string, number>();

    // 统计收藏中各歌手的出现次数
    for (let i = 0; i < likedSongs.length; i++) {
      const likedSong: SongInfo = likedSongs[i];
      const currentCount: number = artistCount.get(likedSong.artist) || 0;
      artistCount.set(likedSong.artist, currentCount + 1);
    }

    // 如果当前歌曲歌手在收藏中出现，加分
    const songArtistCount: number = artistCount.get(song.artist) || 0;
    if (songArtistCount > 0) {
      // 出现次数越多，分数越高，最高1.0
      score = Math.min(songArtistCount / likedSongs.length * 2, 1.0);
    }

    // 如果歌曲本身已被收藏，给予最高分
    let isLiked: boolean = false;
    for (let i = 0; i < likedSongs.length; i++) {
      if (likedSongs[i].id === song.id) {
        isLiked = true;
        break;
      }
    }
    if (isLiked) {
      score = 1.0;
    }

    return score;
  }

  /**
   * 计算热度分数
   * 基于歌曲ID的伪热度（ID越小表示越热门）
   */
  private calculatePopularityScore(song: SongInfo): number {
    // 解析ID，提取数字部分
    const idNumber: number = parseInt(song.id.replace(/\D/g, ''));
    
    // ID越小，热度越高（分数越高）
    // 假设ID范围是1-1000，归一化到0-1
    const maxId: number = 1005;
    const score: number = 1 - (idNumber / maxId);
    
    return Math.max(0, Math.min(1, score));
  }

  /**
   * 获取播放历史
   * 从PlayerService获取当前播放列表作为播放历史
   */
  private getPlayHistory(): SongInfo[] {
    // 使用当前播放列表作为播放历史
    return this.playerService.playList;
  }

  /**
   * 获取相似歌曲
   * 基于歌手和专辑推荐相似歌曲
   */
  getSimilarSongs(song: SongInfo, count: number = 5): SongInfo[] {
    const allSongs: SongInfo[] = HotSongsData.getHotSongs();
    
    // 过滤掉当前歌曲
    const otherSongs: SongInfo[] = [];
    for (let i = 0; i < allSongs.length; i++) {
      if (allSongs[i].id !== song.id) {
        otherSongs.push(allSongs[i]);
      }
    }
    
    // 计算相似度分数
    const scoredSongs: ScoredSong[] = [];
    for (let i = 0; i < otherSongs.length; i++) {
      const s: SongInfo = otherSongs[i];
      let score: number = 0;
      
      // 同歌手加分
      if (s.artist === song.artist) {
        score = score + 0.6;
      }
      
      // 同专辑加分
      if (s.album === song.album) {
        score = score + 0.4;
      }
      
      // 随机因素
      score = score + Math.random() * 0.2;
      
      const scoredSong: ScoredSong = { song: s, score: score };
      scoredSongs.push(scoredSong);
    }

    // 按分数排序
    scoredSongs.sort((a: ScoredSong, b: ScoredSong) => b.score - a.score);
    
    // 返回前 count 首
    const result: SongInfo[] = [];
    for (let i = 0; i < count && i < scoredSongs.length; i++) {
      result.push(scoredSongs[i].song);
    }
    return result;
  }

  /**
   * 获取每日推荐
   * 基于日期生成固定的推荐列表
   */
  getDailyRecommend(count: number = 10): SongInfo[] {
    const allSongs: SongInfo[] = HotSongsData.getHotSongs();
    const today: Date = new Date();
    const dayOfYear: number = this.getDayOfYear(today);
    
    // 使用日期作为随机种子，确保同一天推荐相同
    const seed: number = dayOfYear;
    
    // 基于种子打乱歌曲顺序
    const shuffled: SongInfo[] = this.shuffleWithSeed(allSongs, seed);
    
    // 返回前 count 首
    const result: SongInfo[] = [];
    for (let i = 0; i < count && i < shuffled.length; i++) {
      result.push(shuffled[i]);
    }
    return result;
  }

  /**
   * 获取一年中的第几天
   */
  private getDayOfYear(date: Date): number {
    const start: Date = new Date(date.getFullYear(), 0, 0);
    const diff: number = date.getTime() - start.getTime();
    const oneDay: number = 1000 * 60 * 60 * 24;
    return Math.floor(diff / oneDay);
  }

  /**
   * 使用种子打乱数组（伪随机）
   */
  private shuffleWithSeed(array: SongInfo[], seed: number): SongInfo[] {
    const result: SongInfo[] = [];
    for (let i = 0; i < array.length; i++) {
      result.push(array[i]);
    }
    let currentSeed: number = seed;
    
    // 简单的伪随机数生成器
    const random = (): number => {
      currentSeed = (currentSeed * 9301 + 49297) % 233280;
      return currentSeed / 233280;
    };
    
    // Fisher-Yates 洗牌算法
    for (let i = result.length - 1; i > 0; i--) {
      const j: number = Math.floor(random() * (i + 1));
      const temp: SongInfo = result[i];
      result[i] = result[j];
      result[j] = temp;
    }
    
    return result;
  }
}
