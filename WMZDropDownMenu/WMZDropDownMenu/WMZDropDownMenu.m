//
//  WMZDropDownMenu.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZDropDownMenu.h"
static NSString* const notificationRemove = @"notificationRemove";
@interface WMZDropDownMenu()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
/*
*标题数组
*/
@property(nonatomic,strong)NSArray *titleArr;
/*
*DeopindexPath的数组
*/
@property(nonatomic,strong)NSMutableArray *dropPathArr;
/*
*显示的view的数组
*/
@property(nonatomic,strong)NSMutableArray *showView;
@end
@implementation WMZDropDownMenu
#pragma -mark 更新数据
- (void)updateData:(NSArray*)arr ForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    
    WMZDropIndexPath *currentDrop = dropIndexPath;
    //下一层
    for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
       if (tmpDrop.section == dropIndexPath.section && tmpDrop.row == (dropIndexPath.row+1)) {
           currentDrop = tmpDrop;
           break;
       }
    }
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
        [self updateSubView:dropIndexPath];
    }
}
#pragma -mark UI
- (void)updateUI{
    [self dealData];
    self.backgroundColor = menuMainClor;
    //移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:notificationRemove object:nil];
    //hook监听当前控制器消失
    MenuWeakSelf(self)
    [[WMZDropMenuTool getCurrentVC] aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> aspectInfo)
    {
        MenuStrongSelf(weakObject);
        strongObject.hook = YES;
        [strongObject closeView];
    } error:NULL];
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
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([dic isKindOfClass:[NSString class]]) {
            [btn setTitle:dic forState:UIControlStateNormal];
        }else if([dic isKindOfClass:[NSDictionary class]]){
            [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        }
        CGFloat font = 14.0;
        if (dictionary&&dic[@"font"]) {font = [dic[@"font"]floatValue];}
        UIColor *normalColor = self.param.wCollectionViewCellTitleColor;
        if (dictionary&&dic[@"normalColor"]) {normalColor = dic[@"normalColor"];}
        UIColor *selectColor = self.param.wCollectionViewCellSelectTitleColor;
        if (dictionary&&dic[@"selectColor"]) {selectColor = dic[@"selectColor"];}
        if (dictionary&&dic[@"reSelectImage"]) {btn.reSelectImage = dic[@"reSelectImage"];}
        NSString *seletImage = nil;
        if (dictionary&&dic[@"selectImage"]) {
            seletImage = dic[@"selectImage"];
        }else{
            if (dictionary) {
                seletImage = @"menu_xiangshang";
            }
        }
        NSString *normalImage = nil;
        if (dictionary&&dic[@"normalImage"]) {
            normalImage = dic[@"normalImage"];
        }else{
            if (dictionary) {
                normalImage = @"menu_xiangxia";
            }
        }
        if ((dictionary&&dic[@"normalImage"])&&(dictionary&&!dic[@"selectImage"])) {
            seletImage = dic[@"normalImage"];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:font];
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        btn.normalImage = normalImage;
        btn.selectImage = seletImage;
        btn.normalColor = normalColor;
        btn.selectColor = selectColor;
        [btn setImage:normalImage?[UIImage bundleImage:normalImage]:nil forState:UIControlStateNormal];
        [btn setImage:seletImage?[UIImage bundleImage:seletImage]:nil forState:UIControlStateSelected];
        btn.frame = CGRectMake(tmp?CGRectGetMaxX(tmp.frame):0, 0, self.titleView.frame.size.width/(self.param.wMenuTitleEqualCount<self.titleArr.count?self.titleArr.count:self.param.wMenuTitleEqualCount), self.titleView.frame.size.height);
        //外部自定义标题按钮
        NSDictionary *config = nil;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:customTitleInSection:withTitleBtn:)]) {
            config =  [self.delegate menu:self customTitleInSection:i withTitleBtn:btn];
        }
        [btn setTitleColor:normalColor forState:UIControlStateSelected];
        btn.normalTitle = btn.titleLabel.text;
        CGFloat offset = config[@"offset"]?[config[@"offset"] floatValue]:0;
        CGFloat y = config[@"y"]?[config[@"y"] floatValue]:0;
        btn.frame = CGRectMake(tmp?(CGRectGetMaxX(tmp.frame)+offset):offset, y, btn.frame.size.width-offset, btn.frame.size.height-y*2);
        [WMZDropMenuTool TagSetImagePosition:btn.position spacing:1 button:btn];
        [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        if (i == self.titleArr.count - 1) {
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
                btn.frame = CGRectMake(CGRectGetWidth(self.frame)-self.param.wFixBtnWidth, y, self.param.wFixBtnWidth, tmp.frame.size.height);
                if ([[self.titleView subviews] indexOfObject:btn] == NSNotFound) {
                    [self.titleView addSubview:btn];
                }
                self.titleView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
            }
             [WMZDropMenuTool TagSetImagePosition:btn.position spacing:1 button:btn];
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
    
    NSLog(@"%@",self.mutuallyExclusiveArr);
    
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
}


