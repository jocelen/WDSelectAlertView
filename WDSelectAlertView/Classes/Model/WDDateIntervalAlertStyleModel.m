//
//  WDDateIntervalAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDDateIntervalAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@interface WDDateIntervalAlertStyleModel ()
@property (nonatomic, assign, readwrite) BOOL hasCustomBackgroundColor;
@end

@implementation WDDateIntervalAlertStyleModel

+ (WDDateIntervalAlertStyleModel *)defaultStyle {
    WDDateIntervalAlertStyleModel *model = [[WDDateIntervalAlertStyleModel alloc] init];
    model.materialStyle = WDAlertMaterialStyleAutomatic;
    model.cornerRadius = [WDSelectAlertHelper isIOS26OrLater] ? 24.0 : 16.0;
    model.style = WDDateIntervalAlertStyleHH;
    model->_backgroundColor = UIColor.systemGroupedBackgroundColor;
    model.hasCustomBackgroundColor = NO;
    model->_dateBackgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    model.dateTextColor = UIColor.labelColor;
    model.lineSpaceColor = UIColor.separatorColor;
    model.locale = @"zh-Hans";
    model.cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.secondaryLabelColor;
    model.toTitle = @"至";
    model.toTitleColor = UIColor.labelColor;
    model.sureTitle = @"确定";
    model.sureTitleColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [WDSelectAlertHelper toHexColor:@"#FF4D61"];
        }
        return [WDSelectAlertHelper toHexColor:@"#DC3045"];
    }];
    return model;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    _hasCustomBackgroundColor = (backgroundColor != nil);
}

- (UIColor *)backgroudColor {
    return self.backgroundColor;
}

- (void)setBackgroudColor:(UIColor *)backgroudColor {
    self.backgroundColor = backgroudColor;
}

- (UIColor *)dateBackgroudColor {
    return self.dateBackgroundColor;
}

- (void)setDateBackgroudColor:(UIColor *)dateBackgroudColor {
    self.dateBackgroundColor = dateBackgroudColor;
}

@end
