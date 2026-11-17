//
//  WDSheetAlertView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSheetAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDSheetAlertView : UIView

/** 样式配置 */
@property (nonatomic, strong, readonly) WDSheetAlertStyleModel *styleModel;

/** 选中选项回调 */
@property (nonatomic, copy, nullable) void(^didSelect)(NSInteger index);

/** 点击取消回调 */
@property (nonatomic, copy, nullable) void(^didClickCancel)(void);

- (instancetype)initWithModel:(WDSheetAlertStyleModel *)model;

/// 根据当前宽度与安全区刷新布局和总高度
- (void)updateFrame;

@end

@interface WDSheetAlertButton : UIButton

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong, nullable) UIFont *buttonTitleFont;
@property (nonatomic, assign) NSInteger buttonNumberOfLines;

- (void)setIconInLeftWithSpacing:(CGFloat)spacing;
- (void)setIconInRightWithSpacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
