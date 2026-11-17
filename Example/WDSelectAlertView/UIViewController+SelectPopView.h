//
//  UIViewController+SelectPopView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WDSelectAlertView/WDAlertView.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SelectPopView)

/// 示例工程演示用：当前选中的弹窗材质风格（默认 WDAlertMaterialStyleAutomatic）
@property (nonatomic, assign) WDAlertMaterialStyle wd_demoMaterialStyle;

// MARK: - 确认/选择弹框
- (void)showAlertSelect:(NSString *)message selectAction:(nullable WDAlertSelectOptionsBlock)handler;
- (void)showAlertSelect:(nullable NSString *)title message:(NSString *)message selectAction:(nullable WDAlertSelectOptionsBlock)handler;
- (void)showAlertSelect:(nullable NSString *)title message:(NSString *)message sureTitle:(nullable NSString *)sureTitle selectAction:(nullable WDAlertSelectOptionsBlock)handler;
- (void)showAlertSelect:(nullable NSString *)title message:(NSString *)message sureTitle:(nullable NSString *)sureTitle cancelTitle:(nullable NSString *)cancelTitle selectAction:(nullable WDAlertSelectOptionsBlock)handler;

/// 单按钮确认弹框
- (void)showAlertSure:(nullable NSString *)title message:(NSString *)message sureTitle:(nullable NSString *)sureTitle selectAction:(nullable WDAlertSelectOptionsBlock)handler;

/// 自定义富文本弹框
- (void)showAlertCustomize:(WDSelectAlertStyleModel *)model clickAction:(nullable WDAlertClickItemBlock)click selectAction:(nullable WDAlertSelectOptionsBlock)handler;

// MARK: - Sheet 弹框
- (void)showSheetSelect:(nullable NSString *)title
            selectItems:(NSArray<NSString *> *)selectItems
          selectedIndex:(NSInteger)selectedIndex
           disAbleItems:(nullable NSArray<NSString *> *)disAbleItems
           selectAction:(nullable WDAlertClickItemBlock)handler;

// MARK: - 时间选择
- (void)showDateSelect:(nullable NSDate *)date
           minimumDate:(nullable NSDate *)min
           maximumDate:(nullable NSDate *)max
                 style:(WDDateAlertStyle)format
          changeAction:(nullable void(^)(NSDate *date))changeHandler
          selectAction:(nullable void(^)(BOOL isSure, NSDate *date))handler;

/// 时间区间选择
- (void)showDateParagraphSelect:(nullable NSArray<NSString *> *)selectDateArr
                          style:(WDDateIntervalAlertStyle)format
                   selectAction:(nullable void(^)(BOOL isSure, NSString *begin, NSString *end))handler;

// MARK: - 键值对选择
- (void)showKeyValueSelect:(nullable NSArray<NSString *> *)keyArr
                  valueArr:(nullable NSArray<NSString *> *)valueArr
                     index:(NSInteger)index
              selectAction:(nullable void(^)(BOOL isSure, NSInteger index))handler;

/// 关闭弹窗
- (void)dismissAction;

@end

NS_ASSUME_NONNULL_END
