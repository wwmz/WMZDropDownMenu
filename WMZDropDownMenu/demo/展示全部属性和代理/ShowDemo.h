//
//  ShowDemo.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMZDropDownMenu.h"
@interface ShowDemo : UIViewController
@end

//自定义tableviewCell
@interface ViewCustomCell : UITableViewCell
@property(nonatomic,strong)UIButton *accessTypeBtn;
@property(nonatomic,strong)UILabel *textLa;
@end
//自定义tableview head
@interface TableViewCustomHeadView : UITableViewHeaderFooterView
@property(nonatomic,strong)UILabel *backView;
@end
//自定义tableview foot
@interface TableViewCustomFootView : TableViewCustomHeadView
@end


//自定义tableviewCell
@interface ViewCustomCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *textLa;
@end
//自定义tableview head
@interface CollectionViewCustomHeadView : WMZDropCollectionViewHeadView
@property(nonatomic,strong)UILabel *backView;
@end
//自定义tableview foot
@interface CollectionViewCustomFootView : WMZDropCollectionViewHeadView
@end