#pragma -mark 添加边框
- (void)addBoder{
    [self.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.titleBtnArr.count-1) {
            [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathRight PathWidth:1 heightScale:0.5 button:btn];
        }
    }];
     [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathTop PathWidth:1 heightScale:1 button:self];
     [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathBottom PathWidth:1 heightScale:1 button:self];
}

#pragma -mark 处理delegate的data
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

#pragma -mark tablViewDeleagte
- (NSInteger)tableView:(WMZDropTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *data = [self.dataDic objectForKey:tableView.dropIndex.key];
    
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
            NSArray *lastData = [self.dataDic objectForKey:lastDrop.key];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(WMZDropTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data = [self.dataDic objectForKey:tableView.dropIndex.key];
    WMZDropTree *tree = data[indexPath.row];
    //自定义
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:cellForUITableView:AtIndexPath:dataForIndexPath:)]) {
        UITableViewCell *cell = [self.delegate menu:self cellForUITableView:tableView AtIndexPath:indexPath dataForIndexPath:tree];
        if (cell&&[cell isKindOfClass:[UITableViewCell class]]) {
            return cell;
        }
    }
    WMZDropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WMZDropTableViewCell class])];
    if (!cell) {
        cell = [[WMZDropTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WMZDropTableViewCell class])];
    }
    if ([tree isKindOfClass:[WMZDropTree class]]) {
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage bundleImage:@"menu_check"]];
        image.frame = CGRectMake(0, 0, 20, 20);
        image.hidden = !tree.isSelected;
        cell.accessoryView = self.param.wCellSelectShowCheck?image:nil;
        cell.textLabel.text = tree.name;
        cell.textLabel.textAlignment = self.param.wTextAlignment;
        cell.textLabel.textColor = tree.isSelected? self.param.wCollectionViewCellSelectTitleColor:self.param.wCollectionViewCellTitleColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
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
    return tableView.dropIndex.footViewHeight == 0?0.01:tableView.dropIndex.footViewHeight;
}
- (CGFloat)tableView:(WMZDropTableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView.dropIndex.headViewHeight == 0?0.01:tableView.dropIndex.headViewHeight;
}
- (UIView*)tableView:(WMZDropTableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:footViewForUITableView:AtDropIndexPath:)]) {
        UITableViewHeaderFooterView *footView = [self.delegate menu:self footViewForUITableView:tableView AtDropIndexPath:tableView.dropIndex];
        if (footView&&[footView isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return footView;
        }
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
        if (headView&&[headView isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return headView;
        }
    }
    WMZDropTableViewHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WMZDropTableViewHeadView class])];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForHeadViewAtDropIndexPath:)]) {
        NSString *title = [self.delegate menu:self titleForHeadViewAtDropIndexPath:tableView.dropIndex];
        headView.textLa.text = title;
    }
    return headView;
}
- (CGFloat)tableView:(WMZDropTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data = [self.dataDic objectForKey:tableView.dropIndex.key];
    WMZDropTree *tree = data[indexPath.row];
    return tree.cellHeight;
}
- (void)tableView:(WMZDropTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.keyBoardShow) {
       [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; return;
    };
    NSArray *data = [self.dataDic objectForKey:tableView.dropIndex.key];
    //点击处理
    [self cellTap:tableView.dropIndex data:data indexPath:indexPath];
}

