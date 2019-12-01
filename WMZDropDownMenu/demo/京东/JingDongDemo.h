//
//  JingDongDemo.h
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "BaseVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface JingDongDemo : BaseVC

@end

@interface JingDongHeadView : UICollectionReusableView
@property(nonatomic,strong)UILabel *textLa;
@property(nonatomic,strong)UIButton *accessTypeBtn;
@end

@interface JingDongFootViewView : UICollectionReusableView
@property(nonatomic,strong)UIView *back;
@end

NS_ASSUME_NONNULL_END
