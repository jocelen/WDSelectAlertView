//
//  WDAlertWindowViewController.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAlertWindowStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDAlertWindowViewController : UIViewController

/**  样式*/
@property (nonatomic, strong, readonly) WDAlertWindowStyleModel * styleModel;

/**  展示内容view*/
@property (nonatomic, strong) UIView * contentView;

-(instancetype)initWithModel:(WDAlertWindowStyleModel *)model;

@end

NS_ASSUME_NONNULL_END
