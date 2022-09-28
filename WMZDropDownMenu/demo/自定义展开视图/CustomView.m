//
//  CustomView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2022/9/27.
//  Copyright © 2022 wmz. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
@synthesize dropIndex = _dropIndex;
@synthesize dropArray = _dropArray;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UILabel *la = UILabel.new;
        la.frame = CGRectMake(13, 10, 200, 140);
        la.numberOfLines = 0;
        la.font = [UIFont systemFontOfSize:14];
        la.text = @"打开开关则为选中且关闭\n打开开关则为选中且关闭\n打开开关则为选中且关闭\n打开开关则为选中且关闭\n打开开关则为选中且关闭\n打开开关则为选中且关闭";
        [self addSubview:la];
        
        UISwitch *sw = UISwitch.new;
        [self addSubview:sw];
        sw.frame = CGRectMake(CGRectGetMaxX(la.frame) + 10, 13, 30, 30);
        sw.center = CGPointMake(sw.center.x, self.center.y);
        [sw addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)changeAction:(UISwitch*)sc{
    ///关闭
    [[NSNotificationCenter defaultCenter] postNotificationName:CloseMenuNotificationContentKey object:nil];
}

- (WMZDropIndexPath *)dropIndex{
    if(!_dropIndex){
        _dropIndex = [[WMZDropIndexPath alloc]initWithSection:0 row:0];
        _dropIndex.showAnimalStyle = MenuShowAnimalBottom;
        _dropIndex.hideAnimalStyle = MenuHideAnimalTop;
    }
    return _dropIndex;
}
@end
