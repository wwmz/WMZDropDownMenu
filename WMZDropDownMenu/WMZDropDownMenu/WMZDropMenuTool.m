//
//  WMZDropMenuTool.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuTool.h"

@implementation WMZDropMenuTool

//设置图文位置
+ (void)TagSetImagePosition:(MenuBtnPosition)postion spacing:(CGFloat)spacing button:(UIButton*)btn {
    CGFloat imgW = btn.imageView.image.size.width;
    CGFloat imgH = btn.imageView.image.size.height;
    CGSize trueSize = [self boundingRectWithSize:btn.titleLabel.text Font:btn.titleLabel.font Size:CGSizeMake(btn.frame.size.width-imgW-spacing,btn.frame.size.height)];
    CGFloat trueLabW = trueSize.width;
    CGFloat trueLabH = trueSize.height;
    //image中心移动的x距离
    CGFloat imageOffsetX = trueLabW/2 ;
    //image中心移动的y距离
    CGFloat imageOffsetY = trueLabH/2 + spacing/2;
    //label左边缘移动的x距离
    CGFloat labelOffsetX1 = imgW/2 - trueLabW/2 + trueLabW/2;
    //label右边缘移动的x距离
    CGFloat labelOffsetX2 = imgW/2 + trueLabW/2 - trueLabW/2;
    //label中心移动的y距离
    CGFloat labelOffsetY = imgH/2 + spacing/2;
    switch (postion) {
        case MenuBtnPositionLeft:
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case MenuBtnPositionRight:
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, trueLabW + spacing/2, 0, -(trueLabW + spacing/2));
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -(imgW + spacing/2), 0, imgW + spacing/2);
            break;
            
        case MenuBtnPositionTop:
            btn.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            btn.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX1, -labelOffsetY, labelOffsetX2);
            break;
            
        case MenuBtnPositionBottom:
            btn.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            btn.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX1, labelOffsetY, labelOffsetX2);
            break;
            
        default:
            break;
    }
}


+(CGSize)boundingRectWithSize:(NSString*)txt Font:(UIFont*) font Size:(CGSize)size{
    CGSize _size;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    NSDictionary *attribute = @{NSFontAttributeName: font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    _size = [txt boundingRectWithSize:size options: options attributes:attribute context:nil].size;
#else
    _size = [txt sizeWithFont:font constrainedToSize:size];
#endif
    return _size;
    
}


+ (void)viewPathWithColor:(UIColor *)shadowColor  PathType:(MenuShadowPathType)shadowPathType PathWidth:(CGFloat)shadowPathWidth heightScale:(CGFloat)sacle button:(UIView*)btn{
    
    CGRect shadowRect = CGRectZero;
    CGFloat originX,originY,sizeWith,sizeHeight;
    originX = 0;
    originY = btn.bounds.size.height*(1-sacle)/2;
    sizeWith = btn.bounds.size.width;
    sizeHeight = btn.bounds.size.height*sacle;
    
    if (shadowPathType == MenuShadowPathTop) {
        shadowRect = CGRectMake(originX, originY-shadowPathWidth/2, sizeWith, shadowPathWidth);
    }else if (shadowPathType == MenuShadowPathBottom){
        shadowRect = CGRectMake(originY, sizeHeight-shadowPathWidth/2, sizeWith, shadowPathWidth);
    }else if (shadowPathType == MenuShadowPathLeft){
        shadowRect = CGRectMake(originX-shadowPathWidth/2, originY+sizeHeight/4, shadowPathWidth, sizeHeight/2);
    }else if (shadowPathType == MenuShadowPathRight){
        shadowRect = CGRectMake(sizeWith-shadowPathWidth/2, originY, shadowPathWidth, sizeHeight);
    }else if (shadowPathType == MenuShadowPathCommon){
        shadowRect = CGRectMake(originX-shadowPathWidth/2, 2, sizeWith+shadowPathWidth, sizeHeight+shadowPathWidth/2);
    }else if (shadowPathType == MenuShadowPathAround){
        shadowRect = CGRectMake(originX-shadowPathWidth/2, originY-shadowPathWidth/2, sizeWith+shadowPathWidth, sizeHeight+shadowPathWidth);
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:shadowRect];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = shadowColor.CGColor;
    [btn.layer addSublayer:layer];
}

//设置圆角 单边
+(void)setView:(UIView*)view Radii:(CGSize)size RoundingCorners:(UIRectCorner)rectCorner {
    if (size.width == 0 && size.height == 0) return;
    //设置只有一半圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


/*
 * 获取当前VC
 */
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        currentVC = rootVC;
    }
    return currentVC;
}

@end


@implementation WMZDropMenuAnimal
//Boss样式移动出现
void BossMoveShowAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block){
    CGRect rect = view.frame;
    view.frame = CGRectMake(rect.origin.x, [UIScreen mainScreen].bounds.size.height , rect.size.width, rect.size.height);
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = rect;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}
//Boss样式移动消失
void BossMoveHideAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block){
    CGRect rect = view.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = CGRectMake(rect.origin.x, [UIScreen mainScreen].bounds.size.height , rect.size.width, rect.size.height);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}

