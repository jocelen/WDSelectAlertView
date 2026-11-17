//
//  WDDateIntervalAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WDDateIntervalAlertStyle) {
    WDDateIntervalAlertStyleHH = 0,   /// 09
    WDDateIntervalAlertStyleHHMM = 1, /// 09:03
} NS_SWIFT_NAME(WDDateIntervalAlertStyle);

@interface WDDateIntervalAlertStyleModel : NSObject

/** 背景材质风格（默认 Automatic：iOS 26+ 原生 Liquid Glass，iOS 15-25 系统材质） */
@property (nonatomic, assign) WDAlertMaterialStyle materialStyle;

/** 是否显式设置了自定义背景色 */
@property (nonatomic, assign, readonly) BOOL hasCustomBackgroundColor;

/** 顶部圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 时段格式样式 */
@property (nonatomic, assign) WDDateIntervalAlertStyle style;

/** 面板背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *backgroudColor API_DEPRECATED_WITH_REPLACEMENT("backgroundColor", ios(9.0, 15.0));

/** 国际化标记 */
@property (nonatomic, copy, nullable) NSString *locale;

/** 开始时间（如 "08:00" 或 "08"） */
@property (nonatomic, copy, nullable) NSString *beginDate;

/** 结束时间（如 "12:00" 或 "12"） */
@property (nonatomic, copy, nullable) NSString *endDate;

/** 滚轮区域背景颜色 */
@property (nonatomic, strong) UIColor *dateBackgroundColor;
@property (nonatomic, strong) UIColor *dateBackgroudColor API_DEPRECATED_WITH_REPLACEMENT("dateBackgroundColor", ios(9.0, 15.0));

/** 时间文字颜色 */
@property (nonatomic, strong) UIColor *dateTextColor;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;
/** 中间连接文本，默认“至” */
@property (nonatomic, copy) NSString *toTitle;
/** 中间连接文本颜色 */
@property (nonatomic, strong) UIColor *toTitleColor;

/** 取消按钮文本 */
@property (nonatomic, copy) NSString *cancelTitle;
/** 取消按钮颜色 */
@property (nonatomic, strong) UIColor *cancelTitleColor;
/** 确定按钮文本 */
@property (nonatomic, copy) NSString *sureTitle;
/** 确定按钮颜色 */
@property (nonatomic, strong) UIColor *sureTitleColor;

+ (WDDateIntervalAlertStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
