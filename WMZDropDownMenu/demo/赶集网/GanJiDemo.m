


//
//  GanJiDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/26.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "GanJiDemo.h"
@interface GanJiDemo ()
{
    WMZDropDownMenu *menu;
    BOOL showDetail;
}
@end

@implementation GanJiDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xFF513c))
    .wCollectionViewSectionRecycleCountSet(3)
    .wMaxHeightScaleSet(0.6)
    .wBorderShowSet(YES)
    .wBorderUpDownShowSet(YES)
    .wCellSelectShowCheckSet(NO);
    
    menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}


- (void)showData:(BOOL)show{
    if (showDetail == show) return;
    [menu updateData:show?@[@"不限",@"一室",@"两室",@"三室",@"四室及以上"]:nil AtDropIndexPathSection:2 AtDropIndexPathRow:1];
    CGFloat timeHeight = show?150:-150;
    CGRect dataViewRect = menu.dataView.frame;
    dataViewRect.size.height += timeHeight;
    menu.dataView.frame = dataViewRect;
    for (UICollectionView *collectionView in menu.showView) {
        if ([collectionView isKindOfClass:[UICollectionView class]]) {
            CGRect collectionViewRect = collectionView.frame;
            collectionViewRect.size.height += timeHeight;
            collectionView.frame = collectionViewRect;
            [collectionView reloadData];
        }
   }
  CGRect confirmViewRect = menu.confirmView.frame;
  confirmViewRect.origin.y += timeHeight;
  menu.confirmView.frame = confirmViewRect;
  showDetail = show;
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"全广州",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"租金",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"户型",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @{@"name":@"更多",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
   if (section == 0){
        return 2;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 4;
    }

    return 1;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 0){
          if (dropIndexPath.row == 0) return @[@"附近",@{@"name":@"区域"},@"地铁",@"学校"];
          if (dropIndexPath.row == 1) return @[@"1号线",@"2号线",@"3号线",@"4号线",@"5号线",
                                               @"1号线",@"2号线",@"3号线",@"4号线",@"5号线",
                                               @"1号线",@"2号线",@"3号线",@"4号线",@"5号线"];
      }else if (dropIndexPath.section == 1){
          return @[@"500元以下",@"500-1000",@"1000-1500",@"1500-2000",@"2500-3000",@"2500-3000",@"2500-3000",];
      }else if (dropIndexPath.section == 2){
           if (dropIndexPath.row == 0) return @[@"展开",@"收缩"];
      }else if (dropIndexPath.section == 3){
           if (dropIndexPath.row == 0) return @[@"不限",@"个人",@"经纪人",@"品牌公寓"];
           if (dropIndexPath.row == 1) return @[@"不限",@"安选"];
           if (dropIndexPath.row == 2) return @[@"不限",@"压一付一",@"压一付一",@"压一付一",@"压一付一",
                                                @"压一付一",@"压一付一",
                                                @"压一付一",@"压一付一",@"压一付一",@"压一付一",
                                                @"压一付一",@"压一付一",@"压一付一",@"压一付一"];
           if (dropIndexPath.row == 3) return @[@"不限",@"东",@"西",@"南",@"北",@"南北"];
      }
      return @[];
}

#define titleArr1 @[@"卧室",@"户型"]
#define titleArr2 @[@"房间来源",@"验真情况",@"房源特色",@"朝向"]
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2){
        return titleArr1[dropIndexPath.row];
    }else if (dropIndexPath.section == 3){
        return titleArr2[dropIndexPath.row];
    }
    return nil;
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 3;
}
/*
*是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES 
*/
- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section{
    return NO;
}

//- (NSDictionary*)menu:(WMZDropDownMenu *)menu  customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn*)menuBtn{
//    if (section == 1) {
//        //选中中间清除其他所有选中
//        menuBtn.clear = YES;
//    }
//    return @{};
//}


/*
*互斥的标题数组 即互斥不能同时选中 返回标题对应的section (配合关联代理使用更加)
*/
//- (NSArray*)mutuallyExclusiveSectionsWithMenu:(WMZDropDownMenu *)menu{
//    return @[@(0),@(1)];
//}



- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 0 || dropIndexPath.section == 1) {
        return 50;
    }
    return 35;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2||dropIndexPath.section == 3) {
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (section==3) {
        return MenuHideAnimalLeft;
    }
    return MenuHideAnimalTop;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
     if (section==3) {
          return MenuShowAnimalRight;
      }
      return MenuShowAnimalBottom;
}


- (UITableViewCell*)menu:(WMZDropDownMenu *)menu cellForUITableView:(WMZDropTableView *)tableView AtIndexPath:(NSIndexPath *)indexpath dataForIndexPath:(WMZDropTree *)model{
    if (tableView.dropIndex.section == 1) {
        GanJiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GanJiTableViewCell"];
        if (!cell) {
            cell = [[GanJiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GanJiTableViewCell"];
        }
        cell.textLabel.text = model.name;
        cell.textLabel.textColor = model.isSelected?MenuColor(0xFF513c):MenuColor(0x666666);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    return nil;
}
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0&&dropIndexPath.row == 1)  return YES;
    else if (dropIndexPath.section == 1) return YES;
    return NO;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = NO;
    confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(0, 0,0 , confirmView.frame.size.height)];
    confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(0, 0,confirmView.frame.size.width , confirmView.frame.size.height)];
    confirmView.confirmBtn.backgroundColor = MenuColor(0xFF513c);
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}



-  (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree *)data{
    if (dropIndexPath.section == 0 && dropIndexPath.row == 1) {
        if (indexpath.row == 0) {
            [menu updateDataConfig:@{@"isSelected":@(NO)} AtDropIndexPathSection:2 AtDropIndexPathRow:0 AtIndexPathRow:2];
        }
    }else if (dropIndexPath.section == 2 && dropIndexPath.row == 0) {
        if (indexpath.row == 0) {
            data.isSelected?[self showData:YES]:[self showData:NO];
        }else{
            data.isSelected?[self showData:NO]:[self showData:YES];
        }
    }
}

@end


@implementation GanJiTableViewCell
@end
