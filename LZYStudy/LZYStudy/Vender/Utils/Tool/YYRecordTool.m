//
//  YYRecordTool.m
//  OKVoice
//
//  Created by yanyu on 2018/12/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYRecordTool.h"


@interface YYRecordTool () <AVAudioPlayerDelegate>


@end
@implementation YYRecordTool

static id instance;
#pragma mark - 单例
+ (instancetype)sharedRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}


- (void)playRecordingWith:(NSURL*)url{
    // 正在播放就返回
    if ([self.player isPlaying]) return;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSString *temPath = [location path];
            NSData *data = [NSData dataWithContentsOfFile:temPath];
            if(data){
                NSError *avError = nil;
                self.player = [[AVAudioPlayer alloc] initWithData:data error:&avError];
                if(!avError){
                    self.player.delegate = self;
                    
                    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
                    
                    [self.player play];
                }
            }
        }
    }];
    [downLoadTask resume];
}

- (void)playRecordingWithData:(NSData*)data{
    
    // 正在播放就返回
    if (self.player && [self.player isPlaying]) return;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    self.player.delegate = self;
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil]; 
    
    [self.player play];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordToolDidFinishPlay:)]) {
        [self.delegate recordToolDidFinishPlay:self];
    }
}
@end
