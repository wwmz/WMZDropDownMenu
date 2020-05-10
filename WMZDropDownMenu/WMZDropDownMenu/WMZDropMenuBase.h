//
//  WMZDropMenuBase.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuParam.h"
#import "WMZDropMenuBtn.h"
#import "WMZDropMenuDelegate.h"
#import "WMZDropCustomView.h"
#import "Aspects.h"
#define footHeadHeight 35
#define menuAnimalTime 0.3
#define moreTableViewKey @"moreTableViewKey"
#define menuMainClor [UIColor whiteColor]
NS_ASSUME_NONNULL_BEGIN
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

- (instancetype)initWithDetpth:(NSInteger)depth withName:(NSString*)name  withID:(NSString*)ID;
@end


//基类
@interface WMZDropMenuBase : UIView
/*
*配置
*/
@property(nonatomic,strong)WMZDropMenuParam *param;
/*
*标题数组
*/
@property(nonatomic,strong)NSArray *titleArr;
/*
*DeopindexPath的数组
*/
@property(nonatomic,strong)NSMutableArray *dropPathArr;
/*
*显示的view的数组
*/
@property(nonatomic,strong)NSMutableArray *showView;
/*
*代理
*/
@property(nonatomic,weak)id<WMZDropMenuDelegate> delegate;
/*
*弹出数据层的frame字典
*/
@property(nonatomic,strong)NSMutableDictionary *dataViewFrameDic;
/*
*弹出阴影层的frame字典
*/
@property(nonatomic,strong)NSMutableDictionary *shadomViewFrameDic;
/*
 *数据栏
 */
@property(nonatomic,strong)UIView *dataView;
/*
 *阴影
 */
@property(nonatomic,strong)UIView *shadowView;
/*
 *更多的页面
 */
@property(nonatomic,strong)UIView *moreView;
/*
 *titleView
 */
@property(nonatomic,strong)UIScrollView *titleView;
/*
 *占位图
 */
@property(nonatomic,strong)UIView *emptyView;

/*
*tableVieHeadView
*/
@property (nonatomic, strong) UIView * __nonnull tableVieHeadView;

/*
*confirmView
*/
@property (nonatomic, strong) UIView * __nonnull confirmView;

/*
 *关闭状态
 */
@property(nonatomic,assign)BOOL close;
/*
 *监听到hook
 */
@property(nonatomic,assign)BOOL hook;
/*
 *弹出视图的y值
 */
@property(nonatomic,assign)CGFloat menuOrignY;
/*
 *在tableview上
 */
@property(nonatomic,assign)UITableView *tableView;
/*
 *在tableViewHeadSection上 默认0
 */
@property(nonatomic,assign)NSInteger tableViewHeadSection;
/*
*键盘弹出
*/
@property(nonatomic,assign)BOOL keyBoardShow;
/*
*collectionView
*/
@property(nonatomic,strong)WMZDropCollectionView *collectionView;
/*
*标题按钮数组
*/
@property(nonatomic,strong)NSMutableArray *titleBtnArr;
/*
*当前选中的标题
*/
@property(nonatomic,strong)WMZDropMenuBtn *selectTitleBtn;
/*
*上次选中的标题
*/
@property(nonatomic,assign)NSInteger lastSelectIndex;
/*
*全部的数据源
*/
@property(nonatomic,strong)NSMutableDictionary *dataDic;
/*
*选中的数据源
*/
@property(nonatomic,strong)NSMutableArray *selectArr;

/*
*相互排斥的标题数组
*/
@property(nonatomic,strong)NSMutableArray *mutuallyExclusiveArr;
/*
 *初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame withParam:(WMZDropMenuParam*)param;

- (instancetype)initWithParam:(WMZDropMenuParam*)param;

#pragma -mark 暴露给外部的方法 自定义的时候可以调用

/*
*关闭方法
*/
- (void)closeView;
/*
*确定方法
*/
- (void)confirmAction;
/*
*重置方法
*/
- (void)reSetAction;

#pragma -mark  内部方法
/*
 *解析树形数据
 */
- (void)runTimeSetDataWith:(NSDictionary*)dic withTree:(WMZDropTree*)tree;
/*
*改变标题颜色和文字
*/
- (void)changeTitleConfig:(NSDictionary*)config withBtn:(WMZDropMenuBtn*)currentBtn;
/*
*回复原来的标题和文字
*/
- (void)changeNormalConfig:(NSDictionary*)config withBtn:(WMZDropMenuBtn*)currentBtn;
/*
 *更新dropPath之后的视图
 */
- (void)updateSubView:(WMZDropIndexPath*)dropPath more:(BOOL)more;
/*
*tableviewView
*/
- (WMZDropTableView*)getTableVieww:(WMZDropIndexPath*)path;
/*
*collectionView
*/
- (WMZDropCollectionView*)getCollectonView:(WMZDropIndexPath*)path layout:(UICollectionViewFlowLayout*)layout;

/*
*出现的动画
*/
- (void)showAnimal:(MenuShowAnimalStyle)animalStyle view:(UIView*)view durtion:(NSTimeInterval)durtion block:(DropMenuAnimalBlock)block;

/*
*消失的动画
*/
- (void)hideAnimal:(MenuHideAnimalStyle)animalStyle  view:(UIView*)view durtion:(NSTimeInterval)durtion block:(DropMenuAnimalBlock)block;
/**
 配置贝塞尔曲线
 */
- (UIBezierPath*)getMyDownPath;
- (UIBezierPath*)getMyDownRightPath;
@end

NS_ASSUME_NONNULL_END
