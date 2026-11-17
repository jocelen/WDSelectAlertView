//
//  WDSelectAlertHelper.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSelectAlertHelper.h"

@implementation WDSelectAlertHelper

+ (CGSize)getFontSize:(nullable NSString *)str
                 Font:(nullable UIFont *)font
            Paragraph:(nullable NSParagraphStyle *)paragraph
                 Size:(CGSize)size {
    if (str.length == 0 || font == nil) {
        return CGSizeZero;
    }

    NSMutableDictionary<NSAttributedStringKey, id> *attributeDic = [NSMutableDictionary dictionary];
    attributeDic[NSFontAttributeName] = font;
    if (paragraph) {
        attributeDic[NSParagraphStyleAttributeName] = paragraph;
    }
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin |
                                     NSStringDrawingTruncatesLastVisibleLine |
                                     NSStringDrawingUsesFontLeading;
    return [str boundingRectWithSize:size options:options attributes:attributeDic context:nil].size;
}

+ (UIColor *)toHexColor:(nullable NSString *)string {
    if (string.length == 0) {
        return UIColor.clearColor;
    }

    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![trimmed hasPrefix:@"#"]) {
        return UIColor.clearColor;
    }

    NSString *hexColor = [trimmed substringFromIndex:1];
    if (hexColor.length == 3) {
        NSString *r = [hexColor substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hexColor substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hexColor substringWithRange:NSMakeRange(2, 1)];
        hexColor = [NSString stringWithFormat:@"%@%@%@%@%@%@", r, r, g, g, b, b];
    }

    if (hexColor.length != 6 && hexColor.length != 8) {
        return UIColor.clearColor;
    }

    unsigned int red = 0, green = 0, blue = 0, alpha = 255;
    if (![[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red] ||
        ![[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green] ||
        ![[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue]) {
        return UIColor.clearColor;
    }

    if (hexColor.length == 8) {
        if (![[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&alpha]) {
            alpha = 255;
        }
    }

    return [UIColor colorWithRed:red / 255.0
                           green:green / 255.0
                            blue:blue / 255.0
                           alpha:alpha / 255.0];
}

+ (BOOL)isIOS26OrLater {
    if (@available(iOS 26.0, *)) {
        return YES;
    }
    return NO;
}

+ (nullable UIWindowScene *)activeWindowScene {
    NSSet<UIScene *> *scenes = UIApplication.sharedApplication.connectedScenes;
    UIWindowScene *inactiveScene = nil;
    UIWindowScene *anyScene = nil;

    for (UIScene *scene in scenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) {
            continue;
        }
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            return windowScene;
        }
        if (windowScene.activationState == UISceneActivationStateForegroundInactive && !inactiveScene) {
            inactiveScene = windowScene;
        }
        if (!anyScene) {
            anyScene = windowScene;
        }
    }
    return inactiveScene ?: anyScene;
}

+ (nullable UIWindow *)activeKeyWindow {
    UIWindowScene *windowScene = [self activeWindowScene];
    if (windowScene != nil) {
        if (windowScene.keyWindow != nil) {
            return windowScene.keyWindow;
        }
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) {
                return window;
            }
        }
        for (UIWindow *window in windowScene.windows) {
            if (!window.isHidden && window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
        if (windowScene.windows.count > 0) {
            return windowScene.windows.firstObject;
        }
    }

    id<UIApplicationDelegate> delegate = UIApplication.sharedApplication.delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        UIWindow *legacyWindow = delegate.window;
        if (legacyWindow != nil) {
            return legacyWindow;
        }
    }
    return nil;
}

+ (CGRect)currentWindowBounds {
    UIWindow *keyWindow = [self activeKeyWindow];
    if (keyWindow != nil && !CGRectIsEmpty(keyWindow.bounds)) {
        return keyWindow.bounds;
    }

    UIWindowScene *windowScene = [self activeWindowScene];
    if (windowScene != nil) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 260000
        if (@available(iOS 26.0, *)) {
            CGRect effectiveBounds = windowScene.effectiveGeometry.coordinateSpace.bounds;
            if (!CGRectIsEmpty(effectiveBounds)) {
                return effectiveBounds;
            }
        }
#endif
        CGRect screenBounds = windowScene.screen.bounds;
        if (!CGRectIsEmpty(screenBounds)) {
            return screenBounds;
        }
    }

    return CGRectMake(0, 0, 393.0, 852.0);
}

+ (CGRect)containerBoundsForView:(nullable UIView *)view {
    if (view.window != nil && !CGRectIsEmpty(view.window.bounds)) {
        return view.window.bounds;
    }
    if (view.superview != nil && !CGRectIsEmpty(view.superview.bounds)) {
        return view.superview.bounds;
    }
    if (view != nil && !CGRectIsEmpty(view.bounds)) {
        return view.bounds;
    }
    return [self currentWindowBounds];
}

