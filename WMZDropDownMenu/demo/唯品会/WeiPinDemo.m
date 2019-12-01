//
//  WeiPinDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/29.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WeiPinDemo.h"

@interface WeiPinDemo ()

@end

@implementation WeiPinDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param1 =
    MenuParam()
    .wMainRadiusSet(0)
    .wMaxWidthScaleSet(0.8)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xff3a94))
    .wMenuTitleEqualCountSet(5)
    .wCollectionViewSectionRecycleCountSet(3)
    .wCollectionViewDefaultFootViewMarginYSet(10)
    .wCollectionViewDefaultFootViewPaddingYSet(10)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xfff2f0));
    WMZDropDownMenu *menu1 = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param1];
    menu1.tag = 111;
    menu1.delegate = self;
    [self.view addSubview:menu1];
    
    
    WMZDropMenuParam *param2 =
    MenuParam()
    .wMainRadiusSet(0)
    .wReginerCollectionCellsSet(@[@"WeiPinCollectionView"])
    .wMaxWidthScaleSet(0.8)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xff3a94))
    .wMenuTitleEqualCountSet(4)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xfff2f0));
    WMZDropDownMenu *menu2 = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(menu1.frame), Menu_Width, 40) withParam:param2];
    menu2.delegate = self;
    [self.view addSubview:menu2];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    if (menu.tag == 111) {
        return @[@{@"name":@"综合",},
                 @"销量",
                 @{@"name":@"品牌",@"normalImage":@"menu_shaixuan",@"selectImage":@"menu_shaixuan"},
                 @{@"name":@"筛选",@"normalImage":@"menu_shaixuan",@"selectImage":@"menu_shaixuan"},
                 @{@"normalImage":@"menu_pubu_2",@"selectImage":@"menu_pubu_1"}];
    }
    return @[@"黑色星期五",@"新货",@"唯品自营",@{@"name":@"布衣"}];
}

- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (menu.tag == 111) {
        if (section == 0||section == 2) return 1;
        else if (section == 3) return 6;
    }else{
        if (section == 3) return 1;
    }
    return 0;
}

- (NSArray*)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 0) return @[@"综合排序",@"折扣优先",@"价格由高到低",@"价格由低到高"];
        if (dropIndexPath.section == 2)
            return @[@{@"name":@"奥索洛",@"image":@"menu_image2"},
                     @{@"name":@"奥莎尼",@"image":@"menu_image2"},
                     @{@"name":@"奥玛芭莎",@"image":@"menu_image2"},
                     @{@"name":@"奥玛芭思",@"image":@"menu_image2"},
                     @{@"name":@"安踏",@"image":@"menu_image2"},
                     @{@"name":@"乔丹",@"image":@"menu_image2"},
                     @{@"name":@"安所",@"image":@"menu_image2"},
                     @{@"name":@"安居兔",@"image":@"menu_image2"}];
        if (dropIndexPath.section == 3){
            if (dropIndexPath.row == 0)
                return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价"}}];
            if (dropIndexPath.row == 1)
            return @[@"超值特惠",@"新货",@"专柜同步",@"唯品社"];
            if (dropIndexPath.row == 2)
            return @[@"波司登",@"钱扔给",@"高仿11",@"怎嘛",@"森马",@"子墨"];
            if (dropIndexPath.row == 3)
            return @[@"波司登",@"钱扔给",@"高仿11",@"怎嘛",@"森马",@"子墨"];
            if (dropIndexPath.row == 4)
            return @[@"短",@"常规",@"长",@"短",@"常规",@"长",@"短",@"常规",@"长"];
            if (dropIndexPath.row == 5)
            return @[@"黑色",@"白色",@"花色",@"黑色",@"白色",@"花色",
            @"黑色",@"白色",@"花色",@"黑色",@"白色",@"花色",@"黑色",@"白色",@"花色",
            @"黑色",@"白色",@"花色"];
        }
    }else{
        if (dropIndexPath.section == 3) {
            return @[@"短",@"常规",@"长",@"中长",@"不对称衣长"];
        }
    }
    return @[];
}

#define titleArr  @[@"价格区间",@"唯品服务",@"品牌服务",@"皮内",@"颜色",@"哈哈"]
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 3) {
            return titleArr[dropIndexPath.row];
        }
    }
    return nil;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 1||dropIndexPath.section == 4)  return MenuUINone;
        if (dropIndexPath.section == 3){
            if (dropIndexPath.row == 0) {
                return MenuUICollectionRangeTextField;
            }
            return MenuUICollectionView;
        }
        return MenuUITableView;
    }else{
        if (dropIndexPath.section == 3)  return MenuUICollectionView;
        return MenuUINone;
    }
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 2) return MenuEditMoreCheck;
        if (dropIndexPath.section == 3) return MenuEditMoreCheck;
        if (dropIndexPath.section == 1) return MenuEditNone;
        return MenuEditOneCheck;
    }else{
        if (dropIndexPath.section == 3) {
           return MenuEditMoreCheck;
        }
        return MenuEditNone;
    }
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 3&&dropIndexPath.row == 0) {
            return 1;
        }
        return 3;
    }
    return 2;
}

- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111&& dropIndexPath.section == 3) {
        if (dropIndexPath.row>2) {
            return YES;
        }
    }
    return NO;
}

- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (menu.tag == 111) {
        if (section == 0) return MenuHideAnimalTop;
        if (section == 2) return MenuHideAnimalBoss;
        if (section == 3) return MenuHideAnimalLeft;
    }else{
        if (section == 3) return MenuHideAnimalTop;
    }
    return MenuHideAnimalNone;
}

- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (menu.tag == 111) {
        if (section == 0) return MenuShowAnimalBottom;
        if (section == 2) return MenuShowAnimalBoss;
        if (section == 3) return MenuShowAnimalRight;
    }else{
        if (section == 3) return MenuShowAnimalBottom;
    }
    return MenuShowAnimalNone;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 2) {
            return 80;
        }
    }else{
       return 40;
    }
    return 35;
}
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 3) {
            return 20;
        }
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (menu.tag == 111) {
        if (dropIndexPath.section == 3) {
            return 35;
        }
    }
    return 0;
}

- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView *)collectionView AtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath dataForIndexPath:(WMZDropTree *)model{
    if (menu.tag != 111) {
        WeiPinCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeiPinCollectionView" forIndexPath:indexpath];
        cell.textLa.text = model.name;
        cell.textLa.textColor = model.isSelected?MenuColor(0xff3a94):MenuColor(0x333333);
        cell.line.backgroundColor = MenuColor(0xff3a94);
        cell.line.hidden = !model.isSelected;
        cell.check.hidden = !model.isSelected;
        return cell;
    }
    return nil;
}

@end


@implementation WeiPinCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textLa];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.check];
        self.textLa.frame = self.contentView.bounds;
        self.check.frame = CGRectMake(frame.size.width-35, (frame.size.height-25)/2, 25, 25);
        self.line.frame = CGRectMake(0, frame.size.height-1,frame.size.width , 1);
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

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
    }
    return _line;
}

- (UIImageView *)check{
    if (!_check) {
        _check = [UIImageView new];
        _check.image = [UIImage bundleImage:@"menu_check"];
    }
    return _check;
}

@end
