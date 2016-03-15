//
//  TPMenuItemsView.m
//  TPUIKit
//
//  Created by wang on 16/3/10.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "TPMenuItemsView.h"

#import "Masonry.h"

@interface TPMenuItemsView()
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) NSMutableArray *operationItems;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation TPMenuItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuItems = [[NSMutableArray alloc] init];
        self.operationItems = [[NSMutableArray alloc] init];
        self.itemSize = CGSizeMake(44, 44);
        self.seperateLength = 20;
        self.styleType = TPMenuItemsViewTypeLeft;//默认是在左边
        self.selectedIndex = -1;
    }
    return self;
}

- (void)setDataSource:(id<TPMenuItemsViewDataSource>)dataSource{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    [self tryReloadMenus];
}

- (void)tryReloadMenus{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadMenus) object:nil];
    [self performSelector:@selector(reloadMenus) withObject:nil afterDelay:0.1];
}


- (void) reloadMenus{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(tpMenuItemRows:)]) {
            NSInteger row = [self.dataSource tpMenuItemRows:self];
            if(self.menuItems.count > row){
                //将多余的item删除
                NSMutableIndexSet *removeItemsIndexSet = [[NSMutableIndexSet alloc] init];
                [removeItemsIndexSet addIndexesInRange:NSMakeRange(row, self.menuItems.count)];
                NSArray *removeItems = [self.menuItems objectsAtIndexes:removeItemsIndexSet];
                [removeItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.menuItems removeObjectsAtIndexes:removeItemsIndexSet];
            }
            if(self.menuItems.count < row){
                for (NSInteger i=self.menuItems.count; i<row; i++) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.tag = 100 * i;
                    button.backgroundColor = [UIColor whiteColor];
                    [button addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                    [self.menuItems addObject:button];
                }
            }
            for (int i=0; i<self.menuItems.count; i++) {
                UIButton *menuItem = self.menuItems[i];
                if (i == 0) {
                    [menuItem mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(self.itemSize);
                        make.top.mas_equalTo(self.seperateLength);
                        make.centerX.equalTo(self);
                    }];
                }else{
                    UIButton *preItem = self.menuItems[i - 1];
                    [menuItem mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(preItem.mas_bottom).with.offset(self.seperateLength);
                        make.size.mas_equalTo(self.itemSize);
                        make.centerX.equalTo(preItem);
                    }];
                }
                if ([self.delegate respondsToSelector:@selector(tpMenuItemsView:imageForCellIndex:)]) {
                    UIImage *image = [self.dataSource tpMenuItemsView:self imageForCellIndex:i];
                    [menuItem setImage:image forState:UIControlStateNormal];
                }
                [menuItem setNeedsLayout];
            }
        }else{
            NSAssert(1, @"%@ didn't implement datasouce : - (NSInteger) tpMenuItemRows:(TPMenuItemsView *)menuItemsView ; ",self);
        }
    });
}
- (void)reloadMenuItemAtIndex:(NSInteger)index{
    NSAssert(index <= self.menuItems.count, @"index过大");
    if ([self.delegate respondsToSelector:@selector(tpMenuItemsView:imageForCellIndex:)]) {
        UIButton *menuItem = self.menuItems[index];
        UIImage *image = [self.dataSource tpMenuItemsView:self imageForCellIndex:index];
        [menuItem setImage:image forState:UIControlStateNormal];
    }
}

/**
 *   选中了某个menuitem
 *
 *  @param menuItem <#menuItem description#>
 */
- (void)menuItemClicked:(UIButton *)menuItem{
    NSInteger menuIndex = menuItem.tag / 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tpMenuItemsView:didSelectedCellAtIndex:)]) {
        [self.delegate tpMenuItemsView:self didSelectedCellAtIndex:menuIndex];
    }
}

#pragma mark - moreoperation

/**
 *  显示更多操作
 *
 *  @param images <#images description#>
 *  @param index  <#index description#>
 */
- (void) showMoreOperationsWithImages:(NSArray *)images atIndex:(NSInteger)index{
    
    if (self.selectedIndex == index) {
        //unexpand
        [self unExpand];
        return;
    }
    self.selectedIndex = index;
    UIButton *menuItem = self.menuItems[index];
    for (int i=0; i< images.count; i++) {
        UIImage *operationImage = images[i];
        UIButton *operationBtn = [[UIButton alloc] init];
        [operationBtn setImage:operationImage forState:UIControlStateNormal];
        operationBtn.tag = menuItem.tag * 10 + i;
        [operationBtn addTarget:self action:@selector(menuItemOperationClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:operationBtn];
        [operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat xOffset = (i + 1) * (self.itemSize.width + 10);
            if (self.styleType == TPMenuItemsViewTypeRight) {
                xOffset = 0 - xOffset;
            }
            make.leading.equalTo(menuItem).with.offset(xOffset);
            make.size.equalTo(menuItem);
            make.top.equalTo(menuItem.mas_top);
        }];
        [self.operationItems addObject:operationBtn];
    }
    
}


/**
 *  点击了某个功能栏
 *
 *  @param operationItem <#operationItem description#>
 */
- (void)menuItemOperationClicked:(UIButton *)operationItem{

    if (self.delegate && [self.delegate respondsToSelector:@selector(tpMenuItemsView:didSelectedCellAtIndex:moreOperationIndex:)]) {
        NSInteger operationIndex = operationItem.tag % 1000;
        NSInteger menuIndex = operationItem.tag /1000;
        [self.delegate tpMenuItemsView:self didSelectedCellAtIndex:menuIndex moreOperationIndex:operationIndex];
    }
    [self.operationItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.operationItems removeAllObjects];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        return hitView;
    }
    [self.operationItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.operationItems removeAllObjects];
    return nil;
}

/**
 *  如果已经展开，则收起功能栏
 */
- (void) unExpand{
    [self.operationItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.operationItems removeAllObjects];
    self.selectedIndex = -1;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
