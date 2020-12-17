//
//  WMZDropMenuCollectionLayout.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/12/17.
//  Copyright © 2020 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMZDropMenuEnum.h"
NS_ASSUME_NONNULL_BEGIN
@interface WMZDropMenuCollectionLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign)CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)MenuCellAlignType cellType;
-(instancetype)initWithType:(MenuCellAlignType) cellType betweenOfCell:(CGFloat)betweenOfCell;
@end

NS_ASSUME_NONNULL_END
