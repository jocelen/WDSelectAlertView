//
//  WDKeyValueAlertView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2021/1/6.
//  Copyright © 2021 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDKeyValueAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDKeyValueAlertView : UIView

/** 样式配置 */
@property (nonatomic, strong, readonly) WDKeyValueAlertStyleModel *styleModel;

/** 当前选中的行下标 */
@property (nonatomic, assign) NSInteger selectIndex;

/** 滚动选中回调 */
@property (nonatomic, copy, nullable) void(^didSelectDate)(NSInteger index);

/** 取消/确定按钮点击回调 */
@property (nonatomic, copy, nullable) void(^didClickButton)(BOOL isSure, NSInteger index);

- (instancetype)initWithModel:(WDKeyValueAlertStyleModel *)model;

@end

@interface WDKeyValueAlertViewCell : UIView

/** 左标题 */
@property (nonatomic, strong) UILabel *leftLabel;
/** 右标题 */
@property (nonatomic, strong) UILabel *rightLabel;

/** 双列可见性 */
@property (nonatomic, assign) BOOL showLeft;
@property (nonatomic, assign) BOOL showRight;

/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectTextColor;

/** 是否处于选中态 */
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
