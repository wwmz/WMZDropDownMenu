//
//  WMZDropCollectionView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropCollectionView.h"
#import "WMZDropDownMenu.h"

@implementation WMZDropCollectionView

#pragma -mark collectionDelagete
- (UICollectionViewCell *)collectionView:(WMZDropCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];
    NSArray *arr = [self.menu getArrWithKey:path.key withoutHide:YES withInfo:self.menu.dataDic];
    WMZDropTree *tree = arr[indexPath.row];
    tree.indexPath = indexPath;
    tree.dropPath = path;
    if (self.menu.delegate&&[self.menu.delegate respondsToSelector:@selector(menu:cellForUICollectionView:AtDropIndexPath:AtIndexPath:dataForIndexPath:)]) {
        UICollectionViewCell *cell = [self.menu.delegate menu:self.menu cellForUICollectionView:collectionView AtDropIndexPath:path AtIndexPath:indexPath dataForIndexPath:tree];
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
            UIColor *lowBg = tree.config[@"lowBgColor"]?:self.menu.param.wCollectionViewCellBgColor;
            UIColor *highBg = tree.config[@"highBgColor"]?:self.menu.param.wCollectionViewCellBgColor;
            UIColor *textColor = tree.config[@"textColor"]?:MenuColor(0x333333);
            UIColor *textSelectColor = tree.config[@"textSelectColor"]?:MenuColor(0x333333);
            tree.lowPlaceholder = tree.config[@"lowPlaceholder"]?:tree.lowPlaceholder;
            tree.highPlaceholder = tree.config[@"highPlaceholder"]?:tree.highPlaceholder;
            tree.lowPlaceholder =
            cell.lowText.placeholder =  tree.lowPlaceholder;
            cell.highText.placeholder = tree.highPlaceholder;
            cell.highText.textAlignment = self.menu.param.wCollectionCellTextFieldAlignment;
            cell.lowText.textAlignment = self.menu.param.wCollectionCellTextFieldAlignment;
            cell.lowText.keyboardType = self.menu.param.wCollectionCellTextFieldKeyType;
            cell.highText.keyboardType = self.menu.param.wCollectionCellTextFieldKeyType;
            NSString *lowStr = tree.rangeArr.count>1?[NSString stringWithFormat:@"%@",tree.rangeArr[0]]:@"";
            NSString *maxStr = tree.rangeArr.count>1?[NSString stringWithFormat:@"%@",tree.rangeArr[1]]:@"";
            if (!tree.normalRangeArr||!tree.normalRangeArr.count) {
                if ([lowStr length]&&[maxStr length]) {
                    tree.normalRangeArr = @[lowStr,maxStr];
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
            __weak WMZDropCollectionView *weak = self;
            cell.clickBlock = ^(UITextField * _Nonnull textField, NSString * _Nonnull string) {
                 __strong WMZDropCollectionView *strong = weak;
                [strong tapAction:textField dropPath:path indexPath:indexPath data:tree];
            };
            tree.isSelected = ([lowStr length]>0||[maxStr length]>0);
            cell.lowText.textColor = tree.isSelected?textSelectColor:textColor;
            cell.highText.textColor = tree.isSelected?textSelectColor:textColor;;
            cell.lowText.backgroundColor = lowBg;
            cell.highText.backgroundColor = highBg;
            cell.lowText.font = tree.font?:self.menu.param.wCellTitleFont;
            cell.highText.font = tree.font?:self.menu.param.wCellTitleFont;
            cell.lowText.text  = lowStr;
            cell.highText.text = maxStr;
        }
        [cell layoutSubviews];
        MenuInputStyle style = MenuInputStyleMore;
        if (tree.inputStyle ) {
            style = tree.inputStyle;
        }else{
            style = self.menu.param.wCollectionCellTextFieldStyle;
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
             (tree.isSelected? self.menu.param.wCollectionViewCellSelectBgColor.CGColor:
              self.menu.param.wCollectionViewCellBgColor.CGColor);
             [cell.btn setTitleColor:tree.checkMore?self.menu.param.wCollectionViewCellSelectTitleColor:(
              tree.isSelected? self.menu.param.wCollectionViewCellSelectTitleColor:self.menu.param.wCollectionViewCellTitleColor) forState:UIControlStateNormal];
             cell.btn.titleLabel.font = tree.isSelected?
             tree.font?:self.menu.param.wCellTitleFont:
             tree.selectFont?:self.menu.param.wCellSelectTitleFont;
             [cell.btn setTitle:tree.name forState:UIControlStateNormal];
             [cell.btn setImage:tree.image?[UIImage bundleImage:tree.image]:nil forState:UIControlStateNormal];
             cell.btn.layer.borderColor = tree.checkMore?[UIColor whiteColor].CGColor:(tree.isSelected? self.menu.param.wCollectionViewCellSelectTitleColor.CGColor:self.menu.param.wCollectionViewCellTitleColor.CGColor);
             cell.btn.layer.borderWidth = tree.checkMore?0:(tree.isSelected?self.menu.param.wCollectionViewCellBorderWith:0);
             cell.btn.layer.cornerRadius = 8;
             
         }
         return cell;
    }
}

