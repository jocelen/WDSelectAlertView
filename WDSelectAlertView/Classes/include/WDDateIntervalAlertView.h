//
//  WDDateIntervalAlertView.h
//  WDSelectAlertView
//
//  Created by 文波 on 2020/4/1.
//  Copyright © 2020 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDDateIntervalAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WDDateIntervalPickView;

@interface WDDateIntervalAlertView : UIView

/** 样式配置 */
@property (nonatomic, strong, readonly) WDDateIntervalAlertStyleModel *styleModel;

/** 选中时间变化回调 */
@property (nonatomic, copy, nullable) void(^didSelectDate)(NSString *beginDate, NSString *endDate);

/** 取消/确定按钮点击回调 */
@property (nonatomic, copy, nullable) void(^didClickButton)(BOOL isSure, NSString *beginDate, NSString *endDate);

- (instancetype)initWithModel:(WDDateIntervalAlertStyleModel *)model;

@end

@interface WDDateIntervalPickView : UIPickerView

/** 时段格式样式 */
@property (nonatomic, assign) WDDateIntervalAlertStyle style;
/** 当前选中时间字符串 */
@property (nonatomic, copy, nullable) NSString *currentValue;

/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;

/** 选择值改变回调 */
@property (nonatomic, copy, nullable) void(^valueChanged)(WDDateIntervalPickView *view, NSString *value);
@property (nonatomic, copy, nullable) void(^valueChangeed)(WDDateIntervalPickView *view, NSString *value) API_DEPRECATED_WITH_REPLACEMENT("valueChanged", ios(9.0, 15.0));

/// 向前退一步（减少 1 小时或 1 分钟，支持跨整点借位）
- (void)previousStep;

/// 向后进一步（增加 1 小时或 1 分钟，支持满 60 分钟进位）
- (void)nextStep;

@end

NS_ASSUME_NONNULL_END
