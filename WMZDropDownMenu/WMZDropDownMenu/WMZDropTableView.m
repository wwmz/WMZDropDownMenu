//
//  WMZDropTableView.m
//  WMZDropDownMenu
//
//  Created by wmz on 2020/7/14.
//  Copyright © 2020 wmz. All rights reserved.
//

#import "WMZDropTableView.h"
#import "WMZDropDownMenu.h"

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
    self.textLa.frame = CGRectMake(10, 0, self.contentView.frame.size.width - 20, self.contentView.frame.size.height);
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


