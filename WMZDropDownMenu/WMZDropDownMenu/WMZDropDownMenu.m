//
//  WMZDropDownMenu.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZDropDownMenu.h"
#import "WMZDropDownMenu+Expand.h"

static NSString* const notificationRemove = @"notificationRemove";

@interface WMZDropDownMenu(){
    BOOL checkMore;
}

@end

@implementation WMZDropDownMenu

- (void)setDelegate:(id<WMZDropMenuDelegate>)delegate{
    [super setDelegate:delegate];
    [self UISetup];
}

- (void)UISetup{
    [self dealData];
    [self resetConfig];
}

- (void)dealData{
    self.dropPathArr = [NSMutableArray new];
    ///标题
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleArrInMenu:)]) {
        self.titleArr =  [self.delegate titleArrInMenu:self];
    }
    ///数量
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:numberOfRowsInSection:)]) {
        for (int i = 0; i< self.titleArr.count; i++) {
            UIView <WMZDropShowViewProcotol>*customView = nil;
            if(self.delegate && [self.delegate respondsToSelector:@selector(menu:customViewInSection:)]){
                customView = [self.delegate menu:self customViewInSection:i];
            }
            if(customView && [customView conformsToProtocol:@protocol(WMZDropShowViewProcotol)]){
                if(customView.dropIndex == nil){
                    customView.dropIndex = WMZDropIndexPath.new;
                }
                customView.dropIndex.section = i;
                customView.dropIndex.editStyle = MenuEditCustom;
                customView.dropIndex.UIStyle = MenuUICustom;
                [self.dropPathArr addObject:customView.dropIndex];
            }else{
                NSInteger row =  [self.delegate menu:self numberOfRowsInSection:i];
                if (row == 0) row = 1;
                for (NSInteger j = 0; j < row; j++) {
                    WMZDropIndexPath *path = [[WMZDropIndexPath alloc]initWithSection:i row:j];
                    [self.dropPathArr addObject:path];
                }
            }
        }
    }else{
        for (int i = 0; i<self.titleArr.count; i++) {
            UIView <WMZDropShowViewProcotol>*customView = nil;
            if(self.delegate && [self.delegate respondsToSelector:@selector(menu:customViewInSection:)]){
                customView = [self.delegate menu:self customViewInSection:i];
            }
            
            if(customView && [customView conformsToProtocol:@protocol(WMZDropShowViewProcotol)]){
                if(customView.dropIndex == nil){
                    customView.dropIndex = WMZDropIndexPath.new;
                }
                customView.dropIndex.section = i;
                customView.dropIndex.editStyle = MenuEditCustom;
                customView.dropIndex.UIStyle = MenuUICustom;
                [self.dropPathArr addObject:customView.dropIndex];
            }
            else{
                WMZDropIndexPath *path = [[WMZDropIndexPath alloc]initWithSection:i row:0];
                [self.dropPathArr addObject:path];
            }
         }
    }
    
    for (WMZDropIndexPath *path in self.dropPathArr) {
        if(path.UIStyle == MenuUICustom && path.editStyle == MenuUICustom) continue;
        ///UIStyle
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:uiStyleForRowIndexPath:)]) {
            MenuUIStyle uiStyle =  [self.delegate menu:self uiStyleForRowIndexPath:path];
            path.UIStyle = uiStyle;
        }
        
        ///CellFixStyle
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:cellFixStyleForRowAtDropIndexPath:)]) {
            MenuCollectionUIStyle collectionUIStyle =  [self.delegate menu:self cellFixStyleForRowAtDropIndexPath:path];
            path.collectionUIStyle = collectionUIStyle;
        }
        
        ///CellFixAlign
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:collectionAlignFitTypeForRowAtDropIndexPath:)]) {
            MenuCellAlignType alignType =  [self.delegate menu:self collectionAlignFitTypeForRowAtDropIndexPath:path];
            path.alignType = alignType;
        }
        
        ///showAnimal
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:showAnimalStyleForRowInSection:)]) {
            MenuShowAnimalStyle showAnimalStyle =  [self.delegate menu:self showAnimalStyleForRowInSection:path.section];
            path.showAnimalStyle = showAnimalStyle;
        }else{
            ///最后一个默认右侧出现
            if (path.section == self.titleArr.count-1) {
                path.showAnimalStyle = MenuShowAnimalRight;
            }
        }
        
        ///hideAnimal
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:hideAnimalStyleForRowInSection:)]) {
            MenuHideAnimalStyle hideAnimalStyle =  [self.delegate menu:self hideAnimalStyleForRowInSection:path.section];
            path.hideAnimalStyle = hideAnimalStyle;
        }else{
            if (path.section == self.titleArr.count-1) {
                path.hideAnimalStyle = MenuHideAnimalLeft;
            }
        }
        
        ///editStyle
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:editStyleForRowAtDropIndexPath:)]) {
            MenuEditStyle editStyle =  [self.delegate menu:self editStyleForRowAtDropIndexPath:path];
            path.editStyle = editStyle;
        }
        ///一行显示cell的个数
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:countForRowAtDropIndexPath:)]) {
            //tableView无效 默认一个
            if (path.UIStyle == MenuUICollectionView||
                path.UIStyle == MenuUICollectionRangeTextField) {
                NSInteger count =  [self.delegate menu:self countForRowAtDropIndexPath:path];
                path.collectionCellRowCount = count;
            }
        }
        ///headViewHeight
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
        ///footViewHeight
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
        ///tapClose
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
        ///取消选中
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:dropIndexPathConnectInSection:)]) {
            BOOL connect =  [self.delegate menu:self dropIndexPathConnectInSection:path.section];
            path.connect = connect;
        }
        ///数据源
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:dataForRowAtDropIndexPath:)]) {
            NSArray *arr =  [self.delegate menu:self dataForRowAtDropIndexPath:path];
            NSMutableArray *treeArr = [NSMutableArray new];
            for (int k = 0; k<arr.count; k++) {
                id dic = arr[k];
                WMZDropTree *tree = [WMZDropTree new];
                ///cell高度
                if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightAtDropIndexPath:AtIndexPath:)]) {
                    CGFloat cellHeight = [self.delegate menu:self heightAtDropIndexPath:path AtIndexPath:[NSIndexPath indexPathForRow:[arr indexOfObject:dic] inSection:[self.dropPathArr indexOfObject:path]]];
                    ///MenuUICollectionView 不管外部怎么传 默认每个dropPath全部为最后一个cell的高度
                    if (path.UIStyle == MenuUICollectionView) {
                        path.cellHeight = cellHeight;
                    }else{
                        tree.cellHeight = cellHeight;
                    }
                }
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [self runTimeSetDataWith:dic withTree:tree];
                    ///原来的值
                    tree.originalData = dic;
                }else if ([dic isKindOfClass:[NSString class]]){
                    tree.depth = path.row;
                    tree.name = dic;
                    tree.originalData = dic;
                }
                [treeArr addObject:tree];
            }
            if (treeArr) {
                path.treeArr = treeArr;
            }
        }
        ///expand
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:showExpandAtDropIndexPath:)]) {
            BOOL showExpand =  [self.delegate menu:self showExpandAtDropIndexPath:path];
            path.showExpand = showExpand;
            path.expand = !showExpand;
        }else{
            path.showExpand = [path.treeArr count] > self.param.wCollectionViewSectionShowExpandCount;
        }
    }
}

