//
//  WDDateAlertView.h
//  WDSelectAlertView
//
//  Created by 文波 on 2019/6/18.
//  Copyright © 2019 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDDateAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WDDatePicker;
@class WDDatePickView;
@interface WDDateAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDDateAlertStyleModel * styleModel;

/**  时间选择器*/
@property (nonatomic, strong) WDDatePicker * datePick;
@property (nonatomic, strong) WDDatePickView * datePickView;
/**  选中时间*/
@property (nonatomic, copy) void(^didSelectDate) (NSDate * date);

/**  点击按钮*/
@property (nonatomic, copy) void(^didClickButton) (BOOL isSure, NSDate * date);


-(instancetype)initWithModel:(WDDateAlertStyleModel *)model;


@end


@interface WDDatePicker : UIDatePicker

/**  文本颜色*/
@property (nonatomic, strong) UIColor * showTextColor;

@end


@interface WDDatePickView : UIPickerView

/**  样式*/
@property (nonatomic, assign) WDDateAlertAlertStyle style;
/**  选中值*/
@property (nonatomic, strong) NSDate *date;

/**  文字 颜色*/
@property (nonatomic, strong) UIColor * textColor;

/**  线条颜色 颜色*/
@property (nonatomic, strong) UIColor * lineSpaceColor;


/**  选择值改变*/
@property (nonatomic, copy, nullable) void(^valueChangeed)(WDDatePickView * view,NSDate * value);

@end
NS_ASSUME_NONNULL_END
