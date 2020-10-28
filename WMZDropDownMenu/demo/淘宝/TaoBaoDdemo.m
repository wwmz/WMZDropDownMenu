

//
//  TaoBaoDdemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/26.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "TaoBaoDdemo.h"
@interface TaoBaoDdemo ()

@end

@implementation TaoBaoDdemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wMaxWidthScaleSet(0.8)
    .wCollectionViewCellSelectTitleColorSet([UIColor redColor])
    .wMenuTitleEqualCountSet(5)
    .wCollectionViewDefaultFootViewMarginYSet(10)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xfff2f0));
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    //主动调用
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [menu.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx == menu.titleBtnArr.count-1) {
//                if ([obj isKindOfClass:[WMZDropMenuBtn class]]) {
//                    [obj sendActionsForControlEvents:UIControlEventTouchUpInside];
//                }
//            }
//        }];
//    });
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"综合",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @"销量",
         @{@"name":@"视频",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"normalImage":@"menu_pubu_2",@"selectImage":@"menu_pubu_1"},
         @{@"name":@"筛选",@"normalImage":@"menu_shaixuan",@"selectImage":@"menu_shaixuan"},
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
        return @[@{@"name":@"综合",@"tapClose":@(NO)},@"信用",@"价格降序",@"价格升序"];
    }else if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 0) return @[@"Apple/苹果",@"华为",@"vivo",@"小米",@"OPPO",@"三星"];
        if (dropIndexPath.row == 1) return @[@"包邮",@"天猫",@"淘金币抵钱",@"全球购",@"天猫国际",@"天猫奢品",@"天猫超市",@"天猫国际",@"消费品保障",@"极速发货",@"货到付款",@"7+退货"];
        if (dropIndexPath.row == 2) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价",}}];
        if (dropIndexPath.row == 3) return @[@"购买过的店"];
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
        if (dropIndexPath.row == 2) {
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
        return MenuUITableView;
    }else if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 2) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
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

- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row>2) {
            return YES;
        }
    }
    return NO;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = NO;
    CGFloat width = 80;
    confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.45, 0,width , confirmView.frame.size.height)];
    confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.45+width, 0,width , confirmView.frame.size.height)];
    //渐变色
    confirmView.confirmBtn.backgroundColor = [UIColor menuColorGradientChangeWithSize:CGSizeMake(width, confirmView.frame.size.height) direction:MenuGradientChangeDirectionLevel startColor:MenuColor(0xffc13d) endColor:MenuColor(0xff9233)];
    confirmView.resetBtn.backgroundColor = [UIColor menuColorGradientChangeWithSize:CGSizeMake(width, confirmView.frame.size.height) direction:MenuGradientChangeDirectionLevel startColor:MenuColor(0xff752d) endColor:MenuColor(0xff4f2b)];
    //半边圆角 淘宝样式
    confirmView.showRdio = YES;
}

@end
