//
//  MeiTuanWMDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/27.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "MeiTuanWMDemo.h"
@interface MeiTuanWMDemo ()
@property(nonatomic,strong)NSDictionary *dataDic;
@end

@implementation MeiTuanWMDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(10)
    .wCollectionViewCellSelectTitleColorSet([UIColor orangeColor])
    .wCollectionViewSectionRecycleCountSet(8)
    .wMaxHeightScaleSet(0.5);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"综合排序",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"品类",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"速度",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"全部筛选",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
   if (section == 1){
        return 2;
    }else if (section == 3){
        return 5;
    }

    return 1;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 0){
          return @[@"综合排序",@"销量优先",@"速度优先",@"评分优先",
                   @"综合排序",@"销量优先",@"速度优先",@"评分优先"];

      }else if (dropIndexPath.section == 1){
          if (dropIndexPath.row == 0) return @[@"全部品类",@"美食",@"甜点饮品",@"超市便利",
                                               @"生鲜果蔬",@"送药上门",@"鲜花绿植"];
          if (dropIndexPath.row == 1) return @[];
      }else if (dropIndexPath.section == 2){
           return @[@"30分钟内",@"40分钟内",@"50分钟内",@"60分钟内",@"30km内",@"40km内",@"50km内",@"60km内"];
      }else if (dropIndexPath.section == 3){
           if (dropIndexPath.row == 0) return @[@"四星以上",@"品牌商家"];
           if (dropIndexPath.row == 1) return @[@"美团专送",@"到店自取"];
           if (dropIndexPath.row == 2) return @[@"优惠商家",@"满减优惠",@"近端领券",@"折扣商品",
                                                @"优惠商家",@"满减优惠",@"近端领券",@"折扣商品",
                                                @"优惠商家",@"满减优惠",@"近端领券",@"折扣商品"];
           if (dropIndexPath.row == 3) return @[@"跨天预定",@"开发票",
                                                @{@"name":@"赠准时宝",@"image":@"menu_xinyong"},
                                                @{@"name":@"极速退款",@"image":@"menu_xinyong"}];
          if (dropIndexPath.row == 4) return @[@"30分钟内",@"40分钟内",@"50分钟内",@"60分钟内",
                                               @"30km内",@"40km内",@"50km内",@"60km内"];
      }
      return @[];
}

#define titleArr2 @[@"品质",@"配送",@"优惠活动",@"商家特色",@"速度"]
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3){
        return titleArr2[dropIndexPath.row];
    }
    return nil;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 0 || dropIndexPath.section == 1) {
        return 40;
    }
    return 35;
}
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section ==3) {
        return 20;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return 35;
    }
    return 0;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    return MenuShowAnimalBottom;
}
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    return MenuHideAnimalTop;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2||dropIndexPath.section == 3) {
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3 && dropIndexPath.row == 2) {
        return YES;
    }
    return NO;
}

- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 1&&dropIndexPath.row == 1)  return YES;
    else if (dropIndexPath.section == 0) return YES;
    return NO;
}

- (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree*)data{
    //手动更新二级联动数据
    if (dropIndexPath.section == 1) {
        if (dropIndexPath.row == 0) {
            NSArray *arr = self.dataDic[data.name];
            if (arr.count == 0) {
                [menu closeWith:dropIndexPath row:indexpath.row data:data];
            }
            [menu updateData:self.dataDic[data.name] ForRowAtDropIndexPath:dropIndexPath];
        }
    }
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = YES;
    confirmView.confirmBtn.backgroundColor = MenuColor(0xFFc254);
    [confirmView.confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (NSDictionary*)dataDic{
    if (!_dataDic) {
        _dataDic = @{
//            @[@"全部",@"水果",@"蔬菜",@"冷冻速食",@"肉禽奶蛋",@"肉饼加墨"]
                  @"全部品类":@[],
                  @"美食":@[@"全部",@"水果1",@"蔬菜1",@"冷冻速食1",@"肉禽奶蛋1",@"肉饼加墨1"],
                  @"甜点饮品":@[@"全部",@"水果2",@"蔬菜2",@"肉禽奶蛋2",@"肉饼加墨2"],
                  @"超市便利":@[@"全部",@"水果3",@"蔬菜3",@"肉饼加墨3"],
                  @"生鲜果蔬":@[@"全部",@"水果4",@"冷冻速食4",@"肉禽奶蛋4",@"肉饼加墨4"],
                  @"送药上门":@[@"全部",@"冷冻速食5",@"肉禽奶蛋5",@"肉饼加墨5"],
                  @"鲜花绿植":@[@"全部",@"冷冻速食6",@"肉禽奶蛋6",@"肉饼加墨6",@"蔬6"],
        };
    }
    return _dataDic;
}

@end
