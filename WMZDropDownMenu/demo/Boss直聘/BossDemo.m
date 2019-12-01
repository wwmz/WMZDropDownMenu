//
//  BossDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/27.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "BossDemo.h"

@interface BossDemo ()

@end

@implementation BossDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0x00c2bb))
    .wCollectionViewDefaultFootViewPaddingYSet(20)
    .wCollectionViewSectionRecycleCountSet(8)
    .wMenuTitleEqualCountSet(6)
    .wCollectionViewCellBorderWithSet(1)
    .wCellSelectShowCheckSet(NO)
    .wReginerCollectionHeadViewsSet(@[@"BossSearch"])
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xffffff))
    .wMaxHeightScaleSet(0.5);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @"推荐",
         @"最新",
         @"",//占位
         @{@"name":@"广州",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"筛选",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"关键词",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 3){
        return 3;
    }else if (section == 4){
        return 5;
    }else if (section == 5){
        return 7;
    }else if (section == 2){
        return 0;
    }

    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 3){
          if (dropIndexPath.row == 0) return @[@"商圈",@"地铁"];
          if (dropIndexPath.row == 1) return @[@"全广州",@"天河区",@"白云区",@"番禺区",@"海珠区",@"越秀区",
                                               @"黄浦区",@"荔湾区",@"南沙区",@"从化区"];
          if (dropIndexPath.row == 2) return @[@"全白云区",@"嘉禾",@"嘉禾",@"太和",@"嘉禾",@"嘉禾",@"太和",
                                               @"嘉禾",@"嘉禾",@"太和",@"嘉禾",@"嘉禾",@"太和",
                                               @"嘉禾",@"嘉禾",@"太和",@"嘉禾",@"嘉禾",@"太和"];
      }else if (dropIndexPath.section == 4){
          if (dropIndexPath.row == 0) return @[@"全部",@"初中级以下",@"中专",@"高中",
                                               @"大专",@"本科",@"博士"];
          if (dropIndexPath.row == 1) return @[@"全部",@"3k一下",@"3-5k",@"5-10k",@"10-20k",
                                               @"50k以上"];
          if (dropIndexPath.row >= 2) return @[@"全部",@"3k一下",@"3-5k",@"5-10k",@"10-20k",
                                              @"50k以上",@"应届生",@"1年以内"];
      }else if (dropIndexPath.section == 5){
            if (dropIndexPath.row == 0) return @[@"全部",@"初中级以下",@"中专",@"高中",
                                                         @"大专",@"本科",@"博士"];
            if (dropIndexPath.row == 1) return @[@"全部",@"3k一下",@"3-5k",@"5-10k",@"10-20k",
                                                         @"50k以上"];
            if (dropIndexPath.row >= 2) return @[@"全部",@"3k一下",@"3-5k",@"5-10k",@"10-20k",
                                                        @"50k以上",@"应届生",@"1年以内"];
      }
      return @[];
}
#define titleArr1 @[@"学历要求",@"薪资待遇(多选)",@"经验要求",@"行业分类",@"公司规模",@"融资阶段"]
#define titleArr2 @[@"开发语言",@"iOS开发语言(多选)",@"ios常用库架构",@"iOS开发方向",@"目标操作系统",@"iOS开发项目",@"iOS开发项目",@"iOS开发语言"]
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4){
        return titleArr1[dropIndexPath.row];
    }else if (dropIndexPath.section == 5){
        return titleArr2[dropIndexPath.row];
    }
    return nil;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 3) {
        return 50;
    }
    return 35;
}

- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section >3) {
        return 10;
    }
    return 0;
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 3;
}

- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath{
    if (dropIndexPath.section == 5&&dropIndexPath.row == 0) {
        BossSearch *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BossSearch class]) forIndexPath:indexpath];
        return headView;
    }
    return nil;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section > 3) {
        return 35;
    }
    return 0;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section>3) {
        if (dropIndexPath.row == 1) {
            return MenuEditMoreCheck;
        }
    }else if (dropIndexPath.section == 3 && dropIndexPath.row == 2) {
        return MenuEditMoreCheck;
    }
    if(dropIndexPath.section<2) return MenuEditNone;
    return MenuEditOneCheck;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section>2) {
        return MenuShowAnimalBoss;
    }
    return MenuShowAnimalNone;
}
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (section>2) {
        return MenuHideAnimalBoss;
    }
    return MenuHideAnimalNone;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4||dropIndexPath.section == 5) {
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = NO;
    confirmView.confirmBtn.backgroundColor = MenuColor(0x00c2bb);
    confirmView.resetBtn.backgroundColor = MenuColor(0xf2f2f2);
    [confirmView.resetBtn setTitle:@"清除" forState:UIControlStateNormal];
    [confirmView.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmView.confirmBtn setTitleColor:MenuColor(0xffffff) forState:UIControlStateNormal];
    confirmView.confirmBtn.layer.masksToBounds = YES;
    confirmView.resetBtn.layer.masksToBounds = YES;
    confirmView.confirmBtn.layer.cornerRadius = 5;
    confirmView.resetBtn.layer.cornerRadius = 5;
    confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(15, 0, confirmView.frame.size.width*0.3, confirmView.frame.size.height)];
    confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.35, 0, confirmView.frame.size.width*0.6, confirmView.frame.size.height)];
}

- (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection:(NSInteger)section selectNoramelData:(NSMutableArray*)selectNoramalData selectStringData:(NSMutableArray*)selectData{
    NSLog(@"%@ \n  %@",selectNoramalData,selectData);
}

@end


@implementation BossSearch

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *back = [UIView new];
        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(0, 0, Menu_Width, 70);
        UISearchBar *bar = [UISearchBar new];
        bar.tag = 999;
        bar.barTintColor = [UIColor whiteColor];
        bar.backgroundColor = [UIColor whiteColor];
        bar.searchBarStyle = UISearchBarStyleMinimal;
        bar.searchTextField.textAlignment = NSTextAlignmentCenter;
        bar.placeholder = @"请搜索";
        bar.frame = CGRectMake(10, 0, Menu_Width-20, 70);
        [back addSubview:bar];
        [self addSubview:back];
    }
    return self;
}

@end
