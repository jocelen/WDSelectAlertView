//
//  WDSelectAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSelectAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@interface WDSelectAlertStyleModel ()
@property (nonatomic, assign, readwrite) BOOL hasCustomBackgroundColor;
@end

@implementation WDSelectAlertStyleModel

+ (WDSelectAlertStyleModel *)defaultStyle {
    WDSelectAlertStyleModel *model = [[WDSelectAlertStyleModel alloc] init];

    CGRect windowBounds = [WDSelectAlertHelper currentWindowBounds];
    CGFloat shortSide = MIN(windowBounds.size.width, windowBounds.size.height);

    model.materialStyle = WDAlertMaterialStyleAutomatic;
    model.leftPadding = 16.0;
    model.titleHeight = 52.0;
    model.selectButtonHeight = 50.0;
    model.maxAlertWidth = MIN(shortSide * 0.8, 340.0);
    model.maxAlertHeight = windowBounds.size.height * 0.65;
    model.layoutAlertHeight = 0;
    model.lineSpaceHeight = 1.0 / MAX([WDSelectAlertHelper activeWindowScene].screen.scale, 2.0);
    model.alertCornerRadius = [WDSelectAlertHelper isIOS26OrLater] ? 26.0 : 14.0;

    model->_backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    model.hasCustomBackgroundColor = NO;
    model.lineSpaceColor = UIColor.separatorColor;

    model.titleColor = UIColor.labelColor;
    model.titleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];

    model.contentColor = UIColor.labelColor;
    model.subContentColor = UIColor.secondaryLabelColor;
    model.contentTextAlignment = NSTextAlignmentCenter;
    model.contentFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    model.lineBreakMode = NSLineBreakByWordWrapping;

    UIColor *brandRedColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [WDSelectAlertHelper toHexColor:@"#FF4D61"];
        }
        return [WDSelectAlertHelper toHexColor:@"#DC3045"];
    }];

    model.isOptional = YES;
    model->_sureTitle = @"确定";
    model.sureTitleColor = brandRedColor;
    model.sureTitleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    model.sureTitleAdjusts = NO;
    model.sureTitleMinimumScaleFactor = 0.5;

    model->_cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.secondaryLabelColor;
    model.cancelTitleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    model.cancelTitleAdjusts = NO;
    model.cancelTitleMinimumScaleFactor = 0.5;

    model.highlightColor = UIColor.labelColor;
    model.highlightFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];

    model.linkColor = UIColor.systemBlueColor;
    model.linkFont = model.contentFont;

    return model;
}

#pragma mark - Public Methods

- (NSMutableAttributedString *)layoutAttributesContent {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.contentTextAlignment;
    paragraphStyle.lineSpacing = 3.0;

    UIColor *textColor = (self.hasTitle ? self.subContentColor : self.contentColor) ?: UIColor.labelColor;
    UIFont *font = self.contentFont ?: [UIFont systemFontOfSize:16];

    NSDictionary<NSAttributedStringKey, id> *attributes = @{
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle,
    };
    return [[NSMutableAttributedString alloc] initWithString:self.content ?: @"" attributes:attributes];
}

- (CGRect)layoutTitleFrame {
    if (!self.hasTitle) {
        return CGRectZero;
    }
    CGFloat horizontalInset = self.leftPadding * 1.5;
    CGFloat availableWidth = MAX(0, self.maxAlertWidth - horizontalInset * 2);
    CGSize maxSize = CGSizeMake(availableWidth, CGFLOAT_MAX);
    CGFloat textHeight = [WDSelectAlertHelper getFontSize:self.title
                                                     Font:self.titleFont
                                                Paragraph:nil
                                                     Size:maxSize].height;
    CGFloat layoutTitleHeight = MAX(ceil(textHeight) + self.leftPadding * 1.5, self.titleHeight);
    return CGRectMake(horizontalInset, 0, availableWidth, layoutTitleHeight);
}

- (CGRect)layoutSureButtonFrame {
    CGFloat lineSpace = self.lineSpaceHeight;
    if (self.isOptional) {
        CGFloat halfWidth = (self.maxAlertWidth - lineSpace) / 2.0;
        return CGRectMake(halfWidth + lineSpace, lineSpace, halfWidth, self.selectButtonHeight);
    }
    return CGRectMake(0, lineSpace, self.maxAlertWidth, self.selectButtonHeight);
}

- (CGRect)layoutCancelButtonFrame {
    if (!self.isOptional) {
        return CGRectZero;
    }
    CGFloat halfWidth = (self.maxAlertWidth - self.lineSpaceHeight) / 2.0;
    return CGRectMake(0, self.lineSpaceHeight, halfWidth, self.selectButtonHeight);
}

#pragma mark - Getters & Setters

- (BOOL)hasTitle {
    return self.title.length > 0;
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

- (CGFloat)lineSapceHeight {
    return self.lineSpaceHeight;
}

- (void)setLineSapceHeight:(CGFloat)lineSapceHeight {
    self.lineSpaceHeight = lineSapceHeight;
}

- (void)setTitle:(NSString *)title {
    _title = title.length > 0 ? [title copy] : nil;
}

- (void)setContent:(NSString *)content {
    _content = [content copy];
}

- (void)setSureTitle:(NSString *)sureTitle {
    if (sureTitle.length > 0) {
        _sureTitle = [sureTitle copy];
    }
}

- (void)setCancelTitle:(NSString *)cancelTitle {
    if (cancelTitle.length > 0) {
        _cancelTitle = [cancelTitle copy];
    }
}

@end
