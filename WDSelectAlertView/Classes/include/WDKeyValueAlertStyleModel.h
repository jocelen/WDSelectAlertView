//
//  WDKeyValueAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2021/6/2.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDKeyValueAlertStyleModel : NSObject

/** 背景材质风格（默认 Automatic：iOS 26+ 原生 Liquid Glass，iOS 15-25 系统材质） */
@property (nonatomic, assign) WDAlertMaterialStyle materialStyle;

/** 是否显式设置了自定义背景色 */
@property (nonatomic, assign, readonly) BOOL hasCustomBackgroundColor;

/** 顶部圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 面板背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *backgroudColor API_DEPRECATED_WITH_REPLACEMENT("backgroundColor", ios(9.0, 15.0));

/** 滚轮区域背景颜色 */
@property (nonatomic, strong) UIColor *pickerBackgroundColor;
@property (nonatomic, strong) UIColor *pickBackgroudColor API_DEPRECATED_WITH_REPLACEMENT("pickerBackgroundColor", ios(9.0, 15.0));

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;

/** 普通文本颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 选中文本颜色 */
@property (nonatomic, strong) UIColor *selectTextColor;

/** 取消按钮文本 */
@property (nonatomic, copy) NSString *cancelTitle;
/** 取消按钮颜色 */
@property (nonatomic, strong) UIColor *cancelTitleColor;
/** 确定按钮文本 */
@property (nonatomic, copy) NSString *sureTitle;
/** 确定按钮颜色 */
@property (nonatomic, strong) UIColor *sureTitleColor;
/** 确定按钮禁用颜色 */
@property (nonatomic, strong) UIColor *sureTitleDisableColor;

/** 左列键数组 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *keyArr;
/** 右列值数组 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *valueArr;

+ (WDKeyValueAlertStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
