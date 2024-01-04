//
//  WDSheetAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/17.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDSheetAlertStyleModel : NSObject

/**  最大显示个数 默认6个*/
@property (nonatomic, assign) CGFloat maxShowCount;

/**  cell高度 默认60*/
@property (nonatomic, assign) CGFloat cellHeight;

/**  背景 颜色*/
@property (nonatomic, strong) UIColor * backgroudColor;

/**  线条颜色 颜色*/
@property (nonatomic, strong) UIColor * lineSpaceColor;

/**  选项 背景颜色*/
@property (nonatomic, strong) UIColor * cellBackgroudColor;

/**  选项 文字颜色*/
@property (nonatomic, strong) UIColor * cellTextColor;

/**  line高度 默认0.7*/
@property (nonatomic, assign) CGFloat lineHeight;

/**  标题*/
@property (nonatomic, copy, nullable) NSString * title;

/**  标题 属性*/
@property (nonatomic, assign) CGFloat titleTopPadding;
@property (nonatomic, assign) CGFloat titleLeftPadding;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, assign) NSInteger titleNumberOfLines;

/**  数据*/
@property (nonatomic, strong) NSArray<NSString *> * dataArr;


/**  选项 文字颜色*/
@property (nonatomic, strong) UIColor * disableCellTextColor;
/**  不可选数据*/
@property (nonatomic, strong, nullable) NSArray<NSString *> * disAbleDataArr;


/**  取消文本*/
@property (nonatomic, copy) NSString * cancelTitle;
/**  取消 文字颜色*/
@property (nonatomic, strong) UIColor * cancelTitleTextColor;
/**  底部安全距离高度 */
@property (nonatomic, assign, readonly) CGFloat safeEdgeBottomMargin;


+(WDSheetAlertStyleModel *)defaultStyle;

/// 计算标题
-(CGRect)layoutTitleFrame;
-(CGRect)layoutTitleViewFrame;

@end

NS_ASSUME_NONNULL_END
