//
//  JingDongDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "JingDongDemo.h"
@interface JingDongDemo ()

@end

@implementation JingDongDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    //注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填否则会崩溃
    .wReginerCollectionHeadViewsSet(@[@"JingDongHeadView"])
    //注册自定义的collectionViewFoootView  如果使用了自定义collectionViewFoootView 必填否则会崩溃
    .wReginerCollectionFootViewsSet(@[@"JingDongFootViewView"])
    .wCollectionViewDefaultFootViewMarginYSet(10)
    .wMainRadiusSet(15)
    .wMaxHeightScaleSet(0.8)
    .wMenuLineSet(YES)
    .wCollectionViewCellBorderWithSet(1)
    .wCollectionViewCellSelectTitleColorSet([UIColor redColor]);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
        @{@"name":@"综合"},
        @{@"name":@"销量",@"selectTitle":@"改变",@"hideDefatltImage":@(YES)},
        @{@"name":@"距离价格",
          @"selectTitle":@"由小到大",
          @"reSelectTitle":@"由大到小",
          @"normalImage":@"menu_shangxia",
          @"selectImage":@"menu_xiangshang",
          @"reSelectImage":@"menu_xiangxia"},
         @{@"name":@"筛选",@"normalImage":@"menu_shaixuan"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 3){
        return 6;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        //默认选中
        return @[@{@"name":@"综合排序",@"isSelected":@(YES)},@"评论数从高到低"];
    }else if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 0)
            return @[@"京东物流",@"货到d付款",@"仅看有货",@"促销",@"京东国际",@"Plus专项",
                     @"搭配全球",@"京东超市",@"拍拍二手"];
        if (dropIndexPath.row == 1) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价"}}];
        if (dropIndexPath.row == 2)
            return @[@"索尼\nSONY",@"华为\nHUAWEI",@"索尼\nSONY",@"索尼\nSONY",@"华为\nHUAWEI",@"索尼\nSONY",@"索尼\nSONY",
                     @"索尼\nSONY",@"华为\nHUAWEI",@"索尼\nSONY",@"华为\nHUAWEI",@"索尼\nSONY",@"索尼\nSONY",@"索尼\nSONY",
                     @"索尼\nSONY",@"华为\nHUAWEI",@"索尼\nSONY"];
        if (dropIndexPath.row == 3)
        return @[
                 @"手机配件",
                 @"影音娱乐",
                 ////查看更多 checkMore传YES
                 @{@"name":@"更多分类>>",@"checkMore":@(YES)
                 }
        ];
        if (dropIndexPath.row == 4)
        return @[@"京东物流",@"货到d付款",@"仅看有货",@"促销",@"京东国际",@"Plus专项",
        @"搭配全球",@"京东超市",@"拍拍二手"];
        if (dropIndexPath.row == 5)
        return @[@"京东物流",@"货到d付款",@"仅看有货",@"促销",@"京东国际",@"Plus专项",
        @"搭配全球",@"京东超市",@"拍拍二手"];
    }
    return @[];
}

#define titleArr @[@"服务/折扣",@"价格区间",@"品牌",@"全部分类",@"用途",@"连接类型",@"佩戴方式"]
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return titleArr[dropIndexPath.row];
    }else if ([dropIndexPath.key isEqualToString:moreTableViewKey]) {
        return @"全部分类";
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 1) {
            return 1;
        }
        return 3;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return 35;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.section == 3 && dropIndexPath.row>0 && dropIndexPath.row %2 == 0) {
            return 40;
        }
        return 20;
    }
    return 0;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 1) return 50;
        if (dropIndexPath.row == 2) return 45;
    }
    return 35;
}

- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView *)collectionView AtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 3 && dropIndexPath.row == 0) {
        JingDongHeadView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JingDongHeadView" forIndexPath:indexpath];
        head.textLa.text = @"服务/折扣";
        [head.accessTypeBtn setTitle:@"广东省广州市XXXXXXXXXX" forState:UIControlStateNormal];
        [head.accessTypeBtn setImage:[UIImage bundleImage:@"menu_xinyong"] forState:UIControlStateNormal];
        return head;
    }
    return nil;
}

- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu footViewForUICollectionView:(WMZDropCollectionView *)collectionView AtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 3 && dropIndexPath.row>0 && dropIndexPath.row %2 == 0) {
        JingDongFootViewView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JingDongFootViewView" forIndexPath:indexpath];
        return foot;
    }
    return nil;
}

- (UITableViewCell*)menu:(WMZDropDownMenu *)menu cellForUITableView:(WMZDropTableView*)tableView AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    //自定义查看更多的样式 其他自定义代理也是根据这个判断
    if ([tableView.dropIndex.key isEqualToString:moreTableViewKey]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = model.isSelected?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = model.name;
        cell.textLabel.textColor = model.isSelected?[UIColor redColor]:[UIColor blackColor];
        return cell;
    }
    return nil;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return MenuUITableView;
    }else if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 1) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2)  return MenuEditReSetCheck;
    else if (dropIndexPath.section == 0)  return MenuEditOneCheck;
    else  if (dropIndexPath.section == 1)  return MenuEditNone;
    return MenuEditMoreCheck
    ;
}

- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row>3) {
            return YES;
        }
    }
    return NO;
}

- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
   confirmView.showBorder = NO;
   confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.025, 0,confirmView.frame.size.width*0.45 , confirmView.frame.size.height)];
   confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.525, 0,confirmView.frame.size.width*0.45 , confirmView.frame.size.height)];
    confirmView.resetBtn.backgroundColor = MenuColor(0xffffff);
    confirmView.confirmBtn.backgroundColor = [UIColor menuColorGradientChangeWithSize:CGSizeMake(confirmView.frame.size.width*0.45, confirmView.frame.size.height) direction:MenuGradientChangeDirectionLevel startColor:MenuColor(0xff0024) endColor:MenuColor(0xff4427)];
    [confirmView.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmView.confirmBtn.layer.masksToBounds = YES;
    confirmView.resetBtn.layer.masksToBounds = YES;
    confirmView.resetBtn.layer.cornerRadius = confirmView.frame.size.height/2;
    confirmView.resetBtn.layer.borderColor = MenuColor(0x999999).CGColor;
    confirmView.resetBtn.layer.borderWidth = MenuK1px;
    confirmView.confirmBtn.layer.cornerRadius = confirmView.frame.size.height/2;
}

- (NSDictionary*)menu:(WMZDropDownMenu *)menu  customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn*)menuBtn{
    if (section == 0) {
        [menu changeTitleConfig:@{} withBtn:menuBtn];
        [menuBtn showLine:@{}];
    }
    return @{};
}

//查看更多
- (NSArray *)menu:(WMZDropDownMenu *)menu moreDataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3 && dropIndexPath.row == 3) {
        return @[
            @{@"name":@"手机",@"cellHeight":@(50)},
            @{@"name":@"手机111",@"cellHeight":@(50)},
            @{@"name":@"手机222",@"cellHeight":@(50)},
            @{@"name":@"手机333",@"cellHeight":@(50)},
            @{@"name":@"手机444",@"cellHeight":@(50)},
            @{@"name":@"手机555",@"cellHeight":@(50)},
            @{@"name":@"手机0000000",@"cellHeight":@(50)}];
    }
    return @[];
}

- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section{
    return YES;
}
@end











@implementation JingDongHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.textLa];
        self.textLa.frame = CGRectMake(Menu_GetWNum(30), 0, frame.size.width*0.35, frame.size.height);
        [self addSubview:self.accessTypeBtn];
        self.accessTypeBtn.frame = CGRectMake(CGRectGetMaxX(self.textLa.frame)+Menu_GetWNum(30) , 0, frame.size.width*0.55, frame.size.height);
    }
    return self;
}
- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:15.0f];
        _textLa.textColor = MenuColor(0x666666);
    }
    return _textLa;
}
- (UIButton *)accessTypeBtn{
    if (!_accessTypeBtn) {
        _accessTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accessTypeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_accessTypeBtn setTitleColor:MenuColor(0x333333) forState:UIControlStateNormal];
    }
    return _accessTypeBtn;
}
@end

@implementation JingDongFootViewView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.back];
        self.back.frame = CGRectMake(0, 20, frame.size.width, frame.size.height/2);
        
    }
    return self;
}

- (UIView *)back{
    if (!_back) {
        _back = [UIView new];
        _back.backgroundColor = MenuColor(0xf2f2f2);
    }
    return _back;
}
@end
