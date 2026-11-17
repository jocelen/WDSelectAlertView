//
//  WDDateAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WDDateAlertStyle) {
    WDDateAlertStyleYYYY = 0,     /// 年
    WDDateAlertStyleYYYYMM = 1,   /// 年-月
    WDDateAlertStyleYYYYMMDD = 2, /// 年-月-日
} NS_SWIFT_NAME(WDDateAlertStyle);

/// 向后兼容旧版枚举命名
typedef WDDateAlertStyle WDDateAlertAlertStyle;
enum {
    WDDateAlertAlertStyleYYYY = WDDateAlertStyleYYYY,
    WDDateAlertAlertStyleYYYYMM = WDDateAlertStyleYYYYMM,
    WDDateAlertAlertStyleYYYYMMDD = WDDateAlertStyleYYYYMMDD,
};

@interface WDDateAlertStyleModel : NSObject

/** 背景材质风格（默认 Automatic：iOS 26+ 原生 Liquid Glass，iOS 15-25 系统材质） */
@property (nonatomic, assign) WDAlertMaterialStyle materialStyle;

/** 是否显式设置了自定义背景色 */
@property (nonatomic, assign, readonly) BOOL hasCustomBackgroundColor;

/** 顶部圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 日期格式样式 */
@property (nonatomic, assign) WDDateAlertStyle style;

/** 面板背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *backgroudColor API_DEPRECATED_WITH_REPLACEMENT("backgroundColor", ios(9.0, 15.0));

/** 国际化标记，默认 zh-Hans */
@property (nonatomic, copy, nullable) NSString *locale;

/** 当前选中日期 */
@property (nonatomic, strong, nullable) NSDate *date;
/** 最小可选日期 */
@property (nonatomic, strong, nullable) NSDate *minimumDate;
/** 最大可选日期 */
@property (nonatomic, strong, nullable) NSDate *maximumDate;

/** 滚轮区域背景颜色 */
@property (nonatomic, strong) UIColor *dateBackgroundColor;
@property (nonatomic, strong) UIColor *dateBackgroudColor API_DEPRECATED_WITH_REPLACEMENT("dateBackgroundColor", ios(9.0, 15.0));

/** 日期文字颜色 */
@property (nonatomic, strong) UIColor *dateTextColor;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;
/** 取消按钮标题 */
@property (nonatomic, copy) NSString *cancelTitle;
/** 取消按钮文字颜色 */
@property (nonatomic, strong) UIColor *cancelTitleColor;
/** 确定按钮标题 */
@property (nonatomic, copy) NSString *sureTitle;
/** 确定按钮文字颜色 */
@property (nonatomic, strong) UIColor *sureTitleColor;

+ (WDDateAlertStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
