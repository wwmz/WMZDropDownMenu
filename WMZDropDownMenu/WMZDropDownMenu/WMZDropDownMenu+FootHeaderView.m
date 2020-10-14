//
//  WMZDropDownMenu+FootHeaderView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/15.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropDownMenu+FootHeaderView.h"

@implementation WMZDropDownMenu (FootHeaderView)
#pragma -mark 添加全局的头尾
- (void)addHeadFootView:(NSArray*)connectViews screnFrame:(MenuShowAnimalStyle)screnFrame{
    //头部
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
    //尾部
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
#pragma -mark 默认footView
- (void)addDefaultFootView:(NSArray*)connectViews
                screnFrame:(MenuShowAnimalStyle)screnFrame{
   BOOL insert = NO;
   for (UIView *connectView in connectViews) {
       if ([connectView isKindOfClass:[WMZDropCollectionView class]]) {
           WMZDropCollectionView *collectionView = (WMZDropCollectionView*)connectView;
           insert = YES;
           for (WMZDropIndexPath *path in collectionView.dropArr) {
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
#pragma -mark 默认headView
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
@end
