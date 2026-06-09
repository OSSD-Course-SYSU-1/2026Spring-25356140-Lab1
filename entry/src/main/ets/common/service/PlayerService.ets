import { SongInfo } from '../bean/SongInfo';
import { PlayState, PlayMode } from '../bean/PlayerState';
import { LyricInfo } from '../bean/LyricInfo';
import { LyricParser } from './LyricParser';
import media from '@ohos.multimedia.media';
import promptAction from '@ohos.promptAction';

/**
 * 播放器服务 - 管理播放状态和控制逻辑
 * 使用单例模式确保全局只有一个播放器实例
 */
export class PlayerService {
  private static instance: PlayerService;
  private avPlayer: media.AVPlayer | null = null;
  private isPlayerInitialized: boolean = false;

  // 播放状态
  private _currentSong: SongInfo | null = null;
  private _playState: PlayState = PlayState.IDLE;
  private _currentTime: number = 0; // 当前播放时间（毫秒）
  private _duration: number = 0; // 总时长（毫秒）
  private _playMode: PlayMode = PlayMode.LIST_LOOP;

  // AVPlayer 内部状态跟踪
  private _avPlayerState: string = 'idle';

  // 播放列表
  private _playList: SongInfo[] = [];
  private _currentIndex: number = -1;

  // 歌词
  private _currentLyric: LyricInfo = new LyricInfo();

  // 我喜欢的音乐
  private _likedSongs: SongInfo[] = [];

  // 状态变化回调 - 使用数组支持多监听器
  private onStateChangeListeners: ((state: PlayState) => void)[] = [];
  private onTimeUpdateListeners: ((currentTime: number, duration: number) => void)[] = [];
  private onSongChangeListeners: ((song: SongInfo | null) => void)[] = [];
  private onLyricChangeListeners: ((lyric: LyricInfo) => void)[] = [];
  private onPlayListChangeListeners: ((list: SongInfo[], index: number) => void)[] = [];
  private onLikedSongsChangeListeners: ((songs: SongInfo[]) => void)[] = [];

  private constructor() {
    // 不在构造函数中初始化，改为显式调用
  }

  /**
   * 获取单例实例
   */
  static getInstance(): PlayerService {
    if (!PlayerService.instance) {
      PlayerService.instance = new PlayerService();
    }
    return PlayerService.instance;
  }

  /**
   * 初始化播放器（需要显式调用）
   */
  async initPlayer(): Promise<void> {
    console.info('initPlayer called, isPlayerInitialized:', this.isPlayerInitialized);
    if (this.isPlayerInitialized) {
      console.info('Player already initialized');
      return;
    }
    
    try {
      console.info('Creating AVPlayer...');
      this.avPlayer = await media.createAVPlayer();
      console.info('AVPlayer created successfully, type:', typeof this.avPlayer);
      console.info('AVPlayer object:', this.avPlayer);
      console.info('Setting up listeners...');
      this.setupPlayerListeners();
      this.isPlayerInitialized = true;
      console.info('AVPlayer initialized successfully');
    } catch (error) {
      console.error('Failed to create AVPlayer:', JSON.stringify(error));
      console.error('Error details:', error);
      console.error('Error stack:', error.stack);
      this.isPlayerInitialized = false;
    }
  }

