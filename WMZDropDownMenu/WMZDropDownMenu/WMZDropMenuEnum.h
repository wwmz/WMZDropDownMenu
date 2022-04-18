//
//  WMZDropMenuEnum.h
//  WMZDropDownMenu
//
//  Created by wmz on 2020/12/17.
//  Copyright © 2020 wmz. All rights reserved.
//

#ifndef WMZDropMenuEnum_h
#define WMZDropMenuEnum_h
#import <UIKit/UIKit.h>
typedef void (^MenuAfterTime)(void);

typedef void (^MenuCustomLine)(UIView *customLine);

typedef CGRect (^MenuCusotmDataViewRect)(CGRect currentRect);

typedef CGRect (^MenuCusotmShadomViewRect)(CGRect currentRect);

/// UI样式
typedef enum : NSUInteger{
    /// none 只有点击效果  默认
    MenuUINone = 0,
    /// tableview
    MenuUITableView ,
    /// collection
    MenuUICollectionView,
    /// collectionView内使用 textField
    MenuUICollectionRangeTextField,
}MenuUIStyle;

/// 编辑样式
typedef enum : NSUInteger{
    /// none   只有文字的情况无图标的改变 只能选中且无法取消选中
    MenuEditNone = 0 ,
    /// 有图标的改变 且能取消选中
    MenuEditCheck,
    /// 二选一  数量两个的时候(具体表现为图标的改变)
    MenuEditReSetCheck,
    /// 单选    默认
    MenuEditOneCheck ,
    /// 多选
    MenuEditMoreCheck,          
}MenuEditStyle;

/// 出现的动画样式
typedef enum : NSUInteger{
    /// 无动画
    MenuShowAnimalNone = 0,
    /// 向下移动出现
    MenuShowAnimalBottom,
    /// 向上移动出现
    MenuShowAnimalTop,
    /// 从左侧滑出现
    MenuShowAnimalLeft,
    /// 向右侧滑出现
    MenuShowAnimalRight ,
    /// pop弹出
    MenuShowAnimalPop ,
    /// boss直聘样式 全屏
    MenuShowAnimalBoss ,
}MenuShowAnimalStyle;

///消失的动画样式
typedef enum : NSUInteger{
    ///无动画
    MenuHideAnimalNone = 0,
    ///向上移动消失
    MenuHideAnimalTop,
    ///向下移动消失
    MenuHideAnimalBottom,
    ///向右侧滑消失
    MenuHideAnimalRight,
    ///向左侧滑消失
    MenuHideAnimalLeft ,
    ///boss直聘样式 全屏
    MenuHideAnimalBoss ,
}MenuHideAnimalStyle;

/// 处理数据
typedef enum : NSUInteger{
    ///删除
    MenuDataDelete = 999,
    ///添加
    MenuDataInsert,
    ///默认添加已选中的
    MenuDataDefault,
}MenuDataStyle;

///collectionview cell文字自适应宽度
typedef enum : NSUInteger{
    ///固定宽度默认
    MenuCollectionUINormal = 0,
    ///自适应文本宽度
    MenuCollectionUIFit,
}MenuCollectionUIStyle;

/// cell对齐方式
typedef enum : NSUInteger{
    /// 左对齐
    MenuCellAlignWithLeft,
    /// 居中
    MenuCellAlignWithCenter,
    /// 右对齐
    MenuCellAlignWithRight
}MenuCellAlignType;

/// inputText
typedef enum : NSUInteger{
    /// 两个
    MenuInputStyleMore = 1,
    /// 单个
    MenuInputStyleOne,
}MenuInputStyle;

#endif /* WMZDropMenuEnum_h */
