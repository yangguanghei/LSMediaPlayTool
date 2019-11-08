//
//  NextViewController.m
//  梁森看视频
//
//  Created by chenleping on 2018/9/18.
//  Copyright © 2018年 DSY. All rights reserved.
//

#import "NextViewController.h"

#import "VideoView.h"
#import "Masonry.h"
#import "AppDelegate.h"
#define kSystemVersionFloat [[[UIDevice currentDevice] systemVersion] floatValue]
@interface NextViewController ()

@property (nonatomic, strong)  VideoView * videoView;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.videoView];
//    return;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSString * path1 = [[NSBundle mainBundle] pathForResource:@"如烟-五月天" ofType:@"mp3"];
    // 播放在线视频
//    [self.videoView playMediaWithURL:[NSURL URLWithString:@"http://aladdin.test.tigermai.cn/Uploads/2019-07-05/5d1ec00d82ba8.mp3"]];
    // 播放本地视频(没问题)
//    [self.videoView playMediaWithURL: [NSURL fileURLWithPath:path]];
    // 播放在线音频（没问题）
//    [self.videoView playMediaWithURL:[NSURL URLWithString:@""]];
    // 播放本地音频(没问题)
    [self.videoView playMediaWithURL:[NSURL fileURLWithPath:path1]];
#warning 如何改变视频播放器的位置
    self.videoView.frame = CGRectMake(0, 400, 300, 200);
    self.videoView.backgroundColor = [UIColor blackColor];
    
    UIButton * dissmissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissmissBtn.backgroundColor = [UIColor redColor];
    [dissmissBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.view addSubview:dissmissBtn];
    [dissmissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.videoView.mas_bottom).offset(50);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    [dissmissBtn addTarget:self action:@selector(dissmissAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)dissmissAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 屏幕发生旋转调用的房
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) { // 转至竖屏
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(100);
            make.height.equalTo(@(200));
        }];
        self.videoView.fullScreenBtn.selected = NO;
    } else if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) { // 转至横屏
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (kSystemVersionFloat > 11.0) {
                make.left.bottom.right.top.equalTo(self.view.mas_safeAreaLayoutGuide);
            }else{
                make.left.bottom.right.top.equalTo(self.view);
            }            
        }];
        self.videoView.fullScreenBtn.selected = YES;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.isShouAutoRotate =NO;   // 竖屏状态下不能进行屏幕旋转
}

- (VideoView *)videoView{
    if (_videoView == nil) {
        _videoView = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _videoView;
}
- (void)dealloc{
    
    NSLog(@"%@   被释放了...", NSStringFromClass(self.class));
}

@end
