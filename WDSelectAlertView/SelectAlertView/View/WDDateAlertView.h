//
//  WDDateAlertView.h
//  WDSelectAlertView
//
//  Created by 文波 on 2019/6/18.
//  Copyright © 2019 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDDateSlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDDateAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDDateSlertStyleModel * styleModel;

/**  时间选择器*/
@property (nonatomic, strong) UIDatePicker * datePick;

/**  选中时间*/
@property (nonatomic, copy) void(^didSelectDate) (NSDate * date);

/**  点击按钮*/
@property (nonatomic, copy) void(^didClickButton) (BOOL isSure, NSDate * date);


-(instancetype)initWithModel:(WDDateSlertStyleModel *)model;


@end

NS_ASSUME_NONNULL_END
