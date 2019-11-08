//
//  LSMediaPlayTool.m
//  梁森看视频
//
//  Created by 梁森 on 2019/7/5.
//  Copyright © 2019 DSY. All rights reserved.
//

#import "LSMediaPlayTool.h"

#import <AVFoundation/AVFoundation.h>

@interface LSMediaPlayTool()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem * item;
@property (nonatomic, strong) AVURLAsset *asset;

@end

@implementation LSMediaPlayTool

- (void)playMediaWithURL:(NSURL *)onLineURL{
    AVURLAsset * asset = [AVURLAsset assetWithURL:onLineURL];
    AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    _item = item;
    _asset = asset;
}

#pragma mark --- 对播放器的状态进行监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSTimeInterval totalTime = CMTimeGetSeconds(_asset.duration);
    NSLog(@"时间：%lf", totalTime);
    if ([keyPath isEqualToString:@"status"]) { // 检测播放器状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusFailed) {
            NSLog(@"资源不存在...");
        }else if (status == AVPlayerStatusUnknown){
            NSLog(@"发生未知错误...");
        }else if (status == AVPlayerStatusReadyToPlay){
            NSLog(@"达到播放状态...");
            [self.player play];
        }
    }
}
- (NSInteger)getAudioTimeLength:(NSURL *)audioUrl {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:opts]; // 初始化视频媒体文件
    NSInteger second = 0;
    second = ceil(urlAsset.duration.value / urlAsset.duration.timescale); // 获取视频总时长,单位秒
    return second;
}
- (void)dealloc{
    [_item removeObserver:self forKeyPath:@"status"];
    NSLog(@"%@   被释放了...", NSStringFromClass(self.class));
}

#pragma mark --- 懒加载
- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}
- (AVPlayer *)player{
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}
@end
