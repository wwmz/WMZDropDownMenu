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
- (BOOL)updateData:(NSArray*)arr ForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;


/*
*更新所有位置的数据 section表示所在行 row表示所在列
*/
- (BOOL)updateData:(NSArray*)arr AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row;

/*
*更新全局位置某个数据源的数据 可更换选中状态 显示文字等。。。 根据WMZDropTree 对应属性改变
*/
- (BOOL)updateDataConfig:(NSDictionary*)changeData AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row AtIndexPathRow:(NSInteger)indexPathRow;


/*
*更新所有UI和数据
*/
- (void)updateUI;


/*
*手动关闭
*/
- (void)closeWith:(WMZDropIndexPath*)dropPath row:(NSInteger)row data:(WMZDropTree*)tree;

@end


NS_ASSUME_NONNULL_END
