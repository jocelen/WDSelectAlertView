//
//  WDSelectAlertStyleModel.h
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WDSelectAlertStyleModel : NSObject


/**  边距*/
@property (nonatomic, assign) CGFloat leftPadding;

/**  标题文字高度*/
@property (nonatomic, assign) CGFloat titleHeight;

/**  选中按钮文字高度*/
@property (nonatomic, assign) CGFloat selectButtonHeight;

/**  最大宽度*/
@property (nonatomic, assign) CGFloat maxAlertWidth;
/**  最大高度*/
@property (nonatomic, assign) CGFloat maxAlertHeight;

/**  计算高度 layout之后才会有值*/
@property (nonatomic, assign) CGFloat layoutContentHeight;
@property (nonatomic, assign) CGFloat layoutAlertHeight;

/**  分割线高度*/
@property (nonatomic, assign) CGFloat lineSapceHeight;

/**  圆角*/
@property (nonatomic, assign) CGFloat alertCornerRadius;

/**  背景 颜色*/
@property (nonatomic, strong) UIColor * backgroudColor;

/**  线条颜色 颜色*/
@property (nonatomic, strong) UIColor * lineSpaceColor;


/**  标题*/
@property (nonatomic, copy, nullable) NSString * title;
/**  是否有标题*/
@property (nonatomic, assign, readonly) BOOL hasTitle;
/**  标题文本 颜色*/
@property (nonatomic, strong) UIColor * titleColor;
/**  标题文本 字体*/
@property (nonatomic, strong) UIFont * titleFont;


/**  内容文本*/
@property (nonatomic, copy, nullable) NSString * content;
/**  内容排版 默认 NSTextAlignmentCenter*/
@property (nonatomic) NSTextAlignment contentTextAlignment;
/**  内容文本 颜色*/
@property (nonatomic, strong) UIColor * contentColor;
/**  内容文本 颜色 有标题时候优先使用*/
@property (nonatomic, strong) UIColor * subContentColor;
/**  内容文本 字体*/
@property (nonatomic, strong) UIFont * contentFont;
/**  换行样式*/
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;


/**  是否可选 默认可选*/
@property (nonatomic, assign) BOOL isOptional;
/**  确认按钮文本 默认 ‘确定’*/
@property (nonatomic, copy) NSString * sureTitle;
/**  确定按钮文本 颜色*/
@property (nonatomic, strong) UIColor * sureTitleColor;
/**  确定按钮 字体*/
@property (nonatomic, strong) UIFont * sureTitleFont;


/**  取消按钮文本 默认 ‘取消’*/
@property (nonatomic, copy) NSString * cancelTitle;
/**  取消按钮文本 颜色*/
@property (nonatomic, strong) UIColor * cancelTitleColor;
/**  取消按钮 字体*/
@property (nonatomic, strong) UIFont * cancelTitleFont;


/**  高亮文本 颜色*/
@property (nonatomic, strong) UIColor * highlightColor;
/**  高亮文本 字体*/
@property (nonatomic, strong) UIFont * highlightFont;
/**  高亮文本数组*/
@property (nonatomic, strong, nullable) NSArray <NSString *> * highlightArr;




/**  链接文本 颜色*/
@property (nonatomic, strong) UIColor * linkColor;
/**  链接文本 字体*/
@property (nonatomic, strong) UIFont * linkFont;
/**  链接文本数组*/
@property (nonatomic, strong, nullable) NSArray <NSString *> * linkArr;



+(WDSelectAlertStyleModel *)defaultStyle;

/// 计算富文本
-(NSMutableAttributedString *)layoutAttributesContent;

/// 计算标题
-(CGRect)layoutTitleFrame;

/// 计算确认按钮
-(CGRect)layoutSureButtonFrame;

/// 计算取消按钮
-(CGRect)layoutCancelButtonFrame;


@end

NS_ASSUME_NONNULL_END
