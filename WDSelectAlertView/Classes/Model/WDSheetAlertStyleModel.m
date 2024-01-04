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
    model.titleTopPadding = 12;
    model.titleLeftPadding = 14;
    model.maxShowCount = 6;
    model.cellHeight = [WDSelectAlertHelper adaptScreenSize:60];
    model.lineHeight = [WDSelectAlertHelper adaptScreenSize:0.7];
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    model.titleColor = [WDSelectAlertHelper toHexColor:@"#7B7B7B"];
    model.titleNumberOfLines = 0;
    model.backgroudColor = [WDSelectAlertHelper toHexColor:@"#F6F7F8"];
    model.cellBackgroudColor = [WDSelectAlertHelper toHexColor:@"#FFFFFF"];
    model.cellTextColor = [WDSelectAlertHelper toHexColor:@"#3E3E3E"];
    model.cancelTitle = @"取消";
    model.cancelTitleTextColor = [WDSelectAlertHelper toHexColor:@"#3E3E3E"];
    model.disableCellTextColor = [WDSelectAlertHelper toHexColor:@"#BEBEBE"];
    return model;
}

-(CGRect)layoutTitleFrame;
{
    CGRect frame = CGRectZero;
    if (self.title.length) {
        CGSize maxSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - self.titleLeftPadding * 2, CGFLOAT_MAX);
        CGFloat layoutTitleHight = [WDSelectAlertHelper getFontSize:self.title Font:self.titleFont Paragraph:nil Size:maxSize].height;
        frame = CGRectMake(self.titleTopPadding, self.titleLeftPadding, maxSize.width, layoutTitleHight);
    }
    return frame;
}

-(CGRect)layoutTitleViewFrame;
{
    CGRect frame = self.layoutTitleFrame;
    if (frame.size.height > 0) {
        frame = CGRectMake(0, 0, frame.size.width + self.titleLeftPadding*2, frame.size.height + self.titleTopPadding*2);
    }
    return frame;
}

-(CGFloat)safeEdgeBottomMargin
{
    return WDSelectAlertHelper.safeEdgeBottomMargin;
}

@end