#pragma -mark 重置UI
- (void)resetConfig{
    [self.titleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleView removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleBtnArr removeAllObjects];
    [self.shadowView removeFromSuperview];
    [self.dataView removeFromSuperview];
    [self menuTitle];
}

- (void)menuTitle{
    self.backgroundColor = menuMainClor;
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:notificationRemove object:nil];
   if([[WMZDropMenuTool getCurrentVC] respondsToSelector:@selector(viewWillDisappear:)] ||
      [[WMZDropMenuTool getCurrentVC] respondsToSelector:@selector(viewDidDisappear:)]){
       ///hook监听当前控制器消失
       @MenuWeakSelf(self);
       [[WMZDropMenuTool getCurrentVC] aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> aspectInfo){
         @MenuStrongSelf(self);
           if(!self.close){
               self.hook = YES;
               [self closeView];
               self.hook = NO;
           }
       } error:NULL];
       
       [[WMZDropMenuTool getCurrentVC] aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> aspectInfo){
         @MenuStrongSelf(self);
           if(!self.close){
               self.hook = YES;
               [self closeView];
               self.hook = NO;
           }
       } error:NULL];
   }
   self.userInteractionEnabled = YES;
   [self addSubview:self.titleView];
    self.titleView.frame = self.bounds;
   
   NSArray *indexArr = @[];
   ///相互排斥的标题
   if (self.delegate && [self.delegate respondsToSelector:@selector(mutuallyExclusiveSectionsWithMenu:)])
       indexArr =  [self.delegate mutuallyExclusiveSectionsWithMenu:self];
   
   UIButton *tmp = nil;
   for (int i = 0; i<self.titleArr.count; i++) {
       id dic = self.titleArr[i];
       BOOL dictionary = [dic isKindOfClass:[NSDictionary class]];
       WMZDropMenuBtn *btn = [WMZDropMenuBtn buttonWithType:UIButtonTypeCustom];
       [btn setUpParam:self.param withDic:dic];
       btn.frame = CGRectMake(tmp?CGRectGetMaxX(tmp.frame):0, 0, self.titleView.frame.size.width/(self.param.wMenuTitleEqualCount<self.titleArr.count?self.titleArr.count:self.param.wMenuTitleEqualCount), self.titleView.frame.size.height);
       ///外部自定义标题按钮
       NSDictionary *config = nil;
       if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:customTitleInSection:withTitleBtn:)]) {
           config =  [self.delegate menu:self customTitleInSection:i withTitleBtn:btn];
       }
       CGFloat offset = config[@"offset"]?[config[@"offset"] floatValue]:0;
       CGFloat y = config[@"y"]?[config[@"y"] floatValue]:0;
       btn.frame = CGRectMake(tmp?(CGRectGetMaxX(tmp.frame)+offset):offset, y, btn.frame.size.width , btn.frame.size.height-y*2);
       [WMZDropMenuTool TagSetImagePosition:btn.position spacing:self.param.wMenuTitleSpace button:btn];
       [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
       btn.tag = 1000 + i;
       if (i == self.titleArr.count - 1 && i!=0) {
           if (dictionary && dic[WMZMenuTitleLastFix]) {
               btn.frame = CGRectMake(CGRectGetWidth(self.frame)-self.param.wFixBtnWidth, 0, self.param.wFixBtnWidth, self.titleView.frame.size.height);
               if ([[self subviews] indexOfObject:btn] == NSNotFound) {
                   [self addSubview:btn];
               }
               CGRect rect = self.titleView.frame;
               rect.size.width -= self.param.wFixBtnWidth;
               self.titleView.frame = rect;
               self.titleView.contentSize = CGSizeMake(CGRectGetMaxX(tmp.frame), 0);
               btn.backgroundColor = menuMainClor;
           }else{
               btn.frame = CGRectMake(CGRectGetMaxX(tmp.frame)+offset, y, tmp.frame.size.width, tmp.frame.size.height);
               if ([[self.titleView subviews] indexOfObject:btn] == NSNotFound) {
                   [self.titleView addSubview:btn];
               }
               self.titleView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
           }
            [WMZDropMenuTool TagSetImagePosition:btn.position spacing:self.param.wMenuTitleSpace button:btn];
       }else{
           if ([[self.titleView subviews] indexOfObject:btn] == NSNotFound) {
               [self.titleView addSubview:btn];
           }
       }
       if ([self.titleBtnArr indexOfObject:btn] == NSNotFound) {
           [self.titleBtnArr addObject:btn];
       }
       if ([self.mutuallyExclusiveArr indexOfObject:btn] == NSNotFound&&
          [indexArr indexOfObject:@(i)]!=NSNotFound) {
           [self.mutuallyExclusiveArr addObject:btn];
       }
       tmp = btn;
   }
   //阴影层
   self.shadowView.backgroundColor = self.param.wShadowColor;
   self.shadowView.alpha = self.param.wShadowAlpha;
   if (self.param.wShadowCanTap) {
       self.shadowView.userInteractionEnabled = YES;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
       [self.shadowView addGestureRecognizer:tap];
   }
   ///显示边框
   if (self.param.wBorderShow) {
       [self addBoder];
   }
   ///显示边框
   if (self.param.wBorderUpDownShow) {
      [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathTop PathWidth:1 heightScale:1 button:self];
      [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathBottom PathWidth:1 heightScale:1 button:self];
   }
}

#pragma -mark UI
- (void)updateUI{
    [self UISetup];
}

#pragma -mark 添加边框
- (void)addBoder{
    [self.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.titleBtnArr.count-1) {
            [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathRight PathWidth:1 heightScale:0.5 button:btn];
        }
    }];
}

