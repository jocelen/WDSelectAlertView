//
//  WDAlertWindowStyleModel.h
//  WDSelectAlertView
//
//  Created by 波大王 on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDAlertWindowStyleModel : NSObject

/** 注册消失通知 key */
@property (nonatomic, copy, nullable) NSString *dismissNotificationKey;

/** 点击空白遮罩取消，默认 NO */
@property (nonatomic, assign) BOOL canTouchCancel;

/** 遮罩背景毛玻璃效果，默认 NO */
@property (nonatomic, assign) BOOL isGroundGlass;

/** 是否启用原生弹窗/底栏过渡动画（当 present/dismiss 传入 animated:YES 时生效），默认 YES */
@property (nonatomic, assign) BOOL animatedTransition;

/** 弹窗展示位置，默认居中 */
@property (nonatomic, assign) WDAlertViewPositionType position;

/** 遮罩背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;

/** 向后兼容旧拼写属性 */
@property (nonatomic, strong) UIColor *backgroudColor API_DEPRECATED_WITH_REPLACEMENT("backgroundColor", ios(9.0, 15.0));

+ (WDAlertWindowStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
