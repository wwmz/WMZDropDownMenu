
//
//  MeiTuanDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/25.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "MeiTuanDemo.h"
@interface MeiTuanDemo ()

@end

@implementation MeiTuanDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wMaxWidthScaleSet(0.8)
    .wCollectionViewDefaultFootViewMarginYSet(40)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xfff2f0))
    .wCollectionViewCellSelectTitleColorSet([UIColor orangeColor]);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"排序",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"信用优先",@"normalImage":@"menu_chaoshi",@"selectImage":@"menu_chaoshi"},
         @"0元起送",
         @"赠准时宝",
         @"首单立减",
         @"满减优惠",
         @{@"name":@"更多",@"normalImage":@"menu_shaixuan",@"lastFix":@(YES)},  //最后一个固定
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 6){
        return 5;
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return @[@"人气最高",@"人气最低",@"速度最快",@"起送价最低",@"配送费最低",@"智能排序"];
    }else if (dropIndexPath.section == 6) {
        if (dropIndexPath.row == 0) return @[@"优惠商家",@"减配送费",@"满减优惠",@"门店新客立减",@"首单立减"];
        if (dropIndexPath.row == 1) return @[@"赠准时宝",@"到店自取",@"极速退款",@"美团专用"];
        if (dropIndexPath.row == 2) return @[@"0元起送",@"支持开发票",@"新商家",@"点评高分",@"跨天预定"];
        if (dropIndexPath.row == 3) return @[@"生鲜蔬果",@"生活超市"];
        if (dropIndexPath.row == 4) return @[@"4-29\n16%",@"29-54\n16%",@"54-79\n9%",@"79-105\n2%"];
    }
    return @[];
}

- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 6) {
        if (dropIndexPath.row == 0) return @"优惠活动";
        if (dropIndexPath.row == 1) return @"商家服务";
        if (dropIndexPath.row == 2) return @"商家特色";
        if (dropIndexPath.row == 3) return @"闪购超市";
        if (dropIndexPath.row == 4) return @"价格";
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 6) {
        return 3;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 6) {
        return 20;
    }
    return 0;
}
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuUITableView;
    }else if (dropIndexPath.section == 6) {
        return MenuUICollectionView;
    }
    return MenuUINone;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section > 0 && dropIndexPath.section<6) return MenuEditNone;
    else if (dropIndexPath.section == 6) return  (dropIndexPath.row == 4)?MenuEditOneCheck:MenuEditMoreCheck;
    return MenuEditOneCheck;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 6 && dropIndexPath.row == 4) {
        return 50;
    }
    return 35;
}


- (NSDictionary*)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
    //设置frame
    CGRect rect = menuBtn.frame;
    if (section ==1) {
        rect.size.width = 110;
        menuBtn.position = MenuBtnPositionLeft;
    }else if(section==0){
       rect.size.width = 110;
    }else{
       rect.size.width = 70;
    }
    menuBtn.frame = rect;
    menuBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    if (section!=6) {
        menuBtn.backgroundColor = MenuColor(0xf2f2f2);
        menuBtn.layer.cornerRadius = 5;
        menuBtn.layer.masksToBounds = YES;
    }
    return @{@"offset":@(10),@"y":@"8"};
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
      confirmView.showBorder = NO;
    confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.025, 0,confirmView.frame.size.width*0.45 , confirmView.frame.size.height)];
    confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.525, 0,confirmView.frame.size.width*0.45 , confirmView.frame.size.height)];
    confirmView.confirmBtn.backgroundColor = MenuColor(0XFFc93f);
    confirmView.resetBtn.backgroundColor = MenuColor(0XF6F8FB);
    confirmView.confirmBtn.layer.masksToBounds = YES;
    confirmView.resetBtn.layer.masksToBounds = YES;
    confirmView.confirmBtn.layer.cornerRadius = 10;
    confirmView.resetBtn.layer.cornerRadius = 10;
}

/*
*监听关闭视图 可做修改标题文本和颜色的操作
*/
- (void)menu:(WMZDropDownMenu *)menu closeWithBtn:(WMZDropMenuBtn*)selectBtn   index:(NSInteger )index{

}
/*
*监听打开视图 可做修改标题文本和颜色的操作
*/
- (void)menu:(WMZDropDownMenu *)menu openWithBtn:(WMZDropMenuBtn*)selectBtn   index:(NSInteger )index{
    
}

@end
