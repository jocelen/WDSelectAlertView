//
//  WDViewController.m
//  WDSelectAlertView
//
//  Created by jocelen on 04/16/2021.
//  Copyright (c) 2021 jocelen. All rights reserved.
//

#import "WDViewController.h"
#import "UIViewController+SelectPopView.h"

@interface WDViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *titleArr;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *dataArr;

@end

@implementation WDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadConfig];
    [self addSubviews];
    [self loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Private Methods

- (void)loadConfig {
    self.title = @"WDSelectAlertView (iOS 26)";
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    [self setupNavigationMenus];
}

- (void)setupNavigationMenus {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"材质"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(didTapMaterialButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"外观"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didTapAppearanceButton)];
}

- (void)didTapMaterialButton {
    NSArray<NSString *> *items = @[
        @"自动 (iOS 26 Liquid Glass)",
        @"标准玻璃 (Regular Glass)",
        @"通透玻璃 (Clear Glass)",
        @"纯色卡片 (Solid)"
    ];
    NSInteger currentIndex = 0;
    switch (self.wd_demoMaterialStyle) {
        case WDAlertMaterialStyleAutomatic:
            currentIndex = 0;
            break;
        case WDAlertMaterialStyleGlass:
            currentIndex = 1;
            break;
        case WDAlertMaterialStyleClearGlass:
            currentIndex = 2;
            break;
        case WDAlertMaterialStyleSolid:
            currentIndex = 3;
            break;
    }

    __weak typeof(self) weakSelf = self;
    [self showSheetSelect:@"选择弹窗材质风格"
              selectItems:items
            selectedIndex:currentIndex
             disAbleItems:nil
             selectAction:^(NSInteger index) {
        switch (index) {
            case 0:
                weakSelf.wd_demoMaterialStyle = WDAlertMaterialStyleAutomatic;
                break;
            case 1:
                weakSelf.wd_demoMaterialStyle = WDAlertMaterialStyleGlass;
                break;
            case 2:
                weakSelf.wd_demoMaterialStyle = WDAlertMaterialStyleClearGlass;
                break;
            case 3:
                weakSelf.wd_demoMaterialStyle = WDAlertMaterialStyleSolid;
                break;
            default:
                break;
        }
    }];
}

