//
//  WDDateSlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDDateSlertStyleModel.h"

@implementation WDDateSlertStyleModel

+(WDDateSlertStyleModel *)defaultStyle;
{
    WDDateSlertStyleModel * model = [WDDateSlertStyleModel new];
    model.backgroudColor = UIColor.lightGrayColor;
    model.dateTextColor = UIColor.darkTextColor;
    model.dateBackgroudColor = UIColor.whiteColor;
    model.locale = @"zh-Hans";
    model.cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.darkTextColor;
    model.sureTitle = @"确定";
    model.sureTitleColor = UIColor.redColor;
    
    return model;
}

@end
