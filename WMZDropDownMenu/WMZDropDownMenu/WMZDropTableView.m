//
//  WMZDropTableView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropTableView.h"
#import "WMZDropDownMenu.h"
@implementation WMZDropTableView

#pragma -mark tablViewDeleagte
- (NSInteger)tableView:(WMZDropTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *data = [self.menu getArrWithKey:tableView.dropIndex.key withoutHide:YES withInfo:self.menu.dataDic];
    if (tableView.dropIndex.row>0) {
        WMZDropIndexPath *lastDrop = nil;
        for (WMZDropIndexPath *tmpDrop in self.menu.dropPathArr) {
            if (tmpDrop.section == tableView.dropIndex.section &&
                tmpDrop.row == tableView.dropIndex.row-1) {
                lastDrop = tmpDrop;
                break;
            }
        }
        BOOL hadSelected = NO;
        if (lastDrop) {
            NSArray *lastData = [self.menu getArrWithKey:lastDrop.key withoutHide:YES  withInfo:self.menu.dataDic];
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
    NSArray *data = [self.menu getArrWithKey:tableView.dropIndex.key withoutHide:YES  withInfo:self.menu.dataDic];
    WMZDropTree *tree = data[indexPath.row];
    //自定义
    if (self.menu.delegate&&[self.menu.delegate respondsToSelector:@selector(menu:cellForUITableView:AtIndexPath:dataForIndexPath:)]) {
        UITableViewCell *cell = [self.menu.delegate menu:self.menu cellForUITableView:tableView AtIndexPath:indexPath dataForIndexPath:tree];
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
        cell.accessoryView = self.menu.param.wCellSelectShowCheck?image:nil;
        cell.textLabel.text = tree.name;
        cell.textLabel.textAlignment = self.menu.param.wTextAlignment;
        cell.textLabel.textColor = tree.isSelected? self.menu.param.wCollectionViewCellSelectTitleColor:self.menu.param.wCollectionViewCellTitleColor;
        cell.textLabel.font = self.menu.param.wCellTitleFont;
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
    if (self.menu.delegate&&[self.menu.delegate respondsToSelector:@selector(menu:footViewForUITableView:AtDropIndexPath:)]) {
        UITableViewHeaderFooterView *footView = [self.menu.delegate menu:self.menu footViewForUITableView:tableView AtDropIndexPath:tableView.dropIndex];
        if (footView&&[footView isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return footView;
        }
    }
    WMZDropTableViewFootView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WMZDropTableViewFootView class])];
    if (self.menu.delegate && [self.menu.delegate respondsToSelector:@selector(menu:titleForFootViewAtDropIndexPath:)]) {
        NSString *title = [self.menu.delegate menu:self.menu titleForFootViewAtDropIndexPath:tableView.dropIndex];
        footView.textLa.text = title;
    }
    return footView;
    
}
- (UIView*)tableView:(WMZDropTableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.menu.delegate&&[self.menu.delegate respondsToSelector:@selector(menu:headViewForUITableView:AtDropIndexPath:)]) {
           UITableViewHeaderFooterView *headView = [self.menu.delegate menu:self.menu headViewForUITableView:tableView AtDropIndexPath:tableView.dropIndex];
        if (headView&&[headView isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return headView;
        }
    }
    WMZDropTableViewHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WMZDropTableViewHeadView class])];
    
    if (self.menu.delegate && [self.menu.delegate respondsToSelector:@selector(menu:titleForHeadViewAtDropIndexPath:)]) {
        NSString *title = [self.menu.delegate menu:self.menu titleForHeadViewAtDropIndexPath:tableView.dropIndex];
        headView.textLa.text = title;
    }
    return headView;
}
- (CGFloat)tableView:(WMZDropTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data = [self.menu getArrWithKey:tableView.dropIndex.key withoutHide:YES withInfo:self.menu.dataDic];
    WMZDropTree *tree = data[indexPath.row];
    return tree.cellHeight;
}
- (void)tableView:(WMZDropTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.menu.keyBoardShow) {
       [MenuWindow endEditing:YES]; return;
    };
    NSArray *data = [self.menu getArrWithKey:tableView.dropIndex.key withoutHide:YES  withInfo:self.menu.dataDic];
    //点击处理
    [self.menu cellTap:tableView.dropIndex data:data indexPath:indexPath];
}
@end


@implementation WMZDropTableViewHeadView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLa];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLa.frame = CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
    
}
- (UILabel *)textLa{
    if (!_textLa) {
        _textLa = [UILabel new];
        _textLa.font = [UIFont systemFontOfSize:15.0f];
        _textLa.numberOfLines = 0;
        _textLa.textColor = MenuColor(0x666666);
    }
    return _textLa;
}
@end

@implementation WMZDropTableViewFootView
@end


@implementation WMZDropTableViewCell
@end


