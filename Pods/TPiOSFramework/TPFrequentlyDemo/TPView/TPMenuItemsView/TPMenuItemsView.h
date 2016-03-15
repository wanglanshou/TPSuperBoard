//
//  TPMenuItemsView.h
//  TPUIKit
//
//  Created by wang on 16/3/10.
//  Copyright © 2016年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPMenuItemsView;
@protocol TPMenuItemsViewDataSource <NSObject>

@required
- (NSInteger) tpMenuItemRows:(TPMenuItemsView *)menuItemsView ;

- (UIImage *) tpMenuItemsView:(TPMenuItemsView *)menuItemsView imageForCellIndex:(NSInteger)index;


@end

@protocol TPMenuItemsViewDataDelegate <NSObject>
@optional
/**
 *  选中了某个工具栏
 *
 *  @param menuItemsView 工具栏选择视图
 *  @param menuItemIndex 工具栏选中的index
 */
- (void) tpMenuItemsView:(TPMenuItemsView *)menuItemsView didSelectedCellAtIndex:(NSInteger)menuItemIndex;

/**
 *  选中了某个
 *
 *  @param menuItemsView  <#menuItemsView description#>
 *  @param menuItemIndex  <#menuItemIndex description#>
 *  @param operationIndex <#operationIndex description#>
 */
- (void) tpMenuItemsView:(TPMenuItemsView *)menuItemsView didSelectedCellAtIndex:(NSInteger)menuItemIndex moreOperationIndex:(NSInteger)operationIndex;

@end

typedef NS_ENUM(NSInteger, TPMenuItemsViewType) {

    TPMenuItemsViewTypeLeft = 10,//左边 operationView从右边展开
    TPMenuItemsViewTypeRight//右边 operationview 从左边展开
};


@interface TPMenuItemsView : UIView

@property (nonatomic, weak) id<TPMenuItemsViewDataSource> dataSource;
@property (nonatomic, weak) id<TPMenuItemsViewDataDelegate> delegate;
@property (nonatomic, assign) TPMenuItemsViewType styleType;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat seperateLength;//两个item之间的距离

/**
 *  刷新所有工具栏
 */
- (void) reloadMenus;
/**
 *  刷新某个工具栏
 *
 *  @param index <#index description#>
 */
- (void) reloadMenuItemAtIndex:(NSInteger)index;

/**
 *  显示更多操作
 *
 *  @param images <#images description#>
 *  @param index  <#index description#>
 */
- (void) showMoreOperationsWithImages:(NSArray *)images atIndex:(NSInteger)index;

/**
 *  如果已经展开，则收起功能栏
 */
- (void) unExpand;

@end
