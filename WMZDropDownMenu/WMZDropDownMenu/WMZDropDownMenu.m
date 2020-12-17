//
//  WMZDropDownMenu.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZDropDownMenu.h"
#import "WMZDropDownMenu+MoreView.h"
#import "WMZDropDownMenu+DealLogic.h"
#import "WMZDropDownMenu+DealDelegate.h"
#import "WMZDropDownMenu+NormalView.h"
#import "WMZDropDownMenu+FootHeaderView.h"
static NSString* const notificationRemove = @"notificationRemove";
@interface WMZDropDownMenu(){
    BOOL checkMore;
}
@end
@implementation WMZDropDownMenu
#pragma -mark 重置UI
- (void)resetConfig{
    if (self.titleView) {
        for (UIView *view in self.titleView.subviews) {
            [view removeFromSuperview];
        }
        [self.titleView removeFromSuperview];
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (self.titleBtnArr) {
        [self.titleBtnArr removeAllObjects];
    }
    [self.shadowView removeFromSuperview];
    [self.dataView removeFromSuperview];
    
    [self menuTitle];
}

- (void)menuTitle{
    self.backgroundColor = menuMainClor;
       //移除
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:notificationRemove object:nil];
   if([[WMZDropMenuTool getCurrentVC] respondsToSelector:@selector(viewWillDisappear:)]){
       //hook监听当前控制器消失
       MenuWeakSelf(self)
       [[WMZDropMenuTool getCurrentVC] aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> aspectInfo)
       {
         MenuStrongSelf(weakObject);
         strongObject.hook = YES;
         [strongObject closeView];
       } error:NULL];
   }
   self.userInteractionEnabled = YES;
   [self addSubview:self.titleView];
   
   NSArray *indexArr = @[];
   //相互排斥的标题
   if (self.delegate && [self.delegate respondsToSelector:@selector(mutuallyExclusiveSectionsWithMenu:)]) {
       indexArr =  [self.delegate mutuallyExclusiveSectionsWithMenu:self];
   }
   
   UIButton *tmp = nil;
   for (int i = 0; i<self.titleArr.count; i++) {
       id dic = self.titleArr[i];
       BOOL dictionary = [dic isKindOfClass:[NSDictionary class]];
       WMZDropMenuBtn *btn = [WMZDropMenuBtn buttonWithType:UIButtonTypeCustom];
       [btn setUpParam:self.param withDic:dic];
       btn.frame = CGRectMake(tmp?CGRectGetMaxX(tmp.frame):0, 0, self.titleView.frame.size.width/(self.param.wMenuTitleEqualCount<self.titleArr.count?self.titleArr.count:self.param.wMenuTitleEqualCount), self.titleView.frame.size.height);
       //外部自定义标题按钮
       NSDictionary *config = nil;
       if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:customTitleInSection:withTitleBtn:)]) {
           config =  [self.delegate menu:self customTitleInSection:i withTitleBtn:btn];
       }
       CGFloat offset = config[@"offset"]?[config[@"offset"] floatValue]:0;
       CGFloat y = config[@"y"]?[config[@"y"] floatValue]:0;
       btn.frame = CGRectMake(tmp?(CGRectGetMaxX(tmp.frame)+offset):offset, y, btn.frame.size.width-offset-offset/self.titleArr.count, btn.frame.size.height-y*2);
       
       [WMZDropMenuTool TagSetImagePosition:btn.position spacing:self.param.wMenuTitleSpace button:btn];
       [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
       btn.tag = 1000+i;
       if (i == self.titleArr.count - 1&&i!=0) {
           if (dictionary&&dic[@"lastFix"]) {
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
   //显示边框
   if (self.param.wBorderShow) {
       [self addBoder];
   }
    //显示边框
    if (self.param.wBorderUpDownShow) {
        [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathTop PathWidth:1 heightScale:1 button:self];
        [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathBottom PathWidth:1 heightScale:1 button:self];
    }
}

#pragma -mark UI
- (void)updateUI{
    MenuSuppressPerformSelectorLeakWarning(
    [self performSelector:NSSelectorFromString(@"UISetup")];
    );
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
    //点击代理
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(menu:didSelectTitleInSection:btn:)]) {
        [self.delegate menu:self didSelectTitleInSection:sender.tag-1000 btn:sender];
    }
    MenuWeakSelf(self)
    //点击标题网络请求
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:didSelectTitleInSection:btn:networkBlock:)]) {
        [self.delegate menu:self didSelectTitleInSection:sender.tag-1000 btn:sender networkBlock:^{
            MenuStrongSelf(weakObject)
            [strongObject judgeBtnTitle:sender];
        }];
    }else{
        [self judgeBtnTitle:sender];
    }
}
#pragma -mark 标题点击逻辑处理
- (void)judgeBtnTitle:(WMZDropMenuBtn*)sender{
    if (self.selectTitleBtn&&self.selectTitleBtn.tag!=sender.tag&&[self.selectTitleBtn isSelected]) {
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
       //两种选中状态
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
       }else if(currentDrop.editStyle == MenuEditCheck||currentDrop.editStyle == MenuEditNone){
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
       }else{
          sender.selected = ![sender isSelected];
          if ([sender isSelected]) {
              if (!self.close&&self.lastSelectIndex>=0) {
                  WMZDropMenuBtn *lastBtn = self.titleBtnArr[self.lastSelectIndex];
                  [self dataChangeActionSection:[self getTitleFirstDropWthTitleBtn:lastBtn].section WithKey:nil];
              }
               self.selectArr = [NSMutableArray new];
              [self openView];
          }else{
              [self closeView];
          }
      }
       
       if ([self.selectTitleBtn isSelected]&&self.param.wMenuLine) {
           [self.selectTitleBtn showLine:@{}];
           if (self.param.wJDCustomLine) {
               self.param.wJDCustomLine(self.selectTitleBtn.line);
           }
       }else{
           [self.selectTitleBtn hidenLine];
       }
}
#pragma -mark 关闭方法
- (void)closeView{
    if (self.keyBoardShow) {
       [MenuWindow endEditing:YES];
    };
   //移除嵌套层
   BOOL exist = NO;
   for (UIView *view in [MenuWindow subviews]) {
        //如果window层不存在 返回
        if ((view.tag == 10086 && view == self.shadowView) || (view.tag == 10087&&view == self.dataView)) {
            exist = YES;break;
        }
    }
    if (!exist) return;
    if (!self.selectArr.count) {
        //查看更多取消选中 单独处理
        if (checkMore) {
            NSArray *arr = [self getArrWithKey:moreTableViewKey withoutHide:NO];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WMZDropTree class]]) {
                    obj.isSelected = NO;
                    obj.rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
                    obj.normalRangeArr = [NSArray new];
                    if ([self.selectArr indexOfObject:obj]!=NSNotFound) {
                        [self.selectArr removeObject:obj];
                    }
                  }
            }];
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
            [self dataChangeActionSection:0 WithKey:moreTableViewKey];
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
      WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
      if (self.hook) {
          currentDrop.hideAnimalStyle = MenuHideAnimalNone;
      }
     if ([MenuWindow viewWithTag:10088]!=nil) {
        //动画
        MenuWeakSelf(self)
         [self hideAnimal:currentDrop.hideAnimalStyle view:self.moreView durtion:menuAnimalTime block:^{
            MenuStrongSelf(weakObject)
            [strongObject.moreView removeFromSuperview];
        }];
         return;
      }
      //动画
      MenuWeakSelf(self)
      [self hideAnimal:currentDrop.hideAnimalStyle view:self.dataView durtion:menuAnimalTime block:^{
          MenuStrongSelf(weakObject)
          [strongObject.dataView removeFromSuperview];
      }];
      [self.shadowView removeFromSuperview];
      self.close = YES;
    
    //获取全部选中
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:getAllSelectData:)]) {
        NSMutableArray *allSelectArr = [NSMutableArray new];
        for (WMZDropIndexPath *drop in self.dropPathArr) {
            NSArray *arr = [self getArrWithKey:drop.key withoutHide:NO];
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
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:closeWithBtn:index:)]) {
        [self.delegate menu:self closeWithBtn:self.selectTitleBtn index:[self.titleBtnArr indexOfObject:self.selectTitleBtn]];
    }
}
//数据逻辑处理
- (void)dataChangeActionSection:(NSInteger)section WithKey:(nullable NSString*)key{
    //判断
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        WMZDropIndexPath *selectDrop = nil;
        if (key!=nil) {
            if ([drop.key isEqualToString:key]) {
                selectDrop = drop;
            }
        }else{
            if (drop.section == section){
                selectDrop = drop;
            }
        }
        if (selectDrop) {
            NSArray *arr = [self getArrWithKey:selectDrop.key withoutHide:YES];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WMZDropTree class]]) {
                    if (obj.isSelected) {
                        if ([self.selectArr indexOfObject:obj] == NSNotFound) {
                             obj.isSelected = NO;
                             obj.rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
                             obj.normalRangeArr = [NSArray new];
                        }
                    }else{
                        if ([self.selectArr indexOfObject:obj]!=NSNotFound&&drop.UIStyle!=MenuUITableView) {
                             obj.isSelected = YES;
                        }
                    }
                  }
            }];
        }
    }
}
#pragma -mark 开启筛选
- (void)openView{
    //嵌套层
    for (UIView *view in [MenuWindow subviews]) {
        //如果window层存在 移除上个 嵌套使用的时候
        if ((view.tag == 10086&& view != self.shadowView)|| (view.tag == 10087&& view != self.dataView)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationRemove object:nil userInfo:nil];
            break;
        }
    }
    self.close = NO;
    WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
    
    //获取弹出的位置
    [self getPopY];
    //阴影层frame改变
    self.shadowView.frame = [[self.shadomViewFrameDic objectForKey:@(currentDrop.showAnimalStyle)] CGRectValue];
    //数据层视图frame改变
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
    [self addTableView];
    if (self.dataView.frame.size.height <= 0.1) {
        CGRect rect = self.shadowView.frame;
        rect.size.height = 0;
        self.shadowView.frame = rect;
    }
    
    [self dealDataWithDelete:MenuDataDefault btn:self.selectTitleBtn];
    //动画
    [self showAnimal:currentDrop.showAnimalStyle view:self.dataView durtion:menuAnimalTime block:^{}];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:openWithBtn:index:)]) {
        [self.delegate menu:self openWithBtn:self.selectTitleBtn index:[self.titleBtnArr indexOfObject:self.selectTitleBtn]];
    }
    
}
#pragma -mark 弹出的位置
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
#pragma -mark 改变titleBtnArr中数据的状态
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
#pragma -mark 处理选中的数据 删除或者加入
- (void)dealDataWithDelete:(MenuDataStyle)style btn:(WMZDropMenuBtn*)btn{
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        if (drop.section == btn.tag - 1000 && ![drop.key isEqualToString:moreTableViewKey]) {
            NSArray *arr = [self getArrWithKey:drop.key withoutHide:NO];
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
#pragma -mark 点击选中方法
- (void)cellTap:(WMZDropIndexPath*)dropPath data:(NSArray*)arr indexPath:(NSIndexPath*)indexPath{
    WMZDropTree *tree = arr[indexPath.row];
    if (dropPath.UIStyle == MenuUICollectionRangeTextField) return;
    BOOL close = NO;
    if ([dropPath.key isEqualToString:moreTableViewKey]){
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
                   if (!tmpTree.isSelected) {
                       if ([self.selectArr indexOfObject:tmpTree]!=NSNotFound) {
                           [self.selectArr removeObject:tmpTree];
                       }
                   }
               }
               
               if (dropPath.tapClose&&tree.isSelected&&tree.tapClose) {
                   
                   for (WMZDropIndexPath *drop in self.dropPathArr) {
                       if (drop.section == dropPath.section) {
                           NSArray *arr = [self getArrWithKey:drop.key withoutHide:NO];
                           [arr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               if (obj.isSelected) {
                                   if ([self.selectArr indexOfObject:obj]==NSNotFound) {
                                       [self.selectArr addObject:obj];
                                   }
                               }
                           }];
                       }
                   }
                   close = YES;
                   [self changeTitleConfig:@{@"name":tree.name,@"dropPath":dropPath,@"row":@(indexPath.row)} withBtn:self.selectTitleBtn];
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
            NSArray *arr = [self getArrWithKey:drop.key withoutHide:NO];
            [arr enumerateObjectsUsingBlock:^(WMZDropTree *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected) {
                if ([self.selectArr indexOfObject:obj]==NSNotFound) {
                    [self.selectArr addObject:obj];
                }
            }
            }];
        }
    }
    [self changeTitleConfig:@{@"name":tree.name,@"dropPath":dropPath,@"row":@(row)} withBtn:self.selectTitleBtn];
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
            if ([tree.rangeArr[1] floatValue]<[tree.rangeArr[0] floatValue]) {
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
            [self changeTitleConfig:@{@"name":self.selectTitleBtn.titleLabel.text,@"dropPath":firstPath} withBtn:self.selectTitleBtn];
        }else{
            WMZDropTree *tree = self.selectArr[0];
            [self changeTitleConfig:@{
           @"name":self.selectArr.count>1?
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
/*
*手动选中标题 可做默认
*/
- (void)defaultSelectIndex:(NSInteger)index{
    for (int i = 0; i<self.titleBtnArr.count; i++) {
        if (i == index) {
            WMZDropMenuBtn *btn = self.titleBtnArr[i];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

- (BOOL)updateData:(NSArray*)arr ForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{return YES;}
- (BOOL)updateData:(NSArray*)arr AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row{return YES;}
- (BOOL)updateDataConfig:(NSDictionary*)changeData AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row AtIndexPathRow:(NSInteger)indexPathRow{return YES;}
- (NSArray*)getAllSelectArr{return @[];}
- (NSArray*)getSelectArrWithPathSection:(NSInteger)section{return @[];}
- (NSArray*)getSelectArrWithPathSection:(NSInteger)section row:(NSInteger)row{return @[];}
- (NSArray<WMZDropTableView*>*)tableViewCurrentInRow:(NSInteger)currentRow tableViewchangeInRow:(NSInteger)changeRow scrollTowPath:(NSIndexPath*)indexPath{return @[];}
@end
