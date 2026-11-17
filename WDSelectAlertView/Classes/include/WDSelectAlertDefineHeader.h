//
//  WDSelectAlertDefineHeader.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#ifndef WDSelectAlertDefineHeader_h
#define WDSelectAlertDefineHeader_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 弹窗展示位置
typedef NS_ENUM(NSInteger, WDAlertViewPositionType) {
    WDAlertViewPositionTypeCustom = -1, // 自定义 frame
    WDAlertViewPositionTypeTop = 0,     // 顶部贴边
    WDAlertViewPositionTypeCenter = 1,  // 居中（默认）
    WDAlertViewPositionTypeBottom = 2,  // 底部贴边
} NS_SWIFT_NAME(WDAlertPosition);

/// 向后兼容旧版 BC 前缀枚举
typedef WDAlertViewPositionType BCAlertViewPositionType API_DEPRECATED_WITH_REPLACEMENT("WDAlertViewPositionType", ios(9.0, 15.0));
enum {
    BCAlertViewPositionTypeCustom API_DEPRECATED_WITH_REPLACEMENT("WDAlertViewPositionTypeCustom", ios(9.0, 15.0)) = WDAlertViewPositionTypeCustom,
    BCAlertViewPositionTypeTop API_DEPRECATED_WITH_REPLACEMENT("WDAlertViewPositionTypeTop", ios(9.0, 15.0)) = WDAlertViewPositionTypeTop,
    BCAlertViewPositionTypeCenter API_DEPRECATED_WITH_REPLACEMENT("WDAlertViewPositionTypeCenter", ios(9.0, 15.0)) = WDAlertViewPositionTypeCenter,
    BCAlertViewPositionTypeBottom API_DEPRECATED_WITH_REPLACEMENT("WDAlertViewPositionTypeBottom", ios(9.0, 15.0)) = WDAlertViewPositionTypeBottom,
};

/// 弹窗背景材质风格
typedef NS_ENUM(NSInteger, WDAlertMaterialStyle) {
    /// 自动适配：iOS 26+ 默认启用原生 Liquid Glass (UIGlassEffect)，iOS 15-25 使用系统自适应材质 (UIBlurEffectStyleSystemThickMaterial)
    WDAlertMaterialStyleAutomatic = 0,
    /// 标准毛玻璃 / 液态玻璃材质（iOS 26+ UIGlassEffectStyleRegular）
    WDAlertMaterialStyleGlass = 1,
    /// 通透玻璃材质（iOS 26+ UIGlassEffectStyleClear，iOS 15-25 SystemUltraThinMaterial）
    WDAlertMaterialStyleClearGlass = 2,
    /// 纯色不透明材质（禁用玻璃折射，完全使用 backgroundColor 填充）
    WDAlertMaterialStyleSolid = 3,
} NS_SWIFT_NAME(WDAlertMaterialStyle);

/// 选中一个选项回调
typedef void(^WDAlertClickItemBlock)(NSInteger index);

/// 确认/取消选择回调
typedef void(^WDAlertSelectOptionsBlock)(BOOL isSure, NSString *message);

/// 向后兼容旧版拼写 typedef
typedef WDAlertClickItemBlock clickItemBlcok API_DEPRECATED_WITH_REPLACEMENT("WDAlertClickItemBlock", ios(9.0, 15.0));
typedef WDAlertSelectOptionsBlock selectOptionsBlcok API_DEPRECATED_WITH_REPLACEMENT("WDAlertSelectOptionsBlock", ios(9.0, 15.0));

NS_ASSUME_NONNULL_END

#endif /* WDSelectAlertDefineHeader_h */
