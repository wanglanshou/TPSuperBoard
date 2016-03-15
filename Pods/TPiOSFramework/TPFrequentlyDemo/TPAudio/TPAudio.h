//
//  TPAudio.h
//  TPFramework
//
//  Created by wang on 16/3/7.
//  Copyright © 2016年 wp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TPAudioRecordProgressBlock)(NSInteger recordSeconds);
typedef void (^TPAudioFinishBlock)(NSString *fullPath, NSInteger duration,NSError *error);



@interface TPAudio : NSObject

+ (instancetype)sharedInstance;

/**
 *  开始录音
 *
 *  @param error 如果失败，如权限未开，上一个录音没有停止等 返回error消息
 */
- (void) startRecordMp3WithProgress:(TPAudioRecordProgressBlock)progressBlock error:(NSError **)error;

/**
 *  停止录音
 *
 *  @param completion 录音结束
 *  @param error      如果未开始录音，返回error消息
 */
- (void) stopRecordMp3WithCompletion:(TPAudioFinishBlock)completion error:(NSError **)error;



@end
