//
//  YiTaoOneDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/18.
//  Copyright © 2020 wmz. All rights reserved.
//
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#import "YiTaoOneDemo.h"
#import "WMZDropDownMenu.h"
static NSString *const CollectionViewCell = @"CollectionViewCell";
@interface YiTaoOneDemo ()<UICollectionViewDelegate, UICollectionViewDataSource,WMZDropMenuDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)WMZDropDownMenu *menu;
@end

@implementation YiTaoOneDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
    [self addMenuUI];
}

- (void)addMenuUI{
    WMZDropMenuParam *param = MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xFF003c))
    .wMenuTitleEqualCountSet(5);
    self.menu = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, 0, Menu_Width, 40) withParam:param];
    self.menu.delegate = self;
}

#pragma -mark menuDeleagte

//⚠️重点
//返回所在视图
- (UIScrollView *)inScrollView{
    return self.collectionView;
}
//动态高度
- (CGFloat)popFrameY{
    CGRect rect = [self.collectionView convertRect:self.menu.superview.frame toView:[self.collectionView superview]];
    return rect.origin.y+self.menu.frame.size.height;
}
//点击第一个标题的时候置顶
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn *)selectBtn{
    if (section == 0) {
        //动画关闭
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"人气排序",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @"",
         @{@"name":@"人气排序",@"normalImage":@"menu_treeCheck",
           @"selectImage":@"menu_treeCheckSelect"},
         @{@"name":@"人气排序",@"normalImage":@"menu_treeCheck",
           @"selectImage":@"menu_treeCheckSelect"},
         @{@"name":@"筛选",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"}
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0)return 1;
    if (section == 4)return 2;
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0){
        return @[@"人气排序",@"价格高到低",@"价格由低到高",@"销量优先"];
    }
    if (dropIndexPath.section == 4){
        if (dropIndexPath.row == 0) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价"}}];
        if (dropIndexPath.row == 1) return @[@"免运费",@"天猫",@"消费者保障",@"正品保障",@"七天退换",@"货到付款"];
    }
    return @[];
}
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if(dropIndexPath.section == 0) return MenuEditOneCheck;
    if(dropIndexPath.section == 4 ){
        if (dropIndexPath.row == 1) return MenuEditMoreCheck;
        return MenuEditOneCheck;
    }
    return MenuEditCheck;
}

#define titleArr1 @[@"价格区间(元)",@"商家服务"]
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4){
        return titleArr1[dropIndexPath.row];
    }
    return nil;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 1) return 0;
        return 20;
    }
    return 0;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) return MenuUITableView;
    if (dropIndexPath.section == 4){
        if (dropIndexPath.row == 0) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUINone;
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 0 || dropIndexPath.row == 2) {
            return 1;
        }
    }
    return 4;
}

- (NSDictionary*)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
    if (section == 2||section == 3) {
        menuBtn.position = MenuBtnPositionLeft;
    }else if (section == 4) {
        [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathLeft PathWidth:MenuK1px heightScale:1 button:menuBtn];
    }
    return @{@"offset":@(5)};
}



#pragma -mark collectionView Deleagte
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        if (indexPath.section == 1) {
           [headerView addSubview:self.menu];
        }else{
            [self.menu removeFromSuperview];
        }
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width,section == 0?0:40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell forIndexPath:indexPath];
    cell.backgroundColor = randomColor;
    return cell;
        
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return 20;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
        flow.itemSize = CGSizeMake(Menu_Width/2 - 30, 100);
        flow.minimumLineSpacing = 10;
        flow.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, Menu_Height-Menu_NavigationBar) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
           _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}


@end
