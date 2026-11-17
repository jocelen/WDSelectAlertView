//
//  Tests.m
//  WDSelectAlertViewTests
//
//  Created by jocelen on 04/16/2021.
//  Copyright (c) 2021 jocelen. All rights reserved.
//

@import XCTest;
@import WDSelectAlertView;

#import "../WDSelectAlertView/WDViewController.h"
#import "../WDSelectAlertView/UIViewController+SelectPopView.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)testSelectAlertStyleModelAndBackwardCompatibility {
    WDSelectAlertStyleModel *model = [WDSelectAlertStyleModel defaultStyle];
    XCTAssertEqual(model.materialStyle, WDAlertMaterialStyleAutomatic);
    XCTAssertFalse(model.hasCustomBackgroundColor);
    XCTAssertEqualObjects(model.sureTitle, @"确定");
    XCTAssertEqualObjects(model.cancelTitle, @"取消");

    // 传空字符串不应覆盖默认按钮文案
    model.sureTitle = @"";
    XCTAssertEqualObjects(model.sureTitle, @"确定");

    // title 置空应生效
    model.title = @"提示";
    XCTAssertTrue(model.hasTitle);
    model.title = nil;
    XCTAssertFalse(model.hasTitle);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIColor *customColor = UIColor.purpleColor;
    model.backgroudColor = customColor;
    XCTAssertEqualObjects(model.backgroundColor, customColor);
    XCTAssertEqualObjects(model.backgroudColor, customColor);
    XCTAssertTrue(model.hasCustomBackgroundColor);

    model.lineSapceHeight = 1.5;
    XCTAssertEqualWithAccuracy(model.lineSpaceHeight, 1.5, 0.001);

    BCAlertViewPositionType legacyPos = BCAlertViewPositionTypeBottom;
    XCTAssertEqual(legacyPos, WDAlertViewPositionTypeBottom);
#pragma clang diagnostic pop
}

- (void)testSelectAlertViewLayoutAndRichTextAllOccurrences {
    WDSelectAlertStyleModel *model = [WDSelectAlertStyleModel defaultStyle];
    model.title = @"服务协议";
    model.content = @"请阅读《隐私政策》与《用户协议》，再次确认《隐私政策》条款。";
    model.highlightArr = @[@"再次确认"];
    model.linkArr = @[@"《隐私政策》", @"《用户协议》"];

    WDSelectAlertView *alertView = [[WDSelectAlertView alloc] initWithModel:model];
    CGFloat height = [alertView layoutAlertHeight];
    XCTAssertGreaterThan(height, model.titleHeight + model.selectButtonHeight);
    alertView.frame = CGRectMake(0, 0, model.maxAlertWidth, height);
    [alertView layoutIfNeeded];
    XCTAssertEqualWithAccuracy(CGRectGetHeight(alertView.bounds), height, 0.5);
}

- (void)testSheetAlertStyleAndModernButtonConfiguration {
    WDSheetAlertStyleModel *model = [WDSheetAlertStyleModel defaultStyle];
    model.title = @"操作菜单";
    model.dataArr = @[@"编辑", @"置顶", @"删除"];
    model.disabledDataArr = @[@"置顶"];
    model.selectedIndex = 0;
    model.selectedEnabled = YES;

    WDSheetAlertView *sheetView = [[WDSheetAlertView alloc] initWithModel:model];
    sheetView.frame = CGRectMake(0, 0, 390.0, 0);
    [sheetView updateFrame];
    [sheetView layoutIfNeeded];

    XCTAssertGreaterThan(CGRectGetHeight(sheetView.frame), model.cellHeight * 3);

    WDSheetAlertButton *btn = [WDSheetAlertButton buttonWithType:UIButtonTypeCustom];
    btn.edgeInsets = UIEdgeInsetsMake(4, 12, 4, 12);
    [btn setIconInRightWithSpacing:10.0];
    XCTAssertNotNil(btn.configuration);
    XCTAssertEqual(btn.configuration.imagePlacement, NSDirectionalRectEdgeTrailing);
    XCTAssertEqualWithAccuracy(btn.configuration.imagePadding, 10.0, 0.001);
}

- (void)testDateAlertViewAndYearMonthBounds {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *minComp = [[NSDateComponents alloc] init];
    minComp.year = 2020;
    minComp.month = 1;
    minComp.day = 1;
    NSDate *minDate = [gregorian dateFromComponents:minComp];

    NSDateComponents *maxComp = [[NSDateComponents alloc] init];
    maxComp.year = 2030;
    maxComp.month = 12;
    maxComp.day = 31;
    NSDate *maxDate = [gregorian dateFromComponents:maxComp];

    WDDateAlertStyleModel *model = [WDDateAlertStyleModel defaultStyle];
    model.style = WDDateAlertStyleYYYYMM;
    model.locale = nil; // 验证 locale 为空时不崩溃
    model.minimumDate = minDate;
    model.maximumDate = maxDate;
    model.date = minDate;

    WDDateAlertView *dateView = [[WDDateAlertView alloc] initWithModel:model];
    dateView.frame = CGRectMake(0, 0, 390.0, 260.0);
    [dateView layoutIfNeeded];

    XCTAssertEqual([dateView.datePickView numberOfComponents], 2);
    XCTAssertEqual([dateView.datePickView numberOfRowsInComponent:0], 11); // 2020..2030 共 11 年
}

