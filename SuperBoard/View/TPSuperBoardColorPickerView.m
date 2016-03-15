//
//  TPWhiteBoardColorPickerView.m
//  tupo
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 张珏. All rights reserved.
//

#import "TPSuperBoardColorPickerView.h"
#import "TPSuperBoardPenStyleModel.h"

#import "TPSuperboardDefine.h"
@interface TPSuperBoardColorPickerView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *_colorArray;
    UICollectionView *_collectionView;
}
@end


@implementation TPSuperBoardColorPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self initData];
        [self initSubview];
    }
    return self;
}

- (void)initData
{
    _colorArray = [NSArray arrayWithObjects:
                   [UIColor tpColorWithRed:255 green:228 blue:43],
                   [UIColor tpColorWithRed:255 green:137 blue:65],
                   [UIColor tpColorWithRed:255 green:59 blue:59],
                   [UIColor tpColorWithRed:230 green:90 blue:209],
                   [UIColor tpColorWithRed:106 green:67 blue:165],
                   [UIColor tpColorWithRed:67 green:74 blue:165],
                   [UIColor tpColorWithRed:31 green:42 blue:107],
                   [UIColor tpColorWithRed:0 green:0 blue:0],
                   [UIColor tpColorWithRed:173 green:244 blue:72],
                   [UIColor tpColorWithRed:62 green:210 blue:55],
                   [UIColor tpColorWithRed:26 green:156 blue:47],
                   [UIColor tpColorWithRed:6 green:104 blue:43],
                   [UIColor tpColorWithRed:104 green:48 blue:6],
                   [UIColor tpColorWithRed:79 green:23 blue:23],
                   [UIColor tpColorWithRed:125 green:125 blue:125],
                   [UIColor tpColorWithRed:57 green:57 blue:57],nil];
}
- (void)initSubview
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor tpColorWithRed:74 green:74 blue:74];
    [self addSubview:collectionView];
    
    [collectionView registerClass:[TPSuperBoardColorPickerViewColorCell class] forCellWithReuseIdentifier:@"cellid"];
}


#pragma mark - collectionview datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@" 1111 expectsize  width %f  height %f",_collectionView.contentSize.width,_collectionView.contentSize.height);
    return CGSizeMake(44,44);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        NSLog(@"2222  expectsize  width %f  height %f",_collectionView.contentSize.width,_collectionView.contentSize.height);
    return _colorArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"expectsize  width %f  height %f",_collectionView.contentSize.width,_collectionView.contentSize.height);
    
    if (indexPath.row == 0) {
        CGSize expectSize = _collectionView.contentSize;
        CGRect expectFrame = CGRectMake(_collectionView.tpLeft, self.tpBottom - expectSize.height, expectSize.width, expectSize.height);
        self.frame = expectFrame;
        collectionView.frame = self.bounds;
    }
   
    
    
    TPSuperBoardColorPickerViewColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    UIColor *color = [_colorArray objectAtIndex:indexPath.row];
    
    if (CGColorEqualToColor(color.CGColor, [TPSuperBoardPenStyleModel sharedInstance].color.CGColor) ) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
    [cell setColor:color];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TPSuperBoardPenStyleModel *penStyleModel = [TPSuperBoardPenStyleModel sharedInstance];
    penStyleModel.color = [_colorArray objectAtIndex:indexPath.row];
    
    [self removeFromSuperview];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation TPSuperBoardColorPickerViewColorCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    _showColorView = colorView;
    colorView.layer.cornerRadius = 15;
    [self addSubview:colorView];
}

- (void)setColor:(UIColor *)color
{
    _showColorView.backgroundColor = color;
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        _showColorView.layer.borderColor = [UIColor whiteColor].CGColor;
        _showColorView.layer.borderWidth = 5.0;
    }else{
        _showColorView.layer.borderColor = [UIColor clearColor].CGColor;
        _showColorView.layer.borderWidth = 5.0;
    }
}

@end
