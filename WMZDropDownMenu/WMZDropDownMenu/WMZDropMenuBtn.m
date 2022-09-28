//
//  WMZDropMenuBtn.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/20.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuBtn.h"

@implementation WMZDropMenuBtn

- (void)setUpParam:(WMZDropMenuParam*)param withDic:(id)dic{
    self.tj_acceptEventInterval = 0.3;
    self.param = param;
    BOOL dictionary = [dic isKindOfClass:[NSDictionary class]];
    if(param.wNumOfLine){
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }else{
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([dic isKindOfClass:[NSString class]]) {
        [self setTitle:dic forState:UIControlStateNormal];
    }else if([dic isKindOfClass:[NSDictionary class]]){
        [self setTitle:dic[WMZMenuTitleNormal] forState:UIControlStateNormal];
    }
    CGFloat font = 14.0;
    if (dictionary&&dic[WMZMenuTitleFontNum]) {font = [dic[WMZMenuTitleFontNum]floatValue];}
    if (dictionary&&dic[WMZMenuTitleFont]&&[dic[WMZMenuTitleFont] isKindOfClass:[UIFont class]]) {
        self.titleLabel.font = dic[WMZMenuTitleFont];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    UIColor *normalColor = self.param.wCollectionViewCellTitleColor;
    if (dictionary&&dic[WMZMenuTitleColor]) {normalColor = dic[WMZMenuTitleColor];}
    UIColor *selectColor = self.param.wCollectionViewCellSelectTitleColor;
    if (dictionary&&dic[WMZMenuTitleSelectColor]) {selectColor = dic[WMZMenuTitleSelectColor];}
    if (dictionary&&dic[WMZMenuTitleReSelectImage]) {self.reSelectImage = dic[WMZMenuTitleReSelectImage];}
    if (dictionary&&dic[WMZMenuTitleSelect]) {self.selectTitle = dic[WMZMenuTitleSelect];}
    if (dictionary&&dic[WMZMenuTitleReSelect]) {self.reSelectTitle = dic[WMZMenuTitleReSelect];}
    NSString *seletImage = nil;
    if (dictionary&&dic[WMZMenuTitleSelectImage]) {
        seletImage = dic[WMZMenuTitleSelectImage];
    }else{
        if (dictionary) {
            if (!dic[WMZMenuTitleHideDefaultImage]||
                (dic[WMZMenuTitleHideDefaultImage]&&![dic[WMZMenuTitleHideDefaultImage] boolValue])) {
                 seletImage = @"menu_xiangshang";
            }
        }
    }
    NSString *normalImage = nil;
    if (dictionary&&dic[WMZMenuTitleImage]) {
        normalImage = dic[WMZMenuTitleImage];
    }else{
        if (dictionary) {
            if (!dic[WMZMenuTitleHideDefaultImage]||
                (dic[WMZMenuTitleHideDefaultImage]&&![dic[WMZMenuTitleHideDefaultImage] boolValue])) {
                normalImage = @"menu_xiangxia";
            }
        }
    }
    if ((dictionary&&dic[WMZMenuTitleImage])&&(dictionary&&!dic[WMZMenuTitleSelectImage])) {
        seletImage = dic[WMZMenuTitleImage];
    }
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    self.normalImage = normalImage;
    self.selectImage = seletImage;
    self.normalColor = normalColor;
    self.selectColor = selectColor;
    [self setImage:normalImage?[UIImage bundleImage:normalImage]:nil forState:UIControlStateNormal];
    [self setImage:seletImage?[UIImage bundleImage:seletImage]:nil forState:UIControlStateSelected];
    [self setTitleColor:normalColor forState:UIControlStateSelected];
    self.normalTitle = [self titleForState:UIControlStateNormal];
    if (self.selectTitle) {
        [self setTitle:self.selectTitle forState:UIControlStateSelected];
    }
}

- (MenuBtnPosition)position{
    if (!_position) {
        _position = MenuBtnPositionRight;
    }
    return _position;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [WMZDropMenuTool TagSetImagePosition:self.position spacing:self.param.wMenuTitleSpace button:self];
}
@end

static char lineViewKey;
@implementation WMZDropMenuBtn (WMZLine)

- (void)showLine:(NSDictionary*)config{
    if (self.line == nil||[[self subviews] indexOfObject:self.line]==NSNotFound) {
        CGRect frame = CGRectMake((self.frame.size.width - 30)/2, self.frame.size.height-5, 30, 3);
        self.line = [[UIView alloc] initWithFrame:frame];
        self.line.backgroundColor = [UIColor menuColorGradientChangeWithSize:self.line.frame.size direction:MenuGradientChangeDirectionLevel startColor:MenuColor(0xf92921) endColor:MenuColor(0xffc1bd)];
        [self addSubview:self.line];
        [self bringSubviewToFront:self.line];
    }
}

- (void)hidenLine{
    if (self.line) {
        [self.line removeFromSuperview];
    }
}

#pragma mark - GetterAndSetter
- (UIView *)line{
    return objc_getAssociatedObject(self, &lineViewKey);
}

- (void)setLine:(UIView *)line{
    objc_setAssociatedObject(self, &lineViewKey, line, OBJC_ASSOCIATION_RETAIN);
}


@end

#import <objc/runtime.h>
@implementation WMZDropMenuBtn (Time)
static const char *UIButton_acceptEventInterval = "UIButton_TJ_acceptEventInterval";
static const char *UIButton_acceptEventTime     = "UIButton_TJ_acceptEventTime";
- (NSTimeInterval )tj_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIButton_acceptEventInterval) doubleValue];
}
-(void)setTj_acceptEventInterval:(NSTimeInterval)tj_acceptEventInterval{
    objc_setAssociatedObject(self, UIButton_acceptEventInterval, @(tj_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval )tj_acceptEventTime{
    return [objc_getAssociatedObject(self, UIButton_acceptEventTime) doubleValue];
}
- (void)setTj_acceptEventTime:(NSTimeInterval)tj_acceptEventTime{
    objc_setAssociatedObject(self, UIButton_acceptEventTime, @(tj_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    Method myMethod = class_getInstanceMethod(self, @selector(tj_sendAction:to:forEvent:));
    SEL mySEL = @selector(tj_sendAction:to:forEvent:);
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
    }
}
- (void)tj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    //判断时间差
    if (NSDate.date.timeIntervalSince1970 - self.tj_acceptEventTime < self.tj_acceptEventInterval) {
        return;
    }
    //记录时间
    if (self.tj_acceptEventInterval > 0) {
        self.tj_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    //执行点击事件
    [self tj_sendAction:action to:target forEvent:event];
}
@end

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

@end
