//
//  WMZDropDwonMenuConfig.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#ifndef WMZDropDwonMenuConfig_h
#define WMZDropDwonMenuConfig_h
#import "WMZDropMenuEnum.h"
#import <UIKit/UIKit.h>
@class WMZDropIndexPath;
//implicit retain of 'self'改为NO
#define WMZMenuStatementAndPropSetFuncStatement(propertyModifier,className, propertyPointerType, propertyName)           \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;                                                 \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define WMZMenuSetFuncImplementation(className, propertyPointerType, propertyName)                                       \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
_##propertyName = propertyName;                                                                                         \
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

#define MenuWeakSelf(obj) __weak typeof(obj) weakObject = obj;
#define MenuStrongSelf(obj) __strong typeof(obj) strongObject = weakObject;


#define footHeadHeight 35
#define menuAnimalTime 0.3
#define moreTableViewKey @"moreTableViewKey"
#define menuMainClor [UIColor whiteColor]

#endif /* WMZDropDwonMenuConfig_h */
