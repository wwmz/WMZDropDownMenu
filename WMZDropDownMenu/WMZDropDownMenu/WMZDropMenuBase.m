//
//  WMZDropMenuBase.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuBase.h"
@implementation WMZDropMenuBase

#pragma -mark 初始化
- (instancetype)initWithFrame:(CGRect)frame withParam:(WMZDropMenuParam*)param{
    if (self = [super initWithFrame:frame]) {
        self.param = param;
        [self loadMyData];
    }
    return self;
}
- (instancetype)initWithParam:(WMZDropMenuParam*)param{
    if (self = [super init]) {
        self.param = param;
         [self loadMyData];
    }
    return self;
}

- (void)loadMyData{
    if (self.param.wPopOraignY) {
        self.menuOrignY = self.param.wPopOraignY;
    }
    self.close = YES;
    self.lastSelectIndex = -999;
    [self notifications];
}

- (void)notifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:CloseMenuNotificationContentKey object:nil];
}


- (void)keyboardWillShow:(NSNotification *)note{
    self.keyBoardShow = YES;
    NSDictionary* info = [note userInfo];
    CGFloat height = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height+20;
    if (CGRectGetMaxY(self.collectionView.frame) - height>100) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    }
}

- (void)keyboardWillHide:(NSNotification *)note{
    self.keyBoardShow = NO;
    self.collectionView.contentInset = UIEdgeInsetsZero;
}

- (WMZDropTableView*)getTableVieww:(WMZDropIndexPath*)path{
    WMZDropTableView *tableView = [[WMZDropTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.scrollsToTop = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[WMZDropTableViewHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WMZDropTableViewHeadView class])];
    [tableView registerClass:[WMZDropTableViewFootView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WMZDropTableViewFootView class])];
    tableView.estimatedRowHeight = 100;
    if (@available(iOS 11.0, *)) {
        tableView.estimatedSectionHeaderHeight = 0.01;
        tableView.estimatedSectionFooterHeight = 0.01;
    }
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    if (path && path.key) {
        tableView.dropIndex = path;
    }
    tableView.delegate = (id)self;
    tableView.dataSource = (id)self;
    return tableView;
}

- (WMZDropCollectionView*)getCollectonView:(WMZDropIndexPath*)path layout:(UICollectionViewFlowLayout*)layout{
    WMZDropCollectionView *collection = [[WMZDropCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.scrollsToTop = NO;
    collection.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    collection.showsHorizontalScrollIndicator = NO;
    collection.showsVerticalScrollIndicator = NO;
    [collection registerClass:[WMZMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([WMZMenuCell class])];
    [collection registerClass:[WMZMenuTextFieldCell class] forCellWithReuseIdentifier:NSStringFromClass([WMZMenuTextFieldCell class])];
    [collection registerClass:[WMZDropCollectionViewHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewHeadView class])];
    [collection registerClass:[WMZDropCollectionViewFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewFootView class])];
    if (@available(iOS 11.0, *)) {
        collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (path&&path.key) {
        collection.dropIndex = path;
    }
    return collection;
}
#pragma -mark 解析树形数据
- (void)runTimeSetDataWith:(NSDictionary*)dic withTree:(WMZDropTree*)tree{
    unsigned int outCount, i;
    NSMutableArray *propertyArr = [NSMutableArray new];
    objc_property_t * properties = class_copyPropertyList([tree class], &outCount);
    //获取所有属性
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (propertyName) {
            [propertyArr addObject:propertyName];
        }
    }
    if (properties)
    free(properties);
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //存在该属性赋值
        for (NSString *name in propertyArr) {
            if ([name isEqualToString:key]) {
                [tree setValue:obj forKey:key];
            }
        }
    }];
}

- (void)showAnimal:(MenuShowAnimalStyle)animalStyle view:(UIView*)view durtion:(NSTimeInterval)durtion block:(DropMenuAnimalBlock)block{
    if (animalStyle == MenuShowAnimalBottom) {
        verticalMoveShowAnimation(view, durtion, block);
    }else if (animalStyle == MenuShowAnimalRight) {
        landscapeMoveShowAnimation(view, durtion,YES, block);
    }else if (animalStyle == MenuShowAnimalLeft) {
        landscapeMoveShowAnimation(view, durtion,NO, block);
    }else if (animalStyle == MenuShowAnimalBoss){
        BossMoveShowAnimation(view, durtion, block);
    }else if (animalStyle == MenuShowAnimalTop){
        verticalBottomMoveShowAnimation(view, durtion, block);
    }else{
       if (block) {
          block();
       }
    }
}

