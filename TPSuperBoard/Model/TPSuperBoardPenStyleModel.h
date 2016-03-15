//
//  PenStyleModel.h
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PenSize) {
    PenSize1 = 5, //5px
    PenSize2 = 10,//10px
    PenSize3 = 20,//20px
    PenSize4 = 30//30px
};


@interface TPSuperBoardPenStyleModel : NSObject<NSCopying>

+ (instancetype) sharedInstance;

@property (nonatomic,strong) UIColor *color;//画笔颜色
@property (nonatomic,assign) BOOL isStraightLine;//是否是直线（直线，曲线）
@property (nonatomic,assign) BOOL isSolidLine;//是否是实线(实现，虚线)
@property (nonatomic,assign) PenSize penSize;//画笔的粗细
@property (nonatomic,assign) BOOL isEraser;//是否是橡皮擦模式，橡皮擦模式自动设置为白色
@end
