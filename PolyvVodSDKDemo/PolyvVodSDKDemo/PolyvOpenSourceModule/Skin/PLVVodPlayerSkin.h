//
//  PLVVodPlayerSkin.h
//  PolyvVodSDK
//
//  Created by BqLin on 2017/10/26.
//  Copyright © 2017年 POLYV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLVVodSDK/PLVVodPlayerSkinProtocol.h>

@interface PLVVodPlayerSkin : UIViewController<PLVVodPlayerSkinProtocol>

/// 弱引用的播放器
@property (nonatomic, weak) IBOutlet PLVVodPlayerViewController *delegatePlayer;

#pragma mark 控件

/// 播放/暂停按钮
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;

/// 时间标签
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/// 缓冲进度
@property (weak, nonatomic) IBOutlet UIProgressView *bufferProgressView;

/// 播放进度滑杆
@property (weak, nonatomic) IBOutlet UISlider *playbackSlider;

/// 亮度滑杆
@property (nonatomic, weak) IBOutlet UISlider *brightnessSlider;

/// 音量滑杆
@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;

/// 全屏/半屏按钮
@property (nonatomic, weak) IBOutlet UIButton *fullShrinkscreenButton;

/// 字幕标签
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


@end