- (void)hideAnimal:(MenuHideAnimalStyle)animalStyle  view:(UIView*)view durtion:(NSTimeInterval)durtion block:(DropMenuAnimalBlock)block{
    if (animalStyle == MenuHideAnimalTop) {
        verticalMoveHideAnimation(view, durtion, block);
    }else if (animalStyle == MenuHideAnimalRight) {
        landscapeMoveHideAnimation(view, durtion,NO, block);
    }else if (animalStyle == MenuHideAnimalLeft) {
        landscapeMoveHideAnimation(view, durtion,YES, block);
    }else if (animalStyle == MenuHideAnimalBoss){
        BossMoveHideAnimation(view, durtion, block);
    }else{
       if (block) {
          block();
       }
    }
}
#pragma -mark 改变标题颜色和文字
- (void)changeTitleConfig:(NSDictionary*)config withBtn:(WMZDropMenuBtn*)currentBtn{
    if (config[WMZMenuTitleNormal]) {
        [currentBtn setTitle:config[WMZMenuTitleNormal] forState:UIControlStateNormal];
    }else{
        if (currentBtn.selectTitle) {
            [currentBtn setTitle:currentBtn.selectTitle forState:UIControlStateNormal];
        }
    }
    
    WMZDropIndexPath *path = config[@"dropPath"];
    NSNumber *row = config[@"row"];
    [currentBtn setTitleColor:currentBtn.selectColor forState:UIControlStateNormal];
    [currentBtn setTitleColor:currentBtn.selectColor forState:UIControlStateSelected];
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(menu:changeTitle:selectBtn:atDropIndexPath:dataIndexPath:)]){
        id customInfo =  [self.delegate menu:(WMZDropDownMenu*)self changeTitle:[currentBtn titleForState:UIControlStateNormal]  selectBtn:currentBtn atDropIndexPath:path dataIndexPath:row?[row integerValue]:NSNotFound];
        if (customInfo) {
            if ([customInfo isKindOfClass:[NSDictionary class]]) {
                if (customInfo[WMZMenuTitleNormal]) {
                    [currentBtn setTitle:customInfo[WMZMenuTitleNormal] forState:UIControlStateNormal];
                }
                if (customInfo[WMZMenuTitleSelectColor]) {
                    [currentBtn setTitleColor:customInfo[WMZMenuTitleSelectColor] forState:UIControlStateNormal];
                    [currentBtn setTitleColor:customInfo[WMZMenuTitleSelectColor] forState:UIControlStateSelected];
                }
            }else if ([customInfo isKindOfClass:[NSString class]]){
               [currentBtn setTitle:(NSString*)customInfo forState:UIControlStateNormal];
            }
        }
    }
    [WMZDropMenuTool TagSetImagePosition:currentBtn.position spacing:self.param.wMenuTitleSpace button:currentBtn];
}
#pragma -mark 回复原来的标题和文字
- (void)changeNormalConfig:(NSDictionary*)config withBtn:(WMZDropMenuBtn*)currentBtn{
    [currentBtn setTitleColor:currentBtn.normalColor forState:UIControlStateNormal];
    [currentBtn setTitleColor:currentBtn.normalColor forState:UIControlStateSelected];
    [currentBtn setTitle:currentBtn.normalTitle forState:UIControlStateNormal];
}

