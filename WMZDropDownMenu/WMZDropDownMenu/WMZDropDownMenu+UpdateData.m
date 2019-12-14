//
//  WMZDropDownMenu+UpdateData.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/12/14.
//  Copyright © 2019 wmz. All rights reserved.
//
#pragma -mark 更新数据
#import "WMZDropDownMenu+UpdateData.h"

@implementation WMZDropDownMenu (UpdateData)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
/*
*更新数据 下一列的数据
*/
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
/*
*更新所有位置的数据 section表示所在行 row表示所在列
*/
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
    [self updateTitle:currentDrop changeArr:[self.dataDic objectForKey:currentDrop.key] changeTree:nil];
    return result;
}

/*
*更新全局位置某个数据源的数据 可更换选中状态 显示文字等。。。 根据WMZDropTree 对应属性改变
*/
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
    NSArray *dataArr = [self.dataDic objectForKey:currentDrop.key];
    __weak WMZDropDownMenu *weak = self;
    [dataArr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPathRow) {
            [weak runTimeSetDataWith:changeData withTree:obj];
            tree = obj;
            *stop = YES;
        }
    }];
    //更新标题
    [self updateTitle:currentDrop changeArr:[self.dataDic objectForKey:currentDrop.key] changeTree:tree];
    return result;
}

#pragma clang diagnostic pop
//自动增加数组的配置
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
        [self.dataDic setObject:treeArr forKey:currentDrop.key];
        [self updateSubView:dropIndexPath more:more];
    }
}
//更新标题
- (void)updateTitle:(WMZDropIndexPath*)currentDrop changeArr:(NSArray*)arr changeTree:(WMZDropTree*)tree{
    //当前展开的列 不需要更新标题 视图关闭后会更新
    if (currentDrop.section == self.selectTitleBtn.tag - 1000) return;
    WMZDropMenuBtn *currentBtn = self.titleBtnArr[currentDrop.section];
    NSMutableArray *selectArr = [NSMutableArray new];
    NSMutableArray *dropArr = [NSMutableArray new];
    for (WMZDropIndexPath *dropPath in self.dropPathArr) {
        if (dropPath.section == currentDrop.section) {
            [dropArr addObject:dropPath];
            NSArray *data = [self.dataDic objectForKey:dropPath.key];
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
            WMZDropIndexPath *lastDrop = dropArr.lastObject;
            NSArray *arr = [self.dataDic objectForKey:lastDrop.key];
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
         [self changeTitleConfig:@{@"name":showTitle} withBtn:currentBtn];
    }else{
        [self changeNormalConfig:@{} withBtn:currentBtn];
    }
}

#pragma -mark 更新dropPath之后的视图
- (void)updateSubView:(WMZDropIndexPath*)dropPath more:(BOOL)more{
      //获取需要更新的drop
      NSMutableArray *updateDrop = [NSMutableArray new];
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
              [UIView performWithoutAnimation:^{
                 [self.collectionView reloadData];
              }]; break;
          }
      }
}
@end
