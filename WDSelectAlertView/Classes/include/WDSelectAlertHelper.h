//
//  WDSelectAlertHelper.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDSelectAlertHelper : NSObject

/// 计算文本尺寸
+ (CGSize)getFontSize:(nullable NSString *)str
                 Font:(nullable UIFont *)font
            Paragraph:(nullable NSParagraphStyle *)paragraph
                 Size:(CGSize)size NS_SWIFT_NAME(textSize(for:font:paragraph:maxSize:));

/// 16进制颜色字符串转 UIColor（支持 #RGB / #RRGGBB / #RRGGBBAA）
+ (UIColor *)toHexColor:(nullable NSString *)string NS_SWIFT_NAME(color(hex:));

/// 当前是否为 iOS 26 及以上系统
+ (BOOL)isIOS26OrLater;

/// 当前处于前台激活状态的 UIWindowScene
+ (nullable UIWindowScene *)activeWindowScene;

/// 当前活动主窗口（基于 UIWindowScene.keyWindow，兼容旧版 AppDelegate.window）
+ (nullable UIWindow *)activeKeyWindow;

/// 当前活动窗口边界（替代已废弃的 UIScreen.mainScreen.bounds）
+ (CGRect)currentWindowBounds;

/// 获取指定视图所在容器边界（优先取 view.window / superview，兜底取 currentWindowBounds）
+ (CGRect)containerBoundsForView:(nullable UIView *)view;

/// 获取指定视图的安全区内边距（未挂载到窗口时兜底取活动主窗口安全区）
+ (UIEdgeInsets)safeAreaInsetsForView:(nullable UIView *)view;

/// 安全区域底部距离
+ (CGFloat)safeEdgeBottomMargin;

/// 基于窗口短边的自适应尺寸计算
+ (CGFloat)adaptScreenSize:(CGFloat)len;

/// 为 UIVisualEffectView 配置 iOS 26 Liquid Glass 或 iOS 15-25 系统材质及圆角
+ (void)applyMaterialStyle:(WDAlertMaterialStyle)materialStyle
           backgroundColor:(nullable UIColor *)backgroundColor
      hasCustomBackground:(BOOL)hasCustomBackground
              cornerRadius:(CGFloat)cornerRadius
             maskedCorners:(CACornerMask)maskedCorners
              toEffectView:(UIVisualEffectView *)effectView;

@end

NS_ASSUME_NONNULL_END
