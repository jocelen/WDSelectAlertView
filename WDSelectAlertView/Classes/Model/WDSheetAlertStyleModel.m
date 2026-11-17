//
//  WDSheetAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSheetAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@interface WDSheetAlertStyleModel ()
@property (nonatomic, assign, readwrite) BOOL hasCustomBackgroundColor;
@property (nonatomic, assign, readwrite) BOOL hasCustomCellBackgroundColor;
@end

@implementation WDSheetAlertStyleModel

+ (WDSheetAlertStyleModel *)defaultStyle {
    WDSheetAlertStyleModel *model = [[WDSheetAlertStyleModel alloc] init];
    model.materialStyle = WDAlertMaterialStyleAutomatic;
    model.sheetCornerRadius = [WDSelectAlertHelper isIOS26OrLater] ? 24.0 : 16.0;
    model.titleEdgeInsets = UIEdgeInsetsMake(14, 16, 14, 16);
    model.maxShowCount = 6;
    model.cellHeight = [WDSelectAlertHelper adaptScreenSize:56.0];
    model.cellNumberOfLines = 1;
    model.cellEdgeInsets = UIEdgeInsetsMake(6, 16, 6, 16);
    model.lineHeight = 1.0 / MAX([WDSelectAlertHelper activeWindowScene].screen.scale, 2.0);
    model.titleFont = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    model.titleColor = UIColor.secondaryLabelColor;
    model.titleNumberOfLines = 0;

    model->_backgroundColor = UIColor.systemGroupedBackgroundColor;
    model.hasCustomBackgroundColor = NO;
    model.lineSpaceColor = UIColor.separatorColor;
    model->_cellBackgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    model.hasCustomCellBackgroundColor = NO;

    model.cellTextColor = UIColor.labelColor;
    model.cancelTitle = @"取消";
    model.cancelTitleTextColor = UIColor.labelColor;
    model.disableCellTextColor = UIColor.tertiaryLabelColor;
    model.dataArr = @[];
    model.selectedIndex = -1;
    model.selectedEnabled = YES;
    model.selectedTextColor = UIColor.systemBlueColor;
    model.selectedItemImage = nil;
    model.iconPositionLeft = NO;
    model.iconSpacing = 8.0;
    return model;
}

- (CGRect)layoutTitleFrameWithMaxWidth:(CGFloat)maxWidth {
    if (self.title.length == 0 || maxWidth <= 0) {
        return CGRectZero;
    }
    CGFloat contentWidth = MAX(0, maxWidth - (self.titleEdgeInsets.left + self.titleEdgeInsets.right));
    CGSize maxSize = CGSizeMake(contentWidth, CGFLOAT_MAX);
    CGFloat layoutTitleHeight = ceil([WDSelectAlertHelper getFontSize:self.title
                                                                 Font:self.titleFont
                                                            Paragraph:nil
                                                                 Size:maxSize].height);
    return CGRectMake(self.titleEdgeInsets.left, self.titleEdgeInsets.top, contentWidth, layoutTitleHeight);
}

- (CGRect)layoutTitleViewFrameWithMaxWidth:(CGFloat)maxWidth {
    CGRect labelFrame = [self layoutTitleFrameWithMaxWidth:maxWidth];
    if (labelFrame.size.height <= 0) {
        return CGRectZero;
    }
    return CGRectMake(0,
                      0,
                      maxWidth,
                      labelFrame.size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
}

- (CGRect)layoutTitleFrame {
    return [self layoutTitleFrameWithMaxWidth:[WDSelectAlertHelper currentWindowBounds].size.width];
}

- (CGRect)layoutTitleViewFrame {
    return [self layoutTitleViewFrameWithMaxWidth:[WDSelectAlertHelper currentWindowBounds].size.width];
}

- (CGFloat)safeEdgeBottomMargin {
    return [WDSelectAlertHelper safeEdgeBottomMargin];
}

#pragma mark - Backward Compatible Forwarding

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

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor {
    _cellBackgroundColor = cellBackgroundColor;
    _hasCustomCellBackgroundColor = (cellBackgroundColor != nil);
}

- (UIColor *)cellBackgroudColor {
    return self.cellBackgroundColor;
}

- (void)setCellBackgroudColor:(UIColor *)cellBackgroudColor {
    self.cellBackgroundColor = cellBackgroudColor;
}

- (NSArray<NSString *> *)disAbleDataArr {
    return self.disabledDataArr;
}

- (void)setDisAbleDataArr:(NSArray<NSString *> *)disAbleDataArr {
    self.disabledDataArr = disAbleDataArr;
}

@end