- (void)didTapAppearanceButton {
    UIWindow *window = self.view.window;
    NSInteger currentIndex = 0;
    if (window.overrideUserInterfaceStyle == UIUserInterfaceStyleLight) {
        currentIndex = 1;
    } else if (window.overrideUserInterfaceStyle == UIUserInterfaceStyleDark) {
        currentIndex = 2;
    }

    __weak typeof(self) weakSelf = self;
    [self showSheetSelect:@"选择外观模式"
              selectItems:@[@"跟随系统", @"浅色模式", @"深色模式"]
            selectedIndex:currentIndex
             disAbleItems:nil
             selectAction:^(NSInteger index) {
        UIWindow *targetWindow = weakSelf.view.window;
        if (index == 1) {
            targetWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        } else if (index == 2) {
            targetWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        } else {
            targetWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        }
    }];
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    self.titleArr = @[@"容器位置弹框", @"确认/富文本弹框", @"选项弹框 (Sheet)", @"日期选择", @"时段选择", @"其他选择"];
    self.dataArr = @[
        @[@"顶部 + 遮罩模糊", @"居中 + 禁止点击空白关闭", @"底部 + 点击空白关闭"],
        @[@"单按钮确认", @"双按钮选择", @"长文本滚动展示", @"自定义按钮文案", @"高亮与可点击链接富文本"],
        @[@"基础选项", @"带多行标题选项", @"默认选中第一项 + 勾选图标", @"超多行可滚动选项"],
        @[@"日期 YYYY-MM-DD", @"年月 YYYY-MM", @"年份 YYYY"],
        @[@"时段 HH (整点)", @"时段 HH:MM (支持跨整点进借位)"],
        @[@"双列键值对选择"]
    ];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
        table.delegate = self;
        table.dataSource = self;
        _tableView = table;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.dataArr[(NSUInteger)section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArr[(NSUInteger)section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArr[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
        if (row == 0) {
            style.isGroundGlass = YES;
            style.canTouchCancel = YES;
            style.position = WDAlertViewPositionTypeTop;
        } else if (row == 1) {
            style.isGroundGlass = NO;
            style.canTouchCancel = NO;
            style.position = WDAlertViewPositionTypeCenter;
        } else {
            style.isGroundGlass = NO;
            style.canTouchCancel = YES;
            style.position = WDAlertViewPositionTypeBottom;
        }

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat width = (row == 1) ? MIN(CGRectGetWidth(self.view.bounds) - 64.0, 300.0) : CGRectGetWidth(self.view.bounds);
        button.frame = CGRectMake(0, 0, width, 150.0);
        button.layer.cornerRadius = (row == 1) ? 20.0 : 0.0;
        button.layer.cornerCurve = kCACornerCurveContinuous;
        button.backgroundColor = [UIColor.systemRedColor colorWithAlphaComponent:0.9];
        [button setTitle:@"点击关闭自定义内容" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];

        WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];
        vc.contentView = button;
        [self presentViewController:vc animated:YES completion:nil];
    } else if (section == 1) {
        if (row == 0) {
            [self showAlertSure:nil message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。" sureTitle:@"知道了" selectAction:nil];
        } else if (row == 1) {
            [self showAlertSelect:@"关雎"
                          message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。\n参差不齐的荇菜，在船的左右两边摘取。"
                     selectAction:nil];
        } else if (row == 2) {
            [self showAlertSelect:@"关雎（长文）"
                          message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，日日夜夜都想追求她。\n追求却没法得到，日日夜夜总思念她。绵绵不断的思念，叫人翻来覆去难入睡。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，弹琴鼓瑟来亲近她。\n参差不齐的荇菜，在船的左右两边去挑选它。贤良美好的女子，敲起钟鼓来取悦她。\n关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，日日夜夜都想追求她。\n追求却没法得到，日日夜夜总思念她。绵绵不断的思念，叫人翻来覆去难入睡。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，弹琴鼓瑟来亲近她。\n参差不齐的荇菜，在船的左右两边去挑选它。贤良美好的女子，敲起钟鼓来取悦她。"
                        sureTitle:@"背诵十遍"
                     selectAction:nil];
        } else if (row == 3) {
            [self showAlertSelect:@"关雎"
                          message:@"参差不齐的荇菜，在船的左右两边去挑选它。贤良美好的女子，敲起钟鼓来取悦她。"
                        sureTitle:@"立即背诵"
                      cancelTitle:@"稍后再说"
                     selectAction:nil];
        } else {
            WDSelectAlertStyleModel *model = [WDSelectAlertStyleModel defaultStyle];
            model.materialStyle = self.wd_demoMaterialStyle;
            model.contentTextAlignment = NSTextAlignmentLeft;
            model.title = @"协议与高亮演示";
            model.content = @"关关雎鸠，在河之洲。窈窕淑女，君子好逑。\n参差荇菜，左右流之。窈窕淑女，寤寐求之。\n求之不得，寤寐思服。悠哉悠哉，辗转反侧。\n参差荇菜，左右芼之。";
            model.highlightArr = @[@"在河之洲", @"左右流之", @"寤寐思服"];
            model.highlightFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
            model.highlightColor = UIColor.systemOrangeColor;

            model.linkArr = @[@"窈窕淑女", @"左右芼之", @"悠哉悠哉"];
            model.linkFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            model.linkColor = UIColor.systemBlueColor;

            model.sureTitle = @"超长标题自适应缩放同意✅";
            model.sureTitleFont = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
            model.sureTitleAdjusts = YES;
            model.sureTitleMinimumScaleFactor = 0.5;

            model.cancelTitle = @"放弃";

            [self showAlertCustomize:model clickAction:^(NSInteger index) {
                NSLog(@"点击链接下标: %ld", (long)index);
            } selectAction:nil];
        }
    } else if (section == 2) {
        NSString *title = (row == 1) ? @"温馨提示\n关关雎鸠，在河之洲。窈窕淑女，君子好逑。" : nil;
        NSArray<NSString *> *selects = (row == 3)
            ? @[@"温馨提示：这是一条超长选项文案，自动支持多行换行展示，适配 iOS 26 液态玻璃", @"关关雎鸠", @"在河之洲", @"窈窕淑女", @"君子好逑", @"参差荇菜", @"不可选", @"左右流之", @"寤寐求之", @"琴瑟友之", @"钟鼓乐之"]
            : @[@"拍照", @"不可选", @"从相册选择"];
        NSInteger selectIndex = (row == 2) ? 0 : -1;
        [self showSheetSelect:title
                  selectItems:selects
                selectedIndex:selectIndex
                 disAbleItems:@[@"不可选"]
                 selectAction:^(NSInteger index) {
            NSLog(@"选中 Sheet 下标: %ld", (long)index);
        }];
    } else if (section == 3) {
        WDDateAlertStyle style = WDDateAlertStyleYYYYMMDD;
        if (row == 1) {
            style = WDDateAlertStyleYYYYMM;
        } else if (row == 2) {
            style = WDDateAlertStyleYYYY;
        }
        [self showDateSelect:[NSDate date]
                 minimumDate:nil
                 maximumDate:nil
                       style:style
                changeAction:^(NSDate * _Nonnull date) {
            NSLog(@"滚动日期: %@", date);
        } selectAction:^(BOOL isSure, NSDate * _Nonnull date) {
            NSLog(@"确认(%d)日期: %@", isSure, date);
        }];
    } else if (section == 4) {
        WDDateIntervalAlertStyle intervalStyle = (row == 0) ? WDDateIntervalAlertStyleHH : WDDateIntervalAlertStyleHHMM;
        NSArray<NSString *> *dates = (row == 0) ? @[@"08", @"12"] : @[@"08:59", @"09:00"];
        [self showDateParagraphSelect:dates style:intervalStyle selectAction:^(BOOL isSure, NSString * _Nonnull begin, NSString * _Nonnull end) {
            NSLog(@"确认(%d)时段: %@ -- %@", isSure, begin, end);
        }];
    } else if (section == 5) {
        NSArray<NSString *> *keys = @[@"一", @"二", @"三", @"四", @"五", @"六"];
        NSArray<NSString *> *values = @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six"];
        [self showKeyValueSelect:keys valueArr:values index:1 selectAction:^(BOOL isSure, NSInteger index) {
            NSLog(@"确认(%d)键值对下标: %ld", isSure, (long)index);
        }];
    }
}

@end
