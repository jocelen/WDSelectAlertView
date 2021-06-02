//
//  WDKeyValueAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2021/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDKeyValueAlertStyleModel : NSObject

/**  背景 颜色*/
@property (nonatomic, strong) UIColor * backgroudColor;
@property (nonatomic, strong) UIColor * pickBackgroudColor;

/**  线条颜色 颜色*/
@property (nonatomic, strong) UIColor * lineSpaceColor;

/**  文本颜色*/
@property (nonatomic, strong) UIColor * textColor;
/**  选中颜色*/
@property (nonatomic, strong) UIColor * selectTextColor;

/**  取消文本*/
@property (nonatomic, copy) NSString * cancelTitle;
/**  取消文本 颜色*/
@property (nonatomic, strong) UIColor * cancelTitleColor;
/**  确定文本*/
@property (nonatomic, copy) NSString * sureTitle;
/**  确定文本 颜色*/
@property (nonatomic, strong) UIColor * sureTitleColor;
@property (nonatomic, strong) UIColor * sureTitleDisableColor;

/**  数据*/
@property (nonatomic, strong) NSArray * keyArr;
@property (nonatomic, strong) NSArray * valueArr;

+(WDKeyValueAlertStyleModel *)defaultStyle;

@end

NS_ASSUME_NONNULL_END
