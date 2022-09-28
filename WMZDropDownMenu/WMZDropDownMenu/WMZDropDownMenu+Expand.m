//
//  WMZDropDownMenu+Expand.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropDownMenu+Expand.h"

@implementation WMZDropDownMenu (NormalView)

#pragma -mark 添加数据
- (void)addShowUI{
    //移除之前的view
    for (UIView *view in [self.dataView subviews]) {
        [view removeFromSuperview];
    }
    //移除CALayer
    NSArray<CALayer *> *subLayers = self.dataView.layer.sublayers;
    NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[CAShapeLayer class]];
    }]];
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    self.showView = [NSMutableArray new];
    
    //判断显示的UI类型
    MenuUIStyle showType = MenuUITableView;
    //判断需要显示的WMZDropIndexPath
    NSInteger index = self.selectTitleBtn.tag - 1000;
    NSMutableArray <WMZDropIndexPath*>*dorpArr = [NSMutableArray new];
    for (WMZDropIndexPath *path in self.dropPathArr) {
        if (path.section == index &&
            ![path.key isEqualToString:MoreTableViewKey]) {
            [dorpArr addObject:path];
            showType = path.UIStyle;
        }
    }
    //添加UI
    [self addDropPathUI:[NSArray arrayWithArray:dorpArr] type:showType];
}

