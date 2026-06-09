import router from '@ohos.router';

/**
 * 手势返回组件
 * 从屏幕左侧1/4区域右滑返回上级界面
 * 使用方法：在页面的最外层包裹此组件
 */
@Component
export struct GestureBack {
  @BuilderParam
  contentBuilder: () => void;

  // 手势状态
  @State private startX: number = 0;
  @State private startY: number = 0;
  @State private isInBackZone: boolean = false;

  // 左侧触发区域宽度（屏幕宽度的1/4）
  private readonly BACK_ZONE_WIDTH: number = 80; // 约1/4屏幕宽度
  // 最小滑动距离
  private readonly MIN_SWIPE_DISTANCE: number = 50;
  // 最大垂直偏移
  private readonly MAX_VERTICAL_OFFSET: number = 100;

  build() {
    Stack() {
      // 页面内容
      this.contentBuilder()

      // 左侧手势区域（透明）
      Column()
        .width(this.BACK_ZONE_WIDTH)
        .height('100%')
        .position({ x: 0, y: 0 })
        .backgroundColor('transparent')
        .gesture(
          PanGesture({ direction: PanDirection.Right })
            .onActionStart((event: GestureEvent) => {
              this.startX = event.fingerList[0].localX;
              this.startY = event.fingerList[0].localY;
              this.isInBackZone = true;
            })
            .onActionUpdate((event: GestureEvent) => {
              if (!this.isInBackZone) {
                return;
              }

              const currentX: number = event.fingerList[0].localX;
              const currentY: number = event.fingerList[0].localY;
              const deltaX: number = currentX - this.startX;
              const deltaY: number = Math.abs(currentY - this.startY);

              // 如果垂直偏移太大，取消返回
              if (deltaY > this.MAX_VERTICAL_OFFSET) {
                this.isInBackZone = false;
                return;
              }

              // 如果水平滑动距离足够，执行返回
              if (deltaX > this.MIN_SWIPE_DISTANCE) {
                this.isInBackZone = false;
                // 检查是否可以返回
                try {
                  const pages: router.RouterState = router.getState();
                  if (pages.index > 0) {
                    router.back();
                  }
                } catch (e) {
                  console.error('返回失败:', e);
                }
              }
            })
            .onActionEnd(() => {
              this.isInBackZone = false;
            })
        )
    }
    .width('100%')
    .height('100%')
  }
}
