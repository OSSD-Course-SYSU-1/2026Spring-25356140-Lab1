import { LyricInfo, LyricLine } from '../common/bean/LyricInfo';

/**
 * 歌词显示组件
 * 支持滚动显示、当前行高亮、翻译显示
 */
@Component
export struct LyricView {
  /**
   * 歌词数据
   */
  @Prop lyricInfo: LyricInfo = new LyricInfo();

  /**
   * 当前播放时间（毫秒）
   */
  @Prop currentTime: number = 0;

  /**
   * 是否显示翻译
   */
  @Prop showTranslation: boolean = false;

  /**
   * 当前高亮行索引
   */
  @State currentLineIndex: number = -1;

  /**
   * Scroller控制器
   */
  private scroller: Scroller = new Scroller();

  /**
   * 行高（用于滚动计算）
   */
  private lineHeight: number = 50;

  /**
   * 监听时间变化，更新当前行
   */
  aboutToAppear() {
    this.updateCurrentLine();
  }

  /**
   * 时间变化时更新当前行
   */
  private updateCurrentLine() {
    const newIndex = this.lyricInfo.getCurrentLineIndex(this.currentTime);
    if (newIndex !== this.currentLineIndex) {
      this.currentLineIndex = newIndex;
      // 滚动到当前行
      this.scrollToCurrentLine();
    }
  }

  /**
   * 滚动到当前行
   */
  private scrollToCurrentLine() {
    if (this.currentLineIndex >= 0 && this.lyricInfo.lines.length > 0) {
      // 计算滚动位置，使当前行居中
      this.scroller.scrollToIndex(this.currentLineIndex, true, ScrollAlign.CENTER);
    }
  }

  build() {
    if (this.lyricInfo.lines.length === 0) {
      // 无歌词时显示占位
      Column() {
        Text('暂无歌词')
          .fontSize(16)
          .fontColor('#888888')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List({ scroller: this.scroller }) {
        ForEach(this.lyricInfo.lines, (line: LyricLine, index: number) => {
          ListItem() {
            Column() {
              Text(line.text)
                .fontSize(index === this.currentLineIndex ? 18 : 14)
                .fontColor(index === this.currentLineIndex ? '#FF0000' : '#666666')
                .fontWeight(index === this.currentLineIndex ? FontWeight.Bold : FontWeight.Normal)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .textAlign(TextAlign.Center)
                .width('100%')

              // 显示翻译
              if (this.showTranslation && line.translation.length > 0) {
                Text(line.translation)
                  .fontSize(index === this.currentLineIndex ? 14 : 12)
                  .fontColor(index === this.currentLineIndex ? '#FF6666' : '#999999')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .margin({ top: 4 })
              }
            }
            .width('100%')
            .padding({ top: 8, bottom: 8, left: 32, right: 32 })
          }
          .height(this.lineHeight)
        }, (line: LyricLine, index: number) => `${index}_${line.time}`)
      }
      .width('100%')
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
  }
}
