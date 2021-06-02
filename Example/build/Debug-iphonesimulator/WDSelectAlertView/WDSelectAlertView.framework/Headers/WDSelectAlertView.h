//
//  WDSelectAlertView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSelectAlertStyleModel.h"
#import "WDSelectAlertDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDSelectAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDSelectAlertStyleModel * styleModel;

/**  链接点击事件*/
@property (nonatomic, copy, nullable) clickItemBlcok clickLinkAction;

/**  选择按钮点击事件*/
@property (nonatomic, copy, nullable) selectOptionsBlcok selectAction;


-(instancetype)initWithModel:(WDSelectAlertStyleModel *)model;


/// 计算高度
-(CGFloat)layoutAlertHeight;


@end




NS_ASSUME_NONNULL_END
