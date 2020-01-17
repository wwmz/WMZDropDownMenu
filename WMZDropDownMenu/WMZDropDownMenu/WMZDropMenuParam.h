//
//  WMZDropMenuParam.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropDwonMenuConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZDropMenuParam : NSObject

//初始化
WMZDropMenuParam * MenuParam(void);

//如果弹出位置不准确自行设置此属性 default CGRectGetMaxY(menu.frame)
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wPopOraignY)

//标题视图是否显示边框 default NO
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, BOOL,             wBorderShow)
//固定标题的宽度 default 80
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wFixBtnWidth)
//标题等分个数  用来控制标题的宽度 default 4
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, NSInteger,        wMenuTitleEqualCount)
//标题按钮添加下划线 dfault NO
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, BOOL,             wMenuLine)


//固定弹出显示数据层的高度  default 自动计算~>最大为屏幕高度的0.4倍
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wFixDataViewHeight)
//弹窗视图的圆角 默认0
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wMainRadius)
//最大屏幕宽度系数 default 0.9
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wMaxWidthScale)
//最大屏幕高度系数 default 0.4
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wMaxHeightScale)
//默认确定重置视图的高度  default 40
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wDefaultConfirmHeight)
//弹出动画为pop时候 视图的宽度  default 屏幕宽度/3
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wPopViewWidth)


//遮罩层颜色 default 333333
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, UIColor*,         wShadowColor)
//遮罩层透明度  default 0.4
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,          wShadowAlpha)
//遮罩层能否点击 default YES
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, BOOL,             wShadowCanTap)
//遮罩层是否显示 default YES
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, BOOL,             wShadowShow)


//tableview的颜色 default @[FFFFFF,F6F7FA,EBECF0,FFFFFF]
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, NSArray* ,        wTableViewColor)
//cell文本居中样式 default left
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, NSTextAlignment,  wTextAlignment)
//tableViewCell 选中显示打钩图片 default YES
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, BOOL,             wCellSelectShowCheck)
//京东样式自定义底部划线
WMZMenuStatementAndPropSetFuncStatement(copy,     WMZDropMenuParam, MenuCustomLine,                wJDCustomLine)



//注册自定义的collectionViewCell  如果使用了自定义collectionView 必填否则会崩溃
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, NSArray*,        wReginerCollectionCells)
//注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填否则会崩溃
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, NSArray*,        wReginerCollectionHeadViews)
//注册自定义的collectionViewFoootView  如果使用了自定义collectionViewFoootView 必填否则会崩溃
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, NSArray*,        wReginerCollectionFootViews)
//colletionCell的间距  default 10
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,         wCollectionViewCellSpace)
//colletionCell背景颜色  default 0x666666
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, UIColor*,        wCollectionViewCellBgColor)
//colletionCell文字颜色  default 0xf2f2f2
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, UIColor*,        wCollectionViewCellTitleColor)
//colletionCell选中背景颜色  default 0xffeceb
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, UIColor*,        wCollectionViewCellSelectBgColor)
//colletionCell选中文字颜色  default red
WMZMenuStatementAndPropSetFuncStatement(strong,   WMZDropMenuParam, UIColor*,        wCollectionViewCellSelectTitleColor)
//colletionCell borderWidth default 0
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,         wCollectionViewCellBorderWith)
//colletionView section 超过多少个cell显示收缩按钮 default 6
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, NSInteger,       wCollectionViewSectionShowExpandCount)
//colletionView section 回收时候显示的cell数量 default 0
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, NSInteger,       wCollectionViewSectionRecycleCount)
//colletionViewFootView 距离底部的距离 默认0 当iphonex机型为 20
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,         wCollectionViewDefaultFootViewMarginY)
//colletionViewFootView 距离顶部的距离 默认0
WMZMenuStatementAndPropSetFuncStatement(assign,   WMZDropMenuParam, CGFloat,         wCollectionViewDefaultFootViewPaddingY)

@end

NS_ASSUME_NONNULL_END
