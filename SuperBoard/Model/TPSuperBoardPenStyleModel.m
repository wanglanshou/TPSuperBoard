//
//  PenStyleModel.m
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPSuperBoardPenStyleModel.h"
#import "TPSuperboardDefine.h"
#import "TPSuperboardDefine.h"

@implementation TPSuperBoardPenStyleModel

+ (instancetype) sharedInstance{
    static dispatch_once_t oneToken;
    static TPSuperBoardPenStyleModel *model;
    dispatch_once(&oneToken, ^{
        model = [[TPSuperBoardPenStyleModel alloc] init];
    });
    return model;
    
}
- (instancetype)init
{
    if (self = [super init]) {
        //设置默认的画笔大小
        self.isStraightLine = NO;
        self.isSolidLine = YES;
        self.penSize = PenSize2;
        self.color = [UIColor tpColorWithRed:0 green:0 blue:0];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TPSuperBoardPenStyleModel *penStypeModel = [[[self class] allocWithZone:zone] init];
    penStypeModel.color = self.color;
    penStypeModel.isStraightLine = self.isStraightLine;
    penStypeModel.isSolidLine = self.isSolidLine;
    penStypeModel.penSize = self.penSize;
    penStypeModel.isEraser = self.isEraser;
    return penStypeModel;
}
- (void)setColor:(UIColor *)color
{
    _color = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TPSuperBoard_ColorDidChaged object:nil];
}

@end
