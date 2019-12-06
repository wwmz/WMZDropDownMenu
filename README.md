# WMZDropDownMenu

实现功能
==============
- 组合自定义功能
- 支持自定义多选|单选|复选
- 支持自定义弹出的动画  (目前已实现向下,向左全屏,向右全屏,拼多多对话框弹出,boss直聘全屏弹出)
- 支持自定义tableView/collectionView头尾视图
- 支持自定义全局头尾视图
- 支持自定义collectionCell/tableViewCell视图
- 支持自定义标题
- 支持自定义点击回收视图
- 支持自定义回收列表
- 支持任意级的联动(由于数据比较庞杂,暂时自动适配不了无限级的联动,所以需要你调用一个方法更新数据传给我,详情看Demo)
- 支持嵌套使用,即两个筛选菜单可以连着使用
- 支持放在放在任意视图上,tableviewHeadView毫无疑问支持且无须写其他代码只要放上去即可
- 支持控制器消失自动关闭视图，无须再控制器消失方法里手动关闭
- 链式实现所有配置的自定义修改
(总之，你想要的基本都有,不想要的也有)



#目前已经用这控件实现的效果图
⚠️⚠️⚠️⚠️无须改变源码 只需要调用我的代理组合功能即可⚠️⚠️⚠️⚠️