//垂直移动出现
void verticalMoveShowAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block){
    CGRect rect = view.frame;
    view.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = rect;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}
//垂直移移动消失
void verticalMoveHideAnimation (UIView *view ,NSTimeInterval duration,DropMenuAnimalBlock block){
    CGRect rect = view.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.frame = rect;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}
//横向移动
void landscapeMoveShowAnimation(UIView *view ,NSTimeInterval duration,BOOL right,DropMenuAnimalBlock block){
    CGRect rect = view.frame;
    view.frame = CGRectMake(right?(rect.origin.x+rect.size.width):rect.origin.x, rect.origin.y, 0, rect.size.height);
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = rect;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}
//横向移动消失
void landscapeMoveHideAnimation(UIView *view ,NSTimeInterval duration,BOOL right,DropMenuAnimalBlock block){
    CGRect rect = view.frame;
    if (right) {
        rect.origin.x = rect.origin.x+rect.size.width;
    }
    rect.size.width = 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.frame = rect;
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}


@end


@implementation UIColor (MenuGradientColor)

+ (instancetype)menuColorGradientChangeWithSize:(CGSize)size
                direction:(MenuGradientChangeDirection)direction
                startColor:(UIColor*)startcolor
                endColor:(UIColor*)endColor{
      if(CGSizeEqualToSize(size,CGSizeZero) || !startcolor || !endColor) {
           return nil;
       }
      CAGradientLayer *gradientLayer = [CAGradientLayer layer];
      gradientLayer.frame=CGRectMake(0,0, size.width, size.height);
      CGPoint startPoint = CGPointZero;
      if (direction == MenuGradientChangeDirectionDownDiagonalLine) {
         startPoint =CGPointMake(0.0,1.0);
      }
      gradientLayer.startPoint= startPoint;
      CGPoint endPoint = CGPointZero;
      switch(direction) {
           case MenuGradientChangeDirectionLevel:
               endPoint =CGPointMake(1.0,0.0);
               break;
           case MenuGradientChangeDirectionVertical:
               endPoint =CGPointMake(0.0,1.0);
               break;
           case MenuGradientChangeDirectionUpwardDiagonalLine:
               endPoint =CGPointMake(1.0,1.0);
               break;
           case MenuGradientChangeDirectionDownDiagonalLine:
               endPoint =CGPointMake(1.0,0.0);
               break;
           default:
               break;

       }
       gradientLayer.endPoint= endPoint;
       gradientLayer.colors=@[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
       UIGraphicsBeginImageContext(size);
       [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
       UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       return [UIColor colorWithPatternImage:image];
}

@end

@implementation NSObject (MenuSafeKVO)

- (void)pageAddObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    if (![self hasKey:keyPath withObserver:observer]) {
        [self addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)paegRemoveObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath context:(nullable void *)context {
    if ([self hasKey:keyPath withObserver:observer]) {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    }
}

- (void)removeAllObserverdKeyPath:(NSObject*)VC withKey:(NSString*)key{
    id info = self.observationInfo;
    NSArray *arr = [info valueForKeyPath:@"_observances._property._keyPath"];
    NSArray *objArr = [info valueForKeyPath:@"_observances._observer"];
    if (arr) {
        for (int i = 0; i<arr.count; i++) {
            NSString *keyPath = arr[i];
            NSObject *obj = objArr[i];
            if ([keyPath isEqualToString:key]&&obj == VC) {
                [self removeObserver:VC forKeyPath:keyPath context:nil];
            }
        }
    }
    
}

- (BOOL)hasKey:(NSString *)kvoKey withObserver:(nonnull NSObject *)observer {
    BOOL hasKey = NO;
    id info = self.observationInfo;
    NSArray *arr = [info valueForKeyPath:@"_observances._property._keyPath"];
    NSArray *objArr = [info valueForKeyPath:@"_observances._observer"];
       if (arr) {
           for (int i = 0; i<arr.count; i++) {
               NSString *keyPath = arr[i];
               NSObject *obj = objArr[i];
               if ([keyPath isEqualToString:kvoKey]&&obj == observer) {
                   hasKey = YES;
                   break;
               }
           }
       }
    return hasKey;
}

@end


@implementation UIImage(MenuImageName)

+ (UIImage*)bundleImage:(NSString*)name{
    NSBundle *bundle =  [NSBundle bundleWithPath:[[NSBundle bundleForClass:[WMZDropMenuTool class]] pathForResource:@"WMZDropMenu" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:name ofType:@"png"];
    if (!path) {
        return [UIImage imageNamed:name];
    }else{
        return [UIImage imageWithContentsOfFile:path];
    }
}

@end