#pragma -mark 根据dic添加显示的UI
- (void)addDropPathUI:(NSArray<WMZDropIndexPath*>*)dropArray type:(MenuUIStyle)type{
    CGFloat height = self.param.wFixDataViewHeight;
    CGRect rect = CGRectZero;
    //全屏
    MenuShowAnimalStyle screnFrame = MenuShowAnimalNone;
    BOOL pop = NO;
    if (type == MenuUINone) {        //none
        [self.shadowView removeFromSuperview];
        [self.dataView removeFromSuperview];
        return;
    }else  if (type == MenuUITableView) {     //单tableview
        if (height == 0) {
            //计算高度 获取最大的tableview的高度
            NSMutableArray *heightArr = [NSMutableArray new];
            for (WMZDropIndexPath *path in dropArray) {
                if (path.showAnimalStyle == MenuShowAnimalLeft ||
                    path.showAnimalStyle == MenuShowAnimalRight||
                    path.showAnimalStyle == MenuShowAnimalBoss) {
                    height = self.dataView.frame.size.height;
                    screnFrame = path.showAnimalStyle;
                    break;
                }else{
                    if (path.showAnimalStyle == MenuShowAnimalPop) {
                        pop = YES;
                    }
                    NSArray *dataArr = [self getArrWithPath:path withoutHide:YES];
                    CGFloat sonHeight = 0;
                    for (WMZDropTree *tree in dataArr) {
                        if ([tree isKindOfClass:[WMZDropTree class]]) {
                            sonHeight += tree.cellHeight;
                        }
                    }
                    sonHeight += (path.headViewHeight + path.footViewHeight);
                    [heightArr addObject:@(sonHeight)];
                }
            }
            if (!screnFrame) {
                height = [[heightArr valueForKeyPath:@"@max.floatValue"] floatValue];
                
               if(height>(Menu_Height*(self.param.wMaxHeightScale>1?
                                    1:self.param.wMaxHeightScale))) {
                    height = (Menu_Height*(self.param.wMaxHeightScale>1?
                    1:self.param.wMaxHeightScale));
                }
            }
        }else{
            for (WMZDropIndexPath *path in dropArray) {
                if (path.showAnimalStyle == MenuShowAnimalLeft ||
                    path.showAnimalStyle == MenuShowAnimalRight||
                    path.showAnimalStyle == MenuShowAnimalBoss) {
                 height = self.dataView.frame.size.height;
                 screnFrame = path.showAnimalStyle;
             }else if (path.showAnimalStyle == MenuShowAnimalPop) {
                 pop = YES;
             }
           }
        }
        CGFloat y = 0;
        //添加tableview
        WMZDropTableView *tmpTa = nil;
        for (int i = 0; i< dropArray.count; i++) {
            WMZDropIndexPath *path = dropArray[i];
            WMZDropTableView *tableView = [self getTableVieww:path];
            CGFloat width = self.dataView.frame.size.width / dropArray.count;
            if ([self.param.wTableViewWidth isKindOfClass:NSArray.class] &&
                dropArray.count == self.param.wTableViewWidth.count) {
                if (self.param.wTableViewWidth.count > i &&
                    [self.param.wTableViewWidth[i] isKindOfClass:NSNumber.class]) {
                    width = [self.param.wTableViewWidth[i] floatValue] * self.dataView.frame.size.width;
                }
            }
            tableView.frame = CGRectMake(tmpTa ? CGRectGetMaxX(tmpTa.frame):0, y, width, height-y);
            if (i < self.param.wTableViewColor.count) {
                tableView.backgroundColor = self.param.wTableViewColor[i];
            }else{
                tableView.backgroundColor = MenuColor(0xffffff);
            }
            if (screnFrame && screnFrame!= MenuShowAnimalBoss) {
                self.emptyView.frame = CGRectMake(0, 0, tableView.frame.size.width, Menu_StatusBarHeight);
                tableView.tableHeaderView = self.emptyView;
            }
            [self.dataView addSubview:tableView];
            [self.showView addObject:tableView];
            tmpTa = tableView;
        }
        [self addHeadFootView:self.showView screnFrame:screnFrame];
    }
    else if (type == MenuUICollectionView||
             type == MenuUICollectionRangeTextField) {  //单collectionView
        if (height == 0) {
            for (WMZDropIndexPath *path in dropArray) {
                NSArray *arr = [self getArrWithPath:path withoutHide:YES];
                if (arr.count) {
                    if (path.showAnimalStyle == MenuShowAnimalLeft||
                        path.showAnimalStyle == MenuShowAnimalRight||
                        path.showAnimalStyle == MenuShowAnimalBoss) {
                        height = self.dataView.frame.size.height;
                        screnFrame = path.showAnimalStyle;
                        break;
                    }else{
                        if (path.showAnimalStyle == MenuShowAnimalPop) pop = YES;
                        NSInteger count = ceil((CGFloat)arr.count/path.collectionCellRowCount);
                        height += (count * (path.cellHeight));
                        if (count > 1) height += (count*self.param.wCollectionViewCellSpace);
                        height += (path.headViewHeight + path.footViewHeight);
                    }
                }
            }
            if (!screnFrame) {
                ///最大为maxHeight
                height = MIN(Menu_Height * MIN(1, self.param.wMaxHeightScale), height);
            }
        }else{
            for (WMZDropIndexPath *path in dropArray) {
                if (path.showAnimalStyle == MenuShowAnimalLeft ||
                    path.showAnimalStyle == MenuShowAnimalRight||
                    path.showAnimalStyle == MenuShowAnimalBoss) {
                 height = self.dataView.frame.size.height;
                 screnFrame = path.showAnimalStyle;
             }
           }
        }
        WMZDropIndexPath *firstPath = dropArray.firstObject;
        CGFloat y = (screnFrame && screnFrame != MenuShowAnimalBoss)? Menu_StatusBarHeight : 0;
        WMZDropMenuCollectionLayout *layout = [[WMZDropMenuCollectionLayout alloc]initWithType:firstPath.alignType betweenOfCell:self.param.wCollectionViewCellSpace];
        layout.minimumLineSpacing = self.param.wCollectionViewCellSpace;
        layout.minimumInteritemSpacing = self.param.wCollectionViewCellSpace;
        layout.sectionInset = UIEdgeInsetsMake(0, self.param.wCollectionViewCellSpace, 0, self.param.wCollectionViewCellSpace);
        self.collectionView = [self getCollectonView:[WMZDropIndexPath new] layout:layout];
        ///注册自定义cell
        if (self.param.wReginerCollectionCells) {
            for (NSString *name in self.param.wReginerCollectionCells) {
                if ([name isKindOfClass:NSString.class]) {
                    [self.collectionView registerClass:NSClassFromString(name) forCellWithReuseIdentifier:name];
                }else{
                    Class class = (id)name;
                    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(class) bundle:NSBundle.mainBundle] forCellWithReuseIdentifier:NSStringFromClass(class)];
                }
            }
        }
        ///注册自定义headView
        if (self.param.wReginerCollectionHeadViews) {
            for (NSString *name in self.param.wReginerCollectionHeadViews) {
                if ([name isKindOfClass:NSString.class]) {
                    [self.collectionView registerClass:NSClassFromString(name) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
                }else{
                    Class class = (id)name;
                    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(class) bundle:NSBundle.mainBundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(class)];
                }
            }
        }
        ///注册自定义footView
        if (self.param.wReginerCollectionFootViews) {
            for (NSString *name in self.param.wReginerCollectionFootViews) {
                if ([name isKindOfClass:NSString.class]) {
                    [self.collectionView registerClass:NSClassFromString(name) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:name];
                }else{
                    Class class = (id)name;
                    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(class) bundle:NSBundle.mainBundle] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(class)];
                }
            }
        }
        self.collectionView.delegate = (id)self;
        self.collectionView.dataSource = (id)self;
        self.collectionView.dropArray = [NSArray arrayWithArray:dropArray];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.frame = CGRectMake(0, y , self.dataView.frame.size.width, height - y);
        [self.dataView addSubview:self.collectionView];
        [self.showView addObject:self.collectionView];
        [self addHeadFootView:self.showView screnFrame:screnFrame];
    }
    ///自定义
    else if (type == MenuUICustom){
        if(self.delegate && [self.delegate respondsToSelector:@selector(menu:customViewInSection:)]){
            UIView <WMZDropShowViewProcotol>*customView = [self.delegate menu:self customViewInSection:dropArray.firstObject.section];
            if(customView && [customView conformsToProtocol:@protocol(WMZDropShowViewProcotol)]){
                [self.dataView addSubview:customView];
                [self.showView addObject:customView];
                [customView layoutIfNeeded];
                NSLog(@"%@",customView);
                height = customView.bounds.size.height;
                
            }
        }
    }
    
    if (!screnFrame) {
        if ([[self.dataView subviews] indexOfObject:self.confirmView] != NSNotFound) {
            height += CGRectGetHeight(self.confirmView.frame);
            height += self.param.wCollectionViewDefaultFootViewPaddingY;
        }
        if ([[self.dataView subviews] indexOfObject:self.tableVieHeadView] != NSNotFound) {
            height += CGRectGetHeight(self.tableVieHeadView.frame);
        }
    }
    rect = [[self.dataViewFrameDic objectForKey:@([self getTitleFirstDropWthTitleBtn:self.selectTitleBtn].showAnimalStyle)] CGRectValue];
    rect.size.height  = height;
    self.dataView.frame = rect;
    if (self.param.wCustomDataViewRect) {
        CGRect finalRect =  self.param.wCustomDataViewRect(self.dataView.frame);
        self.dataView.frame = finalRect;
    }
    ///动画是pop
    self.dataView.layer.masksToBounds = !pop;
    self.shadowView.backgroundColor = pop?[UIColor clearColor]:self.param.wShadowColor;
    self.dataView.layer.shadowOpacity = pop?0.2:0;
    if (pop) {
        self.dataView.layer.shadowOffset = CGSizeMake(0,0);
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = nil;
        if (CGRectGetMinX(self.selectTitleBtn.frame)+15>
            (Menu_Width-15-self.param.wPopViewWidth?:Menu_Width/3)) {
           path =  [self getMyDownRightPath];
        }else{
           path =  [self getMyDownPath];
        }
        maskLayer.path = path.CGPath;
        maskLayer.frame = self.dataView.bounds;
        maskLayer.fillColor = MenuColor(0xffffff).CGColor;
        [self.dataView.layer addSublayer:maskLayer];
        return;
    }
    
    if (screnFrame) {
        if (self.param.wMainRadius) {
            [WMZDropMenuTool setView:self.dataView Radii:CGSizeMake(self.param.wMainRadius, self.param.wMainRadius) RoundingCorners:screnFrame == MenuShowAnimalRight?(UIRectCornerTopLeft|UIRectCornerBottomLeft):(UIRectCornerTopRight|UIRectCornerBottomRight)];
        }
    }else{
        if (self.param.wMainRadius) {
            [WMZDropMenuTool setView:self.dataView Radii:CGSizeMake(self.param.wMainRadius, self.param.wMainRadius) RoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft];
        }
    }
}
/// 添加全局的头尾
- (void)addHeadFootView:(NSArray*)connectViews screnFrame:(MenuShowAnimalStyle)screnFrame{
    /// 头部
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:userInteractionHeadViewInSection:)]) {
        UIView *headView = [self.delegate menu:self userInteractionHeadViewInSection:self.selectTitleBtn.tag - 1000];
        if (headView) {
            for (UIView *connectView in connectViews) {
                CGRect rect = connectView.frame;
                if ([connectView isKindOfClass:[UITableView class]]) {
                    UITableView *ta = (UITableView*)connectView;
                    ta.tableHeaderView = nil;
                } else if ([connectView isKindOfClass:[UICollectionView class]]) {
                    rect.size.height += rect.origin.y;
                    rect.origin.y = 0;
                }
                if (screnFrame) {
                    rect.origin.y += CGRectGetMaxY(headView.frame);
                    rect.size.height -= CGRectGetMaxY(headView.frame);
                }else{
                    rect.origin.y += CGRectGetMaxY(headView.frame);
                }
                connectView.frame = rect;
            }
            self.tableVieHeadView = headView;
            [self.dataView addSubview:self.tableVieHeadView];
        }else{
            [self addDefaultHeadView:connectViews screnFrame:screnFrame];
        }
    }else{
       [self addDefaultHeadView:connectViews screnFrame:screnFrame];
    }
    /// 尾部
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:userInteractionFootViewInSection:)]) {
        UIView *footView = [self.delegate menu:self userInteractionFootViewInSection:self.selectTitleBtn.tag - 1000];
        if (footView) {
            for (UIView *connectView in connectViews) {
                CGRect rect = connectView.frame;
                CGRect footViewFram = footView.frame;
                if (screnFrame) {
                    rect.size.height -= ((footViewFram.size.height + (MenuisIphoneX?(self.param.wCollectionViewDefaultFootViewMarginY>=20?0:20):0))+self.param.wCollectionViewDefaultFootViewMarginY+self.param.wCollectionViewDefaultFootViewPaddingY);
                }
                connectView.frame = rect;
               footViewFram.origin.y = CGRectGetMaxY(connectView.frame)+self.param.wCollectionViewDefaultFootViewPaddingY;
               footView.frame = footViewFram;
            }
            self.confirmView = footView;
            [self.dataView addSubview:self.confirmView];
        }else{
            [self addDefaultFootView:connectViews screnFrame:screnFrame];
        }
    }else{
        [self addDefaultFootView:connectViews screnFrame:screnFrame];
    }
}
/// 默认footView
- (void)addDefaultFootView:(NSArray*)connectViews
                screnFrame:(MenuShowAnimalStyle)screnFrame{
   BOOL insert = NO;
   for (UIView *connectView in connectViews) {
       if ([connectView isKindOfClass:[WMZDropCollectionView class]]) {
           WMZDropCollectionView *collectionView = (WMZDropCollectionView*)connectView;
           insert = YES;
           for (WMZDropIndexPath *path in collectionView.dropArray) {
               if (path.tapClose) {
                   insert = NO;break;
               }
           }
           break;
       }else if ([connectView isKindOfClass:[WMZDropTableView class]]) {
           WMZDropTableView *ta = (WMZDropTableView*)connectView;
           if (ta.dropIndex.editStyle == MenuEditMoreCheck) {
               insert = YES; break;
           }
           if (ta.dropIndex.tapClose) {
               insert = NO;
           }
       }
   }
   if (!insert) return;
   WMZDropConfirmView *footView = [WMZDropConfirmView new];
   [footView.confirmBtn addTarget:self action:NSSelectorFromString(@"confirmAction:") forControlEvents:UIControlEventTouchUpInside];
   [footView.resetBtn addTarget:self action:@selector(reSetAction) forControlEvents:UIControlEventTouchUpInside];
   footView.confirmBtn.backgroundColor = self.param.wCollectionViewCellSelectTitleColor;
   for (UIView *connectView in connectViews) {
       if (!connectView.frame.size.height) break;
           if (screnFrame) {
               CGRect rect = connectView.frame;
               rect.size.height -= (self.param.wDefaultConfirmHeight+(MenuisIphoneX?(self.param.wCollectionViewDefaultFootViewMarginY>=20?0:(20-self.param.wCollectionViewDefaultFootViewMarginY)):0)+self.param.wCollectionViewDefaultFootViewMarginY+self.param.wCollectionViewDefaultFootViewPaddingY);
               connectView.frame = rect;
           }
           footView.frame = CGRectMake(0, CGRectGetMaxY(connectView.frame)+self.param.wCollectionViewDefaultFootViewPaddingY, self.dataView.frame.size.width, self.param.wDefaultConfirmHeight);
           if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:customDefauultCollectionFootView:)]) {
               [self.delegate menu:self customDefauultCollectionFootView:footView];
               [footView layoutSubviews];
               footView.frame = CGRectMake(footView.frame.origin.x, CGRectGetMaxY(connectView.frame)+self.param.wCollectionViewDefaultFootViewPaddingY, footView.frame.size.width, self.param.wDefaultConfirmHeight);
           }
   }
    
   self.confirmView = footView;
   [self.dataView addSubview:self.confirmView];
}
/// 默认headView
- (void)addDefaultHeadView:(NSArray*)connectViews
                screnFrame:(MenuShowAnimalStyle)screnFrame{
    if (screnFrame == MenuShowAnimalBoss) {
       WMZDropBossHeadView *bossHeadView = [WMZDropBossHeadView new];
       [bossHeadView.leftBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
       bossHeadView.frame = CGRectMake(0, Menu_StatusBarHeight, self.dataView.frame.size.width, 50);
       for (UIView *connectView in connectViews) {
           CGRect rect = connectView.frame;
           rect.origin.y+=CGRectGetMaxY(bossHeadView.frame);
           rect.size.height-= CGRectGetMaxY(bossHeadView.frame);
           connectView.frame = rect;
       }
       self.tableVieHeadView = bossHeadView;
       [self.dataView addSubview:self.tableVieHeadView];
   }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma -mark 更新数据
///更新数据 下一列的数据
- (BOOL)updateData:(NSArray*)arr ForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    BOOL result = YES;
    if (!dropIndexPath) {
        result = NO;
        return result;
    }
    WMZDropIndexPath *currentDrop = dropIndexPath;
    //下一层
    for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
        if (tmpDrop.section == dropIndexPath.section && tmpDrop.row == (dropIndexPath.row+1)) {
            currentDrop = tmpDrop;
            break;
        }
    }
    [self updateWithData:arr dropPath:currentDrop normalDropPath:dropIndexPath more:YES];
    return result;
}

