//
//  WhiteBoardRightView.m
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "SuperBoardRightView.h"
#import "PenStyleModel.h"
#define TopDownMargin 10
#define CELLSEP 4
#import "TPSuperboardDefine.h"
//如果超过 DisplayTime没有进行任何操作，则会自动隐藏
#define DisplayTime 5
@interface SuperBoardRightView()
{
    NSArray *_imageArray;

}
@end

@implementation SuperBoardRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initSubviews];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)initData
{
    _imageArray = [NSArray arrayWithObjects:
                   @"TPWhiteBoard.bundle/WB_SolidLine",
                   @"TPWhiteBoard.bundle/WB_Curve",
                   @"TPWhiteBoard.bundle/WB_SEP",
                   @"TPWhiteBoard.bundle/WB_SolidLine",
                   @"TPWhiteBoard.bundle/WB_DashLine",
                   @"TPWhiteBoard.bundle/WB_SEP",
                   @"TPWhiteBoard.bundle/WB_PenSize1",
                   @"TPWhiteBoard.bundle/WB_PenSize2",
                   @"TPWhiteBoard.bundle/WB_PenSize3",
                   @"TPWhiteBoard.bundle/WB_PenSize4", nil];
}
- (void)initSubviews
{

    UIView *preView = nil;
    for (int i=0; i<_imageArray.count; i++) {
        WhiteBoardRightViewCell *button = [WhiteBoardRightViewCell buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectZero;
        CGRect imageFrame = CGRectZero;
        if (i == 0) {
            frame = CGRectMake((self.tpWidth -34)/2, TopDownMargin, 34, 34);
            imageFrame = CGRectMake(0, 0, 34, 34);
        }else if(i == 2 || i ==5){
            frame = CGRectMake(preView.tpLeft, preView.tpBottom + CELLSEP, 34, 1);
            imageFrame = CGRectMake(0, 0, 34, 1);
        }else{
            frame = CGRectMake(preView.tpLeft, preView.tpBottom + CELLSEP, 34, 34);
            imageFrame = CGRectMake(0, 0, 34, 34);
        }
        button.frame = frame;
        button.tag = 100 + i;
        
        UIImage *image = [UIImage imageNamed:[_imageArray objectAtIndex:i]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeCenter;
        [button addSubview:imageView];
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        preView = button;
        
        self.tpHeight = preView.tpBottom + TopDownMargin;
    }
    [self resetWithNewModel];
    [self showRightView];
    
}

- (void)showRightView
{
    
    CGFloat screenWidht = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.4 animations:^{
        self.tpLeft = screenWidht - self.tpWidth;
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenRightView) object:nil];
    [self performSelector:@selector(hiddenRightView) withObject:nil afterDelay:DisplayTime];
}

- (void)hiddenRightView
{
    CGFloat screenWidht = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.4 animations:^{
        self.tpLeft = screenWidht;
    }];
}

//画笔发生改变重新设置高亮的图片
- (void)resetWithNewModel
{
    PenStyleModel *model = [PenStyleModel sharedInstance];
    
    WhiteBoardRightViewCell *straightCell = (WhiteBoardRightViewCell *)[self viewWithTag:100];
    straightCell.isSelected = model.isStraightLine;
    
    WhiteBoardRightViewCell *curveCell = (WhiteBoardRightViewCell *)[self viewWithTag:101];
    curveCell.isSelected = !model.isStraightLine;

    WhiteBoardRightViewCell *solidCell = (WhiteBoardRightViewCell *)[self viewWithTag:103];
    solidCell.isSelected = model.isSolidLine;
    WhiteBoardRightViewCell *dashedCell = (WhiteBoardRightViewCell *)[self viewWithTag:104];
    dashedCell.isSelected = !model.isSolidLine;
    

    for (int i= 106; i<=109; i++) {
        WhiteBoardRightViewCell *penCell = (WhiteBoardRightViewCell *)[self viewWithTag:i];
        penCell.isSelected = NO;
    }
    if (model.penSize == PenSize1) {
        WhiteBoardRightViewCell *penCell = (WhiteBoardRightViewCell *)[self viewWithTag:106];
        penCell.isSelected = YES;
    }else if (model.penSize == PenSize2){
        WhiteBoardRightViewCell *penCell = (WhiteBoardRightViewCell *)[self viewWithTag:107];
        penCell.isSelected = YES;
    }else if (model.penSize == PenSize3){
        WhiteBoardRightViewCell *penCell = (WhiteBoardRightViewCell *)[self viewWithTag:108];
        penCell.isSelected = YES;
    }else if (model.penSize == PenSize4){
        WhiteBoardRightViewCell *penCell = (WhiteBoardRightViewCell *)[self viewWithTag:109];
        penCell.isSelected = YES;
    }
    
    
}

- (void)btnClicked:(WhiteBoardRightViewCell *)cell
{
    [self showRightView];
    PenStyleModel *model = [PenStyleModel sharedInstance];
    if (cell.tag == 100) {
        model.isStraightLine = YES;
    }else if (cell.tag == 101){
        model.isStraightLine = NO;
    }else if (cell.tag == 103){
        model.isSolidLine = YES;
    }else if (cell.tag == 104){
        model.isSolidLine = NO;
    }else if (cell.tag == 106){
        model.penSize = PenSize1;
    }else if (cell.tag == 107){
        model.penSize = PenSize2;
    }else if (cell.tag == 108){
        model.penSize = PenSize3;
    }else if (cell.tag == 109){
        model.penSize = PenSize4;
    }
    [self resetWithNewModel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation WhiteBoardRightViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _backView.frame = self.bounds;
    _backView.layer.cornerRadius = self.tpWidth/2;
}
- (void)initSubView
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backView = backView;
    backView.layer.cornerRadius = self.tpWidth/2;
    [self addSubview:backView];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected == isSelected) {
        return;
    }
    _isSelected = isSelected;
    if (isSelected) {
        _backView.image = [UIImage imageNamed:@"TPWhiteBoard.bundle/WB_SelectBG"];
    }else{
        _backView.image = nil;
    }
    
}


@end