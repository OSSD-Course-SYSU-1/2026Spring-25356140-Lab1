import { SongInfo } from '../bean/SongInfo';
import { PlayState, PlayMode } from '../bean/PlayerState';
import { LyricInfo } from '../bean/LyricInfo';

/**
 * 播放器全局状态存储
 * 使用 AppStorage 实现跨组件状态共享
 */
export class PlayerStore {
  // AppStorage 键名
  private static readonly KEY_CURRENT_SONG = 'player_current_song';
  private static readonly KEY_PLAY_STATE = 'player_play_state';
  private static readonly KEY_CURRENT_TIME = 'player_current_time';
  private static readonly KEY_DURATION = 'player_duration';
  private static readonly KEY_PLAY_MODE = 'player_play_mode';
  private static readonly KEY_CURRENT_LYRIC = 'player_current_lyric';
  private static readonly KEY_PLAY_LIST = 'player_play_list';
  private static readonly KEY_CURRENT_INDEX = 'player_current_index';

  /**
   * 初始化 AppStorage（在应用启动时调用一次）
   */
  static init(): void {
    AppStorage.setOrCreate(PlayerStore.KEY_CURRENT_SONG, null as SongInfo | null);
    AppStorage.setOrCreate(PlayerStore.KEY_PLAY_STATE, PlayState.IDLE);
    AppStorage.setOrCreate(PlayerStore.KEY_CURRENT_TIME, 0);
    AppStorage.setOrCreate(PlayerStore.KEY_DURATION, 0);
    AppStorage.setOrCreate(PlayerStore.KEY_PLAY_MODE, PlayMode.LIST_LOOP);
    AppStorage.setOrCreate(PlayerStore.KEY_CURRENT_LYRIC, new LyricInfo());
    AppStorage.setOrCreate(PlayerStore.KEY_PLAY_LIST, [] as SongInfo[]);
    AppStorage.setOrCreate(PlayerStore.KEY_CURRENT_INDEX, -1);
  }

  // Current Song
  static getCurrentSong(): SongInfo | null {
    return AppStorage.get(PlayerStore.KEY_CURRENT_SONG) as SongInfo | null;
  }

  static setCurrentSong(song: SongInfo | null): void {
    AppStorage.set(PlayerStore.KEY_CURRENT_SONG, song);
  }

  static linkCurrentSong(): SubscribedAbstractProperty<SongInfo | null> {
    return AppStorage.link(PlayerStore.KEY_CURRENT_SONG);
  }

  // Play State
  static getPlayState(): PlayState {
    return AppStorage.get(PlayerStore.KEY_PLAY_STATE) as PlayState;
  }

  static setPlayState(state: PlayState): void {
    AppStorage.set(PlayerStore.KEY_PLAY_STATE, state);
  }

  static linkPlayState(): SubscribedAbstractProperty<PlayState> {
    return AppStorage.link(PlayerStore.KEY_PLAY_STATE);
  }

  // Current Time
  static getCurrentTime(): number {
    return AppStorage.get(PlayerStore.KEY_CURRENT_TIME) as number;
  }

  static setCurrentTime(time: number): void {
    AppStorage.set(PlayerStore.KEY_CURRENT_TIME, time);
  }

  static linkCurrentTime(): SubscribedAbstractProperty<number> {
    return AppStorage.link(PlayerStore.KEY_CURRENT_TIME);
  }

  // Duration
  static getDuration(): number {
    return AppStorage.get(PlayerStore.KEY_DURATION) as number;
  }

  static setDuration(duration: number): void {
    AppStorage.set(PlayerStore.KEY_DURATION, duration);
  }

  static linkDuration(): SubscribedAbstractProperty<number> {
    return AppStorage.link(PlayerStore.KEY_DURATION);
  }

  // Play Mode
  static getPlayMode(): PlayMode {
    return AppStorage.get(PlayerStore.KEY_PLAY_MODE) as PlayMode;
  }

  static setPlayMode(mode: PlayMode): void {
    AppStorage.set(PlayerStore.KEY_PLAY_MODE, mode);
  }

  // Current Lyric
  static getCurrentLyric(): LyricInfo {
    return AppStorage.get(PlayerStore.KEY_CURRENT_LYRIC) as LyricInfo;
  }

  static setCurrentLyric(lyric: LyricInfo): void {
    AppStorage.set(PlayerStore.KEY_CURRENT_LYRIC, lyric);
  }

  // Play List
  static getPlayList(): SongInfo[] {
    return AppStorage.get(PlayerStore.KEY_PLAY_LIST) as SongInfo[];
  }

  static setPlayList(list: SongInfo[]): void {
    AppStorage.set(PlayerStore.KEY_PLAY_LIST, list);
  }

  // Current Index
  static getCurrentIndex(): number {
    return AppStorage.get(PlayerStore.KEY_CURRENT_INDEX) as number;
  }

  static setCurrentIndex(index: number): void {
    AppStorage.set(PlayerStore.KEY_CURRENT_INDEX, index);
  }
}
