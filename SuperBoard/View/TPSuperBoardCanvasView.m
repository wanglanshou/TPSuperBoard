//
//  TPWhiteBoardCanvasView.m
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//



#import "TPSuperBoardCanvasView.h"
#import "TPSuperBoardPenStyleModel.h"
#import "TPSuperBoardScrollView.h"

@interface TPSuperBoardCanvasView()
{
    NSMutableArray *_drawArray;//划线记录
    NSInteger _undoCount;//撤销的数量
    
    NSMutableArray *_tempArray;

}

@end


@implementation TPSuperBoardCanvasView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initData];
    }
    return self;
}

- (void)initData {
    _drawArray = [[NSMutableArray alloc] init];
    
}


#pragma mark - 画图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
    if (_undoCount > 0) {
        for (int i=0; i<_undoCount; i++) {
            [_drawArray removeLastObject];
        }
        _undoCount = 0;
    }
  
    _tempArray = [[NSMutableArray alloc] init];
    
    UITouch *touch = touches.anyObject;
    CGPoint locationInView = [touch locationInView:self];
    
    //1 添加画笔的类型
    TPSuperBoardPenStyleModel * brush = [[TPSuperBoardPenStyleModel sharedInstance] copy];
    [_tempArray addObject:brush];
    
    //添加起始坐标
    NSValue *pointValue = [NSValue valueWithCGPoint:locationInView];
    [_tempArray addObject:pointValue];
    [_drawArray addObject:_tempArray];
    
    NSLog(@"touch began   %f    %f",locationInView.x,locationInView.y);
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint locationInView = [touch locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:locationInView];
    [_tempArray addObject:pointValue];
    
    [self setNeedsDisplay];
//    [self.scrollView resetShowViewInPaletteView];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _tempArray = nil;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //如果被中断了，则认为结束了
    _tempArray = nil;
}

- (void)undoPreStep
{
    _undoCount ++;
    _undoCount = MIN(_drawArray.count, _undoCount);
    [self setNeedsDisplay];
}

- (void)backOneStep
{
    _undoCount --;
    _undoCount = MAX(0, _undoCount);
    [self setNeedsDisplay];
}

- (void)clearAll
{
    [_drawArray removeAllObjects];
    [self setNeedsDisplay];
}

- (CGRect)getEffectiveRect
{
    CGFloat minX = MAXFLOAT;
    CGFloat minY = MAXFLOAT;
    
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    
    for (NSArray *tempArray in _drawArray) {
        TPSuperBoardPenStyleModel *model = [tempArray firstObject];
        CGFloat penSize = model.penSize;
        for (int i=1; i<tempArray.count; i++) {
            NSValue *pointValue = [tempArray objectAtIndex:i];
            CGPoint point = [pointValue CGPointValue];
            
            minX = MIN(minX, point.x - penSize);
            minY = MIN(minY, point.y - penSize);
            maxX = MAX(maxX, point.x + penSize);
            maxY = MAX(maxY, point.y + penSize);
        }
    }
   
    return CGRectMake( minX , minY, maxX , maxY );
}


#pragma mark - 绘图

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    if (_drawArray.count == 0) {
        return;
    }
    for (int i=0; i<_drawArray.count - _undoCount; i++) {
        NSArray *array = [_drawArray objectAtIndex:i];
        //第一个元素是画笔的属性
        
        TPSuperBoardPenStyleModel *model = [array firstObject];
        if (model.isEraser) {
            CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);//线条颜色
            CGContextSetLineWidth(context, model.penSize);
        }else{
            CGContextSetStrokeColorWithColor(context, model.color.CGColor);
            CGContextSetLineWidth(context, model.penSize);
        }
        if(!model.isSolidLine && !model.isEraser){
            //虚线
            CGFloat length[] = {5,5};
            CGContextSetLineDash(context, 0, length, 2);
        }else{
            // 实线
            CGFloat length[] = {5,5};
            CGContextSetLineDash(context, 0, length, 0);
        }
        
        if (model.isStraightLine && !model.isEraser) {
            //如果是直线
            NSValue *startPointValue = [array objectAtIndex:1];
            CGPoint startPoint = [startPointValue CGPointValue];
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            
            NSValue *endPointValue = [array lastObject];
            CGPoint endPoint = [endPointValue CGPointValue];
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            CGContextStrokePath(context);
        }else{
            //曲线
            //第二元素是开始点坐标
            NSValue *startPointValue = [array objectAtIndex:1];
            CGPoint startPoint = [startPointValue CGPointValue];
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            for (int i=2; i< array.count; i++) {
                NSValue *pointValue= [array objectAtIndex:i];
                CGPoint point =  [pointValue CGPointValue];
                CGContextAddLineToPoint(context, point.x, point.y);
            }
            CGContextStrokePath(context);
        }
    }
}

@end
