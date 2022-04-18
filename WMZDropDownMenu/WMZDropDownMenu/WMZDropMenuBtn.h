//
//  WMZDropMenuBtn.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/20.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZDropDwonMenuConfig.h"
#import <objc/runtime.h>
#import "WMZDropMenuParam.h"
#import "WMZDropMenuTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZDropMenuBtn : UIButton
/// 选中type
@property (nonatomic, assign) NSInteger selectType;    //复选情况

@property (nonatomic, assign) MenuBtnPosition position;

@property (nonatomic, assign) BOOL click;
/// 初始标题
@property (nonatomic, copy) NSString *normalTitle;
/// select标题
@property (nonatomic, copy) NSString *selectTitle;
/// 双重点击的标题
@property (nonatomic, copy) NSString *reSelectTitle;
/// 普通状态下的颜色
@property (nonatomic, strong) UIColor *normalColor;
/// selected颜色
@property (nonatomic, strong) UIColor *selectColor;
/// 普通状态下的图片
@property (nonatomic, copy) NSString *normalImage;
/// selected图片
@property (nonatomic, copy) NSString *selectImage;
/// 双重点击的图片
@property (nonatomic, copy) NSString *reSelectImage;
/// 参数
@property (nonatomic, strong) WMZDropMenuParam *param;

@property (nonatomic, assign) BOOL clear;

@property (nonatomic, assign) NSInteger index;
/// 设置按钮配置
- (void)setUpParam:(WMZDropMenuParam*)param withDic:(id)dic;

@end

@interface WMZDropMenuBtn (WMZLine)

@property (nonatomic, strong) UIView *line;
/// 显示下划线
- (void)showLine:(NSDictionary*)config;
/// 隐藏下划线
- (void)hidenLine;

@end

@interface WMZDropMenuBtn (Time)
/// 防止button重复点击，设置间隔
@property (nonatomic, assign) NSTimeInterval tj_acceptEventInterval;

@end


@interface WMZDropIndexPath : NSObject
/// section对应标题的列
@property (nonatomic, assign) NSInteger section;
/// row对应联动的层级
@property (nonatomic, assign) NSInteger row;
/// 对应key
@property (nonatomic, strong) NSString *key;
/// collectionView一行多少个cell 默认4个
@property (nonatomic, assign) NSInteger collectionCellRowCount;
/// 固定collectionViewCell高度 default 35
@property (nonatomic, assign) CGFloat cellHeight;
/// headView高度
@property (nonatomic, assign) CGFloat headViewHeight;
/// footView高度
@property (nonatomic, assign) CGFloat footViewHeight;
/// 显示UI类型
@property (nonatomic, assign) MenuUIStyle UIStyle;
/// 编辑类型
@property (nonatomic, assign) MenuEditStyle editStyle;
/// 出现的动画类型 默认最后一个 MenuShowAnimalRight 其他 MenuShowAnimalBottom
@property (nonatomic, assign) MenuShowAnimalStyle showAnimalStyle;
/// 消失的动画类型 默认最后一个 MenuHideAnimalLeft 其他 MenuShowAnimalBottom
@property (nonatomic, assign) MenuHideAnimalStyle hideAnimalStyle;
/// collectionview的每行 的编辑类型 固定宽度|自适应宽度  默认固定宽度 只对collectionviewcell生效
@property (nonatomic, assign) MenuCollectionUIStyle collectionUIStyle;
/// 自定义宽度对齐方式
@property (nonatomic, assign) MenuCellAlignType alignType;
/// 是否展开 default YES
@property (nonatomic, assign) BOOL expand;
/// 是否显示展开 default NO
@property (nonatomic, assign) BOOL showExpand;
/// 点击关闭 default YES 最后一个默认NO
@property (nonatomic, assign) BOOL tapClose;
/// 选中其他标题 此dropIndexPath会不会取消选中状态 dfault NO
@property (nonatomic, assign) BOOL connect;
/// 标题
@property (nonatomic, copy) NSString* title;
/// 初始化方法
- (instancetype)initWithSection:(NSInteger)section row:(NSInteger)row;

@end


/// 树形节点model  传入对应的字典键值对就能获取相应的属性
@interface WMZDropTree:NSObject
/// inputStyle
@property (nonatomic, assign) MenuInputStyle inputStyle;
/// 深度
@property (nonatomic, assign) NSInteger depth;
/// 名字
@property (nonatomic, copy, nullable) NSString *name;
/// 图片
@property (nonatomic, copy, nullable) NSString *image;
/// 对应id 唯一
@property (nonatomic, copy, nullable) NSString *ID;
/// Cell高度 default 35
@property (nonatomic, assign) CGFloat cellHeight;
/// 其他携带数据
@property (nonatomic, strong) id otherData;
/// 配置
@property (nonatomic, strong) NSDictionary *config;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 范围
@property (nonatomic, strong, nullable) NSMutableArray *rangeArr;
/// 初始范围
@property (nonatomic, strong, nullable) NSArray *normalRangeArr;
/// 低位提示语
@property (nonatomic, copy, nullable) NSString *lowPlaceholder;
/// 高位提示语
@property( nonatomic, copy, nullable) NSString *highPlaceholder;
/// 子集
@property (nonatomic, strong) NSMutableArray<WMZDropTree *> *children;
/// 原来传过来的数据模型
@property (nonatomic, strong, nullable) id originalData;
/// 点击查看更多 default NO
@property (nonatomic, assign) BOOL checkMore;
/// 数据存在但不显示 default NO
@property (nonatomic, assign) BOOL hide;
/// 点击关闭 default YES
@property (nonatomic, assign) BOOL tapClose;
/// textField 可以输入 default YES （输入框）
@property (nonatomic, assign) BOOL canEdit;
/// textField 第几个 输入框）
@property (nonatomic, assign) NSInteger index;
/// 字体大小  default nil
@property (nonatomic, strong, nullable) UIFont *font;
/// 选中的字体大小 default nil
@property (nonatomic, strong, nullable) UIFont *selectFont;
/// cell宽度 default 0
@property (nonatomic, assign) CGFloat cellWidth;
/// 所在path
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;
/// 所在dropPath
@property (nonatomic, strong, nullable) WMZDropIndexPath *dropPath;

- (instancetype)initWithDetpth:(NSInteger)depth withName:(NSString*)name  withID:(NSString*)ID;

@end

NS_ASSUME_NONNULL_END
