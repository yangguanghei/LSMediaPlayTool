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
    [playBtn setTitle:@"播放在线" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * locPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locPlayBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:locPlayBtn];
    locPlayBtn.frame = CGRectMake(100, 170, 100, 50);
    [locPlayBtn setTitle:@"播放本地" forState:UIControlStateNormal];
    [locPlayBtn addTarget:self action:@selector(playLoc) forControlEvents:UIControlEventTouchUpInside];
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