///更新所有位置的数据 section表示所在行 row表示所在列
- (BOOL)updateData:(NSArray*)arr AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row{
    WMZDropIndexPath *currentDrop = nil;
    for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
        if (tmpDrop.section == section && tmpDrop.row == row) {
            currentDrop = tmpDrop;
            break;
        }
    }
    BOOL result = YES;
    if (!currentDrop) {
        result = NO;
        return result;
    }
    [self updateWithData:arr dropPath:currentDrop normalDropPath:currentDrop more:NO];
    //更新标题
    [self updateTitle:currentDrop changeArr:[self getArrWithPath:currentDrop withoutHide:YES] changeTree:nil];
    return result;
}

///更新全局位置某个数据源的数据 可更换选中状态 显示文字等。。。 根据WMZDropTree 对应属性改变
- (BOOL)updateDataConfig:(NSDictionary*)changeData AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row AtIndexPathRow:(NSInteger)indexPathRow{
    BOOL result = YES;
    WMZDropIndexPath *currentDrop = nil;
    for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
        if (tmpDrop.section == section && tmpDrop.row == row) {
            currentDrop = tmpDrop;break;
        }
    }
    if (!currentDrop) {
        result = NO;
        return result;
    }
    __block WMZDropTree *tree = nil;
    NSArray *dataArr = [self getArrWithPath:currentDrop withoutHide:YES];
    __weak WMZDropDownMenu *weak = self;
    [dataArr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPathRow) {
            [weak runTimeSetDataWith:changeData withTree:obj];
            tree = obj;
            *stop = YES;
        }
    }];
    //更新标题
    [self updateTitle:currentDrop changeArr:[self getArrWithPath:currentDrop withoutHide:YES] changeTree:tree];
    [self updateSubView:currentDrop more:NO];
    return result;
}

