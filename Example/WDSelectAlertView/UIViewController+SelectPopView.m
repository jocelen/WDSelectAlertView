//
//  UIViewController+SelectPopView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "UIViewController+SelectPopView.h"
#import <objc/runtime.h>

static const void *kWDDemoMaterialStyleKey = &kWDDemoMaterialStyleKey;

@implementation UIViewController (SelectPopView)

- (WDAlertMaterialStyle)wd_demoMaterialStyle {
    NSNumber *num = objc_getAssociatedObject(self, kWDDemoMaterialStyleKey);
    return num ? (WDAlertMaterialStyle)num.integerValue : WDAlertMaterialStyleAutomatic;
}

- (void)setWd_demoMaterialStyle:(WDAlertMaterialStyle)wd_demoMaterialStyle {
    objc_setAssociatedObject(self, kWDDemoMaterialStyleKey, @(wd_demoMaterialStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 确认/选择弹框

- (void)showAlertSelect:(NSString *)message selectAction:(WDAlertSelectOptionsBlock)handler {
    [self showAlertSelect:nil message:message sureTitle:nil cancelTitle:nil selectAction:handler];
}

- (void)showAlertSelect:(NSString *)title message:(NSString *)message selectAction:(WDAlertSelectOptionsBlock)handler {
    [self showAlertSelect:title message:message sureTitle:nil cancelTitle:nil selectAction:handler];
}

- (void)showAlertSelect:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle selectAction:(WDAlertSelectOptionsBlock)handler {
    [self showAlertSelect:title message:message sureTitle:sureTitle cancelTitle:nil selectAction:handler];
}

- (void)showAlertSelect:(NSString *)title
                message:(NSString *)message
              sureTitle:(NSString *)sureTitle
            cancelTitle:(NSString *)cancelTitle
           selectAction:(WDAlertSelectOptionsBlock)handler {
    WDSelectAlertStyleModel *model = [WDSelectAlertStyleModel defaultStyle];
    model.materialStyle = self.wd_demoMaterialStyle;
    model.title = title;
    model.content = message;
    model.sureTitle = sureTitle;
    model.cancelTitle = cancelTitle;
    model.isOptional = YES;
    [self showAlertCustomize:model clickAction:nil selectAction:handler];
}

- (void)showAlertSure:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle selectAction:(WDAlertSelectOptionsBlock)handler {
    WDSelectAlertStyleModel *model = [WDSelectAlertStyleModel defaultStyle];
    model.materialStyle = self.wd_demoMaterialStyle;
    model.title = title;
    model.content = message;
    model.sureTitle = sureTitle;
    model.isOptional = NO;
    [self showAlertCustomize:model clickAction:nil selectAction:handler];
}

- (void)showAlertCustomize:(WDSelectAlertStyleModel *)model
               clickAction:(WDAlertClickItemBlock)click
              selectAction:(WDAlertSelectOptionsBlock)handler {
    if (model == nil || model.content.length == 0) {
        return;
    }

    WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.position = WDAlertViewPositionTypeCenter;

    WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];

    WDSelectAlertView *content = [[WDSelectAlertView alloc] initWithModel:model];
    [content layoutAlertHeight];
    content.frame = CGRectMake(0, 0, content.styleModel.maxAlertWidth, content.styleModel.layoutAlertHeight);

    __weak typeof(self) weakSelf = self;
    content.selectAction = ^(BOOL isSure, NSString * _Nonnull message) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (handler) {
                handler(isSure, message);
            }
        }];
    };

    content.clickLinkAction = ^(NSInteger index) {
        if (click) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                click(index);
            }];
        }
    };

    vc.contentView = content;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Sheet 弹框

- (void)showSheetSelect:(NSString *)title
            selectItems:(NSArray<NSString *> *)selectItems
          selectedIndex:(NSInteger)selectedIndex
           disAbleItems:(NSArray<NSString *> *)disAbleItems
           selectAction:(WDAlertClickItemBlock)handler {
    if (![selectItems isKindOfClass:[NSArray class]] || selectItems.count == 0) {
        return;
    }

    WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.canTouchCancel = YES;
    style.position = WDAlertViewPositionTypeBottom;

    WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];

    WDSheetAlertStyleModel *model = [WDSheetAlertStyleModel defaultStyle];
    model.materialStyle = self.wd_demoMaterialStyle;
    model.title = title;
    model.dataArr = selectItems;
    model.disabledDataArr = disAbleItems;
    model.selectedIndex = selectedIndex;
    model.selectedTextColor = UIColor.systemRedColor;
    model.iconPositionLeft = NO;
    model.iconSpacing = 12.0;
    model.selectedItemImage = [UIImage imageNamed:@"icon_selected"];
    model.selectedEnabled = YES;
    model.cellNumberOfLines = 2;

    CGFloat containerWidth = CGRectGetWidth(self.view.bounds);
    WDSheetAlertView *content = [[WDSheetAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, containerWidth, 0);
    [content updateFrame];

    __weak typeof(self) weakSelf = self;
    content.didSelect = ^(NSInteger index) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (handler) {
                handler(index);
            }
        }];
    };
    content.didClickCancel = ^{
        [weakSelf dismissAction];
    };

    vc.contentView = content;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 时间与区间选择