#pragma -mark 标题点击方法
- (void)titleAction:(WMZDropMenuBtn*)sender{
    ///点击代理
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(menu:didSelectTitleInSection:btn:)]) {
        [self.delegate menu:self didSelectTitleInSection:sender.tag - 1000 btn:sender];
    }
    @MenuWeakSelf(self)
    ///点击标题网络请求
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:didSelectTitleInSection:btn:networkBlock:)]) {
        [self.delegate menu:self didSelectTitleInSection:sender.tag - 1000 btn:sender networkBlock:^{
            @MenuStrongSelf(self)
            [self judgeBtnTitle:sender];
        }];
    }else{
        [self judgeBtnTitle:sender];
    }
}

#pragma -mark 标题点击逻辑处理
- (void)judgeBtnTitle:(WMZDropMenuBtn*)sender{
    if (self.selectTitleBtn &&
        self.selectTitleBtn.tag != sender.tag &&
        [self.selectTitleBtn isSelected]) {
           [self.selectTitleBtn hidenLine];
           WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
           if (currentDrop.editStyle != MenuEditReSetCheck&&
               currentDrop.editStyle != MenuEditCheck&&
               currentDrop.editStyle != MenuEditNone) {
               self.selectTitleBtn.selected = NO;
               self.lastSelectIndex = self.selectTitleBtn.tag - 1000;
           }
       }
       self.selectTitleBtn = sender;
       WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:sender];
       ///两种选中状态
       if (currentDrop.editStyle == MenuEditReSetCheck) {
          if (!self.close) {
              [self closeView];
          }
          [self.selectTitleBtn setTitleColor:self.param.wCollectionViewCellSelectTitleColor forState:UIControlStateSelected];
          sender.selected = YES;
          if (!sender.click) {
              [sender setImage:[UIImage bundleImage:sender.selectImage] forState:UIControlStateSelected];
              [sender setImage:[UIImage bundleImage:sender.selectImage] forState:UIControlStateSelected | UIControlStateHighlighted];
              if (sender.selectTitle) {
                  [sender setTitle:sender.selectTitle forState:UIControlStateSelected];
                  [sender setTitle:sender.selectTitle forState:UIControlStateSelected | UIControlStateHighlighted];
              }
          }else{
              [sender setImage:[UIImage bundleImage:sender.reSelectImage] forState:UIControlStateSelected];
              [sender setImage:[UIImage bundleImage:sender.reSelectImage] forState:UIControlStateSelected | UIControlStateHighlighted];
              if (sender.reSelectTitle) {
                  [sender setTitle:sender.reSelectTitle forState:UIControlStateSelected];
                  [sender setTitle:sender.reSelectTitle forState:UIControlStateSelected | UIControlStateHighlighted];
              }
          }
          sender.click = !sender.click;
          if (sender.click) {
              sender.selectType = 1;
          }else{
              sender.selectType = 2;
          }
          [self changeTitleArr:YES update:YES];
       }
       else if(currentDrop.editStyle == MenuEditCheck||
               currentDrop.editStyle == MenuEditNone){
           if (!self.close) {
               [self closeView];
           }
           [self.selectTitleBtn setTitleColor:self.selectTitleBtn.selectColor forState:UIControlStateSelected];
           if (currentDrop.editStyle == MenuEditCheck) {
               sender.selected = ![sender isSelected];
           }else{
               sender.selected = YES;
           }
           [self changeTitleArr:YES update:YES];
       }
       else{
          sender.selected = ![sender isSelected];
          if ([sender isSelected]) {
              if (!self.close&&
                  self.lastSelectIndex >= 0) {
                  WMZDropMenuBtn *lastBtn = self.titleBtnArr[self.lastSelectIndex];
                  [self dataChangeActionSection:[self getTitleFirstDropWthTitleBtn:lastBtn].section WithKey:nil];
              }
               self.selectArr = [NSMutableArray new];
              [self openView];
          }else{
              [self closeView];
          }
      }
      if ([self.selectTitleBtn isSelected] &&
           self.param.wMenuLine) {
           [self.selectTitleBtn showLine:@{}];
           if (self.param.wJDCustomLine)
               self.param.wJDCustomLine(self.selectTitleBtn.line);
      }else{
           [self.selectTitleBtn hidenLine];
      }
}

#pragma -mark 关闭方法
- (void)closeView{
    if (self.keyBoardShow) [MenuWindow endEditing:YES];
   ///移除嵌套层
   BOOL exist = NO;
   for (UIView *view in [MenuWindow subviews]) {
        //如果window层不存在 返回
        if ((view.tag == 10086 && view == self.shadowView) || (view.tag == 10087&&view == self.dataView)) {
            exist = YES;
            break;
        }
    }
    if (!exist) return;
    if (!self.selectArr.count) {
        ///查看更多取消选中 单独处理
        if (checkMore) {
            WMZDropIndexPath *checkModelDrop = nil;
            for (WMZDropIndexPath *path in self.dropPathArr) {
                if([path.key isEqualToString:MoreTableViewKey]){
                    checkModelDrop = path;
                    break;
                }
            }
            if(checkModelDrop){
                NSArray *arr = [self getArrWithPath:checkModelDrop withoutHide:NO];
                [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[WMZDropTree class]]) {
                        obj.isSelected = NO;
                        obj.rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
                        obj.normalRangeArr = [NSArray new];
                        if ([self.selectArr indexOfObject:obj] != NSNotFound) {
                            [self.selectArr removeObject:obj];
                        }
                      }
                }];
            }
        }else{
            //没有选中的项 取消预选
            [self dealDataWithDelete:MenuDataDelete btn:self.selectTitleBtn];
        }
         [self changeNormalConfig:@{} withBtn:self.selectTitleBtn];
         [self.selectTitleBtn hidenLine];
         for (WMZDropMenuBtn *btn in self.titleBtnArr) {
             if (btn!=self.selectTitleBtn) {
                if ([btn isSelected]&&self.param.wMenuLine) {
                    [btn showLine:@{}];
                    if (self.param.wJDCustomLine) {
                        self.param.wJDCustomLine(btn.line);
                    }
                }
            }
         }
    }else{
        if (checkMore) {
            [self dataChangeActionSection:0 WithKey:MoreTableViewKey];
        }else{
           [self dataChangeActionSection:[self getTitleFirstDropWthTitleBtn:self.selectTitleBtn].section WithKey:nil];
        }
        [self changeTitleArr:YES update:YES];
        if (self.param.wMenuLine) {
            [self.selectTitleBtn showLine:@{}];
             if (self.param.wJDCustomLine) {
                 self.param.wJDCustomLine(self.selectTitleBtn.line);
             }
         }
    }
    [self closeAction];
    self.selectTitleBtn.selected = NO;
}

