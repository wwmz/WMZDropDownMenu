//
//  WMZDropDownMenu+MoreView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropDownMenu+MoreView.h"

@implementation WMZDropDownMenu (MoreView)
#pragma -mark 查看更多
- (void)setUpMoreView:(WMZDropIndexPath*)dropPath{
    [MenuWindow addSubview:self.moreView];
    self.moreView.frame = self.dataView.frame;
    [self showAnimal:dropPath.showAnimalStyle view:self.moreView durtion:menuAnimalTime block:^{}];
    WMZDropIndexPath *path = nil;
    for (WMZDropIndexPath *tmpPath in self.dropPathArr) {
        if ([tmpPath.key isEqualToString:moreTableViewKey]) {
            path = tmpPath; break;
        }
    }
    if (!path) {
        path = [WMZDropIndexPath new];
        path.key = moreTableViewKey;
        path.editStyle = dropPath.editStyle;
        path.headViewHeight = dropPath.headViewHeight;
        path.UIStyle = MenuUITableView;
        [self.dropPathArr addObject:path];
    }
    
    WMZDropTableView *tableView = [self getTableVieww:path];
    tableView.menu = self;
    tableView.frame = CGRectMake(0, Menu_StatusBarHeight, self.moreView.frame.size.width, self.moreView.frame.size.height - (Menu_StatusBarHeight+(MenuisIphoneX?20:0)+self.confirmView.frame.size.height));
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:moreDataForRowAtDropIndexPath:)]) {
        NSArray *arr = [self.delegate menu:self moreDataForRowAtDropIndexPath:dropPath];
        NSMutableArray *treeArr = [NSMutableArray new];
        if (![self getArrWithKey:moreTableViewKey withoutHide:NO]) {
            
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
                [self.dataDic setObject:treeArr forKey:path.key];
                NSArray *nowArr = [self getArrWithKey:dropPath.key withoutHide:YES];
                NSMutableArray *marr = [NSMutableArray arrayWithArray:nowArr];
                for (WMZDropTree *tree in treeArr) {
                    if (tree) {
                        [marr addObject:tree];
                    }
                }
                
                [self.dataDic setObject:marr forKey:dropPath.key];
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
#pragma -mark 查看更多 返回上一级
- (void)backAction{
    [self closeView];
}
@end
