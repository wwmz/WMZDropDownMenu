//
//  WMZDropDownMenu+DealLogic.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//


#import "WMZDropDownMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZDropDownMenu (DealLogic)
//获取当前标题对应的首个drop
- (WMZDropIndexPath*)getTitleFirstDropWthTitleBtn:(WMZDropMenuBtn*)btn;
@end

NS_ASSUME_NONNULL_END
