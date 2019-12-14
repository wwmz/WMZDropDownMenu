//
//  ViewController.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "ViewController.h"
#import "WMZDropDwonMenuConfig.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary *dic;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最全筛选列表控件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.taData = @[@"展示全部属性和代理(仅用于参考用法)",@"闲鱼(三级联动参考)",@"美团",@"淘宝",@"饿了么"
                    ,@"京东",@"拼多多",@"简书",@"赶集网(标题关联相关)",
                    @"美团外卖(二级联动参考)",@"Boss直聘",@"唯品会(嵌套使用)",
                    @"一淘(放在tableViewHead上)"];
    
    UITableView *ta = [[UITableView alloc]initWithFrame:CGRectMake(0, Menu_NavigationBar, self.view.frame.size.width,self.view.frame.size.height-Menu_NavigationBar) style:UITableViewStylePlain];
    [self.view addSubview:ta];
    ta.estimatedRowHeight = 0.01;
    ta.dataSource = self;
    ta.delegate = self;
    self.ta = ta;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 0.01;}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{return nil;}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{return nil;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return [self.taData count];}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 1;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = self.taData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [NSClassFromString(self.dic[@(indexPath.row)]) new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSDictionary *)dic{
    if (!_dic) {
        _dic = @{
            @(0):@"ShowDemo",
            @(1):@"XianYuDemo",
            @(2):@"MeiTuanDemo",
            @(3):@"TaoBaoDdemo",
            @(4):@"ElMentDemo",
            @(5):@"JingDongDemo",
            @(6):@"PinDDDemo",
            @(7):@"JianShuDemo",
            @(8):@"GanJiDemo",
            @(9):@"MeiTuanWMDemo",
            @(10):@"BossDemo",
            @(11):@"WeiPinDemo",
            @(12):@"YiTaoDemo",
        };
    }
    return _dic;
}

@end
