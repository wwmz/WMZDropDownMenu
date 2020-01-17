


//
//  ShowDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "ShowDemo.h"
@interface ShowDemo ()<WMZDropMenuDelegate>

@end

@implementation ShowDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WMZDropMenuParam *param =
    MenuParam()
    //collctionCell 间距
    .wCollectionViewCellSpaceSet(10)
    //collectionCell 背景颜色
    .wCollectionViewCellBgColorSet(MenuColor(0xf2f2f2))
    //collectionCell 标题颜色
    .wCollectionViewCellTitleColorSet(MenuColor(0x666666))
    //collectionCell 选中背景颜色
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xffeceb))
     //collectionCell 选中标题颜色
    .wCollectionViewCellSelectTitleColorSet([UIColor redColor])
    //默认collectionView距离底部的y值
    .wCollectionViewDefaultFootViewMarginYSet(20)
    //默认collectionView距离顶部的y值
    .wCollectionViewDefaultFootViewPaddingYSet(20)
    //一行section超过多少个显示收缩按钮
    .wCollectionViewSectionShowExpandCountSet(9)
    //回收状态时候显示的cell个数 default 0
    .wCollectionViewSectionRecycleCountSet(0)
    //默认重置确定视图的高度
    .wDefaultConfirmHeightSet(40)
    //标题等分宽度
    .wMenuTitleEqualCountSet(4)
    //显示标题选中下划线
    .wMenuLineSet(NO)
    //注册自定义collectionViewCell 类名 如果使用了自定义collectionView 必填否则会崩溃
    .wReginerCollectionCellsSet(@[@"ViewCustomCollectionViewCell"])
    //注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填否则会崩溃
    .wReginerCollectionHeadViewsSet(@[@"CollectionViewCustomHeadView"])
    //注册自定义的collectionViewFoootView  如果使用了自定义collectionViewFoootView 必填否则会崩溃
    .wReginerCollectionFootViewsSet(@[@"CollectionViewCustomFootView"])
    //固定弹出数据层的高度
    //.wFixDataViewHeightSet(200)
    //弹出样式为pop时的视图宽度
    .wPopViewWidthSet(200)
    //遮罩层的透明度
    .wShadowAlphaSet(0.4f)
    //遮罩层的颜色
    .wShadowColorSet(MenuColor(0x333333))
    //遮罩层能否点击
    .wShadowCanTapSet(YES)
    //遮罩层是否显示
    .wShadowShowSet(YES)
    //京东样式底部线自定义修改
    .wJDCustomLineSet(^(UIView *customLine) {
        
    })
    //如果弹出位置不准确可以设置此属性
//    .wPopOraignYSet(200)
    ;

    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    [self.view addSubview:menu];
}

#pragma -mark WMZDropMenuDelegate

/*
*标题数组
 1 传字符串数组 其余属性为默认
 2 可传带字典的数组
 字典参数@{
 @"name":@"标题",
 @"font":@(15)(字体大小)
 @"normalColor":[UIColor blackClor](普通状态下的字体颜色)
 @"selectColor":[UIColor redColor](选中状态下的字体颜色)
 @"normalImage":@"1"(普通状态下的图片)
 @"selectImage":@"2"(选中状态下的图片)
 @"reSelectImage":@"3"(选中状态下再点击的图片~>用于点击两次才回到原来的场景)
 @"lastFix":@(YES) (最后一个固定在在右边,仅最后一个有效)
 }
*/
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
        @{@"name":@"综合"},
        @{@"name":@"品类",@"normalImage":@"menu_twoCheck",
        @"selectImage":@"menu_xiangshang",@"reSelectImage":@"menu_xiangxia"},
        @"速度",
        @"筛选",
        ];
}
/*
 *返回setion行标题有多少列 默认1列
 */
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 3) {
        return 4;
    }
    return 1;
}
/*
*返回WMZDropIndexPath每行 每列的数据
*/
- (NSArray*)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    switch (dropIndexPath.section) {
        case 0:
            {
                if (dropIndexPath.row == 0) {
                    return @[@"1",@"2",@"3",@"4",@"5"];
                }else {
                    return @[@"1_1",@"2_2",@"3_3",@"4_4",@"5_5"];
                }
            }
            break;
           case 1:
            {
                //带图片
                return @[
                    @{@"name":@"11",@"image":@"menu_xinyong"},
                    @{@"name":@"22",@"image":@"menu_xinyong"},
                    @{@"name":@"33",@"image":@"menu_xinyong"},
                    @{@"name":@"44",@"image":@"menu_xinyong"},
                    @{@"name":@"55",@"image":@"menu_xinyong"},
                ];
            }
            break;
            case 2:
            {
                return @[@"1111",@"2222",@"33333"];
            }
            break;
            case 3:
            {
                if (dropIndexPath.row == 0) {
                    return @[@"111_1",@"222_2",@"333_3",@"444_4",@"555_5"];
                }else if (dropIndexPath.row == 1) {
                    return @[@"111_11",@"222_22",@"333_33",@"444_44",@"555_55"];
                }else if (dropIndexPath.row == 2) {
                    return @[@"111_111",@"222_222",@"333_333"];
                }else{
                    return @[@"111_1111",@"222_2222",@"333_3333",@"444_4444",@"555_5555"];
                }
            }
            break;
        default:
            return @[];
            break;
    }
}
/*
 *自定义tableviewCell内容 默认WMZDropTableViewCell 如果要使用默认的cell返回 nil
 */