- (void)testDateIntervalStepCarryAndBorrow {
    WDDateIntervalPickView *picker = [[WDDateIntervalPickView alloc] initWithFrame:CGRectMake(0, 0, 180, 200)];
    picker.style = WDDateIntervalAlertStyleHHMM;

    picker.currentValue = @"08:59";
    XCTAssertEqualObjects(picker.currentValue, @"08:59");

    // 59 -> 00 应进位为 09:00
    [picker nextStep];
    XCTAssertEqualObjects(picker.currentValue, @"09:00");

    // 09:00 -> 退一步应借位为 08:59
    [picker previousStep];
    XCTAssertEqualObjects(picker.currentValue, @"08:59");
}

- (void)testKeyValueAlertViewBoundsSafety {
    WDKeyValueAlertStyleModel *emptyModel = [WDKeyValueAlertStyleModel defaultStyle];
    WDKeyValueAlertView *emptyView = [[WDKeyValueAlertView alloc] initWithModel:emptyModel];
    emptyView.selectIndex = 5;
    XCTAssertEqual(emptyView.selectIndex, -1);

    WDKeyValueAlertStyleModel *model = [WDKeyValueAlertStyleModel defaultStyle];
    model.keyArr = @[@"A", @"B", @"C"];
    model.valueArr = @[@"1", @"2", @"3"];

    WDKeyValueAlertView *kvView = [[WDKeyValueAlertView alloc] initWithModel:model];
    kvView.frame = CGRectMake(0, 0, 390.0, 280.0);
    kvView.selectIndex = 99;
    XCTAssertEqual(kvView.selectIndex, 2);

    kvView.selectIndex = -10;
    XCTAssertEqual(kvView.selectIndex, 0);
}

- (void)testWindowViewControllerLazyViewLoading {
    WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
    style.dismissNotificationKey = @"kTestDismissAlertNotification";

    WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];
    // 初始化阶段严禁提前触发 loadView / viewDidLoad
    XCTAssertFalse(vc.isViewLoaded);

    UIView *dummy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
    vc.contentView = dummy;
    XCTAssertFalse(vc.isViewLoaded);

    // 访问 view 后正常挂载并布局
    vc.view.frame = CGRectMake(0, 0, 393, 852);
    [vc.view layoutIfNeeded];
    XCTAssertTrue(vc.isViewLoaded);
    XCTAssertEqualObjects(dummy.superview, vc.view);
    XCTAssertEqualWithAccuracy(dummy.center.x, 393.0 / 2.0, 0.5);
    XCTAssertEqualWithAccuracy(dummy.center.y, 852.0 / 2.0, 0.5);
}

- (void)testHelperHexColorsAndMetrics {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    UIColor *rgb6 = [WDSelectAlertHelper toHexColor:@"#DC3045"];
    [rgb6 getRed:&r green:&g blue:&b alpha:&a];
    XCTAssertEqualWithAccuracy(r, 220.0 / 255.0, 0.01);
    XCTAssertEqualWithAccuracy(a, 1.0, 0.01);

    UIColor *rgba8 = [WDSelectAlertHelper toHexColor:@"#DC304580"];
    [rgba8 getRed:&r green:&g blue:&b alpha:&a];
    XCTAssertEqualWithAccuracy(a, 128.0 / 255.0, 0.01);

    UIColor *invalid = [WDSelectAlertHelper toHexColor:@"invalid"];
    [invalid getRed:&r green:&g blue:&b alpha:&a];
    XCTAssertEqualWithAccuracy(a, 0.0, 0.01);

    CGRect bounds = [WDSelectAlertHelper currentWindowBounds];
    XCTAssertGreaterThan(bounds.size.width, 0);
    XCTAssertGreaterThan([WDSelectAlertHelper adaptScreenSize:50.0], 0);
}

- (void)testLiveAlertTransitionsAndNavigationActions {
    UIWindow *window = [WDSelectAlertHelper activeKeyWindow];
    XCTAssertNotNil(window);
    UINavigationController *nav = (UINavigationController *)window.rootViewController;
    UIViewController *topVC = [nav isKindOfClass:[UINavigationController class]] ? nav.topViewController : window.rootViewController;
    XCTAssertNotNil(topVC);

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];

    NSArray<NSNumber *> *styles = @[
        @(WDAlertMaterialStyleAutomatic),
        @(WDAlertMaterialStyleGlass),
        @(WDAlertMaterialStyleClearGlass),
        @(WDAlertMaterialStyleSolid)
    ];
    for (NSNumber *styleNum in styles) {
        topVC.wd_demoMaterialStyle = (WDAlertMaterialStyle)styleNum.integerValue;
        [topVC showAlertSelect:@"测试标题" message:@"测试内容" selectAction:nil];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.35]];
        [topVC dismissViewControllerAnimated:YES completion:nil];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    }

    if ([nav isKindOfClass:[UINavigationController class]]) {
        [self tapAllBarButtonsInView:nav.navigationBar onController:topVC];
    }
}

- (void)tapAllBarButtonsInView:(UIView *)root onController:(UIViewController *)topVC {
    if ([root isKindOfClass:[UIControl class]] && [NSStringFromClass([root class]) containsString:@"ButtonBarButton"]) {
        UIControl *control = (UIControl *)root;
        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.35]];
        [topVC dismissViewControllerAnimated:YES completion:nil];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
        return;
    }
    for (UIView *sub in root.subviews) {
        [self tapAllBarButtonsInView:sub onController:topVC];
    }
}

@end
