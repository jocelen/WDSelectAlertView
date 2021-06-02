//
//  WDDateIntervalAlertView.h
//  WDSelectAlertView
//
//  Created by 文波 on 2020/4/1.
//  Copyright © 2020 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDDateIntervalAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDDateIntervalAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDDateIntervalAlertStyleModel * styleModel;

/**  选中时间*/
@property (nonatomic, copy) void(^didSelectDate) (NSString * beginDate, NSString * endDate);

/**  点击按钮*/
@property (nonatomic, copy) void(^didClickButton) (BOOL isSure, NSString * beginDate, NSString * endDate);


-(instancetype)initWithModel:(WDDateIntervalAlertStyleModel *)model;

@end


@interface WDDateIntervalPickView : UIPickerView

/**  选中index*/
@property (nonatomic, assign ) NSInteger currentIndex;
/**  选中值*/
@property (nonatomic, copy, nullable) NSString * currentValue;

/**  文字 颜色*/
@property (nonatomic, strong) UIColor * textColor;

/**  线条颜色 颜色*/
@property (nonatomic, strong) UIColor * lineSpaceColor;

/**  选择值改变*/
@property (nonatomic, copy, nullable) void(^valueChangeed)(WDDateIntervalPickView * view,NSString * value);

/// 前进一步
-(void)previousStep;

/// 后退一步
-(void)nextStep;

@end

NS_ASSUME_NONNULL_END
