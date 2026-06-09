/**
 * 歌词行数据模型
 */
export class LyricLine {
  /**
   * 时间戳（毫秒）
   */
  time: number = 0;

  /**
   * 歌词文本
   */
  text: string = '';

  /**
   * 翻译文本（可选）
   */
  translation: string = '';

  constructor(time: number, text: string, translation: string = '') {
    this.time = time;
    this.text = text;
    this.translation = translation;
  }
}

/**
 * 歌词数据模型
 */
export class LyricInfo {
  /**
   * 歌词行列表
   */
  lines: LyricLine[] = [];

  /**
   * 歌词来源（原始LRC格式）
   */
  rawLyric: string = '';

  /**
   * 翻译歌词来源（可选）
   */
  rawTranslation: string = '';

  /**
   * 根据时间获取当前歌词行索引
   */
  getCurrentLineIndex(currentTime: number): number {
    if (this.lines.length === 0) {
      return -1;
    }

    // 二分查找当前歌词行
    let left = 0;
    let right = this.lines.length - 1;
    let result = 0;

    while (left <= right) {
      const mid = Math.floor((left + right) / 2);
      if (this.lines[mid].time <= currentTime) {
        result = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return result;
  }

  /**
   * 检查是否有翻译
   */
  hasTranslation(): boolean {
    return this.lines.some(line => line.translation.length > 0);
  }
}