#pragma -mark 关闭方法
- (void)closeAction{
    @MenuWeakSelf(self)
    WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
    MenuHideAnimalStyle hideAnimal = currentDrop.hideAnimalStyle;
    if (self.hook) hideAnimal = MenuHideAnimalNone;
    if ([MenuWindow viewWithTag:10088]!=nil) {
        //动画
        [self hideAnimal:hideAnimal view:self.moreView durtion:self.param.wMenuDurtion block:^{
            @MenuStrongSelf(self)
            [self.moreView removeFromSuperview];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:closeWithBtn:index:)]) {
                [self.delegate menu:self closeWithBtn:self.selectTitleBtn index:[self.titleBtnArr indexOfObject:self.selectTitleBtn]];
            }
        }];
        return;
    }
    [self hideAnimal:hideAnimal view:self.dataView durtion:self.param.wMenuDurtion block:^{
        @MenuStrongSelf(self)
        [self.dataView removeFromSuperview];
    }];
    [self.shadowView removeFromSuperview];
    self.close = YES;
    ///获取全部选中
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:getAllSelectData:)]) {
        NSMutableArray *allSelectArr = [NSMutableArray new];
        for (WMZDropIndexPath *drop in self.dropPathArr) {
            NSArray *arr = [self getArrWithPath:drop withoutHide:NO];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WMZDropTree class]]) {
                    if (obj.isSelected) {
                        [allSelectArr addObject:obj];
                    }
                  }
            }];
        }
        [self.delegate menu:self getAllSelectData:[NSArray arrayWithArray:allSelectArr]];
    }
}

///数据逻辑处理
- (void)dataChangeActionSection:(NSInteger)section WithKey:(nullable NSString*)key{
    //判断
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        WMZDropIndexPath *selectDrop = nil;
        if (key!=nil) {
            if ([drop.key isEqualToString:key]) selectDrop = drop;
        }else{
            if (drop.section == section) selectDrop = drop;
        }
        if (selectDrop) {
            NSArray *arr = [self getArrWithPath:selectDrop withoutHide:YES];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WMZDropTree class]]) {
                    if (obj.isSelected) {
                        if ([self.selectArr indexOfObject:obj] == NSNotFound) {
                             obj.isSelected = NO;
                             obj.rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
                             obj.normalRangeArr = [NSArray new];
                        }
                    }else{
                        if ([self.selectArr indexOfObject:obj]!=NSNotFound&&
                            drop.UIStyle!=MenuUITableView) {
                             obj.isSelected = YES;
                        }
                    }
                  }
            }];
        }
    }
}

/// 开启筛选
- (void)openView{
    @MenuWeakSelf(self)
    ///嵌套层
    for (UIView *view in [MenuWindow subviews]) {
        ///如果window层存在 移除上个 嵌套使用的时候
        if ((view.tag == 10086 && view != self.shadowView)||
            (view.tag == 10087&& view != self.dataView)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationRemove object:nil userInfo:nil];
            break;
        }
    }
    self.close = NO;
    WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
    ///获取弹出的位置
    [self getPopY];
    ///阴影层frame改变
    self.shadowView.frame = [[self.shadomViewFrameDic objectForKey:@(currentDrop.showAnimalStyle)] CGRectValue];
    ///数据层视图frame改变
    self.dataView.frame = [[self.dataViewFrameDic objectForKey:@(currentDrop.showAnimalStyle)] CGRectValue];
    if (self.param.wCustomDataViewRect) {
        CGRect rect =  self.param.wCustomDataViewRect(self.dataView.frame);
        self.dataView.frame = rect;
    }
    if (self.param.wCustomShadomViewRect) {
        CGRect rect =  self.param.wCustomShadomViewRect(self.shadowView.frame);
        self.shadowView.frame = rect;
    }
    [MenuWindow addSubview:self.shadowView];
    [MenuWindow addSubview:self.dataView];
    [self addShowUI];
    if (self.dataView.frame.size.height <= 0.1) {
        CGRect rect = self.shadowView.frame;
        rect.size.height = 0;
        self.shadowView.frame = rect;
    }
    [self dealDataWithDelete:MenuDataDefault btn:self.selectTitleBtn];
    ///动画
    [self showAnimal:currentDrop.showAnimalStyle view:self.dataView durtion:self.param.wMenuDurtion block:^{
        @MenuStrongSelf(self)
        if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:openWithBtn:index:)]) {
            [self.delegate menu:self openWithBtn:self.selectTitleBtn index:[self.titleBtnArr indexOfObject:self.selectTitleBtn]];
        }
    }];
}

/// 弹出的位置
- (void)getPopY{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inScrollView)]) {
        UIScrollView *sc = [self.delegate inScrollView];
        if ([sc isMemberOfClass:[UITableView class]]) {
            if (sc) {
                [sc layoutIfNeeded];
                [sc layoutSubviews];
            }
            CGRect rectInTableView = [(UITableView*)sc rectForHeaderInSection:self.tableViewHeadSection];
            CGRect rect = [(UITableView*)sc convertRect:rectInTableView toView:[(UITableView*)sc superview]];
            if (rect.origin.y<0) {
                rect.origin.y = sc.frame.origin.y;
            }
            rect.origin.y+= (sc.superview.frame.origin.y);
            self.menuOrignY = CGRectGetMaxY(rect);
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(popFrameY)]) {
        self.menuOrignY = [self.delegate popFrameY];
    }
}

/// 改变titleBtnArr中数据的状态
- (void)changeTitleArr:(BOOL)clear update:(BOOL)update{
    [self.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag!=self.selectTitleBtn.tag) {
            if ([self getTitleFirstDropWthTitleBtn:obj].connect ||
                ([self.mutuallyExclusiveArr indexOfObject:obj]!=NSNotFound&&
                 [self.mutuallyExclusiveArr indexOfObject:self.selectTitleBtn]!=NSNotFound) ||
                self.selectTitleBtn.clear) {
                obj.selected = NO;
                obj.click = NO;
                obj.selectType = 0;
                if (update) {
                    [self dealDataWithDelete:MenuDataDelete btn:obj];
                }
                if (clear) {
                    [obj setTitleColor:obj.normalColor forState:UIControlStateNormal];
                    [obj setTitleColor:obj.normalColor forState:UIControlStateSelected];
                    [obj setTitle:obj.normalTitle forState:UIControlStateNormal];
                }
            }
            [obj hidenLine];
        }
    }];
}