- (void)updateWithData:(NSArray*)arr dropPath:(WMZDropIndexPath*)currentDrop normalDropPath:(WMZDropIndexPath*)dropIndexPath more:(BOOL)more{
    NSMutableArray *treeArr = [NSMutableArray new];
    if (arr.count) {
        for (id dic in arr) {
            WMZDropTree *tree = [WMZDropTree new];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                [self runTimeSetDataWith:dic withTree:tree];
                //原来的值
                tree.originalData = dic;
            }else if ([dic isKindOfClass:[NSString class]]){
                tree.name = dic;
                tree.originalData = dic;
            }else if ([dic isKindOfClass:[WMZDropTree class]]){
                tree = (WMZDropTree*)dic;
            }
            //cell高度
            if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightAtDropIndexPath:AtIndexPath:)]) {
                CGFloat cellHeight = [self.delegate menu:self heightAtDropIndexPath:currentDrop AtIndexPath:[NSIndexPath indexPathForRow:[arr indexOfObject:dic] inSection:[self.dropPathArr indexOfObject:currentDrop]]];
                //MenuUICollectionView 不管外部怎么传 默认每个dropPath全部为最后一个cell的高度
                if (currentDrop.UIStyle == MenuUICollectionView) {
                    currentDrop.cellHeight = cellHeight;
                }else{
                    tree.cellHeight = cellHeight;
                }
            }
            [treeArr addObject:tree];
        }
    }
    //更新数据源
    if (currentDrop.key&&treeArr) {
        self.selectArr = [NSMutableArray new];
        currentDrop.treeArr = treeArr;
        [self updateSubView:dropIndexPath more:more];
    }
}

