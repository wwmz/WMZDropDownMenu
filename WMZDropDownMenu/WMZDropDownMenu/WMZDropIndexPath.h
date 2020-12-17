//
//  WMZDropIndexPath.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropDwonMenuConfig.h"

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
//collectionview的每行 的编辑类型 固定宽度|自适应宽度  默认固定宽度 只对collectionviewcell生效
@property(nonatomic,assign)MenuCollectionUIStyle collectionUIStyle;
//自定义宽度对齐方式
@property(nonatomic,assign)MenuCellAlignType alignType;
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
//初始化方法
- (instancetype)initWithSection:(NSInteger)section row:(NSInteger)row;
@end


//树形节点model  传入对应的字典键值对就能获取相应的属性
@interface WMZDropTree:NSObject
//深度
@property(nonatomic,assign)NSInteger depth;
//名字
@property(nonatomic,copy)NSString *name;
//图片
@property(nonatomic,copy)NSString *image;
//对应id 唯一
@property(nonatomic,copy)NSString *ID;
//Cell高度 default 35
@property(nonatomic,assign)CGFloat cellHeight;
//其他携带数据
@property(nonatomic,strong)id otherData;
//配置
@property(nonatomic,strong)NSDictionary *config;
//是否选中
@property(nonatomic,assign)BOOL isSelected;
//范围
@property(nonatomic,strong)NSMutableArray *rangeArr;
//初始范围
@property(nonatomic,strong)NSArray *normalRangeArr;
//低位提示语
@property(nonatomic,copy)NSString *lowPlaceholder;
//高位提示语
@property(nonatomic,copy)NSString *highPlaceholder;
//子集
@property(nonatomic,strong)NSMutableArray<WMZDropTree *> *children;
//原来传过来的数据模型
@property(nonatomic,strong)id originalData;
//点击查看更多 default NO
@property(nonatomic,assign)BOOL checkMore;
//数据存在但不显示 default NO
@property(nonatomic,assign)BOOL hide;
//点击关闭 default YES
@property(nonatomic,assign)BOOL tapClose;
//textField 可以输入 default YES （输入框）
@property(nonatomic,assign)BOOL canEdit;
//textField 第几个 输入框）
@property(nonatomic,assign)NSInteger index;

//字体大小  default nil
@property(nonatomic,assign)UIFont *font;
//选中的字体大小 default nil
@property(nonatomic,assign)UIFont *selectFont;

//cell宽度 default 0 
@property(nonatomic,assign)CGFloat cellWidth;

- (instancetype)initWithDetpth:(NSInteger)depth withName:(NSString*)name  withID:(NSString*)ID;
@end

NS_ASSUME_NONNULL_END
