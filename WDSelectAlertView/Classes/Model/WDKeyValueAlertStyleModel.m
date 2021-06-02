//
//  WDKeyValueAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2021/6/2.
//

#import "WDKeyValueAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@implementation WDKeyValueAlertStyleModel

+(WDKeyValueAlertStyleModel *)defaultStyle;
{
    WDKeyValueAlertStyleModel * model = [[WDKeyValueAlertStyleModel alloc] init];
    model.backgroudColor = [WDSelectAlertHelper toHexColor:@"#F6F7F8"];
    model.pickBackgroudColor = [WDSelectAlertHelper toHexColor:@"#FFFFFF"];
    model.lineSpaceColor = [WDSelectAlertHelper toHexColor:@"#EAECED"];
    model.textColor = [WDSelectAlertHelper toHexColor:@"#3E3E3E"];
    model.selectTextColor = [WDSelectAlertHelper toHexColor:@"#DC3045"];
    model.cancelTitle = @"取消";
    model.cancelTitleColor = [WDSelectAlertHelper toHexColor:@"#7B7B7B"];
    model.sureTitle = @"确定";
    model.sureTitleColor = [WDSelectAlertHelper toHexColor:@"#DC3045"];
    model.sureTitleDisableColor = [WDSelectAlertHelper toHexColor:@"#7B7B7B"];
    return model;
}

@end
