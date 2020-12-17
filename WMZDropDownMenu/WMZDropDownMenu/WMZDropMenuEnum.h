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

/*
 * UI样式
 */
typedef enum : NSUInteger{
    MenuUINone = 0,                  //none 只有点击效果  默认
    MenuUITableView ,                //tableview
    MenuUICollectionView,            //collection
    MenuUICollectionRangeTextField,  //collectionView内使用 textField
}MenuUIStyle;

/*
 * 编辑样式
 */
typedef enum : NSUInteger{
    MenuEditNone = 0 ,           //none   只有文字的情况无图标的改变 只能选中且无法取消选中
    MenuEditCheck,               //       有图标的改变 且能取消选中
    MenuEditReSetCheck,          //二选一  数量两个的时候(具体表现为图标的改变)
    MenuEditOneCheck ,           //单选    默认
    MenuEditMoreCheck,           //多选
}MenuEditStyle;

/*
 * 出现的动画样式
 */
typedef enum : NSUInteger{
    MenuShowAnimalNone = 0,           //无动画
    MenuShowAnimalBottom,             //向下移动出现
//    MenuShowAnimalTop,                //向上移动出现
    MenuShowAnimalLeft,               //从左侧滑出现
    MenuShowAnimalRight ,             //向右侧滑出现
    MenuShowAnimalPop ,               //pop弹出
    MenuShowAnimalBoss ,              //boss直聘样式 全屏
}MenuShowAnimalStyle;


/*
 * 消失的动画样式
 */
typedef enum : NSUInteger{
    MenuHideAnimalNone = 0,          //无动画
    MenuHideAnimalTop,               //向上移动消失
//    MenuHideAnimalBottom,            //向下移动消失
    MenuHideAnimalRight,             //向右侧滑消失
    MenuHideAnimalLeft ,             //向左侧滑消失
    MenuHideAnimalBoss ,             //boss直聘样式 全屏
}MenuHideAnimalStyle;


/*
 * 处理数据
 */
typedef enum : NSUInteger{
    MenuDataDelete = 999,             //删除
    MenuDataInsert,                   //添加
    MenuDataDefault,                  //默认添加已选中的
}MenuDataStyle;


/*
 * collectionview cell文字自适应宽度
 */
typedef enum : NSUInteger{
    MenuCollectionUINormal = 0,        //固定宽度默认
    MenuCollectionUIFit,               //自适应文本宽度
}MenuCollectionUIStyle;


/*
* cell对齐方式
*/
typedef enum : NSUInteger{
    MenuCellAlignWithLeft,
    MenuCellAlignWithCenter,
    MenuCellAlignWithRight
}MenuCellAlignType;
#endif /* WMZDropMenuEnum_h */
