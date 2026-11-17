//
//  WDDateAlertView.h
//  WDSelectAlertView
//
//  Created by 文波 on 2019/6/18.
//  Copyright © 2019 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDDateAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WDDatePicker;
@class WDDatePickView;

@interface WDDateAlertView : UIView

/** 样式配置 */
@property (nonatomic, strong, readonly) WDDateAlertStyleModel *styleModel;

/** 年-月-日 系统滚轮选择器 */
@property (nonatomic, strong) WDDatePicker *datePick;
/** 年 / 年-月 自定义滚轮选择器 */
@property (nonatomic, strong) WDDatePickView *datePickView;

/** 滚动变更回调 */
@property (nonatomic, copy, nullable) void(^didSelectDate)(NSDate *date);

/** 取消/确定按钮点击回调 */
@property (nonatomic, copy, nullable) void(^didClickButton)(BOOL isSure, NSDate *date);

- (instancetype)initWithModel:(WDDateAlertStyleModel *)model;

- (void)setDefaultDate:(NSDate *)date;

@end

@interface WDDatePicker : UIDatePicker

/** 文本颜色（保留属性兼容） */
@property (nonatomic, strong, nullable) UIColor *showTextColor;

@end

@interface WDDatePickView : UIPickerView

/** 日期格式样式 */
@property (nonatomic, assign) WDDateAlertStyle style;
/** 当前选中日期 */
@property (nonatomic, strong) NSDate *date;
/** 最小可选日期 */
@property (nonatomic, strong, nullable) NSDate *minimumDate;
/** 最大可选日期 */
@property (nonatomic, strong, nullable) NSDate *maximumDate;

/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;

/** 选择值改变回调 */
@property (nonatomic, copy, nullable) void(^valueChanged)(WDDatePickView *view, NSDate *value);
@property (nonatomic, copy, nullable) void(^valueChangeed)(WDDatePickView *view, NSDate *value) API_DEPRECATED_WITH_REPLACEMENT("valueChanged", ios(9.0, 15.0));

@end

NS_ASSUME_NONNULL_END
