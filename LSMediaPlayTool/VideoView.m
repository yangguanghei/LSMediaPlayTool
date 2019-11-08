//
//  VideoView.m
//  梁森看视频
//
//  Created by chenleping on 2018/9/18.
//  Copyright © 2018年 DSY. All rights reserved.
//

#import "VideoView.h"

#import "Masonry/Masonry.h"

#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
@interface VideoView()

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * playBtn;
@property (nonatomic, strong) UISlider * slider;
@property (nonatomic, strong) UILabel * currentTimeLbl;
@property (nonatomic, strong) UILabel * allTimeLbl;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem * item;
@property (nonatomic, strong) AVURLAsset *asset;

@property (nonatomic, strong) id timeObserver;

@end

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpChildControl];
    }
    return self;
}
#pragma mark --- 页面布局
- (void)setUpChildControl{
    // 底部UIimageview
    UIImageView * backView = [[UIImageView alloc] init];
    [self addSubview:backView];
    [self.layer addSublayer:self.playerLayer];
    // 上方视图
    UIView * topView = [[UIView alloc] init];
    [self addSubview:topView];
    // 下方视图
    UIView * bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    // 播放按钮
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:playBtn];
    // 进度条
    UISlider * slider = [[UISlider alloc] init];
    [bottomView addSubview:slider];
    // 全屏按钮
    UIButton * fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:fullScreenBtn];
    // 当前播放时间
    UILabel * currentTimeLbl = [[UILabel alloc] init];
    [bottomView addSubview:currentTimeLbl];
    // 总时间
    UILabel * allTimeLbl = [[UILabel alloc] init];
    [bottomView addSubview:allTimeLbl];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(30));
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(30));
    }];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.height.equalTo(@(30));
    }];
    [fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-10);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.height.equalTo(@(30));
    }];
    [currentTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bottomView);
        make.left.equalTo(playBtn.mas_right).offset(10);
        make.width.equalTo(@(50));
    }];
    [allTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fullScreenBtn.mas_left).offset(-10);
        make.top.bottom.equalTo(bottomView);
        make.width.equalTo(currentTimeLbl.mas_width);
    }];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentTimeLbl.mas_right).offset(10);
        make.right.equalTo(allTimeLbl.mas_left).offset(-10);
        make.top.bottom.equalTo(bottomView);
    }];
    
    [playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [fullScreenBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    [fullScreenBtn setImage:[UIImage imageNamed:@"小屏"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [fullScreenBtn addTarget:self action:@selector(fullOrNot:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPic:)];
    tap.numberOfTapsRequired = 1;
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:tap];
    slider.value = 0.0;
    [slider addTarget:self action:@selector(drapSlider:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
    
    _topView = topView;
    _bottomView = bottomView;
    _playBtn = playBtn;
    _fullScreenBtn = fullScreenBtn;
    _slider = slider;
    _currentTimeLbl = currentTimeLbl;
    _allTimeLbl = allTimeLbl;
    
    _currentTimeLbl.text = @"00:00";
    _allTimeLbl.text = @"00:00";
    
    backView.backgroundColor = [UIColor greenColor];
    topView.backgroundColor = [UIColor redColor];
    bottomView.backgroundColor = [UIColor redColor];
    self.playerLayer.backgroundColor = [UIColor blueColor].CGColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}
#pragma mark --- 交互事件
- (void)tapPic:(UITapGestureRecognizer *)tap{
    if (_topView.hidden == YES) {
        _topView.hidden = NO;
        _bottomView.hidden = NO;
    }else{
        _topView.hidden = YES;
        _bottomView.hidden = YES;
    }
}
- (void)drapSlider:(UISlider *)slider{
    [self.player seekToTime:CMTimeMake(self.slider.value, 1.0)];
    [self addTimeObsever];
}
#pragma mark --- 播放、暂停
- (void)playOrPause:(UIButton*)btn{
    NSLog(@"播放....");
    btn.selected = !btn.selected;
    [self addTimeObsever];
    if (@available(iOS 10.0, *)) {
        if (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
            [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            [self.player play];
        } else if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            [self.player pause];
        }
    } else {
        // Fallback on earlier versions
        if (btn.selected == YES) {
            [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            [self.player play];
        }else{
            [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            [self.player pause];
        }
    }
}
#pragma mark --- 全屏
- (void)fullOrNot:(UIButton *)btn{
    NSLog(@"全屏..");
    btn.selected = !btn.selected;
    if (btn.selected) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.isShouAutoRotate = YES;
        [self setForceDeviceOrientation:UIDeviceOrientationLandscapeLeft];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.isShouAutoRotate = NO;
        [self setForceDeviceOrientation:UIDeviceOrientationPortrait];
        
    }
}
// 强制切换屏幕方向
- (void)setForceDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:deviceOrientation] forKey:@"orientation"];
}


- (void)addTimeObsever{
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        _currentTimeLbl.text = [weakSelf stringWithTime:CMTimeGetSeconds(weakSelf.player.currentTime)];
        _slider.value = CMTimeGetSeconds(weakSelf.player.currentTime);
    }];
}
#pragma mark --- 对播放器的状态进行监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSTimeInterval totalTime = CMTimeGetSeconds(_asset.duration);
    if ([keyPath isEqualToString:@"status"]) { // 检测播放器状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusFailed) {
            NSLog(@"资源不存在...");
        }else if (status == AVPlayerStatusUnknown){
            NSLog(@"发生未知错误...");
        }else if (status == AVPlayerStatusReadyToPlay){
            NSLog(@"达到播放状态...");
            _slider.maximumValue = totalTime;
            _allTimeLbl.text = [self stringWithTime:totalTime];
        }
    }
}

- (NSString *)stringWithTime:(CGFloat)time;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (time >= 3600) {
        [dateFmt setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFmt setDateFormat:@"mm:ss"];
    }
    return [dateFmt stringFromDate:date];
}


- (void)playMediaWithURL:(NSURL *)url{
    AVURLAsset * asset = [AVURLAsset assetWithURL:url];
    AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    _item = item;
    _asset = asset;
}


#pragma mark --- 懒加载
- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
         _playerLayer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return _playerLayer;
}
- (AVPlayer *)player{
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}



- (void)dealloc{
    [_item removeObserver:self forKeyPath:@"status"];
    NSLog(@"%@   被释放了...", NSStringFromClass(self.class));
}
@end