/// 处理选中的数据 删除或者加入
- (void)dealDataWithDelete:(MenuDataStyle)style btn:(WMZDropMenuBtn*)btn{
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        if (drop.section == btn.tag - 1000 && ![drop.key isEqualToString:MoreTableViewKey]) {
            NSArray *arr = [self getArrWithPath:drop withoutHide:NO];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WMZDropTree class]]) {
                    if (obj.isSelected) {
                        if (style == MenuDataDelete) { //没有选中的项 取消预选项
                             obj.isSelected = NO;
                             obj.rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
                             obj.normalRangeArr = [NSArray new];
                            if ([self.selectArr indexOfObject:obj]!=NSNotFound) {
                                [self.selectArr removeObject:obj];
                            }
                        }else if (style == MenuDataInsert) { //添加
                            if ([self.selectArr indexOfObject:obj]==NSNotFound) {
                                 [self.selectArr addObject:obj];
                             }
                         }else if (style == MenuDataDefault) { //默认添加
                            if ([self.selectArr indexOfObject:obj]==NSNotFound) {
                                 [self.selectArr addObject:obj];
                             }
                         }
                    }
                  }
            }];
        }
    }
}

/// 点击选中方法
- (void)cellTap:(WMZDropIndexPath*)dropPath data:(NSArray*)arr indexPath:(NSIndexPath*)indexPath{
    WMZDropTree *tree = arr[indexPath.row];
    if (dropPath.UIStyle == MenuUICollectionRangeTextField) return;
    BOOL close = NO;
    if ([dropPath.key isEqualToString:MoreTableViewKey]){
        if (dropPath.editStyle == MenuEditOneCheck) {
            for (WMZDropTree *tmpTree in arr) {
                if (tmpTree != tree) {
                    tmpTree.isSelected = NO;
                }else{
                    tmpTree.isSelected = YES;
                }
            }
        }else if (dropPath.editStyle == MenuEditMoreCheck) {
            tree.isSelected = !tree.isSelected;
        }
    }else{
        //编辑事件
           if (dropPath.editStyle == MenuEditOneCheck) {
               if ([self getTitleFirstDropWthTitleBtn:self.selectTitleBtn].UIStyle == MenuUICollectionView) {
                   tree.isSelected = !tree.isSelected;
               }else{
                   tree.isSelected = YES;
               }

               for (WMZDropTree *tmpTree in arr) {
                   if (tmpTree != tree) {
                       tmpTree.isSelected = NO;
                   }
               }
               
               if (dropPath.tapClose && tree.isSelected && tree.tapClose) {
                   for (WMZDropIndexPath *drop in self.dropPathArr) {
                       if (drop.section == dropPath.section) {
                           NSArray *arr = [self getArrWithPath:drop withoutHide:NO];
                           [arr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               if (obj.isSelected) {
                                   if ([self.selectArr indexOfObject:obj]==NSNotFound)
                                       [self.selectArr addObject:obj];
                               }else{
                                   if ([self.selectArr indexOfObject:obj] != NSNotFound)
                                       [self.selectArr removeObject:obj];
                               }
                           }];
                       }
                   }
                   close = YES;
                   [self changeTitleConfig:@{WMZMenuTitleNormal:tree.name,@"dropPath":dropPath,@"row":@(indexPath.row)} withBtn:self.selectTitleBtn];
               }
           }else if (dropPath.editStyle == MenuEditMoreCheck){
               tree.isSelected = !tree.isSelected;
           }
    }
    if (tree.checkMore) {
        tree.isSelected = NO;
        [self setUpMoreView:dropPath];
    }
    
    //点击代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectRowAtDropIndexPath:dataIndexPath:data:)]) {
        [self.delegate menu:self didSelectRowAtDropIndexPath:dropPath dataIndexPath:indexPath data:tree];
    }
    
    [self updateSubView:dropPath more:YES];
    
    if (close) {
       [self closeView];
    }
}

- (void)closeWith:(WMZDropIndexPath*)dropPath row:(NSInteger)row data:(WMZDropTree*)tree{
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        if (drop.section == dropPath.section) {
            NSArray *arr = [self getArrWithPath:drop withoutHide:NO];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected) {
                if ([self.selectArr indexOfObject:obj]==NSNotFound) {
                    [self.selectArr addObject:obj];
                }
            }
            }];
        }
    }
    [self changeTitleConfig:@{WMZMenuTitleNormal:tree.name,@"dropPath":dropPath,@"row":@(row)} withBtn:self.selectTitleBtn];
    [self closeView];
}

#pragma -mark 展开方法
- (void)expandAction:(UIButton*)btn{
    WMZDropCollectionViewHeadView *head = (WMZDropCollectionViewHeadView*)btn.superview;
    btn.selected = ![btn isSelected];
    head.dropIndexPath.expand = !head.dropIndexPath.expand;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:head.dropIndexPath.row]];
}

#pragma -mark 确定方法
- (void)confirmAction:(nullable UIButton*)sender{
    checkMore = (sender.tag == 10089);
    self.selectArr = [NSMutableArray new];
    [self dealDataWithDelete:MenuDataInsert btn:self.selectTitleBtn];
    for (WMZDropTree *tree in self.selectArr) {
        if ([tree.rangeArr[0] length]&&[tree.rangeArr[1] length]) {
            if (self.param.wCollectionCellTextFieldKeyType == UIKeyboardTypeDecimalPad &&
                [tree.rangeArr[1] floatValue] < [tree.rangeArr[0] floatValue] ) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@不能大于%@",tree.lowPlaceholder,tree.highPlaceholder] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [[WMZDropMenuTool getCurrentVC] presentViewController:alert animated:YES completion:nil];
                return;
            }
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:didConfirmAtSection:selectNoramelData:selectStringData:)]) {
        NSMutableArray *nameArr = [NSMutableArray new];
        for (WMZDropTree *tree in self.selectArr) {
            if (!tree.name) {
                if (tree.rangeArr) {
                    [nameArr addObject:tree.rangeArr];
                }
            }else{
                [nameArr addObject:tree.name];
            }
        }
        [self.delegate menu:self didConfirmAtSection:self.selectTitleBtn.tag - 1000 selectNoramelData:self.selectArr selectStringData:nameArr];
    }
    if(self.selectArr.count){
        WMZDropIndexPath *firstPath = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
        if (firstPath.showAnimalStyle == MenuShowAnimalLeft||
            firstPath.showAnimalStyle == MenuShowAnimalRight) {
            [self changeTitleConfig:@{WMZMenuTitleNormal:self.selectTitleBtn.titleLabel.text,@"dropPath":firstPath} withBtn:self.selectTitleBtn];
        }else{
            WMZDropTree *tree = self.selectArr[0];
            [self changeTitleConfig:@{
           WMZMenuTitleNormal:self.selectArr.count>1?
           @"多选":(tree.name?:self.selectTitleBtn.titleLabel.text),
           @"dropPath":firstPath
            }
            withBtn:self.selectTitleBtn];
        }
    }else{
        [self changeNormalConfig:@{} withBtn:self.selectTitleBtn];
    }
    self.selectTitleBtn.selected = NO;
    [self closeView];
}

