//
//  WMZDropTableView.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropIndexPath.h"
#import "WMZDropMenuParam.h"
@class WMZDropDownMenu;
NS_ASSUME_NONNULL_BEGIN

//自定义tableview
@interface WMZDropTableView : UITableView
@property(nonatomic,nullable)WMZDropDownMenu *menu;
@property(nonatomic,strong)WMZDropIndexPath* dropIndex;
@end

//自定义tableviewCell
@interface WMZDropTableViewCell : UITableViewCell
@end

//自定义tableview headView
@interface WMZDropTableViewHeadView : UITableViewHeaderFooterView
@property(nonatomic,strong)UILabel* textLa;
@end

//自定义tableview footView
@interface WMZDropTableViewFootView : WMZDropTableViewHeadView
@end

NS_ASSUME_NONNULL_END
