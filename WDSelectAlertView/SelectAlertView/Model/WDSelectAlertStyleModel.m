//
//  WDSelectAlertStyleModel.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSelectAlertStyleModel.h"
#import "WDSelectAlertHelper.h"

@implementation WDSelectAlertStyleModel

// MARK: -  life cycle
+(WDSelectAlertStyleModel *)defaultStyle;
{
    WDSelectAlertStyleModel * model = [[WDSelectAlertStyleModel alloc] init];
    
    model.leftPadding = 14;
    model.titleHeight = 50;
    model.selectButtonHeight = 50;
    model.maxAlertWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    model.maxAlertHeight = [UIScreen mainScreen].bounds.size.height * 0.6;
    model.layoutAlertHeight = 0;
    model.lineSapceHeight = 0.7;
    model.alertCornerRadius = 4;
    
    model.backgroudColor = UIColor.whiteColor;
    model.lineSpaceColor = UIColor.lightGrayColor;

    model.titleColor = UIColor.darkTextColor;
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:19];
    
    model.contentColor = UIColor.darkTextColor;
    model.subContentColor = UIColor.lightGrayColor;
    model.contentTextAlignment = NSTextAlignmentCenter;
    model.contentFont = [UIFont fontWithName:@"PingFangSC-Regular" size: 18];
    model.lineBreakMode = NSLineBreakByCharWrapping;
    
    model.isOptional = YES;
    model.sureTitle = @"确定";
    model.sureTitleColor = UIColor.redColor;
    model.sureTitleFont = [UIFont fontWithName:@"PingFangSC-Heavy" size:18];
    
    model.cancelTitle = @"取消";
    model.cancelTitleColor = UIColor.lightGrayColor;
    model.cancelTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    
    model.highlightColor = UIColor.darkTextColor;
    model.highlightFont = model.contentFont;
    
    model.linkColor = UIColor.blueColor;
    model.linkFont = model.contentFont;
    
    return model;
}


// MARK: -  public methods
/// 计算富文本
-(NSMutableAttributedString *)layoutAttributesContent;
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName:self.title.length ? self.subContentColor : self.contentColor,
                                 NSFontAttributeName:self.contentFont,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attributes];
    return attributeStr;
}



-(CGRect)layoutTitleFrame;
{
    CGRect frame = CGRectZero;
    if (self.title.length) {
        CGFloat titleLeftPadding = self.leftPadding * 2;
        CGSize maxSize = CGSizeMake(self.maxAlertWidth - titleLeftPadding * 2, CGFLOAT_MAX);
        CGFloat layoutTitleHight = [WDSelectAlertHelper getFontSize:self.title Font:self.titleFont Paragraph:nil Size:maxSize].height;
        
        BOOL hasMax = layoutTitleHight + self.leftPadding*2 > self.titleHeight;
        layoutTitleHight = MAX(layoutTitleHight + self.leftPadding*2, self.titleHeight);
        frame = CGRectMake(titleLeftPadding, hasMax ? 0 : (self.titleHeight - layoutTitleHight)/2, self.maxAlertWidth - titleLeftPadding*2, layoutTitleHight);
    }
    return frame;
}

/// 计算确认按钮
-(CGRect)layoutSureButtonFrame;
{
    CGFloat lineSapce = self.lineSapceHeight;
    CGSize size = CGSizeMake(self.maxAlertWidth/(self.isOptional ? 2 : 1), self.selectButtonHeight);
    CGRect frame = CGRectMake(self.isOptional ? (size.width + lineSapce ): 0 , lineSapce, size.width, size.height);
    return frame;
}



/// 计算取消按钮
-(CGRect)layoutCancelButtonFrame;
{
    CGSize size =  CGSizeMake( self.isOptional ? self.maxAlertWidth/2 - self.lineSapceHeight : 0, self.selectButtonHeight);
    CGRect frame = CGRectMake(0, self.lineSapceHeight, size.width, size.height);
    return frame;
}

// MARK: -  getters and setters

-(BOOL)hasTitle
{
    return _title.length;
}


-(void)setTitle:(NSString *)title
{
    if (title != nil && title.length) {
        _title = title;
    }
}

-(void)setContent:(NSString *)content
{
    if (content != nil && content.length ) {
        _content = content;
    }
}

-(void)setSureTitle:(NSString *)sureTitle
{
    if (sureTitle != nil && sureTitle.length) {
        _sureTitle = sureTitle;
    }
}

-(void)setCancelTitle:(NSString *)cancelTitle
{
    if (cancelTitle != nil && cancelTitle.length) {
        _cancelTitle = cancelTitle;
    }
}


-(void)setLinkArr:(NSArray<NSString *> *)linkArr
{
    if (linkArr != nil && linkArr.count > 0 ) {
        _linkArr = linkArr;
    }
}


-(void)setHighlightArr:(NSArray<NSString *> *)highlightArr
{
    if (highlightArr != nil && highlightArr.count > 0 ) {
        _highlightArr = highlightArr;
    }
}

@end
