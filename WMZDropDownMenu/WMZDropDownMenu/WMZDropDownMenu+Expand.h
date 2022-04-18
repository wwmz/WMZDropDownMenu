//
//  WMZDropDownMenu+Expand.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//
#import "WMZDropDownMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZDropDownMenu (NormalView)
/// 添加ui
- (void)addTableView;
/// 添加全局的头尾
- (void)addHeadFootView:(NSArray*)connectViews screnFrame:(MenuShowAnimalStyle)screnFrame;
/// 获取当前标题对应的首个drop
- (WMZDropIndexPath*)getTitleFirstDropWthTitleBtn:(WMZDropMenuBtn*)btn;
/// 查看更多
- (void)setUpMoreView:(WMZDropIndexPath*)dropPath;

@end

NS_ASSUME_NONNULL_END
