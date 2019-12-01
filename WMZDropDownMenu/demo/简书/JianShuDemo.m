



//
//  JianShuDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/26.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "JianShuDemo.h"
@interface JianShuDemo ()

@end

@implementation JianShuDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xFF375B))
    .wFixBtnWidthSet(120)
    .wPopViewWidthSet(100)
    .wCellSelectShowCheckSet(NO)
    .wMenuTitleEqualCountSet(6);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @"按相关度",
         @"按热度",
         @{@"name":@"按最新排序",@"lastFix":@(YES)},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
   if (section == 2){
        return 1;
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 2){
          return @[@"所有时间",@"最近一天",@"最近一周",@"最近三月"];
      }
      return @[];
}
/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalNone
*/
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    return MenuHideAnimalNone;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section == 2){
        return MenuShowAnimalPop;
    }
    return MenuShowAnimalNone;
}
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if(dropIndexPath.section == 0 || dropIndexPath.section ==1) return MenuEditNone;
    return MenuEditOneCheck;
}
@end
