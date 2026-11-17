//
//  WDSelectAlertView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertStyleModel.h"
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDSelectAlertView : UIView

/** 样式配置 */
@property (nonatomic, strong, readonly) WDSelectAlertStyleModel *styleModel;

/** 富文本链接点击回调 */
@property (nonatomic, copy, nullable) WDAlertClickItemBlock clickLinkAction;

/** 确认/取消按钮点击回调 */
@property (nonatomic, copy, nullable) WDAlertSelectOptionsBlock selectAction;

- (instancetype)initWithModel:(WDSelectAlertStyleModel *)model;

/// 计算并更新弹窗总高度
- (CGFloat)layoutAlertHeight;

@end

NS_ASSUME_NONNULL_END
