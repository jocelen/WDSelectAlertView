//
//  WDSelectAlertHelper.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSelectAlertHelper.h"

@implementation WDSelectAlertHelper


+ (CGSize)getFontSize:(NSString*)str Font:(UIFont*)font Paragraph:(nullable NSParagraphStyle *)paragraph Size:(CGSize)size;
{
    if  (str == nil)
    {
        return  CGSizeMake(0, 0);
    }
    
    if (font)
    {
        NSMutableDictionary * attributeDic = [NSMutableDictionary new];
        [attributeDic setValue:font forKey:NSFontAttributeName];
        [attributeDic setValue:paragraph forKey:NSParagraphStyleAttributeName];
        return  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:attributeDic context:nil].size;
    }
    
    return CGSizeZero;
}


+ (nonnull UIColor*)toHexColor:(NSString *)string;
{
    //过滤非法输入
    if (!string || string.length == 0) {
        return UIColor.clearColor;
    }
    NSString * hexColor = string;
    //去掉#号
    if ([@"#" isEqualToString:[string substringWithRange:NSMakeRange(0, 1)]]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    else
    {
        return  UIColor.clearColor;
    }
    
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = range.length * 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = range.length * 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = range.length * 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}


//安全区域底部的距离
+ (CGFloat)safeEdgeBottomMargin;
{
    if (@available(iOS 11.0, *))
    {
        if ([[UIApplication sharedApplication] delegate].window) {
            return [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        }
    }
    return 0;
}

+ (CGFloat)adaptScreenSize:(CGFloat)len;
{
    return ([UIScreen mainScreen].bounds.size.width / 375.0 * (len));
}
@end
