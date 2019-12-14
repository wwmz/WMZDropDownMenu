



//
//  WMZDropMenuBtn.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/20.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuBtn.h"

@implementation WMZDropMenuBtn

- (void)setUpParam:(WMZDropMenuParam*)param withDic:(id)dic{
    self.param = param;
    BOOL dictionary = [dic isKindOfClass:[NSDictionary class]];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([dic isKindOfClass:[NSString class]]) {
        [self setTitle:dic forState:UIControlStateNormal];
    }else if([dic isKindOfClass:[NSDictionary class]]){
        [self setTitle:dic[@"name"] forState:UIControlStateNormal];
    }
    CGFloat font = 14.0;
    if (dictionary&&dic[@"font"]) {font = [dic[@"font"]floatValue];}
    UIColor *normalColor = self.param.wCollectionViewCellTitleColor;
    if (dictionary&&dic[@"normalColor"]) {normalColor = dic[@"normalColor"];}
    UIColor *selectColor = self.param.wCollectionViewCellSelectTitleColor;
    if (dictionary&&dic[@"selectColor"]) {selectColor = dic[@"selectColor"];}
    if (dictionary&&dic[@"reSelectImage"]) {self.reSelectImage = dic[@"reSelectImage"];}
    NSString *seletImage = nil;
    if (dictionary&&dic[@"selectImage"]) {
        seletImage = dic[@"selectImage"];
    }else{
        if (dictionary) {
            seletImage = @"menu_xiangshang";
        }
    }
    NSString *normalImage = nil;
    if (dictionary&&dic[@"normalImage"]) {
        normalImage = dic[@"normalImage"];
    }else{
        if (dictionary) {
            normalImage = @"menu_xiangxia";
        }
    }
    if ((dictionary&&dic[@"normalImage"])&&(dictionary&&!dic[@"selectImage"])) {
        seletImage = dic[@"normalImage"];
    }
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    self.normalImage = normalImage;
    self.selectImage = seletImage;
    self.normalColor = normalColor;
    self.selectColor = selectColor;
    [self setImage:normalImage?[UIImage bundleImage:normalImage]:nil forState:UIControlStateNormal];
    [self setImage:seletImage?[UIImage bundleImage:seletImage]:nil forState:UIControlStateSelected];
    [self setTitleColor:normalColor forState:UIControlStateSelected];
    self.normalTitle = [self titleForState:UIControlStateNormal];
}

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
