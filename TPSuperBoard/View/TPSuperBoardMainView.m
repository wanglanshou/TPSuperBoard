//
//  WhiteBoardMainView.m
//  tupo
//
//  Created by wang on 15/8/17.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPSuperBoardMainView.h"
#import "TPSuperBoardRightView.h"

#import "TPSuperBoardBottomView.h"
#import "TPSuperBoardScrollView.h"

#import "TPSuperBoardMiniMapView.h"

#import "TPSuperBoardPenStyleModel.h"

#import "TPSuperBoardColorPickerView.h"

#import "TPSuperboardDefine.h"
#import "TPSuperboardDefine.h"

#define RIGHTVIEW_WIDTH 50
#define RIGHTVIEW_TOP 30
#define TOPBUTTON_WIDTH 44
#define TOPBUTTON_HEIGHT 66


@interface TPSuperBoardMainView()
{
    TPSuperBoardScrollView *_scrollView;
    
    TPSuperBoardRightView *_rightView;//右边显示画笔
    CGPoint _prePoint;
    TPSuperBoardMiniMapView *_airscapeView;//鸟瞰图
    
    
    NSArray *_topImageArray;
    NSArray *_topSelectedImageArray;
    
    UIView *_colorView;
}

@end

@implementation TPSuperBoardMainView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initSubViews];
    }
    return self;
}
- (void)initData
{
    _topImageArray = [NSArray arrayWithObjects:@"TPWhiteBoard.bundle/WB_DrawIcon",
                      @"TPWhiteBoard.bundle/WB_EraserIcon",
                      @"TPWhiteBoard.bundle/WB_MoveIcon",
                      @"TPWhiteBoard.bundle/WB_ColorPickerIcon", nil];
    _topSelectedImageArray = [NSArray arrayWithObjects:
                              @"TPWhiteBoard.bundle/WB_DrawIconSelected",
                              @"TPWhiteBoard.bundle/WB_EraserIconSelected",
                              @"TPWhiteBoard.bundle/WB_MoveSelectedIcon",
                              @"TPWhiteBoard.bundle/WB_ColorPickerIcon", nil];
}

- (void)initSubViews
{
    
    TPSuperBoardScrollView *whiteBoardScrollView = [[TPSuperBoardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tpWidth, self.tpHeight -44)];
    whiteBoardScrollView.mainView = self;
    _scrollView = whiteBoardScrollView;
    [self addSubview:whiteBoardScrollView];
    
    TPSuperBoardRightView *rightView = [[TPSuperBoardRightView alloc] initWithFrame:CGRectMake(self.tpWidth - RIGHTVIEW_WIDTH, RIGHTVIEW_TOP, RIGHTVIEW_WIDTH, self.tpHeight - RIGHTVIEW_TOP - 50)];
    _rightView = rightView;
    rightView.backgroundColor = [UIColor tpColorWithRed:81 green:82 blue:85];
    [self addSubview:rightView];
    [self initFourButton];
    
    TPSuperBoardBottomView *bottomView= [[TPSuperBoardBottomView alloc] initWithFrame:CGRectMake(0, self.tpHeight - 44, self.tpWidth, 44)];
    bottomView.mainView = self;
    [self addSubview:bottomView];
    
    TPSuperBoardMiniMapView *airscapeView = [[TPSuperBoardMiniMapView alloc] initWithFrame:CGRectMake(10, 10, 40, 40 * _scrollView.tpHeight/_scrollView.tpWidth)];
    _airscapeView = airscapeView;
    [self addSubview:airscapeView];
    
}

- (void)initFourButton
{
    CGFloat btnSep = (self.tpWidth - TOPBUTTON_WIDTH * 4)/5;
    for (int i=0; i<_topImageArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnSep + (btnSep + TOPBUTTON_WIDTH) *i, self.tpHeight - TOPBUTTON_HEIGHT -44, TOPBUTTON_WIDTH, TOPBUTTON_HEIGHT);
        NSString *iconImageName = [_topImageArray objectAtIndex:i];
        NSString *iconImageNameSelected = [_topSelectedImageArray objectAtIndex:i];
        UIImage *iconImage = [UIImage imageNamed:iconImageName];
        UIImage *iconImageSelected = [UIImage imageNamed:iconImageNameSelected];
        [btn setBackgroundImage:iconImage forState:UIControlStateNormal];
        [btn setBackgroundImage:iconImageSelected forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200 +i;
        [self addSubview:btn];
    }
    
    UIView *lastBtnView = [self viewWithTag:203];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(TOPBUTTON_WIDTH * 0.32, TOPBUTTON_HEIGHT *0.64, TOPBUTTON_WIDTH * 0.38, TOPBUTTON_WIDTH * 0.38)];
    _colorView = colorView;
    colorView.userInteractionEnabled = NO;
    colorView.backgroundColor = [TPSuperBoardPenStyleModel sharedInstance].color;
    colorView.layer.cornerRadius = colorView.tpWidth/2;
    [lastBtnView addSubview:colorView];
    [self bottomBtnClicked:(UIButton *)[self viewWithTag:200]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDidChange) name:kNotification_TPSuperBoard_ColorDidChaged object:nil];
}
- (void)colorDidChange
{
    _colorView.backgroundColor = [TPSuperBoardPenStyleModel sharedInstance].color;
}

- (void)bottomBtnClicked:(UIButton *)btn
{
    _scrollView.scrollEnabled = NO;
    TPSuperBoardPenStyleModel *penStyleModel = [TPSuperBoardPenStyleModel sharedInstance];
    penStyleModel.isEraser = NO;

    for (int i=200; i<204; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        button.selected = NO;
    }
    btn.selected = YES;
    if (btn.tag == 200) {
        //选择画笔样式
        [_rightView showRightView];
        
    }else if (btn.tag == 201){
        //切换到橡皮擦模式
        
        penStyleModel.isEraser = YES;
    }else if (btn.tag == 202){
        //移动
        _scrollView.scrollEnabled = YES;
    }else if (btn.tag == 203){
        //选择画笔颜色
        [self showColorPickView];
    }
        
}

- (void)showColorPickView
{
    TPSuperBoardColorPickerView *pickerView = [[TPSuperBoardColorPickerView alloc] initWithFrame:CGRectMake(0, self.tpHeight - 60 - 44, self.tpWidth, 60)];
    [self addSubview:pickerView];
}

#pragma mark - 选中了图片
- (void)selectedWithImage:(UIImage *)image
{
    [_scrollView selectedWithImage:image];
    
}

- (void)undoPreStep
{
    [_scrollView undoPreStep];
}

- (void)backOneStep
{
    [_scrollView backOneStep];
}

- (void)clearAll
{
    [_scrollView clearAll];
}
//截图
- (UIImage *)getImage
{
    return [_scrollView getImage];
}

//scroview滑动，更新鸟瞰图
- (void)showViewLocatedX:(CGFloat)xPercent y:(CGFloat)yPercent sizeScale:(CGFloat)scale thumbnailImage:(UIImage *)thumbnailImage
{
    [_airscapeView showViewLocatedX:xPercent y:yPercent sizeScale:scale thumbnailImage:thumbnailImage];
}


#pragma mark 滑动图片
- (void)imageViewPaned:(UIPanGestureRecognizer *)panGes
{
    UIView *gestureView = panGes.view;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        _prePoint = [panGes locationInView:gestureView];
        
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [panGes locationInView:gestureView];
        
        _prePoint = newPoint;
        
    }else if (panGes.state == UIGestureRecognizerStateCancelled){
        
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        
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
