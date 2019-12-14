


//
//  WMZDropDownMenu+DealDelegate.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/12/14.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropDownMenu+DealDelegate.h"
@implementation WMZDropDownMenu (DealDelegate)
#pragma -mark 处理delegate的data
- (void)setDelegate:(id<WMZDropMenuDelegate>)delegate{
    [super setDelegate:delegate];
    [self dealData];
    [self updateUI];
}
- (void)dealData{
    self.dropPathArr = [NSMutableArray new];
    //标题
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleArrInMenu:)]) {
        self.titleArr =  [self.delegate titleArrInMenu:self];
    }
    //数量
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:numberOfRowsInSection:)]) {
        for (int i = 0; i<self.titleArr.count; i++) {
            NSInteger row =  [self.delegate menu:self numberOfRowsInSection:i];
            if (row == 0) {
                row = 1;
            }
            for (NSInteger j = 0; j<row; j++) {
                WMZDropIndexPath *path = [[WMZDropIndexPath alloc]initWithSection:i row:j ];
                [self.dropPathArr addObject:path];
            }
        }
    }else{
        for (int i = 0; i<self.titleArr.count; i++) {
            //默认一个
            WMZDropIndexPath *path = [[WMZDropIndexPath alloc]initWithSection:i row:0];
            [self.dropPathArr addObject:path];
         }
    }
    
    for (WMZDropIndexPath *path in self.dropPathArr) {
        //UIStyle
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:uiStyleForRowIndexPath:)]) {
            MenuUIStyle uiStyle =  [self.delegate menu:self uiStyleForRowIndexPath:path];
            path.UIStyle = uiStyle;
        }
        //showAnimal
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:showAnimalStyleForRowInSection:)]) {
            MenuShowAnimalStyle showAnimalStyle =  [self.delegate menu:self showAnimalStyleForRowInSection:path.section];
            path.showAnimalStyle = showAnimalStyle;
        }else{
            //最后一个默认右侧出现
            if (path.section == self.titleArr.count-1) {
                path.showAnimalStyle = MenuShowAnimalRight;
            }
        }
        //hideAnimal
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:hideAnimalStyleForRowInSection:)]) {
            MenuHideAnimalStyle hideAnimalStyle =  [self.delegate menu:self hideAnimalStyleForRowInSection:path.section];
            path.hideAnimalStyle = hideAnimalStyle;
        }else{
            if (path.section == self.titleArr.count-1) {
                path.hideAnimalStyle = MenuHideAnimalLeft;
            }
        }
        //editStyle
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:editStyleForRowAtDropIndexPath:)]) {
            MenuEditStyle editStyle =  [self.delegate menu:self editStyleForRowAtDropIndexPath:path];
            path.editStyle = editStyle;
        }
        //一行显示cell的个数
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:countForRowAtDropIndexPath:)]) {
            //tableView无效 默认一个
            if (path.UIStyle == MenuUICollectionView||
                path.UIStyle == MenuUICollectionRangeTextField) {
                NSInteger count =  [self.delegate menu:self countForRowAtDropIndexPath:path];
                path.collectionCellRowCount = count;
            }
        }
        //headViewHeight
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightForHeadViewAtDropIndexPath:)]) {
            CGFloat headViewHeight =  [self.delegate menu:self heightForHeadViewAtDropIndexPath:path];
            path.headViewHeight = headViewHeight;
        }else{
            if (path.UIStyle == MenuUITableView) {
                path.headViewHeight = 0.01;
            }else{
                path.headViewHeight = footHeadHeight;
            }
        }
        //footViewHeight
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightForFootViewAtDropIndexPath:)]) {
            CGFloat footViewHeight =  [self.delegate menu:self heightForFootViewAtDropIndexPath:path];
            path.footViewHeight = footViewHeight;
        }else{
            if (path.UIStyle == MenuUITableView) {
                path.footViewHeight = 0.01;
            }else{
                path.footViewHeight = 0;
            }
        }
        //tapClose
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:closeWithTapAtDropIndexPath:)]) {
            BOOL tapClose =  [self.delegate menu:self closeWithTapAtDropIndexPath:path];
            path.tapClose = tapClose;
        }else{
            if (path.section == self.titleArr.count-1) {
                path.tapClose = NO;
            }
            if (path.showAnimalStyle == MenuShowAnimalPop) {
                 path.tapClose = YES;
            }
        }
        //取消选中
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:dropIndexPathConnectInSection:)]) {
            BOOL connect =  [self.delegate menu:self dropIndexPathConnectInSection:path.section];
            path.connect = connect;
        }
        //数据源
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:dataForRowAtDropIndexPath:)]) {
            NSArray *arr =  [self.delegate menu:self dataForRowAtDropIndexPath:path];
            NSMutableArray *treeArr = [NSMutableArray new];
            for (int k = 0; k<arr.count; k++) {
                id dic = arr[k];
                WMZDropTree *tree = [WMZDropTree new];
                //cell高度
                if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightAtDropIndexPath:AtIndexPath:)]) {
                    CGFloat cellHeight = [self.delegate menu:self heightAtDropIndexPath:path AtIndexPath:[NSIndexPath indexPathForRow:[arr indexOfObject:dic] inSection:[self.dropPathArr indexOfObject:path]]];
                    //MenuUICollectionView 不管外部怎么传 默认每个dropPath全部为最后一个cell的高度
                    if (path.UIStyle == MenuUICollectionView) {
                        path.cellHeight = cellHeight;
                    }else{
                        tree.cellHeight = cellHeight;
                    }
                }
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [self runTimeSetDataWith:dic withTree:tree];
                    //原来的值
                    tree.originalData = dic;
                }else if ([dic isKindOfClass:[NSString class]]){
                    tree.depth = path.row;
                    tree.name = dic;
                    tree.originalData = dic;
                }
                [treeArr addObject:tree];
            }
            if (treeArr) {
                [self.dataDic setObject:treeArr forKey:path.key];
            }
        }
        //expand
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:showExpandAtDropIndexPath:)]) {
            BOOL showExpand =  [self.delegate menu:self showExpandAtDropIndexPath:path];
            path.showExpand = showExpand;
            path.expand = !showExpand;
        }else{
            path.showExpand = [[self.dataDic objectForKey:path.key] count] > self.param.wCollectionViewSectionShowExpandCount;
        }
    }
}
@end
