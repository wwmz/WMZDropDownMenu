//
//  DemoOne.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/2/27.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "DemoOne.h"

@interface DemoOne ()

@end

@implementation DemoOne

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(0)
    .wMaxHeightScaleSet(0.8)
    .wReginerCollectionCellsSet(@[@"DemoOneCell"])
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xffffff))
    .wCollectionViewSectionShowExpandCountSet(10000)
    .wMenuTitleEqualCountSet(4)
    .wDefaultConfirmHeightSet(50)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xff2448));
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 60) withParam:param];
    menu.backgroundColor = MenuColor(0xfffeff);
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @"全部",
         @{@"name":@"合/整租"},
         @{@"name":@"租金"},
         @{@"name":@"筛选",@"normalImage":@"menu_shaixuan",
           @"selectImage":@"menu_shaixuan"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 3){
        return 4;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 2;
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 0)
            return @[@"会员领红包",
                     @"首单立减",@"津贴联盟",@"首次光顾立减",@"满减优惠",@"下单返红包",
                     @"进店领红包",@"赠品优惠",@"特价商品"];
        else if (dropIndexPath.row == 1)
            return @[@"主卧独卫",@"独立阳台"];
        else if (dropIndexPath.row == 2)
            return @[@"南",@"北",@"东",@"西"];
        else if (dropIndexPath.row == 3)
        return @[@"全部",@"优家3.0",@"优家4.0",@"优家5.0",@"优家6.0",@"优家7.0",@"优家8.0"];
    }else if (dropIndexPath.section == 1) {
        return @[@"整租",@"合租"];
    }else if (dropIndexPath.section == 2) {
        if (dropIndexPath.row == 0) {
             return @[@"不限",@"2000以下",@"2000-3000",@"2000-300000"];
        }
        return @[@{@"config":@{@"lowPlaceholder":@"输入最低价",@"highPlaceholder":@"输入最高价",}}];
    }
    return @[];
}

#define titleArr @[@"优惠活动",@"商家服务",@"人均价格带",@"装修风格"]
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return titleArr[dropIndexPath.row];
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
       return 4;
    }else if (dropIndexPath.section == 1) {
        return 2;
    }else if (dropIndexPath.section == 2) {
        if (dropIndexPath.row == 0) {
            return 1;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return 44;
    }else if (dropIndexPath.section == 1) {
        return 20;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 1) {
        return 20;
    }
    return 10;
}
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuUINone;
    }else if (dropIndexPath.section == 2) {
        if (dropIndexPath.row == 1) {
            return MenuUICollectionRangeTextField;
        }
    }
    return MenuUICollectionView;
}

- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView
              AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    if (dropIndexPath.section == 2&&dropIndexPath.row == 0) {
         DemoOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoOneCell" forIndexPath:indexpath];
         cell.textLa.text = model.name;
         cell.textLa.textColor = model.isSelected?MenuColor(0xff2448):MenuColor(0x333333);
        return cell;
    }
    return nil;
}


- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) return MenuEditNone;
    if (dropIndexPath.section == 1 ||dropIndexPath.section == 2 ) return MenuEditOneCheck;
    return MenuEditMoreCheck;
}
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
     if (section == 1 || section == 2) {
         return MenuHideAnimalTop;
     }else if (section == 3) {
         return MenuHideAnimalLeft;
     }
     return MenuHideAnimalNone;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return MenuShowAnimalBottom;
    }else if (section == 3) {
        return MenuShowAnimalRight;
    }
    
    return MenuShowAnimalNone;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.showBorder = YES;
    confirmView.resetBtn.backgroundColor = MenuColor(0xfcfdfd);
    [confirmView.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmView.confirmBtn.backgroundColor = MenuColor(0xff2448);
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (NSDictionary *)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
    menuBtn.layer.borderWidth = MenuK1px;
    menuBtn.layer.borderColor = MenuColor(0x999999).CGColor;
    menuBtn.layer.cornerRadius = 20;
    menuBtn.layer.masksToBounds = YES;
    return @{@"offset":@(15),@"y":@(12)};
}
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn *)selectBtn{
    
    [menu.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (selectBtn == obj) {
            obj.backgroundColor = MenuColor(0xff2448);
        }else{
            obj.backgroundColor = MenuColor(0xfffeff);
        }
        if ([obj isSelected]) {
            if (idx == 0 && selectBtn != obj) {
                 [obj setTitleColor:MenuColor(0x333333) forState:UIControlStateSelected];
            }else{
                 [obj setTitleColor:MenuColor(0xFFFFFF) forState:UIControlStateSelected];
            }
        }else{
            [obj setTitleColor:MenuColor(0x333333) forState:UIControlStateNormal];
        }
    }];
}

- (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree *)data{
    //有个特殊场景 点击全部 取消其他选中 点击其他 取消全部
    if (dropIndexPath.section == 3 && dropIndexPath.row == 3) {
        if (indexpath.row == 0) {
            NSArray *arr = [menu.dataDic objectForKey:dropIndexPath.key];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              if (idx != 0 && obj.isSelected) {
                [menu updateDataConfig:@{@"isSelected":@(NO)} AtDropIndexPathSection:dropIndexPath.section AtDropIndexPathRow:dropIndexPath.row AtIndexPathRow:idx];
                }
            }];
        }else{
            [menu updateDataConfig:@{@"isSelected":@(NO)} AtDropIndexPathSection:dropIndexPath.section AtDropIndexPathRow:dropIndexPath.row AtIndexPathRow:0];
        }
    }
}
//隐藏默认底部示例
//- (UIView *)menu:(WMZDropDownMenu *)menu userInteractionFootViewInSection:(NSInteger)section{
//    if (section == 1) return [UIView new];
//    return nil;
//}

@end

@implementation DemoOneCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textLa];
        self.textLa.frame = self.contentView.bounds;
        self.textLa.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:15.0f];
        _textLa.numberOfLines = 0;
        _textLa.textColor = MenuColor(0x333333);
    }
    return _textLa;
}
@end
