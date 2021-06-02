//
//  WDSelectAlertDefineHeader.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#ifndef WDSelectAlertDefineHeader_h
#define WDSelectAlertDefineHeader_h


typedef NS_ENUM(NSInteger,BCAlertViewPositionType) {
    BCAlertViewPositionTypeCustom = -1, // 自定义
    BCAlertViewPositionTypeTop, // 顶部
    BCAlertViewPositionTypeCenter, // 中间 默认
    BCAlertViewPositionTypeBottom, // 底部
};



/// 选中一个选项
typedef void(^clickItemBlcok)(NSInteger index);

/// 确认选择选项
typedef void(^selectOptionsBlcok)(BOOL isSure,NSString * message);



#endif /* WDSelectAlertDefineHeader_h */
