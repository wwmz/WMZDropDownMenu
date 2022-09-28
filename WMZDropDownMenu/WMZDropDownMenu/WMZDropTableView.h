//
//  WMZDropTableView.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//
#import "WMZDropMenuParam.h"
#import "WMZDropShowViewProcotol.h"

NS_ASSUME_NONNULL_BEGIN

/// 自定义tableview
@interface WMZDropTableView : UITableView<WMZDropShowViewProcotol>

@end

/// 自定义tableviewCell
@interface WMZDropTableViewCell : UITableViewCell

@end

/// 自定义tableview headView
@interface WMZDropTableViewHeadView : UITableViewHeaderFooterView
///textLa
@property (nonatomic, strong) UILabel* textLa;

@end

/// 自定义tableview footView
@interface WMZDropTableViewFootView : WMZDropTableViewHeadView

@end

NS_ASSUME_NONNULL_END
