//
//  UIViewController+SelectPopView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "UIViewController+SelectPopView.h"
#import "WDSelectAlertHelper.h"
#import "WDAlertWindowViewController.h"

#import "WDDateIntervalAlertView.h"
#import "WDSelectAlertView.h"
#import "WDSheetAlertView.h"
#import "WDDateAlertView.h"
#import "WDKeyValueAlertView.h"

@implementation UIViewController (SelectPopView)

// MARK: -  public methods

// MARK: -  系统弹框

-(void)showAlertSelect:(NSString *)message selectAction:(selectOptionsBlcok _Nullable)handler;
{
    [self showAlertSelect:nil message:message sureTitle:nil cancelTitle:nil selectAction:handler];
}

-(void)showAlertSelect:(NSString * _Nullable)title message:(NSString *)message selectAction:(selectOptionsBlcok _Nullable)handler;
{
    [self showAlertSelect:title message:message sureTitle:nil cancelTitle:nil selectAction:handler];
}

-(void)showAlertSelect:(NSString * _Nullable)title message:(NSString *)message sureTitle:(NSString * _Nullable)sureTitle selectAction:(selectOptionsBlcok _Nullable)handler;
{
    [self showAlertSelect:title message:message sureTitle:sureTitle cancelTitle:nil selectAction:handler];
}

-(void)showAlertSelect:(NSString * _Nullable)title message:(NSString *)message sureTitle:(NSString * _Nullable)sureTitle cancelTitle:(NSString * _Nullable)cancelTitle selectAction:(selectOptionsBlcok _Nullable)handler;
{
    WDSelectAlertStyleModel * model = [WDSelectAlertStyleModel defaultStyle];
    model.title = title;
    model.content = message;
    model.sureTitle = sureTitle;
    model.cancelTitle = cancelTitle;
    model.isOptional = YES;
    [self showAlertCustomize:model clickAction:nil selectAction:handler];
}


-(void)showAlertSure:(NSString * _Nullable)title message:(NSString *)message sureTitle:(NSString * _Nullable)sureTitle selectAction:(selectOptionsBlcok _Nullable)handler;
{
    WDSelectAlertStyleModel * model = [WDSelectAlertStyleModel defaultStyle];
    model.title = title;
    model.content = message;
    model.sureTitle = sureTitle;
    model.isOptional = NO;
    [self showAlertCustomize:model clickAction:nil selectAction:handler];
}


/// 自定义弹框
-(void)showAlertCustomize:(WDSelectAlertStyleModel *)model clickAction:(clickItemBlcok _Nullable)click selectAction:(selectOptionsBlcok _Nullable)handler;
{
    if (model == nil || model.content == nil || model.content.length == 0) { return; }
    
    WDAlertWindowStyleModel * style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.position = BCAlertViewPositionTypeCenter;
    
    WDAlertWindowViewController * vc = [[WDAlertWindowViewController alloc] initWithModel:style];

    WDSelectAlertView * content = [[WDSelectAlertView alloc] initWithModel:model];
    [content layoutAlertHeight];
    content.frame = CGRectMake(0, 0, content.styleModel.maxAlertWidth, content.styleModel.layoutAlertHeight);
    
    __weak typeof(self) weakSelf = self;
    content.selectAction = ^(BOOL isSure, NSString * _Nonnull message) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            if (handler) {
                handler(isSure,message);
            }
        }];
    };
    
    content.clickLinkAction = ^(NSInteger index) {

        if (click) {
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                click(index);
            }];
        }

    };
    
    vc.contentView = content;
    [self presentViewController:vc animated:NO completion:nil];
    
}




-(void)showSheetSelect:(NSArray<NSString *> *)selectItems disAbleItems:(NSArray<NSString *> *)disAbleItems selectAction:(clickItemBlcok _Nullable)handler;
{
    if (!selectItems || [selectItems isKindOfClass:[NSArray class]] == NO || selectItems.count == 0) { return;}
    
    WDAlertWindowStyleModel * style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = YES;
    style.isGroundGlass = NO;
    style.position = BCAlertViewPositionTypeBottom;
    
    WDAlertWindowViewController * vc = [[WDAlertWindowViewController alloc] initWithModel:style];
    
    WDSheetAlertStyleModel * model = [WDSheetAlertStyleModel defaultStyle];
    model.dataArr = selectItems;
    model.disAbleDataArr = disAbleItems;
    
    WDSheetAlertView * content = [[WDSheetAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 0);
    [content updateFrame];
    
    __weak typeof(self) weakSelf = self;
    // 选择
    content.didSelect = ^(NSInteger index) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            if (handler) {
                handler(index);
            }
        }];
    };
    // 取消
    content.didClickCancel = ^{
        [weakSelf dismissAction];
    };
    
    vc.contentView = content;
    [self presentViewController:vc animated:NO completion:nil];
}


