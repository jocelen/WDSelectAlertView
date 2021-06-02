//
//  WDSelectAlertHelper.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDSelectAlertHelper : NSObject

+ (CGSize)getFontSize:(NSString*)str Font:(UIFont*)font Paragraph:(nullable NSParagraphStyle *)paragraph Size:(CGSize)size;

/**  获取Color 16进制颜色字符串转UIColor*/
+ (nonnull UIColor*)toHexColor:(NSString *)string;

//安全区域底部的距离
+ (CGFloat)safeEdgeBottomMargin;

+ (CGFloat)adaptScreenSize:(CGFloat)len;

@end

NS_ASSUME_NONNULL_END

