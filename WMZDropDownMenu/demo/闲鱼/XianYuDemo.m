

//
//  XianYuDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/24.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "XianYuDemo.h"
@interface XianYuDemo ()
{
    BOOL click;
}
@end

@implementation XianYuDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    WMZDropMenuParam *param =
    MenuParam()
    //自定义弹出视图frame
//    .wCustomDataViewRectSet(^CGRect(CGRect currentRect) {
//        currentRect.size.width = Menu_Width*0.8;
//        currentRect.origin.x = 0.1*Menu_Width;
//        return currentRect;
//    })
    //自定义弹出阴影frame
//    .wCustomShadomViewRectSet(^CGRect(CGRect currentRect) {
//        return currentRect;
//    })
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectBgColorSet(MenuColor(0xfff2f0))
    .wCollectionViewCellSelectTitleColorSet([UIColor orangeColor]);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, Menu_NavigationBar, Menu_Width, 40) withParam:param];
    menu.delegate = self;
    //更换背景颜色
//    menu.titleView.backgroundColor = [UIColor redColor];
    menu.tag = 111;
    [self.view addSubview:menu];

}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
        @{@"name":@"综合排序"},
        @"信用优先",   //取消默认图片
        @{@"name":@"区域"},
        @{@"name":@"筛选",@"normalImage":@"menu_shaixuan"},
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 5;
    }else if (section == 1){
        return 0;
    }else if (section == 2){
        return 3;
    }
    return 1;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        return @[@"综合排序",@"价格从低到高",@"价格从高到低",@"最新发布",@"离我最近"];
    }else if (dropIndexPath.section == 2) {
        if (dropIndexPath.row == 0) return @[@"广东省",@"陕西省",@"山东省",@"广西省"];
//        if (dropIndexPath.row == 1) return @[@"汕头市",@"广州市",@"深圳市",@"湛江市",@"珠海市"];
//        if (dropIndexPath.row == 2) return @[@"潮南区",@"潮阳区",@"金平区"];
    }else if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 0) {
            return @[@"全新",@"实拍",@"包邮",@"支持验货",@"玩家宝贝"];
        }else if (dropIndexPath.row == 1) {
            return @[
                @{@"image":@"menu_xinyong",@"name":@"芝麻信用 极好(700分)以上"},
                @{@"image":@"menu_xinyong",@"name":@"芝麻信用 优秀(650分)以上"},
                @{@"image":@"menu_xinyong",@"name":@"芝麻信用 良好(600分)以上"},
            ];
        }else if (dropIndexPath.row == 2) {
            return @[
                      @{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价",
//                        @"lowText":@"默认值1",@"highText":@"默认值2",
                      }}];
        }else if (dropIndexPath.row == 3) {
            return @[@"1天内",@"7天内",@"14天内",@"30天内"];
        }else if (dropIndexPath.row == 4) {
            return @[@"免费送",@"付邮送",@"我发布的"];
        }
    }
    return @[];
}

- (UIView*)menu:(WMZDropDownMenu *)menu userInteractionHeadViewInSection:(NSInteger)section{
    if (section == 2) {
        XianYuHeadView *headView = [XianYuHeadView new];
        headView.frame = CGRectMake(0, 0, menu.dataView.frame.size.width, 75);
        return headView;
    }
    return nil;
}

- (NSString*)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 0) return @"快捷筛选";
        if (dropIndexPath.row == 1) return @"卖家信用";
        if (dropIndexPath.row == 2) return @"价格";
        if (dropIndexPath.row == 3) return @"发布时间";
        if (dropIndexPath.row == 4) return @"其他";
    }
    return @"";
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 0) return 3;
        if (dropIndexPath.row == 1) return 1;
        if (dropIndexPath.row == 2) return 1;
        if (dropIndexPath.row == 4) return 3;
    }
    return 4;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return 30;
    }
    return 0;
}


- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 1) {
        return MenuUINone;
    }else if (dropIndexPath.section == 3) {
        if (dropIndexPath.row == 2) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUITableView;
}

- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 1) return MenuEditNone;
    else if (dropIndexPath.section == 3 && dropIndexPath.row == 0) return MenuEditMoreCheck;
    return MenuEditOneCheck;
}


- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 2) {
        if (dropIndexPath.row == 2) return YES;
        else return NO;
    }else if (dropIndexPath.section == 0) {
        return YES;
    }
    return NO;
}