- (UITableViewCell*)menu:(WMZDropDownMenu *)menu cellForUITableView:(WMZDropTableView*)tableView AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    if (tableView.dropIndex.section == 0 && tableView.dropIndex.row == 0 && indexpath.row !=2) {
        ViewCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ViewCustomCell class])];
        if (!cell) {
            cell = [[ViewCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ViewCustomCell class])];
        }
        cell.textLa.text = model.name;
        cell.textLa.textColor = model.isSelected?[UIColor blueColor]:[UIColor orangeColor];
        cell.textLa.font = [UIFont systemFontOfSize:model.isSelected?19.0:15.0];
        [cell.accessTypeBtn setImage:[UIImage bundleImage:@"menu_check"] forState:UIControlStateNormal];
        cell.accessTypeBtn.hidden = !model.isSelected;
        return cell;
    }
    return nil;
}
/*
*自定义tableView headView
*/
- (UITableViewHeaderFooterView*)menu:(WMZDropDownMenu *)menu headViewForUITableView:(WMZDropTableView*)tableView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    //复用 和tableview用法一样
    TableViewCustomHeadView *myHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TableViewCustomHeadView class])];
    if (!myHeadView) {
        myHeadView = [[TableViewCustomHeadView alloc]initWithReuseIdentifier:NSStringFromClass([TableViewCustomHeadView class])];
    }
    myHeadView.frame = CGRectMake(0, 0, tableView.frame.size.width, 50);
    myHeadView.backView.text = @"自定义tableviewHeadView";
    myHeadView.backView.backgroundColor =  dropIndexPath.row == 0? [UIColor redColor]:[UIColor orangeColor];
    return myHeadView;
}
/*
*自定义tableView footView
*/
- (UITableViewHeaderFooterView*)menu:(WMZDropDownMenu *)menu footViewForUITableView:(WMZDropTableView*)tableView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    TableViewCustomFootView *myFootView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TableViewCustomFootView class])];
    if (!myFootView) {
        myFootView = [[TableViewCustomFootView alloc]initWithReuseIdentifier:NSStringFromClass([TableViewCustomFootView class])];
    }
    myFootView.frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    myFootView.backView.text = @"自定义tableviewFootView";
    myFootView.backView.backgroundColor = dropIndexPath.row == 0? [UIColor yellowColor]:[UIColor blueColor];
    return myFootView;
}


/*
 *自定义collectionViewCell内容
 */
- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView
   AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    if (dropIndexPath.section == 3 && dropIndexPath.row ==1 && indexpath.row == 2) {
        ViewCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ViewCustomCollectionViewCell class]) forIndexPath:indexpath];
        cell.textLa.text = model.name;
        cell.textLa.textColor = model.isSelected?[UIColor orangeColor]:[UIColor blackColor];
        return cell;
    }
    //返回默认的
    return nil;
}

/*
*自定义collectionView headView
*/
- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath{
    CollectionViewCustomHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CollectionViewCustomHeadView class]) forIndexPath:indexpath];
    headView.textLa.text = @"自定义collectionViewHeadView";
    return headView;
}

