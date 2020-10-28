//
//  WMZDropCollectionView.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropIndexPath.h"
#import "WMZDropMenuTool.h"
@class WMZDropDownMenu;
NS_ASSUME_NONNULL_BEGIN

//自定义collection
@interface WMZDropCollectionView : UICollectionView
@property(nonatomic,strong)WMZDropIndexPath* dropIndex;
@property(nonatomic,strong)NSArray* dropArr;
@property(nonatomic,nullable)WMZDropDownMenu *menu;
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
@property(nonatomic,strong)WMZDropTree *tree;
@property(nonatomic,copy)MenuTextFieldCellBlock myBlock;
@property(nonatomic,copy)MenuTextFieldCellBlock clickBlock;
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