- (NSInteger)collectionView:(WMZDropCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   WMZDropIndexPath *path = collectionView.dropArr[section];
    NSInteger count = [[self.menu getArrWithKey:path.key withoutHide:YES withInfo:self.menu.dataDic] count];
    if (!path.expand) {
        if (count>=self.menu.param.wCollectionViewSectionRecycleCount) {
            count = self.menu.param.wCollectionViewSectionRecycleCount;
        }
    }
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(WMZDropCollectionView *)collectionView{
    return self.menu.collectionView.dropArr.count;
}

- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];
    if (path.collectionUIStyle == MenuCollectionUINormal) {
       return CGSizeMake((floor((collectionView.frame.size.width - self.menu.param.wCollectionViewCellSpace*(path.collectionCellRowCount+1))/(CGFloat)path.collectionCellRowCount)) , path.cellHeight);
    }else{
        if (path.UIStyle == MenuUICollectionRangeTextField) {
            return CGSizeMake((floor((collectionView.frame.size.width - self.menu.param.wCollectionViewCellSpace*(path.collectionCellRowCount+1))/(CGFloat)path.collectionCellRowCount)) , path.cellHeight);
        }else{
            NSArray *arr = [self.menu getArrWithKey:path.key withoutHide:YES withInfo:self.menu.dataDic];
            WMZDropTree *tree = arr[indexPath.row];
            UIFont *font = tree.isSelected?
            tree.font?:self.menu.param.wCellTitleFont:
            tree.selectFont?:self.menu.param.wCellSelectTitleFont;
            if (!tree.cellWidth) {
                tree.cellWidth = [WMZDropMenuTool boundingRectWithSize:tree.name Font:font Size:CGSizeMake(MAXFLOAT,MAXFLOAT)].width + 30;
            }
            return CGSizeMake(tree.cellWidth , path.cellHeight);
        }
    }
}

- (UICollectionReusableView *)collectionView:(WMZDropCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        if (self.menu.delegate&&[self.menu.delegate respondsToSelector:@selector(menu:headViewForUICollectionView:AtDropIndexPath:AtIndexPath:)]) {
            UICollectionReusableView *headView = [self.menu.delegate menu:self.menu headViewForUICollectionView:collectionView AtDropIndexPath:collectionView.dropArr[indexPath.section] AtIndexPath:indexPath];
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
        [headerView.accessTypeBtn addTarget:self.menu action:NSSelectorFromString(@"expandAction:") forControlEvents:UIControlEventTouchUpInside];
        if (self.menu.delegate && [self.menu.delegate respondsToSelector:@selector(menu:titleForHeadViewAtDropIndexPath:)]) {
            NSString *title = [self.menu.delegate menu:self.menu titleForHeadViewAtDropIndexPath:collectionView.dropArr[indexPath.section]];
            headerView.textLa.text = title;
        }
        return headerView;
    }else if(kind == UICollectionElementKindSectionFooter){
        if (self.menu.delegate&&[self.menu.delegate respondsToSelector:@selector(menu:footViewForUICollectionView:AtDropIndexPath:AtIndexPath:)]) {
            UICollectionReusableView *footView = [self.menu.delegate menu:self.menu footViewForUICollectionView:collectionView AtDropIndexPath:collectionView.dropArr[indexPath.section] AtIndexPath:indexPath];
            if (footView&&[footView isKindOfClass:[UICollectionReusableView class]]) {
                return footView;
            }
        }
        WMZDropCollectionViewFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([WMZDropCollectionViewFootView class]) forIndexPath:indexPath];
        if (self.menu.delegate && [self.menu.delegate respondsToSelector:@selector(menu:titleForFootViewAtDropIndexPath:)]) {
               NSString *title = [self.menu.delegate menu:self.menu titleForFootViewAtDropIndexPath:collectionView.dropArr[indexPath.section]];
               footerView.textLa.text = title;
        }
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    WMZDropIndexPath *path = collectionView.dropArr[section];
    return CGSizeMake(self.menu.dataView.frame.size.width,path.headViewHeight);
}

