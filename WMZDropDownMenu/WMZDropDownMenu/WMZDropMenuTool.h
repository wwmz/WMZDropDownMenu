//
//  WMZDropMenuTool.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//设置阴影
typedef enum :NSInteger{
    MenuShadowPathTop,
    MenuShadowPathBottom,
    MenuShadowPathLeft,
    MenuShadowPathRight,
    MenuShadowPathCommon,
    MenuShadowPathAround
}MenuShadowPathType;

typedef enum :NSInteger{
    MenuBtnPositionLeft     = 1,            //图片在左，文字在右，默认
    MenuBtnPositionRight    = 2,            //图片在右，文字在左
    MenuBtnPositionTop      = 3,            //图片在上，文字在下
    MenuBtnPositionBottom   = 4,            //图片在下，文字在上
}MenuBtnPosition;

@interface WMZDropMenuTool : NSObject

//设置图文位置
+ (void)TagSetImagePosition:(MenuBtnPosition)postion spacing:(CGFloat)spacing button:(UIButton*)btn;

//计算按钮字体宽高
+(CGSize)boundingRectWithSize:(NSString*)txt Font:(UIFont*) font Size:(CGSize)size;

//设置单边框
+ (void)viewPathWithColor:(UIColor *)shadowColor  PathType:(MenuShadowPathType)shadowPathType PathWidth:(CGFloat)shadowPathWidth heightScale:(CGFloat)sacle button:(UIView*)btn;

//设置圆角 单边
+(void)setView:(UIView*)view Radii:(CGSize)size RoundingCorners:(UIRectCorner)rectCorner;

/*
 * 获取当前VC
 */
+ (UIViewController *)getCurrentVC;

@end
/*
 * 动画完成
 */
typedef void (^DropMenuAnimalBlock)(void);
@interface WMZDropMenuAnimal : NSObject
//垂直移动出现
void verticalMoveShowAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block);
//垂直移移动消失
void verticalMoveHideAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block);
//横向移动出现
void landscapeMoveShowAnimation(UIView *view ,NSTimeInterval duration,BOOL right,DropMenuAnimalBlock block);
//横向移动消失
void landscapeMoveHideAnimation(UIView *view ,NSTimeInterval duration,BOOL right,DropMenuAnimalBlock block);
//Boss样式移动出现
void BossMoveShowAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block);
//Boss样式移动消失
void BossMoveHideAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block);
@end

//渐变色
typedef enum :NSInteger{
    MenuGradientChangeDirectionLevel,                    //水平方向渐变
    MenuGradientChangeDirectionVertical,                 //垂直方向渐变
    MenuGradientChangeDirectionUpwardDiagonalLine,       //主对角线方向渐变
    MenuGradientChangeDirectionDownDiagonalLine,         //副对角线方向渐变
}MenuGradientChangeDirection;

@interface UIColor (MenuGradientColor)
//渐变色
+ (instancetype)menuColorGradientChangeWithSize:(CGSize)size
                direction:(MenuGradientChangeDirection)direction
                startColor:(UIColor*)startcolor
                endColor:(UIColor*)endColor;
@end

@interface NSObject (MenuSafeKVO)
/*!
 @method
 @abstract   移除所有观察的keypath
 */
- (void)removeAllObserverdKeyPath:(NSObject*)VC withKey:(NSString*)key;
/*!
@method
@abstract   安全增加观察者
*/
- (void)pageAddObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
/*!
@method
@abstract   安全删除观察者
*/
- (void)paegRemoveObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath context:(nullable void *)context;
@end


@interface UIImage (MenuImageName)
//从bundle获取图片
+ (UIImage*)bundleImage:(NSString*)name;
@end
NS_ASSUME_NONNULL_END