#pragma -mark collectionDelagete
- (UICollectionViewCell *)collectionView:(WMZDropCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];
    NSArray *arr = [self.dataDic objectForKey:path.key];
    WMZDropTree *tree = arr[indexPath.row];
    
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
            tree.lowPlaceholder = tree.config[@"lowPlaceholder"]?:tree.lowPlaceholder;
            tree.highPlaceholder = tree.config[@"highPlaceholder"]?:tree.highPlaceholder;
            tree.lowPlaceholder =
            cell.lowText.placeholder =  tree.lowPlaceholder;
            cell.highText.placeholder = tree.highPlaceholder;
            
            cell.lowText.text = tree.rangeArr.count>1?tree.rangeArr[0]:@"";
            cell.highText.text = tree.rangeArr.count>1?tree.rangeArr[1]:@"";
            if (!tree.normalRangeArr||!tree.normalRangeArr.count) {
                if ([cell.lowText.text length]&&[cell.highText.text length]) {
                    tree.normalRangeArr = @[cell.lowText.text,cell.highText.text];
                }
            }
            MenuWeakSelf(cell)
            cell.myBlock = ^(UITextField * _Nonnull textField, NSString * _Nonnull string) {
                MenuStrongSelf(weakObject)
                if (textField == cell.lowText) {
                    strongObject.lowT = string;
                    if (strongObject.lowT) {
                        tree.rangeArr[0] = strongObject.lowT;
                    }
                }else{
                    strongObject.highT = string;
                    if (strongObject.highT) {
                        tree.rangeArr[1] = strongObject.highT;
                    }
                }
                tree.isSelected = YES;
            };
            tree.isSelected = ([cell.lowText.text length]>0||[cell.highText.text length]>0);
            cell.lowText.backgroundColor = self.param.wCollectionViewCellBgColor;
            cell.highText.backgroundColor = self.param.wCollectionViewCellBgColor;
        }
        return cell;
    }else{
          //默认视图
         WMZMenuCell *cell = (WMZMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WMZMenuCell class]) forIndexPath:indexPath];
         if ([tree isKindOfClass:[WMZDropTree class]]) {
             cell.btn.backgroundColor =  tree.isSelected? self.param.wCollectionViewCellSelectBgColor:self.param.wCollectionViewCellBgColor;
             [cell.btn setTitleColor:tree.isSelected? self.param.wCollectionViewCellSelectTitleColor:self.param.wCollectionViewCellTitleColor forState:UIControlStateNormal];
             [cell.btn setTitle:tree.name forState:UIControlStateNormal];
             [cell.btn setImage:tree.image?[UIImage bundleImage:tree.image]:nil forState:UIControlStateNormal];
             cell.btn.layer.borderColor = tree.isSelected? self.param.wCollectionViewCellSelectTitleColor.CGColor:self.param.wCollectionViewCellTitleColor.CGColor;
             cell.btn.layer.borderWidth = tree.isSelected?self.param.wCollectionViewCellBorderWith:0;
         }
         return cell;
    }
}
- (NSInteger)collectionView:(WMZDropCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   WMZDropIndexPath *path = collectionView.dropArr[section];
    NSInteger count = [[self.dataDic objectForKey:path.key] count];
    if (!path.expand) {
        if (count>=self.param.wCollectionViewSectionRecycleCount) {
            count = self.param.wCollectionViewSectionRecycleCount;
        }
    }
    return count;
}
- (NSInteger)numberOfSectionsInCollectionView:(WMZDropCollectionView *)collectionView{
    return self.collectionView.dropArr.count;
}
- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];;
    return CGSizeMake((floor((collectionView.frame.size.width - self.param.wCollectionViewCellSpace*(path.collectionCellRowCount+1))/(CGFloat)path.collectionCellRowCount)) , path.cellHeight);
}
- (UICollectionReusableView *)collectionView:(WMZDropCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:headViewForUICollectionView:AtDropIndexPath:AtIndexPath:)]) {
            UICollectionReusableView *headView = [self.delegate menu:self headViewForUICollectionView:collectionView AtDropIndexPath:collectionView.dropArr[indexPath.section] AtIndexPath:indexPath];
            if (headView&&[headView isKindOfClass:[UICollectionReusableView class]]) {
                return headView;
            }
        }
        WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];
        WMZDropCollectionViewHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewHeadView class]) forIndexPath:indexPath];
        headerView.accessTypeBtn.hidden = !path.showExpand;
        headerView.accessTypeBtn.selected = !path.expand;
        [headerView.accessTypeBtn setImage:[UIImage bundleImage:@"menu_xiangshang"] forState:UIControlStateNormal];
        [headerView.accessTypeBtn setImage:[UIImage bundleImage:@"menu_xiangxia"] forState:UIControlStateSelected];
        headerView.dropIndexPath = path;
        [headerView.accessTypeBtn addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForHeadViewAtDropIndexPath:)]) {
            NSString *title = [self.delegate menu:self titleForHeadViewAtDropIndexPath:collectionView.dropArr[indexPath.section]];
            headerView.textLa.text = title;
        }
        return headerView;
    }else if(kind == UICollectionElementKindSectionFooter){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(menu:footViewForUICollectionView:AtDropIndexPath:AtIndexPath:)]) {
            UICollectionReusableView *footView = [self.delegate menu:self footViewForUICollectionView:collectionView AtDropIndexPath:collectionView.dropArr[indexPath.section] AtIndexPath:indexPath];
            if (footView&&[footView isKindOfClass:[UICollectionReusableView class]]) {
                return footView;
            }
        }
        WMZDropCollectionViewFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewFootView class]) forIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:titleForFootViewAtDropIndexPath:)]) {
               NSString *title = [self.delegate menu:self titleForFootViewAtDropIndexPath:collectionView.dropArr[indexPath.section]];
               footerView.textLa.text = title;
        }
        return footerView;
    }
    return nil;
}
- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
     WMZDropIndexPath *path = collectionView.dropArr[section];
    return CGSizeMake(self.dataView.frame.size.width,path.headViewHeight );
}
- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    WMZDropIndexPath *path = collectionView.dropArr[section];
    return CGSizeMake(self.dataView.frame.size.width, path.footViewHeight);
}
- (void)collectionView:(WMZDropCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.keyBoardShow) {
       [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; return;
    };
    //点击处理
    WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];
    NSArray *arr = [self.dataDic objectForKey:path.key];
    [self cellTap:path data:arr indexPath:indexPath];
}

