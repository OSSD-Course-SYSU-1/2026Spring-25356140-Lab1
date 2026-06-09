import { SongInfo } from '../bean/SongInfo';

/**
 * 测试数据 - 用于开发和测试播放器功能
 */
export class TestData {
  /**
   * 获取测试歌曲列表
   */
  static getTestSongs(): SongInfo[] {
    const songs: SongInfo[] = [
      new SongInfo(
        '1',
        '起风了',
        '买辣椒也用券',
        '起风了',
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop',
        // 使用可靠的测试音频 - 公共测试音频
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        325000
      ),
      new SongInfo(
        '2',
        '晴天',
        '周杰伦',
        '叶惠美',
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop',
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        269000
      ),
      new SongInfo(
        '3',
        '七里香',
        '周杰伦',
        '七里香',
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop',
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        300000
      )
    ];
    return songs;
  }

  /**
   * 获取第一首测试歌曲
   */
  static getFirstTestSong(): SongInfo {
    const songs = TestData.getTestSongs();
    return songs[0];
  }
}