- (void)showDateSelect:(NSDate *)date
           minimumDate:(NSDate *)min
           maximumDate:(NSDate *)max
                 style:(WDDateAlertStyle)format
          changeAction:(void (^)(NSDate * _Nonnull))changeHandler
          selectAction:(void (^)(BOOL, NSDate * _Nonnull))handler {
    WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.canTouchCancel = YES;
    style.position = WDAlertViewPositionTypeBottom;

    WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];

    CGFloat safeBottom = [WDSelectAlertHelper safeAreaInsetsForView:self.view].bottom;
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds), 260.0 + safeBottom);

    WDDateAlertStyleModel *model = [WDDateAlertStyleModel defaultStyle];
    model.materialStyle = self.wd_demoMaterialStyle;
    model.date = date;
    model.minimumDate = min;
    model.maximumDate = max;
    model.style = format;

    WDDateAlertView *content = [[WDDateAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, size.width, size.height);

    __weak typeof(self) weakSelf = self;
    content.didSelectDate = ^(NSDate * _Nonnull selectedDate) {
        if (changeHandler) {
            changeHandler(selectedDate);
        }
    };
    content.didClickButton = ^(BOOL isSure, NSDate * _Nonnull selectedDate) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (handler) {
                handler(isSure, selectedDate);
            }
        }];
    };

    vc.contentView = content;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showDateParagraphSelect:(NSArray<NSString *> *)selectDateArr
                          style:(WDDateIntervalAlertStyle)format
                   selectAction:(void (^)(BOOL, NSString * _Nonnull, NSString * _Nonnull))handler {
    WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.canTouchCancel = YES;
    style.position = WDAlertViewPositionTypeBottom;

    WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];

    CGFloat safeBottom = [WDSelectAlertHelper safeAreaInsetsForView:self.view].bottom;
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds), 260.0 + safeBottom);

    WDDateIntervalAlertStyleModel *model = [WDDateIntervalAlertStyleModel defaultStyle];
    model.materialStyle = self.wd_demoMaterialStyle;
    model.style = format;
    model.beginDate = selectDateArr.firstObject;
    model.endDate = selectDateArr.lastObject;

    WDDateIntervalAlertView *content = [[WDDateIntervalAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, size.width, size.height);

    __weak typeof(self) weakSelf = self;
    content.didClickButton = ^(BOOL isSure, NSString * _Nonnull beginDate, NSString * _Nonnull endDate) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (handler) {
                handler(isSure, beginDate, endDate);
            }
        }];
    };

    vc.contentView = content;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 键值对选择

- (void)showKeyValueSelect:(NSArray<NSString *> *)keyArr
                  valueArr:(NSArray<NSString *> *)valueArr
                     index:(NSInteger)index
              selectAction:(void (^)(BOOL, NSInteger))handler {
    WDAlertWindowStyleModel *style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.canTouchCancel = YES;
    style.position = WDAlertViewPositionTypeBottom;

    WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:style];

    WDKeyValueAlertStyleModel *model = [WDKeyValueAlertStyleModel defaultStyle];
    model.materialStyle = self.wd_demoMaterialStyle;
    model.keyArr = keyArr;
    model.valueArr = valueArr;

    CGFloat safeBottom = [WDSelectAlertHelper safeAreaInsetsForView:self.view].bottom;
    WDKeyValueAlertView *content = [[WDKeyValueAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300.0 + safeBottom);
    content.selectIndex = index;

    __weak typeof(self) weakSelf = self;
    content.didClickButton = ^(BOOL isSure, NSInteger selectedIdx) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (handler) {
                handler(isSure, selectedIdx);
            }
        }];
    };

    vc.contentView = content;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
