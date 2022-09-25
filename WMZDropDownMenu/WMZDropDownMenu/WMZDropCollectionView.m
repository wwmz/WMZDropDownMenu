//
//  WMZDropCollectionView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropCollectionView.h"

@implementation WMZDropCollectionView

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
