//
//  WMZDropDownMenu.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuBase.h"

NS_ASSUME_NONNULL_BEGIN
@interface WMZDropDownMenu : WMZDropMenuBase
/*
*更新数据 下一列的数据
*/
- (void)updateData:(NSArray*)arr ForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;


/*
*更新所有位置的数据 section表示所在行 row表示所在列
*/
- (void)updateData:(NSArray*)arr AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row;


/*
*更新所有UI和数据
*/
- (void)updateUI;

@end


NS_ASSUME_NONNULL_END
