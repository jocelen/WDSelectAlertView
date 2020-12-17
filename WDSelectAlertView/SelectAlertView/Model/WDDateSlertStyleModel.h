//
//  WDDateSlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDDateSlertStyleModel : NSObject

/**  背景 颜色*/
@property (nonatomic, strong) UIColor * backgroudColor;

/**  国际化标记*/
@property (nonatomic, copy, nullable) NSString * locale;

/**  选中时间*/
@property (nonatomic, strong, nullable) NSDate * date;
/**  最小时间*/
@property (nonatomic, strong, nullable) NSDate * minimumDate;
/**  最大时间*/
@property (nonatomic, strong, nullable) NSDate * maximumDate;

/**  时间背景 颜色*/
@property (nonatomic, strong) UIColor * dateBackgroudColor;
/**  时间颜色*/
@property (nonatomic, strong) UIColor * dateTextColor;

/**  取消文本*/
@property (nonatomic, copy) NSString * cancelTitle;
/**  取消文本 颜色*/
@property (nonatomic, strong) UIColor * cancelTitleColor;
/**  确定文本*/
@property (nonatomic, copy) NSString * sureTitle;
/**  确定文本 颜色*/
@property (nonatomic, strong) UIColor * sureTitleColor;


+(WDDateSlertStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