- (void)updateTitle:(WMZDropIndexPath*)currentDrop changeArr:(NSArray*)arr changeTree:(WMZDropTree*)tree{
    //当前展开的列 不需要更新标题 视图关闭后会更新
    if (currentDrop.section == self.selectTitleBtn.tag - 1000) return;
    WMZDropMenuBtn *currentBtn = self.titleBtnArr[currentDrop.section];
    NSMutableArray *selectArr = [NSMutableArray new];
    NSMutableArray *dropArray = [NSMutableArray new];
    for (WMZDropIndexPath *dropPath in self.dropPathArr) {
        if (dropPath.section == currentDrop.section) {
            [dropArray addObject:dropPath];
            NSArray *data = [self getArrWithPath:dropPath withoutHide:YES];
            NSMutableArray *sectionSelectArr = [NSMutableArray new];
            [data enumerateObjectsUsingBlock:^(WMZDropTree * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelected) {
                    [selectArr addObject:obj];
                    [sectionSelectArr addObject:obj];
                }
            }];
            if (dropPath.editStyle == MenuEditOneCheck) {
                //单选的时候 有多个选中 此时是不合理的  变为默认第一个选中
                if (sectionSelectArr.count>1) {
                    [sectionSelectArr enumerateObjectsUsingBlock:^(WMZDropTree * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (tree&&tree.isSelected) {
                           if (obj != tree) {
                                obj.isSelected = NO;
                                [selectArr removeObject:obj];
                            }
                        }else{
                            if (idx != 0) {
                                obj.isSelected = NO;
                                [selectArr removeObject:obj];
                            }
                        }
                    }];
                }
            }
        }
    }
    if (selectArr.count>0) {
        NSString *showTitle = nil;
        if (currentDrop.UIStyle == MenuUITableView) {
            WMZDropIndexPath *lastDrop = dropArray.lastObject;
            NSArray *arr = [self getArrWithPath:lastDrop withoutHide:YES];
            NSMutableArray *lastSelectArr = [NSMutableArray new];
            [selectArr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([arr indexOfObject:obj]!=NSNotFound) {
                    [lastSelectArr addObject:obj];
                }
            }];
            
            if (lastSelectArr.count) {
                if (lastSelectArr.count == 1) {
                    WMZDropTree *tree = lastSelectArr[0];
                    showTitle = tree.name;
                }else{
                    showTitle = @"多选";
                }
            }
        }else if (currentDrop.UIStyle == MenuUICollectionView ||currentDrop.UIStyle == MenuUICollectionRangeTextField) {
             if (selectArr.count == 1) {
                WMZDropTree *tree = selectArr[0];
                showTitle = tree.name;
            }else{
                showTitle = @"多选";
            }
        }
        if (showTitle) {
           [self changeTitleConfig:@{WMZMenuTitleNormal:showTitle} withBtn:currentBtn];
        }
    }else{
         [self changeNormalConfig:@{} withBtn:currentBtn];
    }
}

