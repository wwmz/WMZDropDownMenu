//
//  WMZDropShowViewProcotol.h
//  WMZDropDownMenu
//
//  Created by wmz on 2022/9/27.
//  Copyright © 2022 wmz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMZDropMenuBtn.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WMZDropShowViewProcotol <NSObject>

@required
/// 必须赋值
@property (nonatomic, strong) WMZDropIndexPath* dropIndex;

@required
/// 数组
@property (nonatomic, strong) NSArray<WMZDropIndexPath*> *dropArray;


@end

NS_ASSUME_NONNULL_END