- (NSMutableDictionary*)dataViewFrameDic{
    _dataViewFrameDic = [NSMutableDictionary dictionaryWithDictionary:@{
                 @(MenuShowAnimalNone):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY)/2)],
                 @(MenuShowAnimalBottom):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY)/2)],
                 @(MenuShowAnimalLeft):[NSValue valueWithCGRect:CGRectMake(0, 0, (self.param.wMaxWidthScale>1?1:self.param.wMaxWidthScale)*Menu_Width, Menu_Height)],
                 @(MenuShowAnimalRight):[NSValue valueWithCGRect:CGRectMake(Menu_Width - (self.param.wMaxWidthScale>1?1:self.param.wMaxWidthScale)*Menu_Width, 0, (self.param.wMaxWidthScale>1?1:self.param.wMaxWidthScale)*Menu_Width, Menu_Height)],
                 @(MenuShowAnimalBoss):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
                 @(MenuShowAnimalPop):[NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(self.selectTitleBtn.frame)+15>(Menu_Width-15-self.param.wPopViewWidth?:Menu_Width/3)?(Menu_Width-15-self.param.wPopViewWidth?:Menu_Width/3):(CGRectGetMinX(self.selectTitleBtn.frame)+15), self.menuOrignY, self.param.wPopViewWidth?:Menu_Width/3, Menu_Height)],
                 @(MenuShowAnimalTop):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height*self.param.wMaxHeightScale)],
    }];
    return _dataViewFrameDic;
}

- (NSMutableDictionary*)shadomViewFrameDic{
    _shadomViewFrameDic = [NSMutableDictionary dictionaryWithDictionary:@{
             @(MenuShowAnimalNone):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY))],
             @(MenuShowAnimalBottom):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY))],
             @(MenuShowAnimalLeft):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
             @(MenuShowAnimalRight):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
             @(MenuShowAnimalPop):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
             @(MenuShowAnimalBoss):[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
             @(MenuShowAnimalTop):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
    }];
    return _shadomViewFrameDic;
}

- (NSArray*)getArrWithPath:(WMZDropIndexPath*)path withoutHide:(BOOL)hide{
    if ([path.key isEqualToString:MoreTableViewKey] || !hide) {
        return path.treeArr;
    }
    NSMutableArray *marr = [NSMutableArray new];
    [path.treeArr enumerateObjectsUsingBlock:^(WMZDropTree * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (hide) {
            if (!obj.hide) {
                [marr addObject:obj];
            }
        }
    }];
    return [NSArray arrayWithArray:marr];
}

- (UIBezierPath*)getMyDownPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width * 0.25 - 10,0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width * 0.25, -10)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width * 0.25 + 10, 0) ];
    [path closePath];
    return path;
}

- (UIBezierPath*)getMyDownRightPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.75 - 10,0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.75, -10)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.75 + 10, 0) ];
    [path closePath];
    return path;
}

- (void)closeView{}
- (void)confirmAction:(nullable UIButton*)sender{}
- (void)reSetAction{}
- (void)updateSubView:(WMZDropIndexPath*)dropPath more:(BOOL)more{}
- (void)cellTap:(WMZDropIndexPath *)dropPath data:(NSArray *)arr indexPath:(NSIndexPath *)indexPath{}

- (CGFloat)menuOrignY{
    if (!_menuOrignY) {
        _menuOrignY = CGRectGetMaxY(self.frame);
        
    }
    return _menuOrignY;
}

- (UIScrollView *)titleView{
    if (!_titleView) {
        _titleView = [UIScrollView new];
        _titleView.backgroundColor = menuMainClor;
        _titleView.showsVerticalScrollIndicator = NO;
        _titleView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _titleView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _titleView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.tag = 10086;
    }
    return _shadowView;
}

- (UIView *)dataView{
    if (!_dataView) {
        _dataView = [UIView new];
        _dataView.backgroundColor = [UIColor whiteColor];
        _dataView.layer.masksToBounds = YES;
        _dataView.tag = 10087;
    }
    return _dataView;
}

- (UIView *)moreView{
    if (!_moreView) {
        _moreView = [UIView new];
        _moreView.backgroundColor = [UIColor whiteColor];
        _moreView.layer.masksToBounds = YES;
        _moreView.tag = 10088;
    }
    return _moreView;
}

- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [UIView new];
    }
    return _emptyView;
}

- (UIView *)confirmView{
    if (!_confirmView) {
        _confirmView = [UIView new];
    }
    return _confirmView;
}

- (NSMutableArray *)titleBtnArr{
    if (!_titleBtnArr) {
        _titleBtnArr = [NSMutableArray new];
    }
    return _titleBtnArr;
}

- (NSMutableArray *)mutuallyExclusiveArr{
    if (!_mutuallyExclusiveArr) {
        _mutuallyExclusiveArr = [NSMutableArray new];
    }
    return _mutuallyExclusiveArr;
}

- (void)setDelegate:(id<WMZDropMenuDelegate>)delegate{
    _delegate = delegate;
}
@end
