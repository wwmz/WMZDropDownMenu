
//
//  BaseVC.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/27.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MenuColor(0x00A6FF);
    if (@available(iOS 11.0, *)) {

    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[];
}
/*
*返回WMZDropIndexPath每行 每列的数据
*/
- (NSArray*)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    return @[];
}
- (void)dealloc{
    
}
@end