#pragma -mark 重置方法
- (void)reSetAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:didReSetAtSection:)]) {
        [self.delegate menu:self didReSetAtSection:[self.titleBtnArr indexOfObject:self.selectTitleBtn]];
    }
    [self dealDataWithDelete:MenuDataDelete btn:self.selectTitleBtn];
    [self updateSubView:[self getTitleFirstDropWthTitleBtn:self.selectTitleBtn] more:YES];
}

- (void)defaultSelectIndex:(NSInteger)index{
    for (int i = 0; i<self.titleBtnArr.count; i++) {
        if (i == index) {
            WMZDropMenuBtn *btn = self.titleBtnArr[i];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

/// 重置所有数据 恢复原来
- (void)resetAll{
    [self.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.click = NO;
        obj.selectType = 0;
        [obj setTitleColor:obj.normalColor forState:UIControlStateNormal];
        [obj setTitleColor:obj.normalColor forState:UIControlStateSelected];
        [obj setTitle:obj.normalTitle forState:UIControlStateNormal];
        [obj hidenLine];
    }];
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        NSArray *arr = [self getArrWithPath:drop withoutHide:YES];
        [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelected = NO;
            obj.rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
            obj.normalRangeArr = [NSArray new];
            if ([self.selectArr indexOfObject:obj] != NSNotFound) [self.selectArr removeObject:obj];
        }];
    }
    for (UIView *view in self.showView) {
        if ([view isKindOfClass:[WMZDropTableView class]]) {
            WMZDropTableView *ta = (WMZDropTableView*)view;
            [UIView performWithoutAnimation:^{
                [ta reloadData];
            }];
        }else if ([view isKindOfClass:[WMZDropCollectionView class]]){
            WMZDropCollectionView *collectionView = (WMZDropCollectionView*)view;
            [UIView performWithoutAnimation:^{
               [collectionView reloadData];
            }];
        }
    }
}

#pragma -mark tablViewDeleagte
- (NSInteger)tableView:(WMZDropTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *data = [self getArrWithPath:tableView.dropIndex withoutHide:YES];
    if (tableView.dropIndex.row>0) {
        WMZDropIndexPath *lastDrop = nil;
        for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
            if (tmpDrop.section == tableView.dropIndex.section &&
                tmpDrop.row == tableView.dropIndex.row-1) {
                lastDrop = tmpDrop;
                break;
            }
        }
        BOOL hadSelected = NO;
        if (lastDrop) {
            NSArray *lastData = [self getArrWithPath:lastDrop withoutHide:YES];
            for (WMZDropTree *tree in lastData) {
                if (tree.isSelected) {
                    hadSelected = YES;
                    break;
                }
            }
        }
        if (hadSelected) {
            return data.count;
        }else{
            return 0;
        }
    }
    return data.count;
}

- (UITableViewCell *)tableView:(WMZDropTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data = [self getArrWithPath:tableView.dropIndex withoutHide:YES];
    WMZDropTree *tree = data[indexPath.row];
    tree.indexPath = indexPath;
    tree.dropPath = tableView.dropIndex;
    //自定义
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:cellForUITableView:AtIndexPath:dataForIndexPath:)]) {
        UITableViewCell *cell = [self.delegate menu:self cellForUITableView:tableView AtIndexPath:indexPath dataForIndexPath:tree];
        if (cell&&
            [cell isKindOfClass:[UITableViewCell class]]) {
            return cell;
        }
    }
    WMZDropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WMZDropTableViewCell class])];
    if (!cell) {
        cell = [[WMZDropTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WMZDropTableViewCell class])];
    }
    if ([tree isKindOfClass:[WMZDropTree class]]) {
        UIImageView *image = [[UIImageView alloc]initWithImage:self.param.wCellCheckImage];
        image.tintColor = self.param.wCollectionViewCellSelectTitleColor;
        image.frame = CGRectMake(0, 0, 20, 20);
        image.hidden = !tree.isSelected;
        cell.accessoryView = self.param.wCellSelectShowCheck?image:nil;
        cell.textLabel.text = tree.name;
        cell.textLabel.textAlignment = self.param.wTextAlignment;
        cell.textLabel.textColor = tree.isSelected? self.param.wCollectionViewCellSelectTitleColor:self.param.wCollectionViewCellTitleColor;
        cell.textLabel.font = self.param.wCellTitleFont;
        cell.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImage *icon = nil;
        cell.imageView.hidden = !tree.image;
        if (tree.image) {
            icon = [UIImage bundleImage:tree.image];
            cell.imageView.image = icon;
            CGSize itemSize = CGSizeMake(tree.cellHeight*0.7, tree.cellHeight*0.7);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
            CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(WMZDropTableView *)tableView heightForFooterInSection:(NSInteger)section{
    return tableView.dropIndex.footViewHeight == 0 ? 0.01 : tableView.dropIndex.footViewHeight;
}

- (CGFloat)tableView:(WMZDropTableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView.dropIndex.headViewHeight == 0 ? 0.01 : tableView.dropIndex.headViewHeight;
}

- (UIView*)tableView:(WMZDropTableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:footViewForUITableView:AtDropIndexPath:)]) {
        UITableViewHeaderFooterView *footView = [self.delegate menu:self footViewForUITableView:tableView AtDropIndexPath:tableView.dropIndex];
        if (footView&&[footView isKindOfClass:[UITableViewHeaderFooterView class]])
            return footView;
    }
    WMZDropTableViewFootView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WMZDropTableViewFootView class])];
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForFootViewAtDropIndexPath:)]) {
        NSString *title = [self.delegate menu:self titleForFootViewAtDropIndexPath:tableView.dropIndex];
        footView.textLa.text = title;
    }
    return footView;
}

- (UIView*)tableView:(WMZDropTableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:headViewForUITableView:AtDropIndexPath:)]) {
           UITableViewHeaderFooterView *headView = [self.delegate menu:self headViewForUITableView:tableView AtDropIndexPath:tableView.dropIndex];
        if (headView &&
            [headView isKindOfClass:[UITableViewHeaderFooterView class]])
            return headView;
    }
    WMZDropTableViewHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WMZDropTableViewHeadView class])];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForHeadViewAtDropIndexPath:)]) {
        NSString *title = [self.delegate menu:self titleForHeadViewAtDropIndexPath:tableView.dropIndex];
        headView.textLa.text = title;
    }
    return headView;
}

- (CGFloat)tableView:(WMZDropTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data = [self getArrWithPath:tableView.dropIndex withoutHide:YES];
    WMZDropTree *tree = data[indexPath.row];
    return tree.cellHeight;
}

