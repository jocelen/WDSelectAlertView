//
//  WDKeyValueAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2021/6/2.
//

#import "WDKeyValueAlertStyleModel.h"

@implementation WDKeyValueAlertStyleModel

+(WDKeyValueAlertStyleModel *)defaultStyle;
{
    WDKeyValueAlertStyleModel * model = [[WDKeyValueAlertStyleModel alloc] init];
    model.backgroudColor = UIColor.lightGrayColor;
    model.pickBackgroudColor = UIColor.whiteColor;
    model.lineSpaceColor = UIColor.lightGrayColor;
    model.textColor = UIColor.darkTextColor;
    model.selectTextColor = UIColor.redColor;
    model.cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.darkTextColor;
    model.sureTitle = @"确定";
    model.sureTitleColor = UIColor.redColor;
    model.sureTitleDisableColor = UIColor.lightGrayColor;
    return model;
}

@end
