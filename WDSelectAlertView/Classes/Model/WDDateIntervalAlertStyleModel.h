//
//  WDDateIntervalAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,WDDateIntervalAlertStyle) {
    WDDateIntervalAlertStyleHH = 0, /// 09
    WDDateIntervalAlertStyleHHMM = 1, /// 09:03
};

@interface WDDateIntervalAlertStyleModel : NSObject

/**  样式*/
@property (nonatomic, assign) WDDateIntervalAlertStyle style;

/**  背景 颜色*/
@property (nonatomic, strong) UIColor * backgroudColor;

/**  国际化标记*/
@property (nonatomic, copy, nullable) NSString * locale;

/**  开始时间*/
@property (nonatomic, copy, nullable) NSString * beginDate;

/**  结束时间*/
@property (nonatomic, copy, nullable) NSString * endDate;

/**  时间背景 颜色*/
@property (nonatomic, strong) UIColor * dateBackgroudColor;
/**  时间颜色*/
@property (nonatomic, strong) UIColor * dateTextColor;
/**  分割线颜色*/
@property (nonatomic, strong) UIColor * lineSpaceColor;
/**  至文本*/
@property (nonatomic, copy) NSString * toTitle;
/**  至文本 颜色*/
@property (nonatomic, strong) UIColor * toTitleColor;

/**  取消文本*/
@property (nonatomic, copy) NSString * cancelTitle;
/**  取消文本 颜色*/
@property (nonatomic, strong) UIColor * cancelTitleColor;
/**  确定文本*/
@property (nonatomic, copy) NSString * sureTitle;
/**  确定文本 颜色*/
@property (nonatomic, strong) UIColor * sureTitleColor;


+(WDDateIntervalAlertStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
