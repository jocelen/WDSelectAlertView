# WDSelectAlertView

[![Version](https://img.shields.io/cocoapods/v/WDSelectAlertView.svg?style=flat)](https://cocoapods.org/pods/WDSelectAlertView)
[![License](https://img.shields.io/cocoapods/l/WDSelectAlertView.svg?style=flat)](https://cocoapods.org/pods/WDSelectAlertView)
[![Platform](https://img.shields.io/badge/platform-iOS%2015.0%2B-blue.svg?style=flat)](https://github.com/jocelen/WDSelectAlertView)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)

`WDSelectAlertView` 是一个高度可定制的 iOS 弹窗组件库（涵盖确认/富文本弹窗、ActionSheet 选项弹框、年月日选择器、时间区间选择器、双列键值对选择器），已全面适配 **iOS 15.0 ~ iOS 26+**。

## 核心特性

- **原生 iOS 26 Liquid Glass 风格**：默认（`WDAlertMaterialStyleAutomatic`）在 **iOS 26+** 自动启用 `UIGlassEffect` + `UICornerConfiguration` 液态玻璃折射材质，在 **iOS 15 ~ 25** 自动回退至深浅色自适应的系统毛玻璃材质。
- **双包管理支持**：同时支持 **Swift Package Manager (SPM)** 与 **CocoaPods**，提供完整泛型、Nullability 及 `NS_SWIFT_NAME` 混编友好接口。
- **全场景窗口适配**：全面移除废弃的 `UIScreen.mainScreen` 与 `UIButton.titleEdgeInsets`，原生支持 `UIScene` 多窗口、屏幕旋转、iPad 分屏/台前调度以及底部安全区自适应。

## 环境要求

- **iOS 15.0+**
- Xcode 15.0+（如需编译体验原生 iOS 26 Liquid Glass 效果，需使用包含 iOS 26+ SDK 的 Xcode 26+）

## 安装方式

### Swift Package Manager (SPM)

在 Xcode 中选择 **File > Add Package Dependencies...**，输入仓库地址：

```text
https://github.com/jocelen/WDSelectAlertView.git
```

或在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/jocelen/WDSelectAlertView.git", from: "0.2.0")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
platform :ios, '15.0'
pod 'WDSelectAlertView'
```

## 快速使用

### Swift

```swift
import WDSelectAlertView

let model = WDSelectAlertStyleModel.defaultStyle()
model.title = "温馨提示"
model.content = "已完成 iOS 26 Liquid Glass 适配"
// 可切换材质：.automatic (默认) / .glass / .clearGlass / .solid
model.materialStyle = .automatic

let alertView = WDSelectAlertView(model: model)
let height = alertView.layoutAlertHeight()
alertView.frame = CGRect(x: 0, y: 0, width: model.maxAlertWidth, height: height)

let windowStyle = WDAlertWindowStyleModel.defaultStyle()
windowStyle.position = .center
let alertVC = WDAlertWindowViewController(model: windowStyle)
alertVC.contentView = alertView

alertView.selectAction = { [weak alertVC] isSure, _ in
    alertVC?.dismissAlert(animated: true)
}

present(alertVC, animated: true)
```

### Objective-C

```objc
#import <WDSelectAlertView/WDAlertView.h>

WDSelectAlertStyleModel *model = [WDSelectAlertStyleModel defaultStyle];
model.title = @"温馨提示";
model.content = @"已完成 iOS 26 Liquid Glass 适配";

WDSelectAlertView *alertView = [[WDSelectAlertView alloc] initWithModel:model];
CGFloat height = [alertView layoutAlertHeight];
alertView.frame = CGRectMake(0, 0, model.maxAlertWidth, height);

WDAlertWindowStyleModel *windowStyle = [WDAlertWindowStyleModel defaultStyle];
windowStyle.position = WDAlertViewPositionTypeCenter;
WDAlertWindowViewController *vc = [[WDAlertWindowViewController alloc] initWithModel:windowStyle];
vc.contentView = alertView;

__weak typeof(vc) weakVC = vc;
alertView.selectAction = ^(BOOL isSure, NSString *message) {
    [weakVC dismissAlertAnimated:YES completion:nil];
};

[self presentViewController:vc animated:YES completion:nil];
```

## 示例工程

克隆仓库后在 `Example` 目录执行 `pod install`，打开 `Example/WDSelectAlertView.xcworkspace` 即可运行演示工程，支持在导航栏一键切换 **Liquid Glass / 通透玻璃 / 纯色材质** 以及 **深浅色外观模式**。

## Author

jocelen, jocelen@163.com

## License

WDSelectAlertView is available under the MIT license. See the LICENSE file for more info.
