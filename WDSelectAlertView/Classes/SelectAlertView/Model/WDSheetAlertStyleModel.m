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
    
    model.backgroudColor = UIColor.lightGrayColor;
    model.cellBackgroudColor = UIColor.whiteColor;
    model.cellTextColor = UIColor.darkTextColor;
    model.cancelTitle = @"取消";
    model.disableCellTextColor = UIColor.redColor;
    return model;
}

-(CGFloat)safeEdgeBottomMargin
{
    return WDSelectAlertHelper.safeEdgeBottomMargin;
}

@end