- (void)tableView:(WMZDropTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.keyBoardShow)
       [MenuWindow endEditing:YES];
    
    NSArray *data = [self getArrWithPath:tableView.dropIndex withoutHide:YES];
    //点击处理
    [self cellTap:tableView.dropIndex data:data indexPath:indexPath];
}

#pragma -mark collectionDelagete
- (UICollectionViewCell *)collectionView:(WMZDropCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMZDropIndexPath *path = collectionView.dropArray[indexPath.section];
    NSArray *arr = [self getArrWithPath:path withoutHide:YES];
    WMZDropTree *tree = arr[indexPath.row];
    tree.indexPath = indexPath;
    tree.dropPath = path;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:cellForUICollectionView:AtDropIndexPath:AtIndexPath:dataForIndexPath:)]) {
        UICollectionViewCell *cell = [self.delegate menu:self cellForUICollectionView:collectionView AtDropIndexPath:path AtIndexPath:indexPath dataForIndexPath:tree];
        if (cell&&[cell isKindOfClass:[UICollectionViewCell class]]) {
            return cell;
        }
    }
    if (path.UIStyle == MenuUICollectionRangeTextField){
         //默认视图
        WMZMenuTextFieldCell *cell = (WMZMenuTextFieldCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WMZMenuTextFieldCell class]) forIndexPath:indexPath];
        if ([tree isKindOfClass:[WMZDropTree class]]) {
            cell.tree = tree;
            cell.tree.canEdit = tree.config[@"canEdit"]?[tree.config[@"canEdit"] boolValue]:YES;
            UIColor *lowBg = tree.config[@"lowBgColor"]?:self.param.wCollectionViewCellBgColor;
            UIColor *highBg = tree.config[@"highBgColor"]?:self.param.wCollectionViewCellBgColor;
            UIColor *textColor = tree.config[@"textColor"]?:MenuColor(0x333333);
            UIColor *textSelectColor = tree.config[@"textSelectColor"]?:MenuColor(0x333333);
            tree.lowPlaceholder = tree.config[@"lowPlaceholder"]?:tree.lowPlaceholder;
            tree.highPlaceholder = tree.config[@"highPlaceholder"]?:tree.highPlaceholder;
            tree.lowPlaceholder =
            cell.lowText.placeholder =  tree.lowPlaceholder;
            cell.highText.placeholder = tree.highPlaceholder;
            cell.highText.textAlignment = self.param.wCollectionCellTextFieldAlignment;
            cell.lowText.textAlignment = self.param.wCollectionCellTextFieldAlignment;
            cell.lowText.keyboardType = self.param.wCollectionCellTextFieldKeyType;
            cell.highText.keyboardType = self.param.wCollectionCellTextFieldKeyType;
            NSString *lowStr = tree.rangeArr.count>1?[NSString stringWithFormat:@"%@",tree.rangeArr[0]]:@"";
            NSString *maxStr = tree.rangeArr.count>1?[NSString stringWithFormat:@"%@",tree.rangeArr[1]]:@"";
            if (!tree.normalRangeArr||!tree.normalRangeArr.count) {
                if ([lowStr length]&&[maxStr length]) {
                    tree.normalRangeArr = @[lowStr,maxStr];
                }
            }
            @MenuWeakSelf(cell)
            cell.myBlock = ^(UITextField * _Nonnull textField, NSString * _Nonnull string) {
                @MenuStrongSelf(cell)
                if (textField == cell.lowText) {
                    cell.lowT = string;
                    if (cell.lowT) {
                        tree.rangeArr[0] = cell.lowT;
                    }
                }else{
                    cell.highT = string;
                    if (cell.highT) {
                        tree.rangeArr[1] = cell.highT;
                    }
                }
                tree.isSelected = YES;
            };
            __weak WMZDropDownMenu *weak = self;
            cell.clickBlock = ^(UITextField * _Nonnull textField, NSString * _Nonnull string) {
                 __strong WMZDropDownMenu *strong = weak;
                [strong tapAction:textField dropPath:path indexPath:indexPath data:tree];
            };
            tree.isSelected = ([lowStr length]>0||[maxStr length]>0);
            cell.lowText.textColor = tree.isSelected?textSelectColor:textColor;
            cell.highText.textColor = tree.isSelected?textSelectColor:textColor;;
            cell.lowText.backgroundColor = lowBg;
            cell.highText.backgroundColor = highBg;
            cell.lowText.font = tree.font?:self.param.wCellTitleFont;
            cell.highText.font = tree.font?:self.param.wCellTitleFont;
            cell.lowText.text  = lowStr;
            cell.highText.text = maxStr;
        }
        [cell layoutSubviews];
        MenuInputStyle style = MenuInputStyleMore;
        if (tree.inputStyle ) {
            style = tree.inputStyle;
        }else{
            style = self.param.wCollectionCellTextFieldStyle;
        }
        if (style == MenuInputStyleMore) {
            cell.lowText.frame = CGRectMake(0, 0, cell.frame.size.width*0.45, cell.frame.size.height);
            cell.lineLa.frame = CGRectMake(0, 0, cell.frame.size.width*0.1, cell.frame.size.height);
            cell.lineLa.center = cell.contentView.center;
            cell.highText.frame = CGRectMake(cell.frame.size.width*0.55, 0, cell.frame.size.width*0.45, cell.frame.size.height);
            cell.highText.layer.cornerRadius = 8;
            cell.lowText.layer.cornerRadius = 8;
        }else{
            cell.lowText.frame = CGRectMake(0, 0, cell.frame.size.width , cell.frame.size.height);
            cell.highText.frame = cell.lineLa.frame = CGRectZero;
            cell.lowText.layer.cornerRadius = 8;
        }
        return cell;
    }else{
         //默认视图
         WMZMenuCell *cell = (WMZMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WMZMenuCell class]) forIndexPath:indexPath];
         if ([tree isKindOfClass:[WMZDropTree class]]) {
             cell.btn.layer.backgroundColor = tree.checkMore?[UIColor whiteColor].CGColor:
             (tree.isSelected? self.param.wCollectionViewCellSelectBgColor.CGColor:
              self.param.wCollectionViewCellBgColor.CGColor);
             [cell.btn setTitleColor:tree.checkMore?self.param.wCollectionViewCellSelectTitleColor:(
              tree.isSelected? self.param.wCollectionViewCellSelectTitleColor:self.param.wCollectionViewCellTitleColor) forState:UIControlStateNormal];
             cell.btn.titleLabel.font = tree.isSelected?
             tree.font?:self.param.wCellTitleFont:
             tree.selectFont?:self.param.wCellSelectTitleFont;
             [cell.btn setTitle:tree.name forState:UIControlStateNormal];
             [cell.btn setImage:tree.image?[UIImage bundleImage:tree.image]:nil forState:UIControlStateNormal];
             cell.btn.layer.borderColor = tree.checkMore?[UIColor whiteColor].CGColor:(tree.isSelected? self.param.wCollectionViewCellSelectTitleColor.CGColor:self.param.wCollectionViewCellTitleColor.CGColor);
             cell.btn.layer.borderWidth = tree.checkMore?0:(tree.isSelected?self.param.wCollectionViewCellBorderWith:0);
             cell.btn.layer.cornerRadius = 8;
             
         }
         return cell;
    }
}

