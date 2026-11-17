//
//  WDSelectAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDSelectAlertStyleModel : NSObject

/** 背景材质风格（默认 Automatic：iOS 26+ 原生 Liquid Glass，iOS 15-25 系统材质） */
@property (nonatomic, assign) WDAlertMaterialStyle materialStyle;

/** 是否由业务方显式设置了自定义背景色 */
@property (nonatomic, assign, readonly) BOOL hasCustomBackgroundColor;

/** 边距 */
@property (nonatomic, assign) CGFloat leftPadding;

/** 标题最小高度 */
@property (nonatomic, assign) CGFloat titleHeight;

/** 底部操作按钮高度 */
@property (nonatomic, assign) CGFloat selectButtonHeight;

/** 弹窗最大宽度 */
@property (nonatomic, assign) CGFloat maxAlertWidth;
/** 弹窗最大高度 */
@property (nonatomic, assign) CGFloat maxAlertHeight;

/** 计算后的内容与总高度（layoutAlertHeight 后更新） */
@property (nonatomic, assign) CGFloat layoutContentHeight;
@property (nonatomic, assign) CGFloat layoutAlertHeight;

/** 分割线厚度 */
@property (nonatomic, assign) CGFloat lineSpaceHeight;
@property (nonatomic, assign) CGFloat lineSapceHeight API_DEPRECATED_WITH_REPLACEMENT("lineSpaceHeight", ios(9.0, 15.0));

/** 弹窗圆角半径 */
@property (nonatomic, assign) CGFloat alertCornerRadius;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *backgroudColor API_DEPRECATED_WITH_REPLACEMENT("backgroundColor", ios(9.0, 15.0));

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;

/** 标题文本 */
@property (nonatomic, copy, nullable) NSString *title;
/** 是否有标题 */
@property (nonatomic, assign, readonly) BOOL hasTitle;
/** 标题文本颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题文本字体 */
@property (nonatomic, strong) UIFont *titleFont;

/** 内容文本 */
@property (nonatomic, copy, nullable) NSString *content;
/** 内容排版对齐，默认居中 */
@property (nonatomic, assign) NSTextAlignment contentTextAlignment;
/** 内容文本颜色（无标题时使用） */
@property (nonatomic, strong) UIColor *contentColor;
/** 内容文本颜色（有标题时优先使用） */
@property (nonatomic, strong) UIColor *subContentColor;
/** 内容文本字体 */
@property (nonatomic, strong) UIFont *contentFont;
/** 换行样式 */
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

/** 是否显示取消按钮（双按钮模式），默认 YES */
@property (nonatomic, assign) BOOL isOptional;
/** 确认按钮文本，默认“确定” */
@property (nonatomic, copy) NSString *sureTitle;
/** 确认按钮文本颜色 */
@property (nonatomic, strong) UIColor *sureTitleColor;
/** 确认按钮字体 */
@property (nonatomic, strong) UIFont *sureTitleFont;
/** 确认按钮标题是否自适应缩放，默认 NO */
@property (nonatomic, assign) BOOL sureTitleAdjusts;
/** 确认按钮最小缩放比例，默认 0.5 */
@property (nonatomic, assign) CGFloat sureTitleMinimumScaleFactor;

/** 取消按钮文本，默认“取消” */
@property (nonatomic, copy) NSString *cancelTitle;
/** 取消按钮文本颜色 */
@property (nonatomic, strong) UIColor *cancelTitleColor;
/** 取消按钮字体 */
@property (nonatomic, strong) UIFont *cancelTitleFont;
/** 取消按钮标题是否自适应缩放，默认 NO */
@property (nonatomic, assign) BOOL cancelTitleAdjusts;
/** 取消按钮最小缩放比例，默认 0.5 */
@property (nonatomic, assign) CGFloat cancelTitleMinimumScaleFactor;

/** 高亮文本颜色 */
@property (nonatomic, strong) UIColor *highlightColor;
/** 高亮文本字体 */
@property (nonatomic, strong) UIFont *highlightFont;
/** 高亮文本数组 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *highlightArr;

/** 链接文本颜色 */
@property (nonatomic, strong) UIColor *linkColor;
/** 链接文本字体 */
@property (nonatomic, strong) UIFont *linkFont;
/** 链接文本数组 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *linkArr;

+ (WDSelectAlertStyleModel *)defaultStyle;

/// 计算富文本内容
- (NSMutableAttributedString *)layoutAttributesContent;

/// 计算标题 Frame
- (CGRect)layoutTitleFrame;

/// 计算确认按钮 Frame
- (CGRect)layoutSureButtonFrame;

/// 计算取消按钮 Frame
- (CGRect)layoutCancelButtonFrame;

@end

NS_ASSUME_NONNULL_END
