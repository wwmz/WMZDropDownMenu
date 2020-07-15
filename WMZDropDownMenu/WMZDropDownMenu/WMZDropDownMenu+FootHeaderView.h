//
//  WMZDropDownMenu+FootHeaderView.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//
#import "WMZDropDownMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZDropDownMenu (FootHeaderView)
//添加全局的头尾
- (void)addHeadFootView:(NSArray*)connectViews screnFrame:(MenuShowAnimalStyle)screnFrame;
@end

NS_ASSUME_NONNULL_END
