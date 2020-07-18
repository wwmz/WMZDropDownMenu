//
//  YiTaoDemo.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/29.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "YiTaoDemo.h"
#import "WMZDropDownMenu.h"
@interface YiTaoDemo ()<WMZDropMenuDelegate>
@property(nonatomic,strong)WMZDropMenuParam *param;
@property(nonatomic,strong)WMZDropDownMenu *menu ;
@end

@implementation YiTaoDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MenuColor(0x00A6FF);
    self.taData = @[@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",
                      @"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",
                     @"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",
                    @"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1", @"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",@"测试数据1",];
    UIView *headView = [UIView new];
    headView.backgroundColor =  MenuColor(0x00A6FF);
    headView.frame = CGRectMake(0, 0, Menu_Width, 400);
    self.ta.tableHeaderView = headView;
    [self.ta registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    
    
    
    self.param =
    MenuParam()
    .wMainRadiusSet(0)
    .wCollectionViewCellSelectTitleColorSet(MenuColor(0xFF003c))
    .wMenuTitleEqualCountSet(5);
    self.menu = [[WMZDropDownMenu alloc]initWithFrame:CGRectMake(0, 0, Menu_Width, 40) withParam:self.param];
    self.menu.delegate = self;

}

//返回所在视图
- (UIScrollView *)inScrollView{
    return self.ta;
}

- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    return @[
         @{@"name":@"人气排序",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"},
         @"",
         @{@"name":@"人气排序",@"normalImage":@"menu_treeCheck",
           @"selectImage":@"menu_treeCheckSelect"},
         @{@"name":@"人气排序",@"normalImage":@"menu_treeCheck",
           @"selectImage":@"menu_treeCheckSelect"},
         @{@"name":@"筛选",@"normalImage":@"menu_dowm",@"selectImage":@"menu_up"}
    ];
}


- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0)return 1;
    if (section == 4)return 2;
    return 0;
}

- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0){
        return @[@"人气排序",@"价格高到低",@"价格由低到高",@"销量优先"];
    }
    if (dropIndexPath.section == 4){
        if (dropIndexPath.row == 0) return @[@{@"config":@{@"lowPlaceholder":@"最低价",@"highPlaceholder":@"最高价"}}];
        if (dropIndexPath.row == 1) return @[@"免运费",@"天猫",@"消费者保障",@"正品保障",@"七天退换",@"货到付款"];
    }
    return @[];
}
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if(dropIndexPath.section == 0) return MenuEditOneCheck;
    if(dropIndexPath.section == 4 ){
        if (dropIndexPath.row == 1) return MenuEditMoreCheck;
        return MenuEditOneCheck;
    }
    return MenuEditCheck;
}

#define titleArr1 @[@"价格区间(元)",@"商家服务"]
- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4){
        return titleArr1[dropIndexPath.row];
    }
    return nil;
}

- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 1) return 0;
        return 20;
    }
    return 0;
}

- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) return MenuUITableView;
    if (dropIndexPath.section == 4){
        if (dropIndexPath.row == 0) {
            return MenuUICollectionRangeTextField;
        }
        return MenuUICollectionView;
    }
    return MenuUINone;
}

- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 4) {
        if (dropIndexPath.row == 0 || dropIndexPath.row == 2) {
            return 1;
        }
    }
    return 4;
}

- (NSDictionary*)menu:(WMZDropDownMenu *)menu customTitleInSection:(NSInteger)section withTitleBtn:(WMZDropMenuBtn *)menuBtn{
    if (section == 2||section == 3) {
        menuBtn.position = MenuBtnPositionLeft;
    }else if (section == 4) {
        [WMZDropMenuTool viewPathWithColor:MenuColor(0x999999) PathType:MenuShadowPathLeft PathWidth:MenuK1px heightScale:1 button:menuBtn];
    }
    return @{@"offset":@(5)};
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headView) {
        headView =  [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    //多个headView的时候 要传section
//    self.menu.tableViewHeadSection = section;
    [headView addSubview:self.menu];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



@end