+ (UIEdgeInsets)safeAreaInsetsForView:(nullable UIView *)view {
    if (view != nil && view.window != nil) {
        return view.safeAreaInsets;
    }
    UIWindow *window = [self activeKeyWindow];
    if (window != nil) {
        return window.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

+ (CGFloat)safeEdgeBottomMargin {
    return [self safeAreaInsetsForView:nil].bottom;
}

+ (CGFloat)adaptScreenSize:(CGFloat)len {
    CGRect bounds = [self currentWindowBounds];
    CGFloat shortSide = MIN(bounds.size.width, bounds.size.height);
    if (shortSide <= 0) {
        shortSide = 375.0;
    }
    CGFloat scale = MIN(shortSide / 375.0, 1.15);
    return scale * len;
}

+ (void)applyMaterialStyle:(WDAlertMaterialStyle)materialStyle
           backgroundColor:(nullable UIColor *)backgroundColor
      hasCustomBackground:(BOOL)hasCustomBackground
              cornerRadius:(CGFloat)cornerRadius
             maskedCorners:(CACornerMask)maskedCorners
              toEffectView:(UIVisualEffectView *)effectView {
    if (effectView == nil) {
        return;
    }

    [UIView performWithoutAnimation:^{
        CACornerMask allCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner |
                                  kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        BOOL isTopCornersOnly = (maskedCorners == (kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner));

        if (materialStyle == WDAlertMaterialStyleSolid) {
            effectView.effect = nil;
            effectView.contentView.backgroundColor = backgroundColor ?: UIColor.secondarySystemGroupedBackgroundColor;
            effectView.layer.cornerRadius = cornerRadius;
            effectView.layer.cornerCurve = kCACornerCurveContinuous;
            effectView.layer.maskedCorners = maskedCorners ?: allCorners;
            effectView.clipsToBounds = YES;
            effectView.contentView.layer.cornerRadius = cornerRadius;
            effectView.contentView.layer.cornerCurve = kCACornerCurveContinuous;
            effectView.contentView.layer.maskedCorners = maskedCorners ?: allCorners;
            effectView.contentView.clipsToBounds = YES;
            return;
        }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 260000
        if (@available(iOS 26.0, *)) {
            UIGlassEffectStyle glassStyle = (materialStyle == WDAlertMaterialStyleClearGlass)
                                                ? UIGlassEffectStyleClear
                                                : UIGlassEffectStyleRegular;
            UIGlassEffect *glassEffect = [UIGlassEffect effectWithStyle:glassStyle];
            if (hasCustomBackground && backgroundColor != nil) {
                glassEffect.tintColor = backgroundColor;
            }
            effectView.effect = glassEffect;
            effectView.contentView.backgroundColor = UIColor.clearColor;
            effectView.clipsToBounds = NO;

            UICornerRadius *radiusObj = [UICornerRadius fixedRadius:cornerRadius];
            if (isTopCornersOnly) {
                effectView.cornerConfiguration = [UICornerConfiguration configurationWithUniformTopRadius:radiusObj
                                                                                         bottomLeftRadius:nil
                                                                                        bottomRightRadius:nil];
            } else {
                effectView.cornerConfiguration = [UICornerConfiguration configurationWithRadius:radiusObj];
            }

            effectView.contentView.layer.cornerRadius = cornerRadius;
            effectView.contentView.layer.cornerCurve = kCACornerCurveContinuous;
            effectView.contentView.layer.maskedCorners = maskedCorners ?: allCorners;
            effectView.contentView.clipsToBounds = YES;
            return;
        }
#endif

        UIBlurEffectStyle blurStyle = (materialStyle == WDAlertMaterialStyleClearGlass)
                                          ? UIBlurEffectStyleSystemUltraThinMaterial
                                          : UIBlurEffectStyleSystemThickMaterial;
        effectView.effect = [UIBlurEffect effectWithStyle:blurStyle];
        effectView.contentView.backgroundColor = (hasCustomBackground && backgroundColor != nil)
                                                     ? backgroundColor
                                                     : UIColor.clearColor;
        effectView.layer.cornerRadius = cornerRadius;
        effectView.layer.cornerCurve = kCACornerCurveContinuous;
        effectView.layer.maskedCorners = maskedCorners ?: allCorners;
        effectView.clipsToBounds = YES;

        effectView.contentView.layer.cornerRadius = cornerRadius;
        effectView.contentView.layer.cornerCurve = kCACornerCurveContinuous;
        effectView.contentView.layer.maskedCorners = maskedCorners ?: allCorners;
        effectView.contentView.clipsToBounds = YES;
    }];
}

@end