- (NSArray*)getSelectArrWithPathSection:(NSInteger)section{
    return [self getSelectArrWithPathSection:section row:-1];
}

- (NSArray*)getSelectArrWithPathSection:(NSInteger)section row:(NSInteger)row{
    NSMutableArray *allSelectArr = [NSMutableArray new];
     for (WMZDropIndexPath *drop in self.dropPathArr) {
         if (drop.section == section) {
             if (row>=0) {
                 if (drop.row == row) {
                     NSArray *arr = [self getArrWithPath:drop withoutHide:NO];
                     [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[WMZDropTree class]]) {
                            if (obj.isSelected) {
                                [allSelectArr addObject:obj];
                                }
                            }
                        }];
                     break;
                 }
             }else{
                 NSArray *arr = [self getArrWithPath:drop withoutHide:NO];
                 [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[WMZDropTree class]]) {
                        if (obj.isSelected) {
                            [allSelectArr addObject:obj];
                            }
                        }
                }];
             }
         }
     }
     return [NSArray arrayWithArray:allSelectArr];
}


#pragma -mark 更新dropPath之后的视图
- (void)updateSubView:(WMZDropIndexPath*)dropPath more:(BOOL)more{
      //获取需要更新的drop
      NSMutableArray *updateDrop = [NSMutableArray new];
      if ([dropPath.key isEqualToString:MoreTableViewKey]) {
          [updateDrop addObject:dropPath];
      }else{
          for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
              if (tmpDrop.section == dropPath.section ) {
                  if (more) {
                      if(tmpDrop.row >= dropPath.row) {
                         [updateDrop addObject:tmpDrop];continue;
                      }
                  }else{
                      if(tmpDrop.row == dropPath.row) {
                         [updateDrop addObject:tmpDrop];continue;
                      }
                  }
              }
          }
      }
      //更新
      for (UIView *view in self.showView) {
          if ([view isKindOfClass:[WMZDropTableView class]]) {
              WMZDropTableView *ta = (WMZDropTableView*)view;
              if ([updateDrop indexOfObject:ta.dropIndex]!=NSNotFound) {
                  [UIView performWithoutAnimation:^{
                      [ta reloadData];
                  }];
              }
          }else if ([view isKindOfClass:[WMZDropCollectionView class]]){
              WMZDropCollectionView *collectionView = (WMZDropCollectionView*)view;
              [UIView performWithoutAnimation:^{
                 [collectionView reloadData];
              }];
          }
      }
}

