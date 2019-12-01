//
//  WMZDropCustomView.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropDwonMenuConfig.h"
#import "WMZDropMenuTool.h"
NS_ASSUME_NONNULL_BEGIN
@interface WMZDropIndexPath : NSObject
//section对应标题的列
@property(nonatomic,assign)NSInteger section;
//row对应联动的层级
@property(nonatomic,assign)NSInteger row;
//对应key
@property(nonatomic,strong)NSString* key;
//collectionView一行多少个cell 默认4个
@property(nonatomic,assign)NSInteger collectionCellRowCount;
//固定collectionViewCell高度 default 35
@property(nonatomic,assign)CGFloat cellHeight;
//headView高度
@property(nonatomic,assign)CGFloat headViewHeight;
//footView高度
@property(nonatomic,assign)CGFloat footViewHeight;
//显示UI类型
@property(nonatomic,assign)MenuUIStyle UIStyle;
//编辑类型
@property(nonatomic,assign)MenuEditStyle editStyle;
//出现的动画类型 默认最后一个 MenuShowAnimalRight 其他 MenuShowAnimalBottom
@property(nonatomic,assign)MenuShowAnimalStyle showAnimalStyle;
//消失的动画类型 默认最后一个 MenuHideAnimalLeft 其他 MenuShowAnimalBottom
@property(nonatomic,assign)MenuHideAnimalStyle hideAnimalStyle;
//是否展开 default YES
@property(nonatomic,assign)BOOL expand;
//是否显示展开 default NO
@property(nonatomic,assign)BOOL showExpand;
//点击关闭 default YES 最后一个默认NO
@property(nonatomic,assign)BOOL tapClose;
//选中其他标题 此dropIndexPath会不会取消选中状态 dfault NO
@property(nonatomic,assign)BOOL connect;
//标题
@property(nonatomic,copy)NSString* title;
- (instancetype)initWithSection:(NSInteger)section row:(NSInteger)row;
@end

//自定义tableview
@interface WMZDropTableView : UITableView
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

//自定义collection
@interface WMZDropCollectionView : UICollectionView
@property(nonatomic,strong)WMZDropIndexPath* dropIndex;
@property(nonatomic,strong)NSArray* dropArr;
@end

//自定义collectionViewCell
@interface WMZMenuCell : UICollectionViewCell
@property(nonatomic,strong)UIButton *btn;
@end


typedef void (^MenuTextFieldCellBlock)(UITextField *textField,NSString *string);
//自定义collectionViewCell uitextField
@interface WMZMenuTextFieldCell : UICollectionViewCell
@property(nonatomic,copy)NSString *lowT;
@property(nonatomic,copy)NSString *highT;
@property(nonatomic,strong)UITextField *lowText;
@property(nonatomic,strong)UILabel *lineLa;
@property(nonatomic,strong)UITextField *highText;
@property(nonatomic,copy)MenuTextFieldCellBlock myBlock;
@end

//自定义collectionView head
@interface WMZDropCollectionViewHeadView : UICollectionReusableView
@property(nonatomic,strong)WMZDropIndexPath *dropIndexPath;
@property(nonatomic,strong)UILabel* textLa;
@property(nonatomic,strong)UIButton* accessTypeBtn;
@end

//自定义collectionView foot
@interface WMZDropCollectionViewFootView : WMZDropCollectionViewHeadView
@end

@interface WMZDropConfirmView : UIView
//resetBtn的frame
@property(nonatomic,strong)NSValue* resetFrame;
//confirmBtn的frame
@property(nonatomic,strong)NSValue* confirmFrame;
//显示上下划线
@property(nonatomic,assign)BOOL showBorder;
//显示半圆角 淘宝样式
@property(nonatomic,assign)BOOL showRdio;
@property(nonatomic,strong)UIButton *resetBtn;
@property(nonatomic,strong)UIButton *confirmBtn;
@end


@interface WMZDropBossHeadView : UIView
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UILabel *titleLa;
@property(nonatomic,strong)UIButton *rightbtn;
@end

NS_ASSUME_NONNULL_END
