/**
 * 歌曲信息数据模型
 */
export class SongInfo {
  /**
   * 歌曲ID
   */
  id: string = '';

  /**
   * 歌曲名称
   */
  name: string = '';

  /**
   * 歌手名称
   */
  artist: string = '';

  /**
   * 专辑名称
   */
  album: string = '';

  /**
   * 歌曲封面图片URL
   */
  coverUrl: string = '';

  /**
   * 歌曲播放URL
   */
  playUrl: string = '';

  /**
   * 歌曲时长（毫秒）
   */
  duration: number = 0;

  /**
   * 歌词URL
   */
  lyricUrl: string = '';

  /**
   * 翻译歌词URL
   */
  translationUrl: string = '';

  constructor(id: string, name: string, artist: string, album: string,
              coverUrl: string, playUrl: string, duration: number,
              lyricUrl: string = '', translationUrl: string = '') {
    this.id = id;
    this.name = name;
    this.artist = artist;
    this.album = album;
    this.coverUrl = coverUrl;
    this.playUrl = playUrl;
    this.duration = duration;
    this.lyricUrl = lyricUrl;
    this.translationUrl = translationUrl;
  }
}
