//
//  WDDateAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDDateAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@implementation WDDateAlertStyleModel

+(WDDateAlertStyleModel *)defaultStyle;
{
    WDDateAlertStyleModel * model = [WDDateAlertStyleModel new];
    model.style = WDDateAlertAlertStyleYYYYMMDD;
    model.backgroudColor = [WDSelectAlertHelper toHexColor:@"#F6F7F8"];
    model.dateTextColor = [WDSelectAlertHelper toHexColor:@"#5B5B5B"];
    model.dateBackgroudColor = [WDSelectAlertHelper toHexColor:@"#FFFFFF"];
    model.lineSpaceColor = [WDSelectAlertHelper toHexColor:@"#EAECED"];
    model.locale = @"zh-Hans";
    model.cancelTitle = @"取消";
    model.cancelTitleColor = [WDSelectAlertHelper toHexColor:@"#7B7B7B"];
    model.sureTitle = @"确定";
    model.sureTitleColor = [WDSelectAlertHelper toHexColor:@"#DC3045"];

    return model;
}

@end
