//
//  CustomVC.m
//  WMZDropDownMenu
//
//  Created by wmz on 2022/9/27.
//  Copyright © 2022 wmz. All rights reserved.
//

#import "CustomVC.h"
#import "CustomView.h"

@interface CustomVC ()
@property (nonatomic, strong) WMZDropDownMenu *menu;
@property (nonatomic, strong) CustomView *customView;
@end

@implementation CustomVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customView = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, Menu_Width, 150)];
    
    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wMaxWidthScaleSet(0.8)
    .wCollectionCellTextFieldStyleSet(MenuInputStyleOne)
    .wCollectionCellTextFieldKeyTypeSet(UIKeyboardTypeDefault)
    .wCollectionViewCellSelectTitleColorSet([UIColor redColor])
    .wMenuTitleEqualCountSet(5)
    .wCollectionViewDefaultFootViewMarginYSet(10)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xfff2f0));
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    self.menu = menu;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{WMZMenuTitleNormal:@"综合",
           WMZMenuTitleImage:@"menu_dowm",
           WMZMenuTitleSelectImage:@"menu_up"},
         @"销量",
         @{WMZMenuTitleNormal:@"视频",
           WMZMenuTitleImage:@"menu_dowm",
           WMZMenuTitleSelectImage:@"menu_up"},
         @{WMZMenuTitleImage:@"menu_pubu_2",
           WMZMenuTitleSelectImage:@"menu_pubu_1"},
         @{WMZMenuTitleNormal:@"筛选",
           WMZMenuTitleImage:@"menu_shaixuan",
           WMZMenuTitleSelectImage:@"menu_shaixuan"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 4){
        return 8;
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        //tapClose 默认开启 传NO 则表示点击不关闭
        return @[@{WMZMenuTitleNormal:@"综合",@"tapClose":@(NO)},@"信用",@"价格降序",@"价格升序"];
    }else if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 0) return @[@"Apple/苹果",@"华为",@"vivo",@"小米",@"OPPO",@"三星"];
        if (dropIndexPath.row == 1) return @[@"包邮",@"天猫",@"淘金币抵钱",@"全球购",@"天猫国际",@"天猫奢品",@"天猫超市",@"天猫国际",@"消费品保障",@"极速发货",@"货到付款",@"7+退货"];
        if (dropIndexPath.row == 2) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价",}}];
        if (dropIndexPath.row == 3) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价"},@"inputStyle":@(MenuInputStyleMore)}];
        if (dropIndexPath.row == 4) return @[@"512GB",@"2256GB",@"128GB",@"64GB",@"32GB",@"16GB"];
        if (dropIndexPath.row == 5) return @[@"中国大陆",@"美版",@"日版",@"港版"];
        if (dropIndexPath.row == 6) return @[@"B级95新",@"A级99新",@"C级9新",@"S级准新",@"D级8新"];
        if (dropIndexPath.row == 7) return @[@"4800万",@"4000万",@"2000万以上",@"2000万",@"1628万",@"1400万",@"1230万",@"1000万",@"800万"];
    }
    return @[];
}

#define titleArr @[@"品牌",@"这块和服务",@"价格区间(元)",@"我喜欢",@"机身内存ROM",@"版本类型",@"优品成色",@"像素"]
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 4) {
        return titleArr[dropIndexPath.row];
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 2 || dropIndexPath.row == 3) {
            return 1;
        }
        return 3;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        return 20;
    }
    return 0;
}
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuUICustom;
    }else if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 2 || dropIndexPath.row == 3) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) return MenuEditCustom;
    if (dropIndexPath.section == 1) return MenuEditNone;
    if (dropIndexPath.section == 2 ||dropIndexPath.section == 3 ) return MenuEditCheck;
    return MenuEditOneCheck;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 4 && dropIndexPath.row ==3) {
        return 50;
    }
    return 35;
}
- (UIView<WMZDropShowViewProcotol> *)menu:(WMZDropDownMenu *)menu customViewInSection:(NSInteger)section{
    if(section == 0){
        return self.customView;
    }
    return nil;
}
@end