-(void)showDateSelect:(NSDate * _Nullable)date minimumDate:(NSDate * _Nullable)min maximumDate:(NSDate * _Nullable)max changeAction:(void(^)(NSDate * date))changeHandler selectAction:(void(^)(BOOL isSure, NSDate * date))handler;
{
    WDAlertWindowStyleModel * style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = YES;
    style.isGroundGlass = NO;
    style.position = BCAlertViewPositionTypeBottom;
    
    WDAlertWindowViewController * vc = [[WDAlertWindowViewController alloc] initWithModel:style];
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 250 + [WDSelectAlertHelper safeEdgeBottomMargin]);
    
    WDDateAlertStyleModel * model = [WDDateAlertStyleModel defaultStyle];
    model.date = date;
    model.minimumDate = min;
    model.maximumDate = max;

    WDDateAlertView * content = [[WDDateAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, size.width, size.height);
    
    
    __weak typeof(self) weakSelf = self;
    // 选择
    content.didSelectDate = ^(NSDate * _Nonnull date) {
        if (changeHandler) {
            changeHandler(date);
        }
    };
    // 选择按钮
    content.didClickButton = ^(BOOL isSure, NSDate * _Nonnull date) {
        [weakSelf dismissAction];
        
        if (handler) {
            handler(isSure,date);
        }
    };
    
    vc.contentView = content;
    [self presentViewController:vc animated:NO completion:nil];
}


-(void)showDateParagraphSelect:(NSArray <NSString *> * _Nullable)selectDateArr selectAction:(void(^)(BOOL isSure, NSString * begin, NSString * end))handler;
{
    WDAlertWindowStyleModel * style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = YES;
    style.isGroundGlass = NO;
    style.position = BCAlertViewPositionTypeBottom;
    
    WDAlertWindowViewController * vc = [[WDAlertWindowViewController alloc] initWithModel:style];
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 250 + [WDSelectAlertHelper safeEdgeBottomMargin]);
    
    WDDateIntervalAlertStyleModel * model = [WDDateIntervalAlertStyleModel defaultStyle];
    model.beginDate = selectDateArr.firstObject;
    model.endDate = selectDateArr.lastObject;
    
    WDDateIntervalAlertView * content = [[WDDateIntervalAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, size.width, size.height);

    __weak typeof(self) weakSelf = self;
    // 选择
    content.didSelectDate = ^(NSString * _Nonnull beginDate, NSString * _Nonnull endDate) {
        
    };
    
    // 选择按钮
    content.didClickButton = ^(BOOL isSure, NSString * _Nonnull beginDate, NSString * _Nonnull endDate) {
        [weakSelf dismissAction];

        if (handler) {
            handler(isSure,beginDate,endDate);
        }
    };
    
    vc.contentView = content;
    [self presentViewController:vc animated:NO completion:nil];
    
}

-(void)showKeyValueSelect:(NSArray <NSString *> * _Nullable)keyArr valueArr:(NSArray <NSString *> * _Nullable)valueArr index:(NSInteger)index selectAction:(void(^)(BOOL isSure, NSInteger index))handler;
{
    WDAlertWindowStyleModel * style = [WDAlertWindowStyleModel defaultStyle];
    style.isGroundGlass = NO;
    style.canTouchCancel = YES;
    style.position = BCAlertViewPositionTypeBottom;
    WDAlertWindowViewController * vc = [[WDAlertWindowViewController alloc] initWithModel:style];
        
    WDKeyValueAlertStyleModel * model = [WDKeyValueAlertStyleModel defaultStyle];
    model.keyArr = keyArr;
    model.valueArr = valueArr;
    
    __weak typeof(self) weakSelf = self;
    WDKeyValueAlertView * content = [[WDKeyValueAlertView alloc] initWithModel:model];
    content.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300 + [WDSelectAlertHelper safeEdgeBottomMargin]);
    content.selectIndex = index;
    // 选择按钮
    content.didClickButton = ^(BOOL isSure, NSInteger index) {
        [weakSelf dismissAction];

        if (handler) {
            handler(isSure,index);
        }
    };
    
    vc.contentView = content;
    [self presentViewController:vc animated:NO completion:nil];
    
}


/// 取消
-(void)dismissAction;
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


// MARK: -  private methods



@end
