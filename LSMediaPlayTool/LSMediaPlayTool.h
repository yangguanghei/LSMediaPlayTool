//
//  LSMediaPlayTool.h
//  梁森看视频
//
//  Created by 梁森 on 2019/7/5.
//  Copyright © 2019 DSY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSMediaPlayTool : NSObject

- (void)playMediaWithURL:(NSURL *)onLineURL;

- (NSInteger)getAudioTimeLength:(NSURL *)audioUrl;
@end

NS_ASSUME_NONNULL_END
