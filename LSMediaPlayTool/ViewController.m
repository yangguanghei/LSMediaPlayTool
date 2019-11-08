//
//  ViewController.m
//  LSMediaPlayTool
//
//  Created by 梁森 on 2019/7/5.
//  Copyright © 2019 梁森. All rights reserved.
//

#import "ViewController.h"

#import "LSMediaPlayTool.h"

#import "NextViewController.h"
@interface ViewController ()

@property (nonatomic, strong) LSMediaPlayTool * playTool;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:playBtn];
    playBtn.frame = CGRectMake(100, 100, 100, 50);
    [playBtn setTitle:@"在线音频" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * locPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locPlayBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:locPlayBtn];
    locPlayBtn.frame = CGRectMake(100, 170, 100, 50);
    [locPlayBtn setTitle:@"本地音频" forState:UIControlStateNormal];
    [locPlayBtn addTarget:self action:@selector(playLoc) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * onlineVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineVideoBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:onlineVideoBtn];
    CGFloat videoBtnY = CGRectGetMaxY(locPlayBtn.frame) + 20;
    onlineVideoBtn.frame = CGRectMake(100, videoBtnY, 100, 50);
    [onlineVideoBtn setTitle:@"在线视频" forState:UIControlStateNormal];
    [onlineVideoBtn addTarget:self action:@selector(videoOnline) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * locVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locVideoBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:locVideoBtn];
    CGFloat locBtnY = CGRectGetMaxY(onlineVideoBtn.frame) + 20;
    locVideoBtn.frame = CGRectMake(100, locBtnY, 100, 50);
    [locVideoBtn setTitle:@"本地视频" forState:UIControlStateNormal];
    [locVideoBtn addTarget:self action:@selector(videoLoc) forControlEvents:UIControlEventTouchUpInside];
}
// 在线音频
- (void)clickBtn{
    // http://39.106.124.34/files/kongtiaokaiji.mp3
    // http://aladdin.test.tigermai.cn/Uploads/2019-07-05/5d1ec00d82ba8.mp3
    NSURL * url = [NSURL URLWithString:@"http://aladdin.test.tigermai.cn/Uploads/2019-07-05/5d1ec00d82ba8.mp3"];
    NSInteger time = [self.playTool getAudioTimeLength:url];
    NSLog(@"time=:%lu", time);
    [self.playTool playMediaWithURL:url];
}
// 本地音频
- (void)playLoc{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"如烟-五月天" ofType:@"mp3"];
    [self.playTool playMediaWithURL:[NSURL fileURLWithPath:path]];
}
// 在线视频
- (void)videoOnline{
    [self.playTool playMediaWithURL:[NSURL URLWithString:@""]];
}
// 本地视频
- (void)videoLoc{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    [self.playTool playMediaWithURL:[NSURL fileURLWithPath:path]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //
    [self presentViewController:[NextViewController new] animated:YES completion:nil];
}


- (LSMediaPlayTool *)playTool{
    if (_playTool == nil) {
        _playTool = [LSMediaPlayTool new];
    }
    return _playTool;
}

@end
