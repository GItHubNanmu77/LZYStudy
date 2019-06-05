//
//  YYRecordTool.h
//  OKVoice
//
//  Created by yanyu on 2018/12/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class YYRecordTool;
@protocol YYRecordToolDelegate <NSObject>

@optional
- (void)recordToolDidFinishPlay:(YYRecordTool *)recordTool; 
@end

@interface YYRecordTool : NSObject
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, assign) id<YYRecordToolDelegate> delegate;

+ (instancetype)sharedRecordTool;

/** 播放录音文件 */
- (void)playRecordingWith:(NSURL*)url;

- (void)playRecordingWithData:(NSData*)data;

@end
