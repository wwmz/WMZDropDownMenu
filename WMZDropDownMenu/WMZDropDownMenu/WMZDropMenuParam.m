


//
//  WMZDropMenuParam.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuParam.h"
#import "WMZDropMenuTool.h"

@implementation WMZDropMenuParam

/// 标题
WMZMenuTitleKey const WMZMenuTitleNormal = @"name";
/// 选中的标题
WMZMenuTitleKey const WMZMenuTitleSelect = @"selectTitle";
/// 选中状态下再次点中的标题
WMZMenuTitleKey const WMZMenuTitleReSelect = @"reSelectTitle";
/// 字体大小
WMZMenuTitleKey const WMZMenuTitleFontNum = @"font";
/// 字体对象
WMZMenuTitleKey const WMZMenuTitleFont = @"fontObject";
/// 字体颜色
WMZMenuTitleKey const WMZMenuTitleColor = @"normalColor";
/// 选中的字体颜色
WMZMenuTitleKey const WMZMenuTitleSelectColor = @"selectColor";
/// 图片
WMZMenuTitleKey const WMZMenuTitleImage = @"normalImage";
/// 图片
WMZMenuTitleKey const WMZMenuTitleSelectImage = @"selectImage";
/// 选中状态下再点击的图片~>用于点击两次才回到原来的场景
WMZMenuTitleKey const WMZMenuTitleReSelectImage = @"reSelectImage";
/// 最后一个固定
WMZMenuTitleKey const WMZMenuTitleLastFix = @"lastFix";
/// 隐藏默认给的图标
WMZMenuTitleKey const WMZMenuTitleHideDefaultImage = @"hideDefatltImage";


WMZDropMenuParam * MenuParam(void){
    return  [WMZDropMenuParam  new];
}
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIImage* ,          wCellCheckImage)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIFont*,            wCellTitleFont)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIFont*,            wCellSelectTitleFont)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wShadowColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellBgColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellTitleColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellSelectBgColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellSelectTitleColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSTextAlignment,    wTextAlignment)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSArray<UIColor*>* ,wTableViewColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSArray<NSNumber*>*,wTableViewWidth)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSArray*,           wReginerCollectionCells)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSArray*,           wReginerCollectionHeadViews)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSArray*,           wReginerCollectionFootViews)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wCollectionViewCellSpace)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wShadowAlpha)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wFixDataViewHeight)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wMainRadius)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wCollectionViewCellBorderWith)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wMaxWidthScale)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wMaxHeightScale)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wPopViewWidth)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wFixBtnWidth)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wMenuDurtion)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wCollectionViewDefaultFootViewMarginY)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wCollectionViewDefaultFootViewPaddingY)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wPopOraignY)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wDefaultConfirmHeight)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wMenuTitleSpace)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSInteger,          wMenuTitleEqualCount)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSInteger,          wCollectionViewSectionShowExpandCount)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSInteger,          wCollectionViewSectionRecycleCount)
WMZMenuSetFuncImplementation(WMZDropMenuParam, MenuCustomLine,                wJDCustomLine)
WMZMenuSetFuncImplementation(WMZDropMenuParam, MenuCusotmDataViewRect,                wCustomDataViewRect)
WMZMenuSetFuncImplementation(WMZDropMenuParam, MenuCusotmShadomViewRect,                wCustomShadomViewRect)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wNumOfLine)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wShadowCanTap)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wShadowShow)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wBorderShow)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wCellSelectShowCheck)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wMenuLine)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wBorderUpDownShow)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIKeyboardType,     wCollectionCellTextFieldKeyType)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSTextAlignment,    wCollectionCellTextFieldAlignment)
WMZMenuSetFuncImplementation(WMZDropMenuParam, MenuInputStyle,     wCollectionCellTextFieldStyle)
- (instancetype)init{
    if (self = [super init]) {
        _wMenuTitleSpace = 2;
        _wShadowAlpha = 0.4f;
        _wMainRadius = 15.0f;
        _wShadowColor = MenuColor(0x333333);
        _wShadowCanTap = YES;
        _wShadowShow = YES;
        _wTableViewColor = @[MenuColor(0xFFFFFF),MenuColor(0xF6F7FA),MenuColor(0xEBECF0),MenuColor(0xFFFFFF)];
        _wTextAlignment = NSTextAlignmentLeft;
        _wCollectionViewCellSpace = Menu_GetWNum(20);
        _wCollectionViewCellBgColor = MenuColor(0xf2f2f2);
        _wCollectionViewCellTitleColor = MenuColor(0x666666);
        _wCollectionViewCellSelectTitleColor = [UIColor redColor];
        _wCollectionViewCellSelectBgColor = MenuColor(0xffeceb);
        _wMaxWidthScale = 0.9f;
        _wMaxHeightScale = 0.4f;
        _wCollectionViewSectionShowExpandCount = 6;
        _wMenuTitleEqualCount = 4;
        _wDefaultConfirmHeight = 40.0f;
        _wPopViewWidth = Menu_Width/3;
        _wFixBtnWidth = 80;
        _wCellSelectShowCheck = YES;
        _wNumOfLine = YES;
        _wCellTitleFont = [UIFont systemFontOfSize:15.0f];
        _wCellSelectTitleFont = [UIFont systemFontOfSize:15.0f];
        _wCellCheckImage = [[UIImage bundleImage:@"menu_check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _wMenuDurtion = 0.25;
        _wCollectionCellTextFieldKeyType = UIKeyboardTypeDecimalPad;
        _wCollectionCellTextFieldAlignment = NSTextAlignmentCenter;
        _wCollectionCellTextFieldStyle = MenuInputStyleMore;
    }
    return self;
}

@end
