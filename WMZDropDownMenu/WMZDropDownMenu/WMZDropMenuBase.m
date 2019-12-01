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
    self.close = YES;
     self.lastSelectIndex = -999;
     [self notifications];
}


//通知
- (void)notifications{
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘弹出
- (void)keyboardWillShow:(NSNotification *)note
{
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

//获取tableviewView
- (WMZDropTableView*)getTableVieww:(WMZDropIndexPath*)path{
    WMZDropTableView *tableView = [[WMZDropTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.estimatedRowHeight = 0.01;
    tableView.estimatedSectionFooterHeight = 0.01;
    tableView.estimatedSectionHeaderHeight = 0.01;
    tableView.scrollsToTop = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[WMZDropTableViewHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WMZDropTableViewHeadView class])];
    [tableView registerClass:[WMZDropTableViewFootView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WMZDropTableViewFootView class])];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (path&&path.key) {
        tableView.dropIndex = path;
    }
    return tableView;
}
//获取collectionView
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
/*
*出现的动画
*/
- (void)showAnimal:(MenuShowAnimalStyle)animalStyle view:(UIView*)view durtion:(NSTimeInterval)durtion block:(DropMenuAnimalBlock)block{
    if (animalStyle == MenuShowAnimalBottom) {
        verticalMoveShowAnimation(view, durtion, block);
    }else if (animalStyle == MenuShowAnimalRight) {
        landscapeMoveShowAnimation(view, durtion,YES, block);
    }else if (animalStyle == MenuShowAnimalLeft) {
        landscapeMoveShowAnimation(view, durtion,NO, block);
    }else if (animalStyle == MenuShowAnimalBoss){
        BossMoveShowAnimation(view, durtion, block);
    }else{
       if (block) {
          block();
       }
    }
}
/*
*消失的动画
*/
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

- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *view = self;
    UITableView *ta = nil;
    if (!self.tableView) {
        while (view.superview) {
            view = view.superview;
            if ([view isKindOfClass:[UITableView class]]) {
                ta = (UITableView*)view;
            }
        }
    }
    if (!self.tableView&&ta) {
        self.tableView = ta;
        [self.tableView layoutIfNeeded];
        [self.tableView layoutSubviews];
        CGRect rectInTableView = [self.tableView rectForHeaderInSection:self.tableViewHeadSection];
        CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        self.menuOrignY = CGRectGetMaxY(rect);
        [self.tableView pageAddObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

//监听子控制器中的滚动视图
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
       CGRect rectInTableView = [self.tableView rectForHeaderInSection:self.tableViewHeadSection];
       CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        if (rect.origin.y<0) {
            rect.origin.y = self.tableView.frame.origin.y;
        }
        self.menuOrignY = CGRectGetMaxY(rect);
        if (!self.close) {
            [self closeView];
        }
    }
}



//不同动画frame不同 dataView的frame
- (NSMutableDictionary*)dataViewFrameDic{
    _dataViewFrameDic = [NSMutableDictionary dictionaryWithDictionary:@{
                 @(MenuShowAnimalNone):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY)/2)],
                 @(MenuShowAnimalBottom):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY)/2)],
                 @(MenuShowAnimalLeft):[NSValue valueWithCGRect:CGRectMake(0, 0, (self.param.wMaxWidthScale>1?1:self.param.wMaxWidthScale)*Menu_Width, Menu_Height)],
                 @(MenuShowAnimalRight):[NSValue valueWithCGRect:CGRectMake(Menu_Width - (self.param.wMaxWidthScale>1?1:self.param.wMaxWidthScale)*Menu_Width, 0, (self.param.wMaxWidthScale>1?1:self.param.wMaxWidthScale)*Menu_Width, Menu_Height)],
                 @(MenuShowAnimalBoss):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
                 @(MenuShowAnimalPop):[NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(self.selectTitleBtn.frame)+15>(Menu_Width-15-self.param.wPopViewWidth?:Menu_Width/3)?(Menu_Width-15-self.param.wPopViewWidth?:Menu_Width/3):(CGRectGetMinX(self.selectTitleBtn.frame)+15), self.menuOrignY, self.param.wPopViewWidth?:Menu_Width/3, Menu_Height)]
    }];
    return _dataViewFrameDic;
}

//不同动画frame不同 shadomView的frame
- (NSMutableDictionary*)shadomViewFrameDic{
    _shadomViewFrameDic = [NSMutableDictionary dictionaryWithDictionary:@{
             @(MenuShowAnimalNone):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY))],
             @(MenuShowAnimalBottom):[NSValue valueWithCGRect:CGRectMake(0, self.menuOrignY, Menu_Width,(Menu_Height - self.menuOrignY))],
             @(MenuShowAnimalLeft):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
             @(MenuShowAnimalRight):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
             @(MenuShowAnimalPop):[NSValue valueWithCGRect:CGRectMake(0, 0, Menu_Width, Menu_Height)],
             @(MenuShowAnimalBoss):[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
    }];
    return _shadomViewFrameDic;
}

/**
 配置贝塞尔曲线
 */
- (UIBezierPath*)getMyDownPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.25-10,0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.25, -10)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.25+10, 0) ];
    [path closePath];
    return path;
}
- (UIBezierPath*)getMyDownRightPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.75-10,0)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.75, -10)];
    [path addLineToPoint:CGPointMake(self.dataView.frame.size.width*0.75+10, 0) ];
    [path closePath];
    return path;
}


- (void)closeView{}
- (void)confirmAction{}
- (void)reSetAction{}

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
        _titleView.frame = self.bounds;
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

- (NSCache *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSCache new];
    }
    return _dataDic;
}

- (void)setDelegate:(id<WMZDropMenuDelegate>)delegate{
    _delegate = delegate;
}

- (void)dealloc{
    [self removeAllObserverdKeyPath:self withKey:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation WMZDropTree

- (instancetype)init{
    if (self = [super init]) {
        self.cellHeight = footHeadHeight;
    }
    return self;
}

- (instancetype)initWithDetpth:(NSInteger)depth withName:(NSString*)name  withID:(NSString*)ID{
    if (self = [super init]) {
        _depth = depth;
        _name = name;
        _ID = ID;
    }
    return self;
}

- (NSMutableArray *)rangeArr{
    if (!_rangeArr) {
        _rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
    }
    return _rangeArr;
}


- (NSDictionary *)config{
    if (!_config) {
        _config = [NSDictionary new];
    }
    return _config;
}

- (NSMutableArray<WMZDropTree *> *)children{
    if (!_children) {
        _children = [NSMutableArray new];
    }
    return _children;
}

@end