### 仿闲鱼筛选菜单
![闲鱼1.gif](https://upload-images.jianshu.io/upload_images/9163368-0a03c6a2fc69c113.gif?imageMogr2/auto-orient/strip)

### 仿美团筛选菜单
 ![美团.gif](https://upload-images.jianshu.io/upload_images/9163368-af9d4c05f703f309.gif?imageMogr2/auto-orient/strip)

### 仿淘宝筛选菜单
![淘宝.gif](https://upload-images.jianshu.io/upload_images/9163368-64fa9419acc07992.gif?imageMogr2/auto-orient/strip)

### 饿了么筛选菜单
![饿了么.gif](https://upload-images.jianshu.io/upload_images/9163368-554a3805a1cb1d8b.gif?imageMogr2/auto-orient/strip)

### 京东筛选菜单
![京东.gif](https://upload-images.jianshu.io/upload_images/9163368-dedba78704246959.gif?imageMogr2/auto-orient/strip)

### 拼多多筛选菜单
![拼多多1.gif](https://upload-images.jianshu.io/upload_images/9163368-bbc3246bb8a10ec7.gif?imageMogr2/auto-orient/strip)

### 简书筛选菜单
![简书.gif](https://upload-images.jianshu.io/upload_images/9163368-c1a446591ccd5eae.gif?imageMogr2/auto-orient/strip)

### 赶集网筛选菜单
![赶集网.gif](https://upload-images.jianshu.io/upload_images/9163368-b06baad72ae259e6.gif?imageMogr2/auto-orient/strip)

### 美团外卖筛选菜单
![美团外卖.gif](https://upload-images.jianshu.io/upload_images/9163368-901a88b8d5dd0b36.gif?imageMogr2/auto-orient/strip)

### Boss直聘筛选菜单
![Boss直聘.gif](https://upload-images.jianshu.io/upload_images/9163368-162c065ae0f2dfef.gif?imageMogr2/auto-orient/strip)

### 唯品会筛选菜单
![唯品会.gif](https://upload-images.jianshu.io/upload_images/9163368-1cd346d22ed24a0f.gif?imageMogr2/auto-orient/strip)

### 一淘筛选菜单
![一淘.gif](https://upload-images.jianshu.io/upload_images/9163368-ea885fce6c81c9fa.gif?imageMogr2/auto-orient/strip)

#我手机只有这么一些app了。。~ ~ 总之，目前的app的筛选样式几乎都能实现，当然细节要自己去调

用法（组装全在一些代理里,代理方法可能有点多~ ~,不过只有两个是必实现的,其他的都是可选的）
==============
    WMZDropMenuDelegate 
    @required 一定实现的方法
    */
    - (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu;
    /*
    *返回WMZDropIndexPath每行 每列的数据
    */
    - (NSArray*)menu:(WMZDropDownMenu *)menu 
    dataForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
    @optional 可选实现的方法
    /*
    *返回setion行标题有多少列 默认1列
    */
    - (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection: 
     (NSInteger)section;
     /*
     *自定义tableviewCell内容 默认WMZDropTableViewCell 如果要使用默认的 
      cell返回 nil
     */
     - (UITableViewCell*)menu:(WMZDropDownMenu *)menu 
     cellForUITableView:(WMZDropTableView*)tableView AtIndexPath: 
     (NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model;
     /*
     *自定义tableView headView
     */
     - (UITableViewHeaderFooterView*)menu:(WMZDropDownMenu *)menu 
     headViewForUITableView:(WMZDropTableView*)tableView 
     AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
     /*
     *自定义tableView footView
     */
     - (UITableViewHeaderFooterView*)menu:(WMZDropDownMenu *)menu 
     footViewForUITableView:(WMZDropTableView*)tableView 
     AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;

     /*
     *自定义collectionViewCell内容
     */
     - (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu 
     cellForUICollectionView:(WMZDropCollectionView*)collectionView
     AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath: 
    (NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model;
     /*
    *自定义collectionView headView
    */
    - (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu 
    headViewForUICollectionView:(WMZDropCollectionView*)collectionView 
    AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath: 
    (NSIndexPath*)indexpath;

    /*
    *自定义collectionView footView
    */
    - (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu 
    footViewForUICollectionView:(WMZDropCollectionView*)collectionView 
    AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath: 
    (NSIndexPath*)indexpath;

    /*
    *headView标题
    */
    - (NSString*)menu:(WMZDropDownMenu *)menu 
    titleForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
    /*
    *footView标题
    */
    - (NSString*)menu:(WMZDropDownMenu *)menu 
    titleForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;


    /*
    *返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
    */
    - (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath: 
     (WMZDropIndexPath*)dropIndexPath AtIndexPath: 
     (NSIndexPath*)indexpath;
     /*
    *自定义headView高度 collectionView默认35
    */
    - (CGFloat)menu:(WMZDropDownMenu *)menu 
    heightForHeadViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
    /*
    *自定义footView高度
    */
     - (CGFloat)menu:(WMZDropDownMenu *)menu 
    heightForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;

    #pragma -mark 自定义用户交互的每行的头尾视图
    /*
     *自定义每行全局头部视图 多用于交互事件
     */
     - (UIView*)menu:(WMZDropDownMenu *)menu 
    userInteractionHeadViewInSection:(NSInteger)section;
     /*
     *自定义每行全局尾部视图 多用于交互事件
     */
     - (UIView*)menu:(WMZDropDownMenu *)menu 
     userInteractionFootViewInSection:(NSInteger)section;
    #pragma -mark 样式动画相关代理
     /*
    *返回WMZDropIndexPath每行 每列的UI样式  默认MenuUITableView
     注:设置了dropIndexPath.section 设置了 MenuUITableView 那么row则全部 
     为MenuUITableView 保持统一风格
     */
     - (MenuUIStyle)menu:(WMZDropDownMenu *)menu 
     uiStyleForRowIndexPath:(WMZDropIndexPath*)dropIndexPath;
      /*
      *返回section行标题数据视图出现的动画样式   默认 
      MenuShowAnimalBottom
      注:最后一个默认是筛选 弹出动画为 MenuShowAnimalRight
      */
      - (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu 
      showAnimalStyleForRowInSection:(NSInteger)section;
      /*
      *返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
      注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
       */
       - (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu 
      hideAnimalStyleForRowInSection:(NSInteger)section;
      /*
      *返回WMZDropIndexPath每行 每列的编辑类型 单选|多选  默认单选
      */
      - (MenuEditStyle)menu:(WMZDropDownMenu *)menu 
      editStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
      /*
      *返回WMZDropIndexPath每行 每列 显示的个数
       注:
       样式MenuUITableView         默认4个
       样式MenuUICollectionView    默认1个 传值无效
       */
       - (NSInteger)menu:(WMZDropDownMenu *)menu 
      countForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;
      /*
      *WMZDropIndexPath是否显示收缩功能 default >参数 
       wCollectionViewSectionShowExpandCount 显示
        */
       - (BOOL)menu:(WMZDropDownMenu *)menu 
      showExpandAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;

      /*
      *WMZDropIndexPath上的内容点击 是否关闭视图 default YES
      */
      - (BOOL)menu:(WMZDropDownMenu *)menu 
      closeWithTapAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath;

      /*
      *是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default 
      YES 取消，互不关联
      */
      - (BOOL)menu:(WMZDropDownMenu *)menu 
     dropIndexPathConnectInSection:(NSInteger)section;

     #pragma -mark 交互自定义代理
     /*
     *cell点击方法
     */
      - (void)menu:(WMZDropDownMenu *)menu 
     didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath
     dataIndexPath:(NSIndexPath*)indexpath data:(WMZDropTree*)data;
     /*
     *标题点击方法
     */
     - (void)menu:(WMZDropDownMenu *)menu didSelectTitleInSection: 
    (NSInteger)section btn:(WMZDropMenuBtn*)selectBtn;
     /*
     *确定方法 多个选择
      selectNoramalData 转化后的的模型数据
     selectData 字符串数据
     */
     - (void)menu:(WMZDropDownMenu *)menu didConfirmAtSection: 
    (NSInteger)section selectNoramelData:( 
    NSMutableArray*)selectNoramalData selectStringData: 
    (NSMutableArray*)selectData;


      /*
      *自定义标题按钮视图  返回配置 参数说明
      offset       按钮的间距
      y            按钮的y坐标   自动会居中
     */
     - (NSDictionary*)menu:(WMZDropDownMenu *)menu  
     customTitleInSection: 
     (NSInteger)section withTitleBtn:(WMZDropMenuBtn*)menuBtn;

     /*
    *自定义修改默认collectionView尾部视图
    */
    - (void)menu:(WMZDropDownMenu *)menu  
    customDefauultCollectionFootView:(WMZDropConfirmView*)confirmView;

配置-链式语法调用（都是可选实现的）
==============
### MenuTitle相关
| 参数               | 类型      | 作用   (默认值)                                 |
|------------------------|-----------|-----------------------------------------------------|
| wBorderShow                | BOOL        | 标题视图是否显示边框 default NO                     |
| wFixBtnWidth                | CGFLoat        | 固定标题的宽度 default 80   |
| wMenuTitleEqualCount                | NSInteger| 标题等分个数  用来控制标题的宽度 default 4                       |
| wMenuLine                | BOOL        | 标题按钮添加下划线 dfault NO   |
###弹出视图相关相关
| 参数               | 类型      | 作用   (默认值)                                 |
|------------------------|-----------|-----------------------------------------------------|
| wFixDataViewHeight                | CGFLoat        | 固定弹出显示数据层的高度  default 自动计算~>最大为屏幕高度的0.4倍                |
| wMainRadius                | CGFLoat        | 弹窗视图的圆角 默认0   |
| wMaxWidthScale                | CGFLoat| 最大屏幕宽度系数 default 0.9                   |
| wMaxHeightScale                | CGFLoat        | 最大屏幕高度系数 default 0.4  |
| wDefaultConfirmHeight                | CGFLoat        | 默认确定重置视图的高度  default 40             |
| wPopViewWidth                | CGFLoat        | 弹出动画为pop时候 视图的宽度  default 屏幕宽度/3   |
| wShadowColor                | UIColor        | 遮罩层颜色 default 333333  |
| wShadowAlpha                | CGFLoat| 遮罩层透明度  default 0.4                   |
| wShadowCanTap                | BOOL        | 遮罩层能否点击 default YES |
| wShadowShow                | BOOL        | 遮罩层是否显示 default YES            |
### tableview相关
| 参数               | 类型      | 作用   (默认值)                                 |
|------------------------|-----------|-----------------------------------------------------|
| wTableViewColor                | NSArray        | tableview的颜色 default @[FFFFFF,F6F7FA,EBECF0,FFFFFF]                     |
| wTextAlignment                | NSTextAlignment        | cell文本居中样式 default left   |
| wCellSelectShowCheck                | BOOL| tableViewCell 选中显示打钩图片 default YES                 |
### collectionView相关
| 参数               | 类型      | 作用   (默认值)                                 |
|------------------------|-----------|-----------------------------------------------------|
| wReginerCollectionCells            | NSArray        | 注册自定义的collectionViewCell  如果使用了自定义collectionView 必填否则会崩溃        |
| wReginerCollectionHeadViews        | NSArray        |注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填   |
| wReginerCollectionFootViews                | NSArray| 注册自定义的collectionViewFoootView  如果使用了自定义collectionViewFoootView 必填           |
| wCollectionViewCellSpace        | CGFloat        | colletionCell的间距  default 10 |
| wCollectionViewCellBgColor                | UIColor|colletionCell背景颜色  default 0x666666        |
| wCollectionViewCellTitleColor        | UIColor        | colletionCell文字颜色  default 0xf2f2f2|
| wCollectionViewCellSelectBgColor                | UIColor|colletionCell选中背景颜色  default 0xffeceb|
| wCollectionViewCellSelectTitleColor        | UIColor        | colletionCell选中文字颜色  default red|
| wCollectionViewCellBorderWith                | CGFloat| colletionCell borderWidth default 0   |
| wCollectionViewSectionShowExpandCount        | NSInteger        |colletionView section 超过多少个cell显示收缩按钮 default 6 |
| wCollectionViewSectionRecycleCount                | NSInteger| colletionView section 回收时候显示的cell数量 default 0   |
| wCollectionViewDefaultFootViewMarginY        | CGFloat        | colletionViewFootView 距离底部的距离 默认0 当iphonex机型为 20  |
| wCollectionViewDefaultFootViewPaddingY                | CGFloat|colletionViewFootView 距离顶部的距离 默认0        |


# 内容有点多 不过要兼容所有的筛选 需要开放很多接口出来自定义,~ ~
### 其他具体看demo
### 如果实在觉得代理繁多,直接看我demo哪个app像你要实现的效果 复制代码 稍加修改哈哈。。。。

### 依赖
无任何依赖 

安装
==============

### CocoaPods
1. 将 cocoapods 更新至最新版本.
2. 在 Podfile 中添加 `pod 'WMZDropDownMenu'`。
3. 执行 `pod install` 或 `pod update`。
4. 导入 #import "WMZDropDownMenu.h"。

### 注:要消除链式编程的警告 
要在Buildding Settings 把CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF 设为NO

### 手动安装
1. 下载 WMZDropDownMenu 文件夹内的所有内容。
2. 将 WMZDropDownMenu 内的源文件添加(拖放)到你的工程。
3. 导入 #import "WMZDropDownMenu.h"

使用过程中如果有什么bug或者使用的问题欢迎给我提issue或者加我qq  我看到就会解决
觉得有用的话给个star
[简书地址](https://www.jianshu.com/p/366d5bb08766)


###更新日记
- 20191206 新增代理 - (void)menu:(WMZDropDownMenu *)menu getAllSelectData:(NSArray*)selectData;（获取所有选中的数据）
- 20191206 新增代理 - (NSArray*)mutuallyExclusiveSectionsWithMenu:(WMZDropDownMenu *)menu;（互斥的标题数组 即互斥不能同时选中 返回标题对应的section (配合关联代理使用更加)）
- 20191206 新增实例方法 - (void)updateData:(NSArray*)arr AtDropIndexPathSection:(NSInteger)section AtDropIndexPathRow:(NSInteger)row （更新所有位置的数据 section表示所在行 row表示所在列）
- 20191206 cocopods 更新至1.0.1
