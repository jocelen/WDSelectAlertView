//
//  WDAlertWindowStyleModel.h
//  WDSelectAlertView
//
//  Created by 波大王 on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WDSelectAlertDefineHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDAlertWindowStyleModel : NSObject

/**  注册 消失通知key*/
@property (nonatomic, copy, nullable) NSString * dismissNotificationKey;

/**  点击空白取消 默认关闭*/
@property (nonatomic, assign) BOOL canTouchCancel;

/**  毛玻璃效果 默认打开*/
@property (nonatomic, assign) BOOL isGroundGlass;

/**  位置*/
@property (nonatomic, assign) BCAlertViewPositionType position;

/**  背景 颜色*/
@property (nonatomic, strong) UIColor * backgroudColor;

+(WDAlertWindowStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