  /**
   * 设置播放器监听器
   */
  private setupPlayerListeners(): void {
    if (!this.avPlayer) {
      console.error('setupPlayerListeners: AVPlayer is null');
      return;
    }

    console.info('setupPlayerListeners: Setting up listeners...');
    
    // 状态变化监听
    this.avPlayer.on('stateChange', (state: string) => {
      console.info(`AVPlayer state changed to: ${state}`);
      this._avPlayerState = state;
      switch (state) {
        case 'playing':
          console.info('AVPlayer state: PLAYING');
          this._playState = PlayState.PLAYING;
          break;
        case 'paused':
          console.info('AVPlayer state: PAUSED');
          this._playState = PlayState.PAUSED;
          break;
        case 'stopped':
          console.info('AVPlayer state: STOPPED');
          this._playState = PlayState.STOPPED;
          break;
        case 'idle':
          console.info('AVPlayer state: IDLE');
          this._playState = PlayState.IDLE;
          break;
        case 'initialized':
          console.info('AVPlayer state: INITIALIZED');
          break;
        case 'prepared':
          console.info('AVPlayer state: PREPARED');
          break;
        case 'preparing':
          console.info('AVPlayer state: PREPARING');
          break;
        case 'error':
          console.error('AVPlayer state: ERROR');
          this._playState = PlayState.IDLE;
          break;
        default:
          console.info(`AVPlayer state: ${state}`);
          break;
      }
      // 通知所有状态变化监听器
      this.notifyStateChange(this._playState);
    });

    // 时间更新监听
    this.avPlayer.on('timeUpdate', (time: number) => {
      console.info(`AVPlayer timeUpdate: ${time}ms`);
      this._currentTime = time;
      // 通知所有时间更新监听器
      this.notifyTimeUpdate(this._currentTime, this._duration);
    });

    // 错误监听
    this.avPlayer.on('error', (error: Error) => {
      console.error('AVPlayer error:', error);
      console.error('AVPlayer error stack:', error.stack);
      this._playState = PlayState.IDLE;
      // 通知所有状态变化监听器
      this.notifyStateChange(this._playState);
    });

    // 播放完成监听
    this.avPlayer.on('endOfStream', () => {
      console.info('AVPlayer end of stream');
      this.onPlayComplete();
    });

    console.info('setupPlayerListeners: Listeners set up successfully');
  }

  /**
   * 播放完成处理
   */
  private async onPlayComplete(): Promise<void> {
    switch (this._playMode) {
      case PlayMode.SINGLE_LOOP:
        // 单曲循环
        if (this._currentSong) {
          await this.playSong(this._currentSong);
        }
        break;
      default:
        // 播放下一首
        await this.playNext();
        break;
    }
  }

  /**
   * 播放指定歌曲
   */
  async playSong(song: SongInfo): Promise<void> {
    console.info('playSong called, song:', song.name, 'URL:', song.playUrl);
    console.info('Current playState:', this._playState);
    console.info('isPlayerInitialized:', this.isPlayerInitialized);
    console.info('avPlayer exists:', !!this.avPlayer);
    
    // 检查播放器是否初始化
    if (!this.isPlayerInitialized) {
      console.warn('Player not initialized, initializing now...');
      await this.initPlayer();
      
      // 再次检查初始化是否成功
      if (!this.isPlayerInitialized || !this.avPlayer) {
        console.error('Player initialization failed or AVPlayer is null');
        this._playState = PlayState.IDLE;
        this._currentSong = null;
        this.notifySongChange(null);
        this.notifyStateChange(this._playState);
        return;
      }
    }

    if (!this.avPlayer) {
      console.error('AVPlayer is null after initialization');
      this._playState = PlayState.IDLE;
      this._currentSong = null;
      this.notifySongChange(null);
      this.notifyStateChange(this._playState);
      return;
    }

    if (!song.playUrl || song.playUrl === '') {
      console.warn('歌曲暂无音频资源:', song.name);
      // 显示Toast提示用户
      promptAction.showToast({
        message: '暂无音频资源，仅展示歌曲信息',
        duration: 2000
      });
      // 只更新当前歌曲信息，不实际播放
      this._currentSong = song;
      this._playState = PlayState.IDLE;
      this._duration = song.duration || 0;
      this._currentTime = 0;
      this.notifySongChange(song);
      this.notifyStateChange(this._playState);
      this.notifyTimeUpdate(0, this._duration);
      return;
    }

    try {
      console.info('Starting to play:', song.name, song.artist);
      console.info('Play URL:', song.playUrl);
      console.info('Current AVPlayer state before play:', this._avPlayerState);

      // 根据当前状态决定如何重置播放器
      if (this._avPlayerState === 'playing' || this._avPlayerState === 'paused' || this._avPlayerState === 'prepared') {
        console.info('Resetting player...');
        await this.avPlayer.reset();
        console.info('Player reset complete, waiting for idle state...');
        // 等待状态变为 idle
        await this.waitForState('idle', 2000);
      } else if (this._avPlayerState === 'preparing') {
        // 如果在准备中，先停止
        console.info('Player is preparing, stopping first...');
        await this.avPlayer.stop();
        await this.waitForState('stopped', 2000);
        await this.avPlayer.reset();
        await this.waitForState('idle', 2000);
      }

      console.info('AVPlayer state before set url:', this._avPlayerState);

      // 检查是否在 error 状态
      if (this._avPlayerState === 'error') {
        console.error('AVPlayer is in error state, resetting...');
        try {
          await this.avPlayer.reset();
          await this.waitForState('idle', 2000);
        } catch (e) {
          console.error('Failed to reset from error state:', e);
          // 如果 reset 失败，尝试重新创建播放器
          console.info('Recreating AVPlayer...');
          await this.destroy();
          await this.initPlayer();
        }
      }

      // 设置播放源 - 这会将状态从 idle 变为 initialized
      console.info('Setting play URL:', song.playUrl);
      try {
        this.avPlayer.url = song.playUrl;
        console.info('Play URL set successfully');
      } catch (urlError) {
        console.error('Failed to set URL:', urlError);
        throw new Error('Invalid audio URL: ' + song.playUrl);
      }

      // 等待状态变为 initialized 或 error
      await this.waitForStateWithError('initialized', 5000);

      // 检查是否在 error 状态
      if (this._avPlayerState === 'error') {
        console.error('AVPlayer entered error state after setting URL. Possible causes:');
        console.error('  1. URL is not accessible');
        console.error('  2. Audio format is not supported');
        console.error('  3. Network permission denied');
        throw new Error('Failed to load audio from URL: ' + song.playUrl);
      }

      console.info('AVPlayer is initialized, preparing...');

      // 准备播放 - 这会将状态从 initialized 变为 prepared
      await this.avPlayer.prepare();
      console.info('Player prepared');

      // 等待状态变为 prepared
      await this.waitForState('prepared', 5000);

      // 获取时长
      this._duration = this.avPlayer.duration;
      console.info('Duration:', this._duration);

      // 更新当前歌曲（在播放前更新，确保UI同步）
      this._currentSong = song;
      this.notifySongChange(song);

      // 开始播放
      console.info('Starting playback...');
      await this.avPlayer.play();
      console.info('Playback started - waiting for state change callback');

      // 加载歌词
      await this.loadLyric(song);

      console.info(`✅ Playing song: ${song.name}`);
    } catch (error) {
      console.error('❌ Failed to play song:', JSON.stringify(error));
      console.error('Error details:', error);
      console.error('Error stack:', error.stack);

      // 更新状态为错误
      this._playState = PlayState.IDLE;
      this.notifyStateChange(this._playState);
    }
  }

