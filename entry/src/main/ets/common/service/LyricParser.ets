import { LyricInfo, LyricLine } from '../bean/LyricInfo';
import http from '@ohos.net.http';

/**
 * 歌词解析服务
 * 支持解析标准LRC格式歌词
 */
export class LyricParser {
  /**
   * 解析LRC格式歌词
   * LRC格式示例：
   * [ti:歌曲名]
   * [ar:歌手名]
   * [al:专辑名]
   * [00:00.00]第一行歌词
   * [00:05.50]第二行歌词
   */
  static parse(lrcContent: string): LyricInfo {
    const lyricInfo = new LyricInfo();
    lyricInfo.rawLyric = lrcContent;

    if (!lrcContent || lrcContent.trim().length === 0) {
      return lyricInfo;
    }

    const lines = lrcContent.split('\n');
    const lyricLines: LyricLine[] = [];

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const trimmedLine = line.trim();
      if (trimmedLine.length === 0) {
        continue;
      }

      // 跳过元数据行（如 [ti:xxx]、[ar:xxx] 等）
      if (trimmedLine.startsWith('[ti:') ||
          trimmedLine.startsWith('[ar:') ||
          trimmedLine.startsWith('[al:') ||
          trimmedLine.startsWith('[by:') ||
          trimmedLine.startsWith('[offset:')) {
        continue;
      }

      // 解析时间标签和歌词文本
      // 格式：[mm:ss.xx]歌词文本 或 [mm:ss:xx]歌词文本
      const timeTagRegex = /\[(\d+):(\d+)(?:[.:](\d+))?\]/g;
      let match: RegExpExecArray | null = timeTagRegex.exec(trimmedLine);
      const timeTags: number[] = [];
      let lastIndex = 0;

      while (match !== null) {
        const minutes = parseInt(match[1]);
        const seconds = parseInt(match[2]);
        const milliseconds = match[3] ? parseInt(match[3].padEnd(3, '0').substring(0, 3)) : 0;

        const time = minutes * 60 * 1000 + seconds * 1000 + milliseconds;
        timeTags.push(time);
        lastIndex = match.index + match[0].length;
        match = timeTagRegex.exec(trimmedLine);
      }

      // 提取歌词文本
      const text = trimmedLine.substring(lastIndex).trim();

      if (timeTags.length > 0 && text.length > 0) {
        for (let j = 0; j < timeTags.length; j++) {
          lyricLines.push(new LyricLine(timeTags[j], text));
        }
      }
    }

    // 按时间排序
    lyricLines.sort((a, b) => a.time - b.time);
    lyricInfo.lines = lyricLines;

    return lyricInfo;
  }

  /**
   * 解析带翻译的歌词
   * @param lrcContent 原始歌词
   * @param translationContent 翻译歌词
   */
  static parseWithTranslation(lrcContent: string, translationContent: string): LyricInfo {
    const lyricInfo = LyricParser.parse(lrcContent);
    lyricInfo.rawTranslation = translationContent;

    if (!translationContent || translationContent.trim().length === 0) {
      return lyricInfo;
    }

    // 解析翻译歌词
    const translationLines = LyricParser.parse(translationContent).lines;

    // 匹配翻译到原歌词
    for (let i = 0; i < lyricInfo.lines.length; i++) {
      const line = lyricInfo.lines[i];
      for (let j = 0; j < translationLines.length; j++) {
        const t = translationLines[j];
        if (Math.abs(t.time - line.time) < 100) {
          line.translation = t.text;
          break;
        }
      }
    }

    return lyricInfo;
  }

  /**
   * 从URL加载歌词（异步）
   */
  static async loadFromUrl(url: string): Promise<LyricInfo> {
    return new Promise<LyricInfo>((resolve, reject) => {
      const httpRequest = http.createHttp();
      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 10000,
        readTimeout: 10000
      }, (err, response) => {
        if (err) {
          console.error('Failed to load lyric:', err);
          resolve(new LyricInfo());
          return;
        }
        if (response.responseCode !== http.ResponseCode.OK) {
          console.error('Failed to load lyric:', response.responseCode);
          resolve(new LyricInfo());
          return;
        }
        const content = response.result as string;
        resolve(LyricParser.parse(content));
        httpRequest.destroy();
      });
    });
  }
}