/*
*点击方法
*/
- (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree*)data{
    NSLog(@"标题所在列:%ld \n 联动层级:%ld  \n 点击indexPath:%@ \n 点击的数据 :%@",dropIndexPath.section,dropIndexPath.row,indexpath,data);
    //三级联动示例
    if (dropIndexPath.section == 2) {
        //更新第二层
        if (dropIndexPath.row  == 0) {
            [menu updateData:[self oneData][data.name] ForRowAtDropIndexPath:dropIndexPath];
        }else if (dropIndexPath.row  == 1) {  //更新第三层
            [menu updateData:[self twoData][data.name] ForRowAtDropIndexPath:dropIndexPath];
        }
    }
}

//模拟点击标题网络请求数据
- (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection:(NSInteger)section btn:(WMZDropMenuBtn *)selectBtn networkBlock:(MenuAfterTime)block{
    if (section == 0) {
        //判断是否是选中的状态 选中的状态则直接block
        if ([selectBtn isSelected]) {
             block();
        }else{
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
            [self.view addSubview:activityIndicator];
            activityIndicator.frame= CGRectMake((self.view.frame.size.width - 100)/2, 100, 100, 100);
            activityIndicator.color = [UIColor redColor];
            [activityIndicator startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
                [menu updateData:@[@"综合排序",@"价格从低到高1",@"价格从高到低",@"最新发布",@"离我最近"] AtDropIndexPathSection:0 AtDropIndexPathRow:0];
                block();  //结束的标志
            });
        }
    }else{
        block();
    }
}


- (NSDictionary*)oneData{
    return @{
              @"广东省":@[@"汕头市",@"普宁市",@"潮州市"],
              @"陕西省":@[@"汕头市1",@"普宁市1"],
              @"山东省":@[@"汕头市2",@"普宁市2"],
              @"广西省":@[@"汕头市3",@"普宁市3"],
    };
}
- (NSDictionary*)twoData{
    return @{
              @"汕头市":@[@"全部1",@"水果",@"蔬菜",@"冷冻速食",@"肉禽奶蛋",@"肉饼加墨"],
              @"普宁市":@[@"全部2",@"水果1",@"蔬菜1"],
              @"潮州市":@[@"全部3",@"水果2",@"蔬菜2",@"肉禽奶蛋2",@"肉饼加墨2"],
              @"汕头市1":@[@"全部4",@"水果3",@"蔬菜3",@"肉饼加墨3"],
              @"普宁市1":@[@"全部5",@"水果4",@"冷冻速食4"],
              @"汕头市2":@[@"全部6",@"冷冻速食5",@"肉禽奶蛋5"],
              @"普宁市2":@[@"全部7",@"冷冻速食6",@"肉禽奶蛋6"],
              @"汕头市3":@[@"全部8",@"冷冻速食7",@"肉禽奶蛋7"],
              @"普宁市3":@[@"全部9",@"冷冻速食8",@"肉禽奶蛋8"],
    };
}

@end






@implementation XianYuHeadView
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.headLa];
        [self addSubview:self.detailLa];
        [self addSubview:self.refreshBtn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.headLa.frame = CGRectMake(20, 10, self.frame.size.width-40, 25);
    self.detailLa.frame = CGRectMake(20, CGRectGetMaxY(self.headLa.frame), self.frame.size.width - 80, 30);
    self.refreshBtn.frame = CGRectMake(self.frame.size.width - 75, CGRectGetMaxY(self.headLa.frame), 60, 30);
}
- (UILabel *)headLa{
    if (!_headLa) {
        _headLa = [UILabel new];
        _headLa.text = @"当前位置";
        _headLa.font = [UIFont systemFontOfSize:12.0];
        _headLa.textColor = MenuColor(0x666666);
    }
    return _headLa;
}
- (UILabel *)detailLa{
    if (!_detailLa) {
        _detailLa = [UILabel new];
        _detailLa.text = @"广州";
        _detailLa.font = [UIFont systemFontOfSize:15.0];
    }
    return _detailLa;
}
- (UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitleColor:MenuColor(0x00A6FF) forState:UIControlStateNormal];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_refreshBtn setImage:[UIImage bundleImage:@"menu_refresh"] forState:UIControlStateNormal];
    }
    return _refreshBtn;
}
@end
