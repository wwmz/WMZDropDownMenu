//
//  WMZDropDownMenu+NormalView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropDownMenu+NormalView.h"
#import "WMZDropDownMenu+FootHeaderView.h"
#import "WMZDropDownMenu+DealLogic.h"
@implementation WMZDropDownMenu (NormalView)
#pragma -mark 添加数据
- (void)addTableView{
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
    NSMutableArray *dorpArr = [NSMutableArray new];
    for (WMZDropIndexPath *path in self.dropPathArr) {
        if (path.section == index&&![path.key isEqualToString:moreTableViewKey]) {
            [dorpArr addObject:path];
            showType = path.UIStyle;
        }
    }
    //添加UI
    [self addDropPathUI:[NSArray arrayWithArray:dorpArr] type:showType];
}

#pragma -mark 根据dic添加显示的UI
- (void)addDropPathUI:(NSArray*)dropArr type:(MenuUIStyle)type{
    CGFloat height = self.param.wFixDataViewHeight;
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
            for (WMZDropIndexPath *path in dropArr) {
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
                    NSArray *dataArr = [self getArrWithKey:path.key withoutHide:YES];
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
            for (WMZDropIndexPath *path in dropArr) {
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
        for (int i = 0; i< dropArr.count; i++) {
            WMZDropIndexPath *path = dropArr[i];
            WMZDropTableView *tableView = [self getTableVieww:path];
            tableView.menu = self;
            tableView.frame = CGRectMake(tmpTa?CGRectGetMaxX(tmpTa.frame):0, y, self.dataView.frame.size.width/dropArr.count, height-y);
            if (i<self.param.wTableViewColor.count) {
                tableView.backgroundColor = self.param.wTableViewColor[i];
            }else{
                tableView.backgroundColor = MenuColor(0xffffff);
            }
            if (screnFrame&&screnFrame!= MenuShowAnimalBoss) {
                self.emptyView.frame = CGRectMake(0, 0, tableView.frame.size.width, Menu_StatusBarHeight);
                tableView.tableHeaderView = self.emptyView;
            }
            [self.dataView addSubview:tableView];
            [self.showView addObject:tableView];
            tmpTa = tableView;
        }
        [self addHeadFootView:self.showView screnFrame:screnFrame];
    }else if (type == MenuUICollectionView||
              type == MenuUICollectionRangeTextField) {  //单collectionView
        
        if (height == 0) {
            for (WMZDropIndexPath *path in dropArr) {
                NSArray *arr = [self getArrWithKey:path.key withoutHide:YES];
                if (arr.count) {
                    if (path.showAnimalStyle == MenuShowAnimalLeft||
                        path.showAnimalStyle == MenuShowAnimalRight||
                        path.showAnimalStyle == MenuShowAnimalBoss) {
                        height = self.dataView.frame.size.height;
                        screnFrame = path.showAnimalStyle;
                        break;
                    }else{
                        if (path.showAnimalStyle == MenuShowAnimalPop) {
                              pop = YES;
                        }
                        NSInteger count = ceil((CGFloat)arr.count/path.collectionCellRowCount);
                        height += (count * (path.cellHeight));
                        if (count>1) {
                            height += (count*self.param.wCollectionViewCellSpace);
                        }
                        height += (path.headViewHeight + path.footViewHeight);
                        
                    }
                }
            }
            if (!screnFrame) {
                //最大为maxHeight
                if (height > (Menu_Height*(self.param.wMaxHeightScale>1?
                1:self.param.wMaxHeightScale))) {
                    height = (Menu_Height*(self.param.wMaxHeightScale>1?
                    1:self.param.wMaxHeightScale));
                }
            }
        }else{
            
            for (WMZDropIndexPath *path in dropArr) {
                if (path.showAnimalStyle == MenuShowAnimalLeft ||
                    path.showAnimalStyle == MenuShowAnimalRight||
                    path.showAnimalStyle == MenuShowAnimalBoss) {
                 height = self.dataView.frame.size.height;
                 screnFrame = path.showAnimalStyle;
             }
           }
        }
        WMZDropIndexPath *firstPath = dropArr.firstObject;
        CGFloat y = (screnFrame&&screnFrame!= MenuShowAnimalBoss)?Menu_StatusBarHeight:0;
        WMZDropMenuCollectionLayout *layout = [[WMZDropMenuCollectionLayout alloc]initWithType:firstPath.alignType betweenOfCell:self.param.wCollectionViewCellSpace];
        layout.minimumLineSpacing = self.param.wCollectionViewCellSpace;
        layout.minimumInteritemSpacing = self.param.wCollectionViewCellSpace;
        layout.sectionInset = UIEdgeInsetsMake(0, self.param.wCollectionViewCellSpace, 0, self.param.wCollectionViewCellSpace);
        self.collectionView = [self getCollectonView:[WMZDropIndexPath new] layout:layout];
        //注册自定义cell
        if (self.param.wReginerCollectionCells) {
            for (NSString *name in self.param.wReginerCollectionCells) {
                [self.collectionView registerClass:NSClassFromString(name) forCellWithReuseIdentifier:name];
            }
        }
        //注册自定义headView
        if (self.param.wReginerCollectionHeadViews) {
            for (NSString *name in self.param.wReginerCollectionHeadViews) {
                [self.collectionView registerClass:NSClassFromString(name) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
            }
        }
        //注册自定义footView
        if (self.param.wReginerCollectionFootViews) {
            for (NSString *name in self.param.wReginerCollectionFootViews) {
                 [self.collectionView registerClass:NSClassFromString(name) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:name];
            }
        }
        self.collectionView.delegate = (id)self.collectionView;
        self.collectionView.dataSource = (id)self.collectionView;
        self.collectionView.menu = self;
        self.collectionView.dropArr = [NSArray arrayWithArray:dropArr];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.frame = CGRectMake(0, y , self.dataView.frame.size.width, height - y);
        [self.dataView addSubview:self.collectionView];
        [self.showView addObject:self.collectionView];
        [self addHeadFootView:self.showView screnFrame:screnFrame];
    }
    
    if (!screnFrame) {
        if ([[self.dataView subviews] indexOfObject:self.confirmView] != NSNotFound) {
            height += CGRectGetHeight(self.confirmView.frame);
            height += self.param.wCollectionViewDefaultFootViewPaddingY;
        }
        if ([[self.dataView subviews] indexOfObject:self.tableVieHeadView]!= NSNotFound) {
            height += CGRectGetHeight(self.tableVieHeadView.frame);
        }
    }
    CGRect rect = [[self.dataViewFrameDic objectForKey:@([self getTitleFirstDropWthTitleBtn:self.selectTitleBtn].showAnimalStyle)] CGRectValue];
    rect.size.height  = height;
    self.dataView.frame = rect;
    if (self.param.wCustomDataViewRect) {
        CGRect rect =  self.param.wCustomDataViewRect(self.dataView.frame);
        self.dataView.frame = rect;
    }
    
    
    //动画是pop
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
@end
