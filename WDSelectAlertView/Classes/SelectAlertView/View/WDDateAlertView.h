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
@interface WDDateAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDDateAlertStyleModel * styleModel;

/**  时间选择器*/
@property (nonatomic, strong) WDDatePicker * datePick;

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

NS_ASSUME_NONNULL_END
