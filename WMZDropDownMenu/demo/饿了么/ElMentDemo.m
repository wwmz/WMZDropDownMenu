//
//  ElMentDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/26.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "ElMentDemo.h"
@interface ElMentDemo ()

@end

@implementation ElMentDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wMaxHeightScaleSet(0.8)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0x0096FF))
    .wCollectionViewSectionShowExpandCountSet(10000)
    .wMenuTitleEqualCountSet(5)
    .wDefaultConfirmHeightSet(50)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xf0fafe));
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"综合排序"},
         @"销量最高",
         @"距离最近",
         @{@"name":@"筛选",@"lastFix":@(YES),@"normalImage":@"menu_shaixuan",
           @"selectImage":@"menu_shaixuan"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 3){
        return 3;
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return @[@"综合排序",@"好评优先",@"起送价最低",@"配送最快",@"通用排序"];
    }else if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 0)
            return @[@{@"name":@"会员领红包",@"image":@"menu_xinyong"},
                     @"首单立减",@"津贴联盟",@"首次光顾立减",@"满减优惠",@"下单返红包",
                     @"进店领红包",@"赠品优惠",@"特价商品"];
        if (dropIndexPath.row == 1)
            return @[
            @{@"name":@"峰鸟专送",@"image":@"menu_xinyong"},
            @{@"name":@"品牌商家",@"image":@"menu_xinyong"},
            @{@"name":@"新店",@"image":@"menu_xinyong"},
            @{@"name":@"食安保",@"image":@"menu_xinyong"},
            @{@"name":@"开发票",@"image":@"menu_xinyong"},
            ];
        if (dropIndexPath.row == 2) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价",}}];
    }
    return @[];
}

#define titleArr @[@"优惠活动",@"商家服务",@"人均价格带"]
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return titleArr[dropIndexPath.row];
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 2) {
            return 1;
        }
        return 3;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return 10;
    }
    return 0;
}
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuUITableView;
    }else if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 2) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) return MenuEditOneCheck;
    if (dropIndexPath.section == 1 ||dropIndexPath.section == 2 ) return MenuEditNone;
    return MenuEditMoreCheck;
}
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (section ==0){
        return MenuHideAnimalTop;
    }else if (section == 3) {
        return MenuHideAnimalTop;
    }
    return MenuHideAnimalNone;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section == 0 || section == 3) {
        return MenuShowAnimalBottom;
    }
    return MenuShowAnimalNone;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = YES;
    confirmView.resetBtn.backgroundColor = MenuColor(0xfcfdfd);
    [confirmView.confirmBtn setTitle:@"查看" forState:UIControlStateNormal];
    confirmView.confirmBtn.backgroundColor = MenuColor(0x0096FF);
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
@end
