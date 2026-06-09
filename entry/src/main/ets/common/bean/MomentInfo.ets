import { SongInfo } from './SongInfo';

/**
 * 动态类型
 */
export enum MomentType {
  TEXT = 'TEXT',     // 纯文本
  MUSIC = 'MUSIC',   // 分享音乐
  IMAGE = 'IMAGE',   // 图片动态
  VIDEO = 'VIDEO'    // 视频动态
}

/**
 * 用户类型
 */
export enum UserType {
  NORMAL = 'NORMAL',     // 普通用户
  STAR = 'STAR',         // 明星
  OFFICIAL = 'OFFICIAL'  // 官方账号
}

/**
 * 用户信息
 */
export class UserInfo {
  id: string;
  name: string;
  avatar: string;
  userType: UserType;
  isFollowed: boolean;

  constructor(id: string, name: string, avatar: string, userType: UserType = UserType.NORMAL, isFollowed: boolean = false) {
    this.id = id;
    this.name = name;
    this.avatar = avatar;
    this.userType = userType;
    this.isFollowed = isFollowed;
  }
}

/**
 * 动态/笔记信息
 */
export class MomentInfo {
  id: string;
  user: UserInfo;
  content: string;
  type: MomentType;
  music: SongInfo | null;
  images: string[];
  videoUrl: string;
  createTime: number;
  likes: number;
  comments: number;
  shares: number;
  isLiked: boolean;

  constructor(
    id: string,
    user: UserInfo,
    content: string,
    type: MomentType = MomentType.TEXT,
    music: SongInfo | null = null,
    images: string[] = [],
    videoUrl: string = '',
    createTime: number = Date.now(),
    likes: number = 0,
    comments: number = 0,
    shares: number = 0,
    isLiked: boolean = false
  ) {
    this.id = id;
    this.user = user;
    this.content = content;
    this.type = type;
    this.music = music;
    this.images = images;
    this.videoUrl = videoUrl;
    this.createTime = createTime;
    this.likes = likes;
    this.comments = comments;
    this.shares = shares;
    this.isLiked = isLiked;
  }

  /**
   * 获取格式化的时间字符串
   */
  getFormattedTime(): string {
    const now: number = Date.now();
    const diff: number = now - this.createTime;
    const minute: number = 60 * 1000;
    const hour: number = 60 * minute;
    const day: number = 24 * hour;

    if (diff < minute) {
      return '刚刚';
    } else if (diff < hour) {
      return Math.floor(diff / minute) + '分钟前';
    } else if (diff < day) {
      return Math.floor(diff / hour) + '小时前';
    } else if (diff < 7 * day) {
      return Math.floor(diff / day) + '天前';
    } else {
      const date: Date = new Date(this.createTime);
      return (date.getMonth() + 1) + '月' + date.getDate() + '日';
    }
  }

  /**
   * 获取格式化的数字（如 1.2w）
   */
  getFormattedCount(count: number): string {
    if (count >= 10000) {
      return (count / 10000).toFixed(1) + 'w';
    } else if (count >= 1000) {
      return (count / 1000).toFixed(1) + 'k';
    } else {
      return count.toString();
    }
  }
}