- (CGSize)collectionView:(WMZDropCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    WMZDropIndexPath *path = collectionView.dropArr[section];
    return CGSizeMake(self.menu.dataView.frame.size.width, path.footViewHeight);
}

- (void)collectionView:(WMZDropCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.menu.keyBoardShow) {
       [MenuWindow endEditing:YES]; return;
    }
    //点击处理
    WMZDropIndexPath *path = collectionView.dropArr[indexPath.section];
    NSArray *arr = [self.menu getArrWithKey:path.key withoutHide:YES withInfo:self.menu.dataDic];
    [self.menu cellTap:path data:arr indexPath:indexPath];
}

- (void)tapAction:(UITextField*)sender dropPath:(WMZDropIndexPath*)dropPath indexPath:(NSIndexPath*)indexPath data:(WMZDropTree*)tree{
    if (self.menu.delegate && [self.menu.delegate respondsToSelector:@selector(menu:didSelectRowAtDropIndexPath:dataIndexPath:data:)]) {
        tree.index = sender.tag;
        [self.menu.delegate menu:self.menu didSelectRowAtDropIndexPath:dropPath dataIndexPath:indexPath data:tree];
    }
}

@end

@implementation WMZMenuCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self.contentView addSubview:self.btn];
        self.btn.userInteractionEnabled = NO;
        self.btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
     self.btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _btn;
}

@end

@interface WMZMenuTextFieldCell()<UITextFieldDelegate>

@end

@implementation WMZMenuTextFieldCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self.contentView addSubview:self.lowText];
        self.lowText.layer.masksToBounds = YES;
        [self.contentView addSubview:self.highText];
        self.highText.layer.masksToBounds = YES;
        [self.contentView addSubview:self.lineLa];
        self.highText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.lowText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.lowText.delegate = self;
        self.highText.delegate = self;
        self.lowText.returnKeyType = UIReturnKeyDone;
        self.highText.returnKeyType = UIReturnKeyDone;
        [self.lowText addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
        [self.highText addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textAction:(UITextField*)textField{
    if (self.myBlock) {
        self.myBlock(textField,textField.text);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.tree.canEdit) {
        if (self.clickBlock) {
            self.clickBlock(textField, textField.text);
        }
    }
    return self.tree.canEdit;
}

- (UITextField *)lowText{
    if (!_lowText) {
        _lowText = [UITextField new];
        _lowText.leftViewMode = UITextFieldViewModeAlways;
        _lowText.tag = 0;
    }
    return _lowText;
}

- (UITextField *)highText{
    if (!_highText) {
        _highText = [UITextField new];
        _highText.leftViewMode = UITextFieldViewModeAlways;
        _highText.tag = 1;
    }
    return _highText;
}

- (UILabel *)lineLa{
    if (!_lineLa) {
        _lineLa = [UILabel new];
        _lineLa.textAlignment = NSTextAlignmentCenter;
        _lineLa.text = @"-";
    }
    return _lineLa;
}

@end

@implementation WMZDropCollectionViewHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.textLa];
        [self addSubview:self.accessTypeBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLa.frame = CGRectMake(Menu_GetWNum(30), 0, self.frame.size.width * 0.85, self.frame.size.height);
    self.accessTypeBtn.frame = CGRectMake(CGRectGetMaxX(self.textLa.frame) , 0, 30, self.frame.size.height);
}

- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:15.0f];
        _textLa.numberOfLines = 0;
        _textLa.textColor = MenuColor(0x333333);
    }
    return _textLa;
}

