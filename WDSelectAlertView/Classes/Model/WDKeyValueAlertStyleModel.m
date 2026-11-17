//
//  WDKeyValueAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2021/6/2.
//

#import "WDKeyValueAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@interface WDKeyValueAlertStyleModel ()
@property (nonatomic, assign, readwrite) BOOL hasCustomBackgroundColor;
@end

@implementation WDKeyValueAlertStyleModel

+ (WDKeyValueAlertStyleModel *)defaultStyle {
    WDKeyValueAlertStyleModel *model = [[WDKeyValueAlertStyleModel alloc] init];
    model.materialStyle = WDAlertMaterialStyleAutomatic;
    model.cornerRadius = [WDSelectAlertHelper isIOS26OrLater] ? 24.0 : 16.0;
    model->_backgroundColor = UIColor.systemGroupedBackgroundColor;
    model.hasCustomBackgroundColor = NO;
    model->_pickerBackgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    model.lineSpaceColor = UIColor.separatorColor;

    UIColor *brandRedColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [WDSelectAlertHelper toHexColor:@"#FF4D61"];
        }
        return [WDSelectAlertHelper toHexColor:@"#DC3045"];
    }];

    model.textColor = UIColor.labelColor;
    model.selectTextColor = brandRedColor;
    model.cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.secondaryLabelColor;
    model.sureTitle = @"确定";
    model.sureTitleColor = brandRedColor;
    model.sureTitleDisableColor = UIColor.tertiaryLabelColor;
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

- (UIColor *)pickBackgroudColor {
    return self.pickerBackgroundColor;
}

- (void)setPickBackgroudColor:(UIColor *)pickBackgroudColor {
    self.pickerBackgroundColor = pickBackgroudColor;
}

@end
