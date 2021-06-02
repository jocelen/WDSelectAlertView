//
//  WDSheetAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSheetAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@implementation WDSheetAlertStyleModel

+(WDSheetAlertStyleModel *)defaultStyle;
{
    WDSheetAlertStyleModel * model = [[WDSheetAlertStyleModel alloc] init];
    model.maxShowCount = 6;
    model.cellHeight = [WDSelectAlertHelper adaptScreenSize:60];
    model.lineHeight = [WDSelectAlertHelper adaptScreenSize:0.7];
    
    model.backgroudColor = [WDSelectAlertHelper toHexColor:@"#F6F7F8"];
    model.cellBackgroudColor = [WDSelectAlertHelper toHexColor:@"#FFFFFF"];
    model.cellTextColor = [WDSelectAlertHelper toHexColor:@"#3E3E3E"];
    model.cancelTitle = @"取消";
    model.cancelTitleTextColor = [WDSelectAlertHelper toHexColor:@"#3E3E3E"];
    model.disableCellTextColor = [WDSelectAlertHelper toHexColor:@"#BEBEBE"];
    return model;
}

-(CGFloat)safeEdgeBottomMargin
{
    return WDSelectAlertHelper.safeEdgeBottomMargin;
}

@end
