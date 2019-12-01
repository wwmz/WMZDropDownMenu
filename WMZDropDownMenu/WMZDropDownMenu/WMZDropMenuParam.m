


//
//  WMZDropMenuParam.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuParam.h"

@implementation WMZDropMenuParam
WMZDropMenuParam * MenuParam(void){
    return  [WMZDropMenuParam  new];
}
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wShadowColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellBgColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellTitleColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellSelectBgColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, UIColor*,           wCollectionViewCellSelectTitleColor)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSTextAlignment,    wTextAlignment)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSArray* ,          wTableViewColor)
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
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wCollectionViewDefaultFootViewMarginY)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wCollectionViewDefaultFootViewPaddingY)
WMZMenuSetFuncImplementation(WMZDropMenuParam, CGFloat,            wDefaultConfirmHeight)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSInteger,          wMenuTitleEqualCount)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSInteger,          wCollectionViewSectionShowExpandCount)
WMZMenuSetFuncImplementation(WMZDropMenuParam, NSInteger,          wCollectionViewSectionRecycleCount)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wShadowCanTap)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wShadowShow)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wBorderShow)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wCellSelectShowCheck)
WMZMenuSetFuncImplementation(WMZDropMenuParam, BOOL,               wMenuLine)
- (instancetype)init{
    if (self = [super init]) {
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
    }
    return self;
}

@end
