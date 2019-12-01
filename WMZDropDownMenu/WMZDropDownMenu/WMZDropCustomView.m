//
//  WMZDropCustomView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropCustomView.h"

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

@implementation WMZDropTableView
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

@implementation WMZDropCollectionView
@end

@implementation WMZMenuCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self.contentView addSubview:self.btn];
        self.btn.layer.masksToBounds = YES;
        self.btn.userInteractionEnabled = NO;
        self.btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
     self.btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
     self.btn.layer.cornerRadius = 8;
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _btn;
}
@end
@interface WMZMenuTextFieldCell()<UITextFieldDelegate>

@end
@implementation WMZMenuTextFieldCell
-(instancetype)initWithFrame:(CGRect)frame
{
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
        self.lowText.font = [UIFont systemFontOfSize:15.0];
        self.highText.font = [UIFont systemFontOfSize:15.0];
        self.highText.delegate = self;
        self.highText.textAlignment = NSTextAlignmentCenter;
        self.lowText.textAlignment = NSTextAlignmentCenter;
        self.lowText.keyboardType = UIKeyboardTypeDecimalPad;
        self.highText.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *mainText = @"";
    if ([string isEqual:@""]) {
        if (![textField.text isEqualToString:@""]) {
            mainText = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            mainText = textField.text;
        }
    }else{
        mainText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    self.myBlock(textField,mainText);
    return YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.lowText.frame = CGRectMake(0, 0, self.frame.size.width*0.45, self.frame.size.height);
    self.lowText.layer.cornerRadius = 8;
    self.lineLa.frame = CGRectMake(0, 0, self.frame.size.width*0.1, self.frame.size.height);
    self.lineLa.center = self.contentView.center;
    self.highText.frame = CGRectMake(self.frame.size.width*0.55, 0, self.frame.size.width*0.45, self.frame.size.height);
    self.highText.layer.cornerRadius = 8;
}
- (UITextField *)lowText{
    if (!_lowText) {
        _lowText = [UITextField new];
        _lowText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _lowText;
}
- (UITextField *)highText{
    if (!_highText) {
        _highText = [UITextField new];
        _highText.leftViewMode = UITextFieldViewModeAlways;
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
        self.textLa.frame = CGRectMake(Menu_GetWNum(30), 0, frame.size.width*0.85, frame.size.height);
        [self addSubview:self.accessTypeBtn];
        self.accessTypeBtn.frame = CGRectMake(CGRectGetMaxX(self.textLa.frame) , 0, 30, frame.size.height);
    }
    return self;
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
