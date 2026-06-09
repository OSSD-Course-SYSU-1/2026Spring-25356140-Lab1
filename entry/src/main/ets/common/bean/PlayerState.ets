/**
 * 播放器状态枚举
 */
export enum PlayState {
  /**
   * 空闲状态（无歌曲）
   */
  IDLE = 'idle',

  /**
   * 播放中
   */
  PLAYING = 'playing',

  /**
   * 暂停
   */
  PAUSED = 'paused',

  /**
   * 停止
   */
  STOPPED = 'stopped'
}

/**
 * 播放模式枚举
 */
export enum PlayMode {
  /**
   * 列表循环
   */
  LIST_LOOP = 'list_loop',

  /**
   * 单曲循环
   */
  SINGLE_LOOP = 'single_loop',

  /**
   * 随机播放
   */
  SHUFFLE = 'shuffle'
}
