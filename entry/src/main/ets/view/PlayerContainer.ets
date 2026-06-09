import { MiniPlayer } from './MiniPlayer';

/**
 * 全局播放器容器
 * 包裹页面内容，底部固定显示 MiniPlayer
 * 用法：在所有 @Entry 页面的 build() 中，将内容放入此容器
 */
@Component
export struct PlayerContainer {
  @BuilderParam
  contentBuilder: () => void;

  build() {
    Column() {
      // 页面内容区域
      Column() {
        this.contentBuilder()
      }
      .width('100%')
      .layoutWeight(1)

      // 底部迷你播放栏 - 始终显示
      MiniPlayer()
    }
    .width('100%')
    .height('100%')
  }
}
