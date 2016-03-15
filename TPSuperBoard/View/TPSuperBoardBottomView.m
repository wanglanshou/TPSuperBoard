//
//  WhiteBoardButtomView.m
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPSuperBoardBottomView.h"

#define BOTTOMVIEWHEIGHT 44


#import "TPSuperBoardBottomView+Function.h"
#import "TPSuperboardDefine.h"
@interface TPSuperBoardBottomView()
{
    
    NSArray *_bottomImageArray;
}

@end

@implementation TPSuperBoardBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initSubview];
    }
    return self;
}

- (void)initData
{
    
    _bottomImageArray = [NSArray arrayWithObjects:
                         @"TPWhiteBoard.bundle/WB_ImportIcon",
                         @"TPWhiteBoard.bundle/WB_RedoIcon",
                         @"TPWhiteBoard.bundle/WB_ForwardIcon",
                         @"TPWhiteBoard.bundle/WB_CleanIcon", nil];
}

- (void)initSubview
{
    [self initBottomView];
}

- (void)initBottomView
{
    UIView *bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tpHeight - 44, self.tpWidth, 44)];
    bottomBackView.backgroundColor = [UIColor tpColorWithRed:38 green:39 blue:43];
    [self addSubview:bottomBackView];
    
    //每个按钮的大小是44 *44
    CGFloat buttonSep = (self.tpWidth - 44 * 4)/4;//各个按钮之间的间距
    for (int i=0; i< _bottomImageArray.count; i++) {
        NSString *imageName = [_bottomImageArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonSep/2 + (buttonSep + 44)* i, 0, 44, 44);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
        imageView.image = [UIImage imageNamed:imageName];
        [button addSubview:imageView];
        [bottomBackView addSubview:button];
        [button addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200 + i;
        
    }
    
}


//取图片 撤销  继续  清空
- (void)bottomBtnClicked:(UIButton *)btn
{
    if (btn.tag == 200) {
        //加载图片
        [self inputImage];//Fuction方法
    }else if (btn.tag == 201){
        //撤销上一步
        [self undoPreStep];//Fuction方法
    }else if (btn.tag == 202){
        //回退，取消撤销
        [self backOneStep];//Fuction方法
    }else if (btn.tag == 203){
        //清空
        [self clearAll];//Fuction方法
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
