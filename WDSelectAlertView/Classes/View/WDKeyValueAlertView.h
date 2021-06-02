//
//  WDKeyValueAlertView.h
//  BOC
//
//  Created by dzkj on 2021/1/6.
//  Copyright © 2021 mimiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDKeyValueAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDKeyValueAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDKeyValueAlertStyleModel * styleModel;

/**  index*/
@property (nonatomic, assign) NSInteger selectIndex;

/**  选中index*/
@property (nonatomic, copy) void(^didSelectDate) (NSInteger index);

/**  点击按钮*/
@property (nonatomic, copy) void(^didClickButton) (BOOL isSure, NSInteger index);

-(instancetype)initWithModel:(WDKeyValueAlertStyleModel *)model;


@end




@interface WDKeyValueAlertViewCell : UIView

/**  左标题*/
@property (nonatomic, strong) UILabel * leftLabel;
/**  右标题*/
@property (nonatomic, strong) UILabel * rightLabel;

/**  文字颜色*/
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * selectTextColor;

/**  选中*/
@property (nonatomic, assign) BOOL isSelect;

@end



NS_ASSUME_NONNULL_END