/*
*自定义collectionView footView
*/
- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu footViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath{
    CollectionViewCustomFootView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([CollectionViewCustomFootView class]) forIndexPath:indexpath];
    headView.textLa.text = @"自定义collectionViewFootView";
    return headView;
}

/*
*headView标题
*/
- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    return @"自定义标题";
}
/*
*footView标题
*/
- (NSString*)menu:(WMZDropDownMenu *)menu titleForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    return @"自定义尾部";
}


/*
*返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath{
    if (dropIndexPath.section == 0 && dropIndexPath.row == 0) {
        return 40;
    }
    return 35;
}
/*
*自定义headView高度 collectionView默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 0 && dropIndexPath.row ==1) {
        return 35;
    }
    return 40;
}
/*
*自定义footView高度
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
     if (dropIndexPath.section == 0 && dropIndexPath.row ==1) {
           return 40;
    }
    return 35;
}

/*
*返回WMZDropIndexPath每行 每列的UI样式  默认MenuUITableView
  注:设置了dropIndexPath.section 设置了 MenuUITableView 那么row则全部为MenuUITableView 保持统一风格
*/
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 1) {
         return MenuUITableView;
     }
     else if (dropIndexPath.section == 3){
         if (dropIndexPath.row == 2) {
             return MenuUICollectionRangeTextField;
         }
         return MenuUICollectionView;
     }
     else if (dropIndexPath.section == 2){
         return MenuUINone;
     }
     return MenuUITableView;
}

/*
*返回section行标题数据视图出现的动画样式   默认 MenuShowAnimalBottom
  注:最后一个默认是筛选 弹出动画为 MenuShowAnimalRight
*/
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    if (section ==0){
        return MenuShowAnimalBottom;
    }else if (section == 3) {
        return MenuShowAnimalRight;
    }else if (section ==1){
        return MenuShowAnimalNone;
    }
    return MenuShowAnimalNone;
}

/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
  注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
*/
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    if (section ==0){
        return MenuHideAnimalTop;
    }else if (section == 3) {
        return MenuHideAnimalLeft;
    }else if (section ==1){
        return MenuHideAnimalTop;
    }
    return MenuHideAnimalNone;
}

/*
*返回WMZDropIndexPath每行 每列的编辑类型 单选|多选  默认单选
*/
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 0 && dropIndexPath.row == 0) {
        return MenuEditOneCheck;
    }else if (dropIndexPath.section == 1) {
        return MenuEditReSetCheck;
    }else if (dropIndexPath.section == 3 && dropIndexPath.row == 1) {
        return MenuEditMoreCheck;
    }else if (dropIndexPath.section == 2) {
        return MenuEditNone;
    }
    return MenuEditOneCheck;
}


/*
*返回WMZDropIndexPath每行 每列 显示的个数
 注:
    样式MenuUITableView         默认4个
    样式MenuUICollectionView    默认1个 传值无效
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 3 && dropIndexPath.row == 1) {
        return 3;
    }else if (dropIndexPath.section == 3 && dropIndexPath.row == 2) {
        return 1;
    }else if (dropIndexPath.section == 3 && dropIndexPath.row == 3) {
        return 5;
    }
    return 4;
}


/*
*WMZDropIndexPath是否显示收缩功能 default >参数wCollectionViewSectionShowExpandCount 显示
*/
- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath*)dropIndexPat{
    return NO;
}

/*
*是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default NO
*/
- (BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section{
    return NO;
}

/*
*互斥的标题数组 即互斥不能同时选中 返回标题对应的section (配合关联代理使用更加)
*/
- (NSArray*)mutuallyExclusiveSectionsWithMenu:(WMZDropDownMenu *)menu{
    return @[];
}

/*
*WMZDropIndexPath上的内容点击 是否关闭视图
*/
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 0) {
        if (dropIndexPath.row == 1) {
            return YES;
        }
    }
    return NO;
}

/*
*点击方法
*/
- (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree*)data{
    NSLog(@"标题所在列:%ld \n 联动层级:%ld  \n 点击indexPath:%@ \n 点击的数据 :%@ \n ",dropIndexPath.section,dropIndexPath.row,indexpath,data);
}

/*
*标题点击方法
*/
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn *)selectBtn{
    NSLog(@"点击了标题 %ld",section);
}


