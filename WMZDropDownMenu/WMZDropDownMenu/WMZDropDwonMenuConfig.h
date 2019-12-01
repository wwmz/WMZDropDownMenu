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
if ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0) {\
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


#define Menu_Height [UIScreen mainScreen].bounds.size.height
#define Menu_Width  [UIScreen mainScreen].bounds.size.width
#define Menu_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define Menu_NavigationBar (([[UIApplication sharedApplication] statusBarFrame].size.height) + 44)
#define Menu_GetWNum(A)   (A)/2.0*(Menu_Width/375)
#define MenuColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MenuK1px (1 / UIScreen.mainScreen.scale)

#define  MenuWindow        [UIApplication sharedApplication].keyWindow


#define MenuWeakSelf(obj) __weak typeof(obj) weakObject = obj;
#define MenuStrongSelf(obj) __strong typeof(obj) strongObject = weakObject;


/*
 * UI样式
 */
typedef enum : NSUInteger{
    MenuUINone = 0,                  //none 只有点击效果  默认
    MenuUITableView ,                //tableview
    MenuUICollectionView,            //collection
    MenuUICollectionRangeTextField,  //collectionView内使用 textField
}MenuUIStyle;

/*
 * 编辑样式
 */
typedef enum : NSUInteger{
    MenuEditNone = 0 ,           //none   只有文字的情况无图标的改变 只能选中且无法取消选中
    MenuEditCheck,               //       有图标的改变 且能取消选中
    MenuEditReSetCheck,          //二选一  数量两个的时候(具体表现为图标的改变)
    MenuEditOneCheck ,           //单选    默认
    MenuEditMoreCheck,           //多选
}MenuEditStyle;

/*
 * 出现的动画样式
 */
typedef enum : NSUInteger{
    MenuShowAnimalNone = 0,           //无动画
    MenuShowAnimalBottom,             //向下移动出现
    MenuShowAnimalLeft,               //从左侧滑出现
    MenuShowAnimalRight ,             //向右侧滑出现
    MenuShowAnimalPop ,               //pop弹出
    MenuShowAnimalBoss ,              //boss直聘样式 全屏
}MenuShowAnimalStyle;


/*
 * 消失的动画样式
 */
typedef enum : NSUInteger{
    MenuHideAnimalNone = 0,          //无动画
    MenuHideAnimalTop,               //向上移动消失
    MenuHideAnimalRight,             //向右侧滑消失
    MenuHideAnimalLeft ,             //向左侧滑出现
    MenuHideAnimalBoss ,             //boss直聘样式 全屏
}MenuHideAnimalStyle;


/*
 * 处理数据
 */
typedef enum : NSUInteger{
    MenuDataDelete = 999,             //删除
    MenuDataInsert,                   //添加
    MenuDataDefault,                  //默认添加已选中的
}MenuDataStyle;

#endif /* WMZDropDwonMenuConfig_h */