#pragma -mark 标题点击方法
- (void)titleAction:(WMZDropMenuBtn*)sender{
    if (self.selectTitleBtn&&self.selectTitleBtn!=sender&&[self.selectTitleBtn isSelected]) {
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
       }else{
           [sender setImage:[UIImage bundleImage:sender.reSelectImage] forState:UIControlStateSelected];
                         [sender setImage:[UIImage bundleImage:sender.reSelectImage] forState:UIControlStateSelected | UIControlStateHighlighted];
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
        [self.selectTitleBtn setTitleColor:self.param.wCollectionViewCellSelectTitleColor forState:UIControlStateSelected];
        if (currentDrop.editStyle == MenuEditCheck) {
            sender.selected = ![sender isSelected];
        }else{
            sender.selected = YES;
        }
        [self changeTitleArr:YES update:YES];
    }else{
       sender.selected = ![sender isSelected];
       if ([sender isSelected]) {
            self.selectArr = [NSMutableArray new];
           if (!self.close&&self.lastSelectIndex>=0) {
               [self dealDataWithDelete:MenuDataDelete btn:self.titleBtnArr[self.lastSelectIndex]];
           }
           [self openView];
       }else{
           [self closeView];
       }
   }
    
    //点击代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectTitleInSection:btn:)]) {
        [self.delegate menu:self didSelectTitleInSection:sender.tag-1000 btn:sender];
    }
    
    if ([self.selectTitleBtn isSelected]&&self.param.wMenuLine) {
        [self.selectTitleBtn showLine:@{}];
    }else{
        [self.selectTitleBtn hidenLine];
    }
}
#pragma -mark 关闭方法
- (void)closeView{
    if (self.keyBoardShow) {
       [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
        //没有选中的项 取消预选
         [self dealDataWithDelete:MenuDataDelete btn:self.selectTitleBtn];
         [self changeNormalConfig:@{}];
         [self.selectTitleBtn hidenLine];
         for (WMZDropMenuBtn *btn in self.titleBtnArr) {
             if (btn!=self.selectTitleBtn) {
                if ([btn isSelected]&&self.param.wMenuLine) {
                    [btn showLine:@{}];
                }
            }
         }
    }else{
         [self changeTitleArr:YES update:YES];
         [self changeTitleConfig:@{}];
         if (self.param.wMenuLine) {
            [self.selectTitleBtn showLine:@{}];
         }
    }
    
    [self closeAction];
    self.selectTitleBtn.selected = NO;
}
#pragma -mark 关闭方法 不处理数据
- (void)closeAction{
     WMZDropIndexPath *currentDrop = [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn];
      if (self.hook) {
          currentDrop.hideAnimalStyle = MenuHideAnimalNone;
      }
      //动画
      MenuWeakSelf(self)
      [self hideAnimal:currentDrop.hideAnimalStyle view:self.dataView durtion:menuAnimalTime block:^{
          MenuStrongSelf(weakObject)
          [strongObject.dataView removeFromSuperview];
      }];
      [self.shadowView removeFromSuperview];
      self.close = YES;
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
    //阴影层frame改变
    self.shadowView.frame = [[self.shadomViewFrameDic objectForKey:@(currentDrop.showAnimalStyle)] CGRectValue];
    //数据层视图frame改变
    self.dataView.frame = [[self.dataViewFrameDic objectForKey:@(currentDrop.showAnimalStyle)] CGRectValue];
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
}

#pragma -mark 改变titleBtnArr中数据的状态
- (void)changeTitleArr:(BOOL)clear update:(BOOL)update{
    [self.titleBtnArr enumerateObjectsUsingBlock:^(WMZDropMenuBtn  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag!=self.selectTitleBtn.tag) {
            if ([self getTitleFirstDropWthTitleBtn:obj].connect ||
                ([self.mutuallyExclusiveArr indexOfObject:obj]!=NSNotFound&&[self.mutuallyExclusiveArr indexOfObject:self.selectTitleBtn]!=NSNotFound)) {
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


#pragma -mark 改变标题颜色和文字
- (void)changeTitleConfig:(NSDictionary*)config{
    if (config[@"name"]) {
       [self.selectTitleBtn setTitle:config[@"name"] forState:UIControlStateNormal];
    }
    [self.selectTitleBtn setTitleColor:self.selectTitleBtn.selectColor forState:UIControlStateNormal];
    [self.selectTitleBtn setTitleColor:self.selectTitleBtn.selectColor forState:UIControlStateSelected];
}
#pragma -mark 回复原来的标题和文字
- (void)changeNormalConfig:(NSDictionary*)config{
    [self.selectTitleBtn setTitle:self.selectTitleBtn.normalTitle forState:UIControlStateNormal];
    [self.selectTitleBtn setTitleColor:self.selectTitleBtn.normalColor forState:UIControlStateNormal];
    [self.selectTitleBtn setTitleColor:self.selectTitleBtn.normalColor forState:UIControlStateSelected];
}
#pragma -mark 处理选中的数据 删除或者加入
- (void)dealDataWithDelete:(MenuDataStyle)style btn:(WMZDropMenuBtn*)btn{
    for (WMZDropIndexPath *drop in self.dropPathArr) {
        if (drop.section == btn.tag - 1000) {
            NSArray *arr = [self.dataDic objectForKey:drop.key];
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
        if (dropPath.tapClose&&tree.isSelected) {
            if ([self.selectArr indexOfObject:tree]==NSNotFound) {
                [self.selectArr addObject:tree];
            }
            [self changeTitleConfig:@{@"name":tree.name}];
            [self closeView];
        }
    }else if (dropPath.editStyle == MenuEditMoreCheck){
        tree.isSelected = !tree.isSelected;
    }
    
    //点击代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectRowAtDropIndexPath:dataIndexPath:data:)]) {
        [self.delegate menu:self didSelectRowAtDropIndexPath:dropPath dataIndexPath:indexPath data:tree];
    }
    
    [self updateSubView:dropPath];
}

#pragma -mark 更新dropPath之后的视图
- (void)updateSubView:(WMZDropIndexPath*)dropPath{
    //获取需要更新的drop
      NSMutableArray *updateDrop = [NSMutableArray new];
      for (WMZDropIndexPath *tmpDrop in self.dropPathArr) {
          if (tmpDrop.section == dropPath.section && (tmpDrop.row >= dropPath.row)) {
              [updateDrop addObject:tmpDrop];continue;
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
    MenuUIStyle showType = MenuUINone;
    //判断需要显示的WMZDropIndexPath
    NSInteger index = self.selectTitleBtn.tag - 1000;
    NSMutableArray *dorpArr = [NSMutableArray new];
    for (WMZDropIndexPath *path in self.dropPathArr) {
        if (path.section == index) {
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
                    NSArray *dataArr = [self.dataDic objectForKey:path.key];
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
            tableView.delegate = self;
            tableView.dataSource = self;
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
                NSArray *arr = [self.dataDic objectForKey:path.key];
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
        CGFloat y = (screnFrame&&screnFrame!= MenuShowAnimalBoss)?Menu_StatusBarHeight:0;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
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
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
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
        }
    }else{
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
        }
    }else{
        
        BOOL insert = NO;
        for (UIView *connectView in connectViews) {
            if ([connectView isKindOfClass:[UICollectionView class]]) {
                insert = YES;
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
        [footView.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
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
}

#pragma -mark 展开方法
- (void)expandAction:(UIButton*)btn{
    WMZDropCollectionViewHeadView *head = (WMZDropCollectionViewHeadView*)btn.superview;
    btn.selected = ![btn isSelected];
    head.dropIndexPath.expand = !head.dropIndexPath.expand;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:head.dropIndexPath.row]];
}
#pragma -mark 确定方法
- (void)confirmAction{
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
            [nameArr addObject:tree.name];
        }
        [self.delegate menu:self didConfirmAtSection:self.selectTitleBtn.tag - 1000 selectNoramelData:self.selectArr selectStringData:nameArr];
    }

    if(self.selectArr.count){
        if ([self getTitleFirstDropWthTitleBtn:self.selectTitleBtn].showAnimalStyle == MenuShowAnimalLeft||
            [self getTitleFirstDropWthTitleBtn:self.selectTitleBtn].showAnimalStyle == MenuShowAnimalRight) {
            [self changeTitleConfig:@{@"name":self.selectTitleBtn.titleLabel.text}];
        }else{
            WMZDropTree *tree = self.selectArr[0];
            [self changeTitleConfig:@{@"name":self.selectArr.count>1?@"多选":
                                          (tree.name?:self.selectTitleBtn.titleLabel.text)}];
        }
    }else{
        [self changeNormalConfig:@{}];
    }
    self.selectTitleBtn.selected = NO;
    [self closeView];
}
#pragma -mark 重置方法
- (void)reSetAction{
    [self dealDataWithDelete:MenuDataDelete btn:self.selectTitleBtn];
    [self updateSubView:[self getTitleFirstDropWthTitleBtn:self.selectTitleBtn]];
}
#pragma -mark 获取当前标题对应的首个drop
- (WMZDropIndexPath*)getTitleFirstDropWthTitleBtn:(WMZDropMenuBtn*)btn{
    for (WMZDropIndexPath *path in self.dropPathArr) {
        if (path.section == btn.tag - 1000) {
            return path;
        }
    }
    //默认第一个
    return nil;
}
#pragma -mark lazy
- (void)setDelegate:(id<WMZDropMenuDelegate>)delegate{
    [super setDelegate:delegate];
    [self updateUI];
}
@end