  /**
   * 加载歌词
   */
  private async loadLyric(song: SongInfo): Promise<void> {
    if (song.lyricUrl) {
      try {
        if (song.translationUrl) {
          this._currentLyric = await LyricParser.loadFromUrl(song.lyricUrl);
          // TODO: 加载翻译歌词
        } else {
          this._currentLyric = await LyricParser.loadFromUrl(song.lyricUrl);
        }
      } catch (error) {
        console.error('Failed to load lyric:', error);
        this._currentLyric = new LyricInfo();
      }
    } else {
      this._currentLyric = new LyricInfo();
    }

    this.notifyLyricChange(this._currentLyric);
  }

  /**
   * 设置歌词（直接设置歌词内容）
   */
  setLyric(lyricContent: string, translationContent: string = ''): void {
    if (translationContent) {
      this._currentLyric = LyricParser.parseWithTranslation(lyricContent, translationContent);
    } else {
      this._currentLyric = LyricParser.parse(lyricContent);
    }
    this.notifyLyricChange(this._currentLyric);
  }

  /**
   * 播放/暂停切换
   */
  async togglePlay(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      if (this._playState === PlayState.PLAYING) {
        // 先同步更新状态，再调用底层 pause，避免 UI 刷新延迟
        this._playState = PlayState.PAUSED;
        this.notifyStateChange(this._playState);
        await this.avPlayer.pause();
      } else if (this._playState === PlayState.PAUSED) {
        // 先同步更新状态，再调用底层 play
        this._playState = PlayState.PLAYING;
        this.notifyStateChange(this._playState);
        await this.avPlayer.play();
      } else if (this._currentSong) {
        await this.playSong(this._currentSong);
      }
    } catch (error) {
      console.error('Failed to toggle play:', error);
    }
  }

  /**
   * 暂停播放
   */
  async pause(): Promise<void> {
    if (!this.avPlayer || this._playState !== PlayState.PLAYING) {
      return;
    }

    try {
      await this.avPlayer.pause();
    } catch (error) {
      console.error('Failed to pause:', error);
    }
  }

  /**
   * 继续播放
   */
  async resume(): Promise<void> {
    if (!this.avPlayer || this._playState !== PlayState.PAUSED) {
      return;
    }

    try {
      await this.avPlayer.play();
    } catch (error) {
      console.error('Failed to resume:', error);
    }
  }

  /**
   * 停止播放
   */
  async stop(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      await this.avPlayer.stop();
      this._currentSong = null;
      this._currentTime = 0;
      this._currentLyric = new LyricInfo();
      this.notifySongChange(null);
      this.notifyLyricChange(this._currentLyric);
    } catch (error) {
      console.error('Failed to stop:', error);
    }
  }

  /**
   * 跳转到指定位置
   */
  async seekTo(time: number): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      await this.avPlayer.seek(time);
    } catch (error) {
      console.error('Failed to seek:', error);
    }
  }

  /**
   * 播放上一首
   */
  async playPrevious(): Promise<void> {
    if (this._playList.length === 0) {
      return;
    }

    this._currentIndex--;
    if (this._currentIndex < 0) {
      this._currentIndex = this._playList.length - 1;
    }

    await this.playSong(this._playList[this._currentIndex]);
    this.notifyPlayListChange();
  }

  /**
   * 播放下一首
   */
  async playNext(): Promise<void> {
    if (this._playList.length === 0) {
      return;
    }

    switch (this._playMode) {
      case PlayMode.SINGLE_LOOP:
        // 单曲循环：重新播放当前歌曲
        if (this._currentSong) {
          await this.playSong(this._currentSong);
        }
        break;

      case PlayMode.SHUFFLE:
        // 随机播放：随机选择一首歌曲
        this._currentIndex = Math.floor(Math.random() * this._playList.length);
        await this.playSong(this._playList[this._currentIndex]);
        break;

      case PlayMode.LIST_LOOP:
      default:
        // 列表循环：播放下一首
        this._currentIndex++;
        if (this._currentIndex >= this._playList.length) {
          this._currentIndex = 0;
        }
        await this.playSong(this._playList[this._currentIndex]);
        break;
    }
    this.notifyPlayListChange();
  }

  /**
   * 按索引播放歌曲
   */
  async playSongByIndex(index: number): Promise<void> {
    if (index < 0 || index >= this._playList.length) {
      return;
    }
    this._currentIndex = index;
    await this.playSong(this._playList[index]);
    this.notifyPlayListChange();
  }

  /**
   * 设置播放列表
   */
  setPlayList(songs: SongInfo[], startIndex: number = 0): void {
    this._playList = songs;
    this._currentIndex = startIndex;
    this.notifyPlayListChange();
  }

  /**
   * 添加歌曲到播放列表
   */
  addToPlayList(song: SongInfo): void {
    this._playList.push(song);
    this.notifyPlayListChange();
  }

  /**
   * 从播放列表移除歌曲
   */
  removeFromPlayList(index: number): void {
    if (index < 0 || index >= this._playList.length) {
      return;
    }
    this._playList.splice(index, 1);
    if (this._currentIndex >= this._playList.length) {
      this._currentIndex = this._playList.length - 1;
    }
    this.notifyPlayListChange();
  }

  /**
   * 清空播放列表
   */
  clearPlayList(): void {
    this._playList = [];
    this._currentIndex = -1;
    this.notifyPlayListChange();
  }

  /**
   * 通知状态变化 - 通知所有监听器
   */
  private notifyStateChange(state: PlayState): void {
    this.onStateChangeListeners.forEach(callback => {
      try {
        callback(state);
      } catch (e) {
        console.error('Error in state change listener:', e);
      }
    });
  }

  /**
   * 通知时间更新 - 通知所有监听器
   */
  private notifyTimeUpdate(currentTime: number, duration: number): void {
    this.onTimeUpdateListeners.forEach(callback => {
      try {
        callback(currentTime, duration);
      } catch (e) {
        console.error('Error in time update listener:', e);
      }
    });
  }

  /**
   * 通知歌曲变化 - 通知所有监听器
   */
  private notifySongChange(song: SongInfo | null): void {
    this.onSongChangeListeners.forEach(callback => {
      try {
        callback(song);
      } catch (e) {
        console.error('Error in song change listener:', e);
      }
    });
  }

  /**
   * 通知歌词变化 - 通知所有监听器
   */
  private notifyLyricChange(lyric: LyricInfo): void {
    this.onLyricChangeListeners.forEach(callback => {
      try {
        callback(lyric);
      } catch (e) {
        console.error('Error in lyric change listener:', e);
      }
    });
  }

  /**
   * 通知播放列表变化 - 通知所有监听器
   */
  private notifyPlayListChange(): void {
    this.onPlayListChangeListeners.forEach(callback => {
      try {
        callback(this._playList, this._currentIndex);
      } catch (e) {
        console.error('Error in playlist change listener:', e);
      }
    });
  }

  /**
   * 切换播放模式
   */
  togglePlayMode(): void {
    switch (this._playMode) {
      case PlayMode.LIST_LOOP:
        this._playMode = PlayMode.SINGLE_LOOP;
        break;
      case PlayMode.SINGLE_LOOP:
        this._playMode = PlayMode.SHUFFLE;
        break;
      case PlayMode.SHUFFLE:
        this._playMode = PlayMode.LIST_LOOP;
        break;
    }
  }

  /**
   * 添加状态变化监听器
   */
  addOnStateChange(callback: (state: PlayState) => void): void {
    this.onStateChangeListeners.push(callback);
  }

  /**
   * 移除状态变化监听器
   */
  removeOnStateChange(callback: (state: PlayState) => void): void {
    const index = this.onStateChangeListeners.indexOf(callback);
    if (index > -1) {
      this.onStateChangeListeners.splice(index, 1);
    }
  }

  /**
   * 添加时间更新监听器
   */
  addOnTimeUpdate(callback: (currentTime: number, duration: number) => void): void {
    this.onTimeUpdateListeners.push(callback);
  }

  /**
   * 移除时间更新监听器
   */
  removeOnTimeUpdate(callback: (currentTime: number, duration: number) => void): void {
    const index = this.onTimeUpdateListeners.indexOf(callback);
    if (index > -1) {
      this.onTimeUpdateListeners.splice(index, 1);
    }
  }

  /**
   * 添加歌曲变化监听器
   */
  addOnSongChange(callback: (song: SongInfo | null) => void): void {
    this.onSongChangeListeners.push(callback);
  }

  /**
   * 移除歌曲变化监听器
   */
  removeOnSongChange(callback: (song: SongInfo | null) => void): void {
    const index = this.onSongChangeListeners.indexOf(callback);
    if (index > -1) {
      this.onSongChangeListeners.splice(index, 1);
    }
  }

  /**
   * 添加歌词变化监听器
   */
  addOnLyricChange(callback: (lyric: LyricInfo) => void): void {
    this.onLyricChangeListeners.push(callback);
  }

  /**
   * 移除歌词变化监听器
   */
  removeOnLyricChange(callback: (lyric: LyricInfo) => void): void {
    const index = this.onLyricChangeListeners.indexOf(callback);
    if (index > -1) {
      this.onLyricChangeListeners.splice(index, 1);
    }
  }

  /**
   * 添加播放列表变化监听器
   */
  addOnPlayListChange(callback: (list: SongInfo[], index: number) => void): void {
    this.onPlayListChangeListeners.push(callback);
  }

  /**
   * 移除播放列表变化监听器
   */
  removeOnPlayListChange(callback: (list: SongInfo[], index: number) => void): void {
    const index = this.onPlayListChangeListeners.indexOf(callback);
    if (index > -1) {
      this.onPlayListChangeListeners.splice(index, 1);
    }
  }

  /**
   * 获取当前歌曲
   */
  get currentSong(): SongInfo | null {
    return this._currentSong;
  }

  /**
   * 获取播放状态
   */
  get playState(): PlayState {
    return this._playState;
  }

  /**
   * 获取当前播放时间
   */
  get currentTime(): number {
    return this._currentTime;
  }

  /**
   * 获取总时长
   */
  get duration(): number {
    return this._duration;
  }

  /**
   * 获取播放模式
   */
  get playMode(): PlayMode {
    return this._playMode;
  }

  /**
   * 获取播放列表
   */
  get playList(): SongInfo[] {
    return this._playList;
  }

  /**
   * 获取当前播放索引
   */
  get currentIndex(): number {
    return this._currentIndex;
  }

  /**
   * 获取当前歌词
   */
  get currentLyric(): LyricInfo {
    return this._currentLyric;
  }

  /**
   * 获取我喜欢的音乐列表
   */
  get likedSongs(): SongInfo[] {
    return this._likedSongs;
  }

  /**
   * 切换歌曲喜欢状态
   * @returns true 表示已收藏，false 表示已取消收藏
   */
  toggleLikeSong(song: SongInfo): boolean {
    const index = this._likedSongs.findIndex(s => s.id === song.id);
    if (index > -1) {
      // 已喜欢，取消喜欢
      this._likedSongs.splice(index, 1);
      console.info(`取消喜欢歌曲: ${song.name}`);
      this.notifyLikedSongsChange();
      return false;
    } else {
      // 未喜欢，添加喜欢
      this._likedSongs.push(song);
      console.info(`添加喜欢歌曲: ${song.name}`);
      this.notifyLikedSongsChange();
      return true;
    }
  }

  /**
   * 检查歌曲是否已喜欢
   */
  isSongLiked(song: SongInfo | null): boolean {
    if (!song) {
      return false;
    }
    return this._likedSongs.some(s => s.id === song.id);
  }

  /**
   * 通知我喜欢的音乐列表变化
   */
  private notifyLikedSongsChange(): void {
    this.onLikedSongsChangeListeners.forEach(callback => {
      try {
        callback(this._likedSongs);
      } catch (e) {
        console.error('Error in liked songs change listener:', e);
      }
    });
  }

  /**
   * 添加我喜欢的音乐列表变化监听器
   */
  addOnLikedSongsChange(callback: (songs: SongInfo[]) => void): void {
    this.onLikedSongsChangeListeners.push(callback);
  }

  /**
   * 移除我喜欢的音乐列表变化监听器
   */
  removeOnLikedSongsChange(callback: (songs: SongInfo[]) => void): void {
    const index = this.onLikedSongsChangeListeners.indexOf(callback);
    if (index > -1) {
      this.onLikedSongsChangeListeners.splice(index, 1);
    }
  }

  /**
   * 等待 AVPlayer 进入指定状态
   */
  private waitForState(targetState: string, timeoutMs: number): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this._avPlayerState === targetState) {
        resolve();
        return;
      }

      const checkInterval = 50;
      let elapsed = 0;

      const timer = setInterval(() => {
        elapsed += checkInterval;
        if (this._avPlayerState === targetState) {
          clearInterval(timer);
          resolve();
        } else if (elapsed >= timeoutMs) {
          clearInterval(timer);
          console.warn(`Timeout waiting for state ${targetState}, current state: ${this._avPlayerState}`);
          // 超时但不 reject，让后续操作尝试继续
          resolve();
        }
      }, checkInterval);
    });
  }

  /**
   * 等待 AVPlayer 进入指定状态，如果进入 error 状态也立即返回
   */
  private waitForStateWithError(targetState: string, timeoutMs: number): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this._avPlayerState === targetState || this._avPlayerState === 'error') {
        resolve();
        return;
      }

      const checkInterval = 50;
      let elapsed = 0;

      const timer = setInterval(() => {
        elapsed += checkInterval;
        if (this._avPlayerState === targetState || this._avPlayerState === 'error') {
          clearInterval(timer);
          resolve();
        } else if (elapsed >= timeoutMs) {
          clearInterval(timer);
          console.warn(`Timeout waiting for state ${targetState} or error, current state: ${this._avPlayerState}`);
          resolve();
        }
      }, checkInterval);
    });
  }

  /**
   * 销毁播放器
   */
  async destroy(): Promise<void> {
    if (this.avPlayer) {
      try {
        await this.avPlayer.release();
        this.avPlayer = null;
      } catch (error) {
        console.error('Failed to destroy player:', error);
      }
    }
  }
}
