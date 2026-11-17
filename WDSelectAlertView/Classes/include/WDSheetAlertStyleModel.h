//
//  WDSheetAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDSheetAlertStyleModel : NSObject

/** 背景材质风格（默认 Automatic：iOS 26+ 原生 Liquid Glass，iOS 15-25 系统材质） */
@property (nonatomic, assign) WDAlertMaterialStyle materialStyle;

/** 是否由业务方显式设置了自定义背景色 */
@property (nonatomic, assign, readonly) BOOL hasCustomBackgroundColor;

/** 是否由业务方显式设置了自定义选项背景色 */
@property (nonatomic, assign, readonly) BOOL hasCustomCellBackgroundColor;

/** 顶部圆角半径（iOS 26 默认 24，iOS 15-25 默认 16） */
@property (nonatomic, assign) CGFloat sheetCornerRadius;

/** 最大同时可见选项个数，默认 6 个 */
@property (nonatomic, assign) NSInteger maxShowCount;

/** 单个选项高度，默认自适应 56~60pt */
@property (nonatomic, assign) CGFloat cellHeight;

/** 选项文字最大行数，默认 1 */
@property (nonatomic, assign) NSInteger cellNumberOfLines;

/** 选项文字内边距 */
@property (nonatomic, assign) UIEdgeInsets cellEdgeInsets;

/** 面板底色 */
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *backgroudColor API_DEPRECATED_WITH_REPLACEMENT("backgroundColor", ios(9.0, 15.0));

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineSpaceColor;

/** 选项背景颜色 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellBackgroudColor API_DEPRECATED_WITH_REPLACEMENT("cellBackgroundColor", ios(9.0, 15.0));

/** 选项文字颜色 */
@property (nonatomic, strong) UIColor *cellTextColor;

/** 分割线高度 */
@property (nonatomic, assign) CGFloat lineHeight;

/** 标题文本 */
@property (nonatomic, copy, nullable) NSString *title;

/** 标题属性 */
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSInteger titleNumberOfLines;

/** 选项数据源 */
@property (nonatomic, copy) NSArray<NSString *> *dataArr;

/** 选中项下标，-1 表示默认不选中 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 已选中项是否允许再次点击，默认 YES */
@property (nonatomic, assign) BOOL selectedEnabled;
/** 选中项文字颜色 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/** 选中项图标 */
@property (nonatomic, strong, nullable) UIImage *selectedItemImage;
/** 选中图标是否居左，默认 NO（居右） */
@property (nonatomic, assign) BOOL iconPositionLeft;
/** 选中图标与文字间距，默认 8 */
@property (nonatomic, assign) CGFloat iconSpacing;

/** 禁用项文字颜色 */
@property (nonatomic, strong) UIColor *disableCellTextColor;
/** 禁用项文本集合 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *disabledDataArr;
@property (nonatomic, copy, nullable) NSArray<NSString *> *disAbleDataArr API_DEPRECATED_WITH_REPLACEMENT("disabledDataArr", ios(9.0, 15.0));

/** 取消按钮文本 */
@property (nonatomic, copy) NSString *cancelTitle;
/** 取消按钮文字颜色 */
@property (nonatomic, strong) UIColor *cancelTitleTextColor;
/** 底部安全区高度 */
@property (nonatomic, assign, readonly) CGFloat safeEdgeBottomMargin;

+ (WDSheetAlertStyleModel *)defaultStyle;

/// 按给定容器宽度计算标题 Label Frame
- (CGRect)layoutTitleFrameWithMaxWidth:(CGFloat)maxWidth;
/// 按给定容器宽度计算标题容器 Frame
- (CGRect)layoutTitleViewFrameWithMaxWidth:(CGFloat)maxWidth;

/// 使用当前活动窗口宽度计算标题 Frame
- (CGRect)layoutTitleFrame;
- (CGRect)layoutTitleViewFrame;

@end

NS_ASSUME_NONNULL_END
