//
//  WeiPinDemo.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/29.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeiPinDemo : BaseVC

@end

@interface WeiPinCollectionView : UICollectionViewCell
@property(nonatomic,strong)UILabel *textLa;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIImageView *check;
@end

NS_ASSUME_NONNULL_END
