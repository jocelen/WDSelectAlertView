//
//  WDAlertWindowViewController.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAlertWindowStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDAlertWindowViewController : UIViewController

/** 窗口样式配置 */
@property (nonatomic, strong, readonly) WDAlertWindowStyleModel *styleModel;

/** 承载的具体弹窗内容视图 */
@property (nonatomic, strong, nullable) UIView *contentView;

- (instancetype)initWithModel:(WDAlertWindowStyleModel *)model;

/// 关闭当前弹窗控制器
- (void)dismissAlertAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
