//
//  UIViewController+SelectPopView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertDefineHeader.h"
#import "WDSelectAlertStyleModel.h"
#import "WDDateIntervalAlertStyleModel.h"
#import "WDDateAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SelectPopView)

// MARK: -  系统弹框
/// 选择弹框   取消/确定
-(void)showAlertSelect:(NSString *)message selectAction:(selectOptionsBlcok _Nullable)handler;
-(void)showAlertSelect:(NSString * _Nullable)title message:(NSString *)message selectAction:(selectOptionsBlcok _Nullable)handler;
-(void)showAlertSelect:(NSString * _Nullable)title message:(NSString *)message sureTitle:(NSString * _Nullable)sureTitle selectAction:(selectOptionsBlcok _Nullable)handler;
-(void)showAlertSelect:(NSString * _Nullable)title message:(NSString *)message sureTitle:(NSString * _Nullable)sureTitle cancelTitle:(NSString * _Nullable)cancelTitle selectAction:(selectOptionsBlcok _Nullable)handler;

/// 确认弹框   确定
-(void)showAlertSure:(NSString * _Nullable)title message:(NSString *)message sureTitle:(NSString * _Nullable)sureTitle selectAction:(selectOptionsBlcok _Nullable)handler;

/// 自定义弹框
-(void)showAlertCustomize:(WDSelectAlertStyleModel *)model clickAction:(clickItemBlcok _Nullable)click selectAction:(selectOptionsBlcok _Nullable)handler;


// MARK: -  Sheet弹框
/// 选项弹框 选项+取消
-(void)showSheetSelect:(NSString * _Nullable)title selectItems:(NSArray<NSString *> *)selectItems selectedIndex:(NSInteger)selectedIndex disAbleItems:(NSArray<NSString *> * _Nullable)disAbleItems selectAction:(clickItemBlcok _Nullable)handler;


// MARK: -  时间选择
/// 时间选择
-(void)showDateSelect:(NSDate * _Nullable)date minimumDate:(NSDate * _Nullable)min maximumDate:(NSDate * _Nullable)max style:(WDDateAlertAlertStyle)format changeAction:(void(^)(NSDate * date))changeHandler selectAction:(void(^)(BOOL isSure, NSDate * date))handler;

/// 时间区间 选择
-(void)showDateParagraphSelect:(NSArray <NSString *> * _Nullable)selectDateArr style:(WDDateIntervalAlertStyle)format selectAction:(void(^)(BOOL isSure, NSString * begin, NSString * end))handler;

// MARK: -  其他选择
/// 键值对 选择
-(void)showKeyValueSelect:(NSArray <NSString *> * _Nullable)keyArr valueArr:(NSArray <NSString *> * _Nullable)valueArr index:(NSInteger)index selectAction:(void(^)(BOOL isSure, NSInteger index))handler;






/// 取消
-(void)dismissAction;


@end

NS_ASSUME_NONNULL_END
