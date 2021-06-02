//
//  WDSheetAlertView.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSheetAlertStyleModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WDSheetAlertView : UIView

/**  样式*/
@property (nonatomic, strong, readonly) WDSheetAlertStyleModel * styleModel;

/**  选中index*/
@property (nonatomic, copy) void(^didSelect) (NSInteger index);

/**  取消*/
@property (nonatomic, copy) void(^didClickCancel) (void);

-(instancetype)initWithModel:(WDSheetAlertStyleModel *)model;

/// 计算高度
-(void)updateFrame;

@end

NS_ASSUME_NONNULL_END
