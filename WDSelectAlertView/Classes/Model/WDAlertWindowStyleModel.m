//
//  WDAlertWindowStyleModel.m
//  WDSelectAlertView
//
//  Created by 波大王 on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDAlertWindowStyleModel.h"

@implementation WDAlertWindowStyleModel

+ (WDAlertWindowStyleModel *)defaultStyle {
    WDAlertWindowStyleModel *model = [[WDAlertWindowStyleModel alloc] init];
    model.isGroundGlass = NO;
    model.animatedTransition = YES;
    model.position = WDAlertViewPositionTypeCenter;
    model.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.35];
    return model;
}

- (UIColor *)backgroudColor {
    return self.backgroundColor;
}

- (void)setBackgroudColor:(UIColor *)backgroudColor {
    self.backgroundColor = backgroudColor;
}

@end
