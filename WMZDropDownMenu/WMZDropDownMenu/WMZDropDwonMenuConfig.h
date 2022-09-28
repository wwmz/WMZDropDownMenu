//
//  WMZDropDwonMenuConfig.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#ifndef WMZDropDwonMenuConfig_h
#define WMZDropDwonMenuConfig_h

#import <UIKit/UIKit.h>
@class WMZDropIndexPath;

#define WMZMenuStatementAndPropSetFuncStatement(propertyModifier,className, propertyPointerType, propertyName)           \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;                                                 \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define WMZMenuSetFuncImplementation(className, propertyPointerType, propertyName)                                       \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
self->_##propertyName = propertyName;                                                                                         \
return self;                                                                                                            \
};                                                                                                                      \
}

#define MenuisIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
if (MenuWindow.safeAreaInsets.bottom > 0.0) {\
isPhoneX = YES;\
}\
}\
isPhoneX;\
})

#define MenuSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



//ios13暗黑模式颜色
#define MenuDarkColor(light,dark)    \
({\
    UIColor *wMenuIndicator = nil; \
    if (@available(iOS 13.0, *)) {  \
        wMenuIndicator = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) { \
        if ([traitCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {  \
            return light;  \
        }else {   \
            return dark;  \
        }}];  \
    }else{  \
        wMenuIndicator = light;  \
    }   \
    (wMenuIndicator); \
})\


#define  MenuWindow \
({\
UIWindow *window = nil; \
if (@available(iOS 13.0, *)) \
{ \
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) { \
        if (windowScene.activationState == UISceneActivationStateForegroundActive) \
        { \
            for (UIWindow *currentWindow in windowScene.windows)\
            { \
                if (currentWindow.isKeyWindow)\
                { \
                    window = currentWindow; \
                    break; \
                }\
            }\
        }\
    }\
}\
else \
{ \
    window =  [UIApplication sharedApplication].keyWindow; \
}\
(window); \
})\

#define Menu_Height [UIScreen mainScreen].bounds.size.height
#define Menu_Width  [UIScreen mainScreen].bounds.size.width
#define Menu_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define Menu_NavigationBar (([[UIApplication sharedApplication] statusBarFrame].size.height) + 44)
#define Menu_GetWNum(A)   (A)/2.0*(Menu_Width/375)
#define MenuColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MenuK1px (1 / UIScreen.mainScreen.scale)

#ifndef MenuWeakSelf
    #if DEBUG
        #if __has_feature(objc_arc)
            #define MenuWeakSelf(obj) autoreleasepool{} __weak __typeof__(obj) obj##Weak = obj;
        #else
            #define MenuWeakSelf(obj) autoreleasepool{} __block __typeof__(obj) obj##Block = obj;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define MenuWeakSelf(obj) try{} @finally{} {} __weak __typeof__(obj) obj##Weak = obj;
        #else
            #define MenuWeakSelf(obj) try{} @finally{} {} __block __typeof__(obj) obj##Block = obj;
        #endif
    #endif
#endif

#ifndef MenuStrongSelf
    #if DEBUG
        #if __has_feature(objc_arc)
            #define MenuStrongSelf(obj) autoreleasepool{} __typeof__(obj) obj = obj##Weak;
        #else
            #define MenuStrongSelf(obj) autoreleasepool{} __typeof__(obj) obj = obj##Block;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define MenuStrongSelf(obj) try{} @finally{} __typeof__(obj) obj = obj##Weak;
        #else
            #define MenuStrongSelf(obj) try{} @finally{} __typeof__(obj) obj = obj##Block;
        #endif
    #endif
#endif

#define footHeadHeight 35
static NSString * const MoreTableViewKey = @"moreTableViewKey";
static NSString * const CloseMenuNotificationContentKey = @"CloseMenuNotificationContentKey";
#define menuMainClor [UIColor whiteColor]

typedef void (^MenuAfterTime)(void);

typedef void (^MenuCustomLine)(UIView *customLine);

typedef CGRect (^MenuCusotmDataViewRect)(CGRect currentRect);

typedef CGRect (^MenuCusotmShadomViewRect)(CGRect currentRect);

/// UI样式
typedef enum : NSUInteger{
    /// none 只有点击效果  默认
    MenuUINone = 0,
    /// tableview
    MenuUITableView ,
    /// collection
    MenuUICollectionView,
    /// collectionView内使用 textField
    MenuUICollectionRangeTextField,
    /// 自定义View 必须实现协议
    MenuUICustom,
}MenuUIStyle;

/// 编辑样式
typedef enum : NSUInteger{
    /// none   只有文字的情况无图标的改变 只能选中且无法取消选中
    MenuEditNone = 0 ,
    /// 有图标的改变 且能取消选中
    MenuEditCheck,
    /// 二选一  数量两个的时候(具体表现为图标的改变)
    MenuEditReSetCheck,
    /// 单选    默认
    MenuEditOneCheck ,
    /// 多选
    MenuEditMoreCheck,
    /// 自定义
    MenuEditCustom,
}MenuEditStyle;

/// 出现的动画样式
typedef enum : NSUInteger{
    /// 无动画
    MenuShowAnimalNone = 0,
    /// 向下移动出现
    MenuShowAnimalBottom,
    /// 向上移动出现
    MenuShowAnimalTop,
    /// 从左侧滑出现
    MenuShowAnimalLeft,
    /// 向右侧滑出现
    MenuShowAnimalRight ,
    /// pop弹出
    MenuShowAnimalPop ,
    /// boss直聘样式 全屏
    MenuShowAnimalBoss ,
}MenuShowAnimalStyle;

///消失的动画样式
typedef enum : NSUInteger{
    ///无动画
    MenuHideAnimalNone = 0,
    ///向上移动消失
    MenuHideAnimalTop,
    ///向下移动消失
    MenuHideAnimalBottom,
    ///向右侧滑消失
    MenuHideAnimalRight,
    ///向左侧滑消失
    MenuHideAnimalLeft ,
    ///boss直聘样式 全屏
    MenuHideAnimalBoss ,
}MenuHideAnimalStyle;

/// 处理数据
typedef enum : NSUInteger{
    ///删除
    MenuDataDelete = 999,
    ///添加
    MenuDataInsert,
    ///默认添加已选中的
    MenuDataDefault,
}MenuDataStyle;

///collectionview cell文字自适应宽度
typedef enum : NSUInteger{
    ///固定宽度默认
    MenuCollectionUINormal = 0,
    ///自适应文本宽度
    MenuCollectionUIFit,
}MenuCollectionUIStyle;

/// cell对齐方式
typedef enum : NSUInteger{
    /// 左对齐
    MenuCellAlignWithLeft,
    /// 居中
    MenuCellAlignWithCenter,
    /// 右对齐
    MenuCellAlignWithRight
}MenuCellAlignType;

/// inputText
typedef enum : NSUInteger{
    /// 两个
    MenuInputStyleMore = 1,
    /// 单个
    MenuInputStyleOne,
}MenuInputStyle;

#endif /* WMZDropDwonMenuConfig_h */
