//
//  WMZDropMenuDelegate.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZDropShowViewProcotol.h"

@class WMZDropDownMenu,WMZDropIndexPath,WMZDropDwonMenuConfig,
       WMZDropTree,WMZDropTableView,WMZDropCollectionView,
       WMZDropConfirmView,WMZDropMenuBtn;

NS_ASSUME_NONNULL_BEGIN
@protocol WMZDropMenuDelegate <NSObject>
#pragma -mark data相关代理
@required

/// 标题数组
/// NSArray<NSString*> 或 NSArray<WMZMenuTitleKey>
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu;

/// 返回WMZDropIndexPath每行 每列的数据
/// 可传@[@{},@{},@{}] 带字典的数组
/// 如果要传model过去可以这么传
/// @[
///   @{WMZMenuTitleNormal:@"1",@"otherData":model},
///   @{WMZMenuTitleNormal:@"1",@"otherData":model},
///   @{WMZMenuTitleNormal:@"1",@"otherData":model}
/// ]
/// 字典里 WMZDropTree类的属性都可以传 为对应的key
/// 例如@{@"isSelected":@(YES),@"ID":@""...1}
- (NSArray*)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
@optional
///返回setion行标题有多少列 默认1列
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section;

#pragma -mark 视图相关 新增
///弹出视图的Y值 可动态改变 （例如滚动时候动态改变此值）
- (CGFloat)popFrameY;
/// 放在scrollView/tableview/collectionview上 放tableview等视图必传
- (UIScrollView*)inScrollView;

#pragma -mark cell相关代理
/// 自定义tableviewCell内容 默认WMZDropTableViewCell 如果要使用默认的cell返回 nil
- (nullable UITableViewCell*)menu:(WMZDropDownMenu *)menu cellForUITableView:(WMZDropTableView*)tableView AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model;
/// 自定义tableView headView
- (nullable UITableViewHeaderFooterView*)menu:(WMZDropDownMenu *)menu headViewForUITableView:(WMZDropTableView*)tableView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 自定义tableView footView
- (nullable UITableViewHeaderFooterView*)menu:(WMZDropDownMenu *)menu footViewForUITableView:(WMZDropTableView*)tableView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 自定义collectionViewCell内容
- (nullable UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView
    AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model;
/// 自定义collectionView headView
- (nullable UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath;
/// 自定义collectionView footView
- (nullable UICollectionReusableView*)menu:(WMZDropDownMenu *)menu footViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath;
/// headView标题
- (nullable NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// footView标题
- (nullable NSString*)menu:(WMZDropDownMenu *)menu titleForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath;
/// 自定义headView高度 collectionView默认35
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 自定义footView高度
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;

#pragma -mark 自定义用户交互的每行的头尾视图
/// 自定义每行全局头部视图 多用于交互事件 传入[UIView new]为不需要此头部 传入nil为默认的头部
- (nullable UIView*)menu:(WMZDropDownMenu *)menu userInteractionHeadViewInSection:(NSInteger)section;
/// 自定义每行全局尾部视图 多用于交互事件 传入[UIView new]为不需要此尾部 传入nil为默认的尾部
- (nullable UIView*)menu:(WMZDropDownMenu *)menu userInteractionFootViewInSection:(NSInteger)section;

#pragma -mark 样式动画相关代理
/// 返回WMZDropIndexPath每行 每列的UI样式  默认MenuUITableView
///  注:设置了dropIndexPath.section 设置了 MenuUITableView 那么row则全部为MenuUITableView 保持统一风格
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 返回section行标题数据视图出现的动画样式   默认 MenuShowAnimalBottom
/// 注:最后一个默认是筛选 弹出动画为 MenuShowAnimalRight
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section;
/// 返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
/// 注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section;
/// 返回WMZDropIndexPath每行 每列的编辑类型 单选|多选  默认单选
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 返回collectionview的每行 的编辑类型 固定宽度|自适应宽度  默认固定宽度 只对collectionviewcell生效
- (MenuCollectionUIStyle)menu:(WMZDropDownMenu *)menu cellFixStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 返回collectionview的每行自定义宽度的对齐方式  MenuCollectionUIStyle = MenuCollectionUIFit有效
- (MenuCellAlignType)menu:(WMZDropDownMenu *)menu collectionAlignFitTypeForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 返回WMZDropIndexPath每行 每列 显示的个数
/// 注:样式MenuUITableView         默认4个
/// 样式MenuUICollectionView    默认1个 传值无效
- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// WMZDropIndexPath是否显示收缩功能 default >参数wCollectionViewSectionShowExpandCount 显示
- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// WMZDropIndexPath上的内容点击 是否关闭视图 default YES
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
/// 是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES 取消，互不关联
- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section;
/// 互斥的标题数组 即互斥不能同时选中 返回标题对应的section (配合关联代理使用更加)
- (NSArray*)mutuallyExclusiveSectionsWithMenu:(WMZDropDownMenu *)menu;
/// 查看更多的数据
- (NSArray*)menu:(WMZDropDownMenu *)menu moreDataForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;

#pragma -mark 交互自定义代理
/// cell点击方法
- (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath
   dataIndexPath:(NSIndexPath*)indexpath data:(WMZDropTree*)data;
/// 标题点击方法
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn*)selectBtn;
/// 标题点击方法 多了一个block 用于网络请求完数据 再打开 block() 为请求数据结束的标识
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn*)selectBtn networkBlock:(MenuAfterTime)block;
/// 确定方法 多个选择
/// @param selectNoramalData 转化后的的模型数据
/// @param selectData 字符串数据
- (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection:(NSInteger)section selectNoramelData:(NSMutableArray*)selectNoramalData selectStringData:(NSMutableArray*)selectData;
/// 获取所有选中的数据
- (void)menu:(WMZDropDownMenu *)menu getAllSelectData:(NSArray*)selectData;
/// 重置方法
- (void)menu:(WMZDropDownMenu *)menu didReSetAtSection:(NSInteger)section;
/// 自定义标题按钮视图  返回配置 参数说明
/// @return offset       按钮的间距
///          y            按钮的y坐标   自动会居中
- (nullable NSDictionary*)menu:(WMZDropDownMenu *)menu  customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn*)menuBtn;
/// 自定义修改默认collectionView尾部视图
- (void)menu:(WMZDropDownMenu *)menu  customDefauultCollectionFootView:(WMZDropConfirmView*)confirmView;
/// 监听关闭视图 可做修改标题文本和颜色的操作
- (void)menu:(WMZDropDownMenu *)menu closeWithBtn:(WMZDropMenuBtn*)selectBtn   index:(NSInteger )index;
/// 监听打开视图 可做修改标题文本和颜色的操作
- (void)menu:(WMZDropDownMenu *)menu openWithBtn:(WMZDropMenuBtn*)selectBtn   index:(NSInteger )index;
/// 更改选中后的标题
/// @param currentTitle 为当前的标题 返回nil 表示用默认的标题
/// @param selectBtn 为当前的标题按钮
/// @return 可传字符串(更改的字符串标题)
///         可传字典(标题和标题颜色) @{WMZMenuTitleNormal:@"标题",WMZMenuTitleSelectColor:[UIColor redColor]}
- (nullable id)menu:(WMZDropDownMenu *)menu changeTitle:(NSString*)currentTitle selectBtn:(WMZDropMenuBtn*)selectBtn atDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSInteger)row;

#pragma -mark 深度自定义
///自定义展开视图 必须实现协议WMZDropShowViewProcotol 使用默认的地方返回nil
- (nullable UIView<WMZDropShowViewProcotol>*)menu:(WMZDropDownMenu *)menu customViewInSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
