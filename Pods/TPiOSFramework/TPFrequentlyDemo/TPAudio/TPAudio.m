//
//  TPAudio.m
//  TPFramework
//
//  Created by wang on 16/3/7.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "TPAudio.h"
#import <AVFoundation/AVFoundation.h>
#import <lame/lame.h>
#define TPAudioSAMPLE_RATE 11025.0

@interface TPAudio()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) NSInteger totalRecordSeconds;
@property (nonatomic, copy) TPAudioRecordProgressBlock progressBlock;
@property (nonatomic, copy) TPAudioFinishBlock finishBlock;


@end

@implementation TPAudio


+(instancetype)sharedInstance{
    static dispatch_once_t token;
    static TPAudio *audio;
    dispatch_once(&token, ^{
        audio = [[TPAudio alloc] init];
    });
    return audio;
}

/**
 *  开始录音
 *
 *  @param error 如果失败，如权限未开，上一个录音没有停止等 返回error消息
 */
- (void) startRecordMp3WithProgress:(TPAudioRecordProgressBlock)progressBlock error:(NSError **)error{
    
    if (self.audioRecorder && self.audioRecorder.isRecording) {
        //正在录制，返回失败
        
        *error = [NSError errorWithDomain:@"www.tupo.com" code:2000 userInfo:@{NSCocoaErrorDomain:@"正在录制，请先停止之前的录制"}];
        return;
    }
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:error];
    if(*error){
        return ;
    }
    
    [avSession setActive:YES error:nil];
    
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    
    //5 采样信号是整数还是浮点数
    //[recordSettings setObject:
    // [NSNumber numberWithBool:YES] forKey:AVLinearPCMIsFloatKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    NSString *pcmFullPath = [self getRecordPath];
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:pcmFullPath] settings:recordSettings error:error];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    if (*error) {
        return ;
    }
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
    
    
    
    //定时器启动，计算录制时长
    self.progressTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(recordProgressChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];//添加到runloop
    self.totalRecordSeconds = 0;
    self.progressBlock = progressBlock;
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    
}

//刷新录制时间
- (void)recordProgressChanged{
    self.totalRecordSeconds ++;
    if (self.progressBlock) {
        self.progressBlock(self.totalRecordSeconds);
    }
}


/**
 *  停止录音
 *
 *  @param completion 录音结束
 *  @param error      如果未开始录音，返回error消息
 */
- (void) stopRecordMp3WithCompletion:(TPAudioFinishBlock)completion error:(NSError **)error{
    [self.progressTimer invalidate];
    if (!self.audioRecorder || !self.audioRecorder.isRecording) {
        *error = [NSError errorWithDomain:@"www.tupo.com" code:3000 userInfo:@{NSCocoaErrorDomain:@"未开始录制"}];
        return;
    }
    
    NSURL *recordUrl = self.audioRecorder.url;
    NSString *recordFullPath = [recordUrl relativePath];
    NSString *mp3Fullpath = [recordFullPath stringByReplacingOccurrencesOfString:@"pcm" withString:@"mp3"];
    [self.audioRecorder stop];
    self.audioRecorder = nil;
    self.finishBlock = completion;
    [self transcodingPCMFile:recordFullPath toMp3FilePath:mp3Fullpath];
    

}

/**
 *  将PCM文件转成MP3文件
 *
 *  @param pcmFilePath <#pcmFilePath description#>
 *  @param mp3Path     <#mp3Path description#>
 */
- (void) transcodingPCMFile:(NSString*)pcmFilePath toMp3FilePath:(NSString*)mp3Path{
    
    BOOL isSuc = FALSE;
    @try {
        int read, write;
        FILE *pcm = fopen([pcmFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        if(!pcm){
            return;
        }
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        if(!mp3){
            fclose(pcm);
            return;
        }
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
        lame_set_quality(lame,7); /* 2=high 5 = medium 7=low 音质*/
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        isSuc = TRUE;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {

        if (!self.finishBlock) {
            return;
        }
        
        if (!isSuc) {
            NSError *error = [NSError errorWithDomain:@"www.tupo.com" code:4000 userInfo:@{NSCocoaErrorDomain:@"转码失败"}];
            self.finishBlock(nil,0,error);
            return;
        }
        self.finishBlock(mp3Path,self.totalRecordSeconds,nil);
    }
}
#pragma mark - 文件相关
- (NSString *) getRecordPath{
    
    NSString *fileName = [[self class] uuid];
    fileName  =  [fileName stringByAppendingString:@".pcm"];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullPath = [[paths firstObject] stringByAppendingPathComponent:fileName];
    return fullPath;
}


+ (NSString *)uuid{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


@end
