//
//  DemoTwo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/12/17.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "DemoTwo.h"

@interface DemoTwo ()

@end

@implementation DemoTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    WMZDropMenuParam *param =
    MenuParam()
    //不展示收缩按钮
    .wCollectionViewSectionShowExpandCountSet(999)
    .wMenuTitleEqualCountSet(3)
    //间距
    .wCollectionViewCellSpaceSet(10)
    .wMainRadiusSet(5);
       
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 60) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray *)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[@"筛选左对齐",@"筛选中对齐",@"筛选右对齐"];
}
- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.row == 0) {
        return @[@"首单立减",@"津贴联盟",@"首次光顾立减",@"满减优惠",@"下单返红包",
                 @"进店领红包",@"赠品优惠",@"特价商品"];
    }else if (dropIndexPath.row == 1) {
        return @[@"首单立减1",@"津贴联盟1",@"首次光顾立减1",@"满减优惠1",@"下单返红包1",
                 @"进店领红包1",@"赠品优惠1",@"特价商品1"];
    }else if (dropIndexPath.row == 2) {
        return @[@"首单立减2",@"津贴联盟22",@"首次光顾立减22",@"满减优惠22",@"下单返红包22",
                 @"进店领红包22",@"赠品优惠22",@"特价商品22"];
    }
    return @[];
}
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return MenuUICollectionView;
}
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    return MenuShowAnimalLeft;
}
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    return MenuHideAnimalRight;
}
- (MenuCollectionUIStyle)menu:(WMZDropDownMenu *)menu cellFixStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    return MenuCollectionUIFit;
}
- (MenuCellAlignType)menu:(WMZDropDownMenu *)menu collectionAlignFitTypeForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuCellAlignWithLeft;
    }else  if (dropIndexPath.section == 1) {
        return MenuCellAlignWithCenter;
    }else  if (dropIndexPath.section == 2) {
        return MenuCellAlignWithRight;
    }
    return MenuCellAlignWithLeft;
}
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return @"标题";
}
@end
