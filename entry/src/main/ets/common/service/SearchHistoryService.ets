import { SongInfo } from '../bean/SongInfo';
import { HotSongsData } from '../constants/HotSongsData';

/**
 * 搜索历史服务
 * 管理搜索历史和搜索功能
 */
export class SearchHistoryService {
  private static instance: SearchHistoryService;
  private readonly STORAGE_KEY: string = 'search_history';
  private readonly MAX_HISTORY: number = 10;

  private constructor() {}

  static getInstance(): SearchHistoryService {
    if (!SearchHistoryService.instance) {
      SearchHistoryService.instance = new SearchHistoryService();
    }
    return SearchHistoryService.instance;
  }

  /**
   * 获取搜索历史
   */
  getSearchHistory(): string[] {
    try {
      const historyStr: string = AppStorage.get<string>(this.STORAGE_KEY) || '';
      if (historyStr) {
        return JSON.parse(historyStr) as string[];
      }
    } catch (e) {
      console.error('获取搜索历史失败:', e);
    }
    return [];
  }

  /**
   * 添加搜索历史
   */
  addSearchHistory(keyword: string): void {
    if (!keyword || keyword.trim() === '') {
      return;
    }

    const trimmedKeyword: string = keyword.trim();
    let history: string[] = this.getSearchHistory();

    // 移除已存在的相同关键词
    history = history.filter(item => item !== trimmedKeyword);

    // 添加到开头
    history.unshift(trimmedKeyword);

    // 限制数量
    if (history.length > this.MAX_HISTORY) {
      history = history.slice(0, this.MAX_HISTORY);
    }

    // 保存
    try {
      AppStorage.set<string>(this.STORAGE_KEY, JSON.stringify(history));
    } catch (e) {
      console.error('保存搜索历史失败:', e);
    }
  }

  /**
   * 删除单个搜索历史
   */
  removeSearchHistory(keyword: string): void {
    let history: string[] = this.getSearchHistory();
    history = history.filter(item => item !== keyword);

    try {
      AppStorage.set<string>(this.STORAGE_KEY, JSON.stringify(history));
    } catch (e) {
      console.error('删除搜索历史失败:', e);
    }
  }

  /**
   * 清空搜索历史
   */
  clearSearchHistory(): void {
    try {
      AppStorage.set<string>(this.STORAGE_KEY, JSON.stringify([]));
    } catch (e) {
      console.error('清空搜索历史失败:', e);
    }
  }

  /**
   * 搜索歌曲
   * 支持曲名和歌手名搜索
   */
  searchSongs(keyword: string): SongInfo[] {
    if (!keyword || keyword.trim() === '') {
      return [];
    }

    const trimmedKeyword: string = keyword.trim().toLowerCase();
    const allSongs: SongInfo[] = HotSongsData.getHotSongs();

    const results: SongInfo[] = [];
    for (let i = 0; i < allSongs.length; i++) {
      const song: SongInfo = allSongs[i];
      const songName: string = song.name.toLowerCase();
      const artistName: string = song.artist.toLowerCase();

      // 匹配曲名或歌手名
      if (songName.includes(trimmedKeyword) || artistName.includes(trimmedKeyword)) {
        results.push(song);
      }
    }

    return results;
  }

  /**
   * 获取热门搜索
   */
  getHotSearches(): string[] {
    return [
      '周杰伦',
      '林俊杰',
      '陈奕迅',
      '薛之谦',
      '毛不易',
      '邓紫棋',
      '李荣浩',
      '张杰',
      '许嵩',
      '汪苏泷'
    ];
  }
}
