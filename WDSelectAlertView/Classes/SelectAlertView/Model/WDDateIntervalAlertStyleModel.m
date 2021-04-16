//
//  WDDateIntervalAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDDateIntervalAlertStyleModel.h"

@implementation WDDateIntervalAlertStyleModel

+(WDDateIntervalAlertStyleModel *)defaultStyle;
{
    WDDateIntervalAlertStyleModel * model = [WDDateIntervalAlertStyleModel new];
    model.backgroudColor = UIColor.lightGrayColor;
    model.dateTextColor = UIColor.darkTextColor;
    model.dateBackgroudColor = UIColor.whiteColor;
    model.lineSpaceColor = UIColor.lightGrayColor;
    model.locale = @"zh-Hans";
    model.cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.darkTextColor;
    model.toTitle = @"至";
    model.toTitleColor = UIColor.darkTextColor;
    model.sureTitle = @"确定";
    model.sureTitleColor = UIColor.redColor;
    
    return model;
}

@end
