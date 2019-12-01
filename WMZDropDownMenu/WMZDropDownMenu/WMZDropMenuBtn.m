



//
//  WMZDropMenuBtn.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/20.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuBtn.h"

@implementation WMZDropMenuBtn
- (MenuBtnPosition)position{
    if (!_position) {
        _position = MenuBtnPositionRight;
    }
    return _position;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{\
    [super setTitle:title forState:state];
    [WMZDropMenuTool TagSetImagePosition:self.position spacing:1 button:self];
}
@end

static char lineViewKey;
@implementation WMZDropMenuBtn (WMZLine)

- (void)showLine:(NSDictionary*)config
{
    if (self.line == nil||[[self subviews] indexOfObject:self.line]==NSNotFound) {
        CGRect frame = CGRectMake((self.frame.size.width - 30)/2, self.frame.size.height-5, 30, 3);
        self.line = [[UIView alloc] initWithFrame:frame];
        self.line.backgroundColor = [UIColor menuColorGradientChangeWithSize:self.line.frame.size direction:MenuGradientChangeDirectionLevel startColor:MenuColor(0xf92921) endColor:MenuColor(0xffc1bd)];
        [self addSubview:self.line];
        [self bringSubviewToFront:self.line];
    }
}

- (void)hidenLine
{
    if (self.line) {
        [self.line removeFromSuperview];
    }
}

#pragma mark - GetterAndSetter
- (UIView *)line
{
    return objc_getAssociatedObject(self, &lineViewKey);
}

- (void)setLine:(UIView *)line
{
    objc_setAssociatedObject(self, &lineViewKey, line, OBJC_ASSOCIATION_RETAIN);
}


@end
