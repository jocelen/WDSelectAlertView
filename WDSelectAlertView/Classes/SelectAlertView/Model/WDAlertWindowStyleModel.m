//
//  WDAlertWindowStyleModel.m
//  WDSelectAlertView
//
//  Created by 波大王 on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDAlertWindowStyleModel.h"

@implementation WDAlertWindowStyleModel


+(WDAlertWindowStyleModel *)defaultStyle;
{
    WDAlertWindowStyleModel * model = [WDAlertWindowStyleModel new];
    model.isGroundGlass = YES;
    model.position = BCAlertViewPositionTypeCenter;
    model.backgroudColor = [UIColor.blackColor colorWithAlphaComponent:0.4f];
    return model;
}

@end