/*
*确定方法 多个选择
*/
- (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection:(NSInteger)section selectNoramelData:(NSMutableArray*)selectNoramalData selectStringData:(NSMutableArray*)selectData{
    NSLog(@"选择了 %@ %@",selectNoramalData,selectData);
}

/*
*自定义每行全局头部视图 多用于交互事件
*/
- (UIView*)menu:(WMZDropDownMenu *)menu userInteractionHeadViewInSection:(NSInteger)section{
    UIView *userInteractionHeadView = [UIView new];
    userInteractionHeadView.backgroundColor = [UIColor greenColor];
    userInteractionHeadView.frame = CGRectMake(0, 0, menu.dataView.frame.size.width, 50);
    UILabel *la = [UILabel new];
    la.font = [UIFont systemFontOfSize:15.0f];
    la.text = @"自定义每行全局头部视图";
    la.frame = userInteractionHeadView.bounds;
    [userInteractionHeadView addSubview:la];
    return userInteractionHeadView;
}
/*
*自定义每行全局尾部视图 多用于交互事件
*/
- (UIView*)menu:(WMZDropDownMenu *)menu userInteractionFootViewInSection:(NSInteger)section{
    UIView *userInteractionFootView = [UIView new];
    userInteractionFootView.backgroundColor = [UIColor cyanColor];
    userInteractionFootView.frame = CGRectMake(0, 0, menu.dataView.frame.size.width, 60);
    UILabel *la = [UILabel new];
    la.font = [UIFont systemFontOfSize:15.0f];
    la.text = @"自定义每行全局尾部视图";
    la.frame = userInteractionFootView.bounds;
    [userInteractionFootView addSubview:la];
    return userInteractionFootView;
}


/*
*自定义标题按钮视图  返回配置 参数说明
 offset       按钮的间距
 y            按钮的y坐标   自动会居中
*/
- (NSDictionary*)menu:(WMZDropDownMenu *)menu  customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn*)menuBtn{
    if (section == 1) {
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:19.0f];
    }
    return @{};
}

/*
*自定义修改默认collectionView尾部视图
*/
- (void)menu:(WMZDropDownMenu *)menu customDefauultCollectionFootView:(WMZDropConfirmView *)confirmView{
    confirmView.resetFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.025, 0,confirmView.frame.size.width*0.45 , confirmView.frame.size.height)];
    confirmView.confirmFrame = [NSValue valueWithCGRect:CGRectMake(confirmView.frame.size.width*0.525, 0,confirmView.frame.size.width*0.45 , confirmView.frame.size.height)];
    confirmView.confirmBtn.layer.masksToBounds = YES;
    confirmView.resetBtn.layer.masksToBounds = YES;
    confirmView.confirmBtn.layer.cornerRadius = confirmView.frame.size.height/2;
    confirmView.resetBtn.layer.cornerRadius = confirmView.frame.size.height/2;
}

/*
*获取所有选中的数据
*/
- (void)menu:(WMZDropDownMenu *)menu getAllSelectData:(NSArray*)selectData{
    NSLog(@"%@",selectData);
}

@end


















@implementation ViewCustomCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLa];
        [self.contentView addSubview:self.accessTypeBtn];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.accessTypeBtn.frame = CGRectMake(10, 0,  self.accessTypeBtn.hidden?0:30, self.contentView.frame.size.height);
    self.textLa.frame = CGRectMake(CGRectGetMaxX(self.accessTypeBtn.frame), 0, self.contentView.frame.size.width-CGRectGetMaxX(self.accessTypeBtn.frame)-10, self.contentView.frame.size.height);
}
- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:15.0f];
    }
    return _textLa;
}
- (UIButton *)accessTypeBtn{
    if (!_accessTypeBtn) {
        _accessTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _accessTypeBtn;
}
@end
@implementation TableViewCustomHeadView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backView = [UILabel new];
        [self addSubview:self.backView];
    }
    return self;
}
- (void)layoutSubviews{
    self.backView.frame = self.bounds;
}
@end
@implementation TableViewCustomFootView
@end

//自定义tableviewCell
@implementation ViewCustomCollectionViewCell
- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        [self.contentView addSubview:_textLa];
    }
    return _textLa;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLa.frame = self.contentView.bounds;
}
@end
//自定义tableview head
@implementation CollectionViewCustomHeadView
@end
//自定义tableview foot
@implementation CollectionViewCustomFootView
@end
