

//
//  PinDDDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/26.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "PinDDDemo.h"
@interface PinDDDemo ()

@end

@implementation PinDDDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet([UIColor redColor])
    .wMenuTitleEqualCountSet(5)
    .wDefaultConfirmHeightSet(50)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xffeceb));
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    UIView *line = [UIView new];
    line.backgroundColor = MenuColor(0x999999);
    line.frame = CGRectMake(0, menu.frame.size.height, menu.frame.size.width, MenuK1px);
    [menu addSubview:line];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"综合",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @"销量价格",
         @{@"name":@"价格",@"normalImage":@"menu_shangxia",
           @"selectImage":@"menu_xiangshang",@"reSelectImage":@"menu_xiangxia"},
         @"品牌",
         @{@"name":@"筛选",@"normalImage":@"menu_shaixuan",@"selectImage":@"menu_shaixuan"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 4){
        return 3;
    }else if (section == 2){
        return 1;   //要返回1 不然会当做没数量的处理
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return @[@"综合排序",@"评分排序"];
    }else if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 0)
            return @[@"0-30",@"30-50",@"50-120",@"120以上"];;
        if (dropIndexPath.row == 2)
            return @[@"退货包运费",@"顺丰包邮"];
        if (dropIndexPath.row == 1) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价"}}];
    }
    return @[];
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 1) return 1;
        return 4;
    }
    return 0;
}

#define titleArr @[@"价格区间",@"",@"精选服务"]
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section ==4) {
        return titleArr[dropIndexPath.row];
    }
    return @"";
}


- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        return 20;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 1) {
            return 0;
        }
        return 35;
    }
    return 0;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuUITableView;
    }else if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 1) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2) {
        return MenuEditReSetCheck;
    }else if(dropIndexPath.section == 1 || dropIndexPath.section == 3) return MenuEditNone;
    return MenuEditOneCheck;
}

/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalNone
*/
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (section ==0){
        return MenuHideAnimalNone;
    }else if (section == 4) {
        return MenuHideAnimalTop;
    }
    return MenuHideAnimalNone;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section == 0){
        return MenuShowAnimalPop;
    }else if ( section == 4) {
        return MenuShowAnimalBottom;
    }
    return MenuShowAnimalNone;
}


- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = YES;
    confirmView.resetBtn.backgroundColor = [UIColor whiteColor];
    [confirmView.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    confirmView.confirmBtn.backgroundColor = [UIColor redColor];
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection:(NSInteger)section selectNoramelData:(NSMutableArray *)selectNoramalData selectStringData:(NSMutableArray *)selectData{
    NSLog(@"%@",selectData);
}

@end
