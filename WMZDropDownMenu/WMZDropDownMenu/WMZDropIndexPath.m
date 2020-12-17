//
//  WMZDropIndexPath.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropIndexPath.h"

@implementation WMZDropIndexPath
- (instancetype)initWithSection:(NSInteger)section row:(NSInteger)row{
    if (self = [super init]) {
        self.section = section;
        self.row = row;
        self.editStyle = MenuEditOneCheck;
        self.UIStyle = MenuUITableView;
        self.showAnimalStyle = MenuShowAnimalBottom;
        self.hideAnimalStyle = MenuHideAnimalTop;
        self.collectionCellRowCount = 4;
        self.cellHeight = 35;
        self.expand = YES;
        self.tapClose = YES;
        self.connect = YES;
        self.collectionUIStyle = MenuCollectionUINormal;
        self.alignType = MenuCellAlignWithLeft;
    }
    return self;
}
- (NSString *)key{
    if (!_key) {
        _key = [NSString stringWithFormat:@"%ld-%ld",self.section,self.row];
    }
    return _key;
}

@end

@implementation WMZDropTree

- (instancetype)init{
    if (self = [super init]) {
        self.cellHeight = footHeadHeight;
        self.tapClose = YES;
        self.canEdit = YES;
    }
    return self;
}


- (instancetype)initWithDetpth:(NSInteger)depth withName:(NSString*)name  withID:(NSString*)ID{
    if (self = [super init]) {
        _depth = depth;
        _name = name;
        _ID = ID;
    }
    return self;
}

- (NSMutableArray *)rangeArr{
    if (!_rangeArr) {
        _rangeArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
    }
    return _rangeArr;
}


- (NSDictionary *)config{
    if (!_config) {
        _config = [NSDictionary new];
    }
    return _config;
}

- (NSMutableArray<WMZDropTree *> *)children{
    if (!_children) {
        _children = [NSMutableArray new];
    }
    return _children;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"name = %@ ，isSeleted = %d",self.name,self.isSelected];
}

@end