#pragma -mark 获取当前标题对应的首个drop
- (WMZDropIndexPath*)getTitleFirstDropWthTitleBtn:(WMZDropMenuBtn*)btn{
    for (WMZDropIndexPath *path in self.dropPathArr) {
        if (path.section == btn.tag - 1000) {
            return path;
        }
    }
    return nil;
}

#pragma -mark tableView联动

- (NSArray<WMZDropTableView *> *)tableViewCurrentInRow:(NSInteger)currentRow          tableViewchangeInRow:(NSInteger)changeRow scrollTowPath:(NSIndexPath *)indexPath{
    __block NSMutableArray<WMZDropTableView *> *marr = [NSMutableArray new];
    __block  WMZDropTableView *leftTa = nil;
    __block  WMZDropTableView *rightTa = nil;
    [self.showView enumerateObjectsUsingBlock:^(UIView*  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:[WMZDropTableView class]]) {
               WMZDropTableView *tableView = (WMZDropTableView*)view;
            if (tableView.dropIndex.row == currentRow) {
                leftTa = tableView;
                [marr addObject:leftTa];
            }else if (tableView.dropIndex.row == changeRow){
                rightTa = tableView;
                [marr addObject:rightTa];
            }
        }
    }];

    if (leftTa&&rightTa) {
        [rightTa selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [rightTa scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return [NSArray arrayWithArray:marr];
}

/// 查看更多
- (void)setUpMoreView:(WMZDropIndexPath*)dropPath{
    [MenuWindow addSubview:self.moreView];
    self.moreView.frame = self.dataView.frame;
    [self showAnimal:dropPath.showAnimalStyle view:self.moreView durtion:self.param.wMenuDurtion block:^{}];
    WMZDropIndexPath *path = nil;
    for (WMZDropIndexPath *tmpPath in self.dropPathArr) {
        if ([tmpPath.key isEqualToString:MoreTableViewKey]) {
            path = tmpPath; break;
        }
    }
    if (!path) {
        path = [WMZDropIndexPath new];
        path.key = MoreTableViewKey;
        path.editStyle = dropPath.editStyle;
        path.headViewHeight = dropPath.headViewHeight;
        path.UIStyle = MenuUITableView;
        [self.dropPathArr addObject:path];
    }
    
    WMZDropTableView *tableView = [self getTableVieww:path];
    tableView.frame = CGRectMake(0, Menu_StatusBarHeight, self.moreView.frame.size.width, self.moreView.frame.size.height - (Menu_StatusBarHeight+(MenuisIphoneX?20:0)+self.confirmView.frame.size.height));
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:moreDataForRowAtDropIndexPath:)]) {
        NSArray *arr = [self.delegate menu:self moreDataForRowAtDropIndexPath:dropPath];
        NSMutableArray *treeArr = [NSMutableArray new];
        if (!path.treeArr) {
            for (int k = 0; k<arr.count; k++) {
                id dic = arr[k];
                WMZDropTree *tree = [WMZDropTree new];
                //cell高度
                if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightAtDropIndexPath:AtIndexPath:)]) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        [self runTimeSetDataWith:dic withTree:tree];
                            //原来的值
                        tree.originalData = dic;
                    }else if ([dic isKindOfClass:[NSString class]]){
                        tree.name = dic;
                        tree.originalData = dic;
                    }
                    tree.hide = YES;
                    [treeArr addObject:tree];
                }
            }
            if (treeArr) {
                path.treeArr = treeArr;
                NSArray *nowArr = [self getArrWithPath:dropPath withoutHide:YES];
                NSMutableArray *marr = [NSMutableArray arrayWithArray:nowArr];
                for (WMZDropTree *tree in treeArr) {
                    if (tree) {
                        [marr addObject:tree];
                    }
                }
                path.treeArr = marr;
            }
        }
        [self.moreView addSubview:tableView];
        [self.showView addObject:tableView];
    }
    WMZDropConfirmView *footView = [WMZDropConfirmView new];
    [footView.confirmBtn addTarget:self action:NSSelectorFromString(@"confirmAction:") forControlEvents:UIControlEventTouchUpInside];
    footView.confirmBtn.tag = 10089;
    [footView.resetBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    footView.confirmBtn.backgroundColor = self.param.wCollectionViewCellSelectTitleColor;
    footView.frame = self.confirmView.frame;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:customDefauultCollectionFootView:)]) {
        [self.delegate menu:self customDefauultCollectionFootView:footView];
        [footView layoutSubviews];
        footView.frame = CGRectMake(footView.frame.origin.x, self.confirmView.frame.origin.y, footView.frame.size.width, self.param.wDefaultConfirmHeight);
    }
    [footView.resetBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.moreView addSubview:footView];
}
/// 查看更多 返回上一级
- (void)backAction{
    [self closeView];
}

@end
