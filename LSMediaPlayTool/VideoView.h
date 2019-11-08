//
//  VideoView.h
//  梁森看视频
//
//  Created by chenleping on 2018/9/18.
//  Copyright © 2018年 DSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoView : UIView

- (void)playMediaWithURL:(NSURL *)url;

@property (nonatomic, strong) UIButton * fullScreenBtn;
@end