- (UIButton *)accessTypeBtn{
    if (!_accessTypeBtn) {
        _accessTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _accessTypeBtn;
}

@end

@implementation WMZDropCollectionViewFootView

@end

@implementation WMZDropConfirmView

- (instancetype)init{
    if(self = [super init]){
        [self addSubview:self.resetBtn];
        [self addSubview:self.confirmBtn];
        [self.resetBtn setTitleColor:MenuColor(0x333333) forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:MenuColor(0x333333) forState:UIControlStateNormal];
        self.resetBtn.backgroundColor = [UIColor whiteColor];
        [self.resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.showBorder = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.resetBtn.frame = [self.resetFrame CGRectValue];
    self.confirmBtn.frame = [self.confirmFrame CGRectValue];
    [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathTop PathWidth:self.showBorder?MenuK1px:0 heightScale:1 button:self];
    [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathBottom PathWidth:self.showBorder?MenuK1px:0 heightScale:1 button:self];
    [WMZDropMenuTool setView:self.resetBtn Radii:CGSizeMake(self.showRdio?self.resetBtn.frame.size.height/2:0, self.showRdio?self.resetBtn.frame.size.height/2:0) RoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [WMZDropMenuTool setView:self.confirmBtn Radii:CGSizeMake(self.showRdio?self.resetBtn.frame.size.height/2:0, self.showRdio?self.resetBtn.frame.size.height/2:0) RoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
}

- (NSValue *)resetFrame{
    if (!_resetFrame) {
        _resetFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    }
    return _resetFrame;
}

- (NSValue *)confirmFrame{
    if (!_confirmFrame) {
        _confirmFrame = [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(self.resetBtn.frame), 0, self.frame.size.width-CGRectGetMaxX(self.resetBtn.frame),self.resetBtn.frame.size.height)];
    }
    return _confirmFrame;
}

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _resetBtn;
}
- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _confirmBtn;
}

@end

@implementation WMZDropBossHeadView

- (instancetype)init{
    if(self = [super init]){
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightbtn];
        [self addSubview:self.titleLa];
        self.titleLa.text = @"标题";
        self.titleLa.textAlignment = NSTextAlignmentCenter;
        [self.leftBtn setTitle:@"X" forState:UIControlStateNormal];
        [self.rightbtn setTitle:@"" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:MenuColor(0x333333) forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:MenuColor(0x00c2bb) forState:UIControlStateNormal];
         self.leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
         self.rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftBtn.frame = CGRectMake(15, 0, self.frame.size.width*0.2, self.frame.size.height);
    self.titleLa.frame = CGRectMake(self.frame.size.width*0.25, 0, self.frame.size.width*0.5, self.frame.size.height);
    self.rightbtn.frame = CGRectMake(CGRectGetMaxX(self.titleLa.frame)+0.05, 0, self.frame.size.width*0.2, self.frame.size.height);
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _leftBtn;
}

- (UIButton *)rightbtn{
    if (!_rightbtn) {
        _rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightbtn;
}

- (UILabel *)titleLa{
    if (!_titleLa) {
        _titleLa = [UILabel new];
    }
    return _titleLa;
}

@end

@interface WMZDropMenuCollectionLayout(){
    CGFloat _sumCellWidth ;
}
@end

@implementation WMZDropMenuCollectionLayout

-(instancetype)initWithType:(MenuCellAlignType)cellType betweenOfCell:(CGFloat)betweenOfCell{
    self = [super init];
    if (self){
        _betweenOfCell = betweenOfCell;
        _cellType = cellType;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index];
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1];
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];
        [layoutAttributesTemp addObject:currentAttr];
        _sumCellWidth += currentAttr.frame.size.width;
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    switch (_cellType) {
        case MenuCellAlignWithLeft:{
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.betweenOfCell;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        }
        case MenuCellAlignWithCenter:{
            nowWidth = (self.collectionView.frame.size.width - _sumCellWidth - ((layoutAttributes.count - 1) * _betweenOfCell)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.betweenOfCell;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        }
            
        case MenuCellAlignWithRight:{
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - _betweenOfCell;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        }
    }
}

@end