- (NSInteger)collectionView:(WMZDropCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   WMZDropIndexPath *path = collectionView.dropArray[section];
    NSInteger count = [[self getArrWithPath:path withoutHide:YES] count];
    if (!path.expand) {
        if (count>=self.param.wCollectionViewSectionRecycleCount) {
            count = self.param.wCollectionViewSectionRecycleCount;
        }
    }
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(WMZDropCollectionView *)collectionView{
    return self.collectionView.dropArray.count;
}

- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMZDropIndexPath *path = collectionView.dropArray[indexPath.section];
    if (path.collectionUIStyle == MenuCollectionUINormal) {
       return CGSizeMake((floor((collectionView.frame.size.width - self.param.wCollectionViewCellSpace*(path.collectionCellRowCount+1))/(CGFloat)path.collectionCellRowCount)) , path.cellHeight);
    }else{
        if (path.UIStyle == MenuUICollectionRangeTextField) {
            return CGSizeMake((floor((collectionView.frame.size.width - self.param.wCollectionViewCellSpace*(path.collectionCellRowCount+1))/(CGFloat)path.collectionCellRowCount)) , path.cellHeight);
        }else{
            NSArray *arr = [self getArrWithPath:path withoutHide:YES];
            WMZDropTree *tree = arr[indexPath.row];
            UIFont *font = tree.isSelected?
            tree.font?:self.param.wCellTitleFont:
            tree.selectFont?:self.param.wCellSelectTitleFont;
            if (!tree.cellWidth) {
                tree.cellWidth = [WMZDropMenuTool boundingRectWithSize:tree.name Font:font Size:CGSizeMake(MAXFLOAT,MAXFLOAT)].width + 30;
            }
            return CGSizeMake(tree.cellWidth , path.cellHeight);
        }
    }
}

- (UICollectionReusableView *)collectionView:(WMZDropCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:headViewForUICollectionView:AtDropIndexPath:AtIndexPath:)]) {
            UICollectionReusableView *headView = [self.delegate menu:self headViewForUICollectionView:collectionView AtDropIndexPath:collectionView.dropArray[indexPath.section] AtIndexPath:indexPath];
            if (headView&&[headView isKindOfClass:[UICollectionReusableView class]]) {
                return headView;
            }
        }
        WMZDropIndexPath *path = collectionView.dropArray[indexPath.section];
        WMZDropCollectionViewHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewHeadView class]) forIndexPath:indexPath];
        headerView.accessTypeBtn.hidden = !path.showExpand;
        headerView.accessTypeBtn.selected = !path.expand;
        [headerView.accessTypeBtn setImage:[UIImage bundleImage:@"menu_xiangshang"] forState:UIControlStateNormal];
        [headerView.accessTypeBtn setImage:[UIImage bundleImage:@"menu_xiangxia"] forState:UIControlStateSelected];
        headerView.dropIndexPath = path;
        [headerView.accessTypeBtn addTarget:self action:NSSelectorFromString(@"expandAction:") forControlEvents:UIControlEventTouchUpInside];
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForHeadViewAtDropIndexPath:)]) {
            NSString *title = [self.delegate menu:self titleForHeadViewAtDropIndexPath:collectionView.dropArray[indexPath.section]];
            headerView.textLa.text = title;
        }
        return headerView;
    }else if(kind == UICollectionElementKindSectionFooter){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:footViewForUICollectionView:AtDropIndexPath:AtIndexPath:)]) {
            UICollectionReusableView *footView = [self.delegate menu:self footViewForUICollectionView:collectionView AtDropIndexPath:collectionView.dropArray[indexPath.section] AtIndexPath:indexPath];
            if (footView&&[footView isKindOfClass:[UICollectionReusableView class]]) {
                return footView;
            }
        }
        WMZDropCollectionViewFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewFootView class]) forIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForFootViewAtDropIndexPath:)]) {
               NSString *title = [self.delegate menu:self titleForFootViewAtDropIndexPath:collectionView.dropArray[indexPath.section]];
               footerView.textLa.text = title;
        }
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    WMZDropIndexPath *path = collectionView.dropArray[section];
    return CGSizeMake(self.dataView.frame.size.width,path.headViewHeight);
}

- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    WMZDropIndexPath *path = collectionView.dropArray[section];
    return CGSizeMake(self.dataView.frame.size.width, path.footViewHeight);
}

- (void)collectionView:(WMZDropCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.keyBoardShow)
        [MenuWindow endEditing:YES];
    //点击处理
    WMZDropIndexPath *path = collectionView.dropArray[indexPath.section];
    NSArray *arr = [self getArrWithPath:path withoutHide:YES];
    [self cellTap:path data:arr indexPath:indexPath];
}

- (void)tapAction:(UITextField*)sender dropPath:(WMZDropIndexPath*)dropPath indexPath:(NSIndexPath*)indexPath data:(WMZDropTree*)tree{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectRowAtDropIndexPath:dataIndexPath:data:)]) {
        tree.index = sender.tag;
        [self.delegate menu:self didSelectRowAtDropIndexPath:dropPath dataIndexPath:indexPath data:tree];
    }
}

- (BOOL)updateData:(NSArray*)arr ForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{return YES;}
- (BOOL)updateData:(NSArray*)arr AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row{return YES;}
- (BOOL)updateDataConfig:(NSDictionary*)changeData AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row AtIndexPathRow:(NSInteger)indexPathRow{return YES;}
- (NSArray*)getAllSelectArr{return @[];}
- (NSArray*)getSelectArrWithPathSection:(NSInteger)section{return @[];}
- (NSArray*)getSelectArrWithPathSection:(NSInteger)section row:(NSInteger)row{return @[];}
- (NSArray<WMZDropTableView*>*)tableViewCurrentInRow:(NSInteger)currentRow tableViewchangeInRow:(NSInteger)changeRow scrollTowPath:(NSIndexPath*)indexPath{return @[];}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.hook = YES;
    [self closeView];
}
@end
