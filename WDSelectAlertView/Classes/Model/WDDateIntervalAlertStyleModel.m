//
//  WDDateIntervalAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDDateIntervalAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@implementation WDDateIntervalAlertStyleModel

+(WDDateIntervalAlertStyleModel *)defaultStyle;
{
    WDDateIntervalAlertStyleModel * model = [WDDateIntervalAlertStyleModel new];
    model.backgroudColor = [WDSelectAlertHelper toHexColor:@"#F6F7F8"];
    model.dateTextColor = [WDSelectAlertHelper toHexColor:@"#5B5B5B"];
    model.dateBackgroudColor = [WDSelectAlertHelper toHexColor:@"#FFFFFF"];
    model.lineSpaceColor = [WDSelectAlertHelper toHexColor:@"#EAECED"];
    model.locale = @"zh-Hans";
    model.cancelTitle = @"取消";
    model.cancelTitleColor =  [WDSelectAlertHelper toHexColor:@"#7B7B7B"];
    model.toTitle = @"至";
    model.toTitleColor = [WDSelectAlertHelper toHexColor:@"#3E3E3E"];
    model.sureTitle = @"确定";
    model.sureTitleColor = [WDSelectAlertHelper toHexColor:@"#DC3045"];
    
    return model;
}

@end
