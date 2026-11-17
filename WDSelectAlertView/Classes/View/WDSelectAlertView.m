//
//  WDSelectAlertView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSelectAlertView.h"
#import "WDSelectAlertHelper.h"

static NSString * const kSelectAlertActionTag = @"actionevent%lu";

@interface WDSelectAlertView () <UITextViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleLine;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *buttonTopLine;
@property (nonatomic, strong) UIView *buttonMiddleLine;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation WDSelectAlertView

@synthesize styleModel = _styleModel;

- (instancetype)initWithModel:(WDSelectAlertStyleModel *)model {
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model ?: [WDSelectAlertStyleModel defaultStyle];
        [self loadConfig];
        [self addSubviews];
        [self loadData];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_styleModel) {
        _styleModel = [WDSelectAlertStyleModel defaultStyle];
    }
    [self loadConfig];
    [self addSubviews];
    [self loadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.backgroundEffectView.frame = self.bounds;

    CGFloat widthMax = CGRectGetWidth(self.bounds) > 0 ? CGRectGetWidth(self.bounds) : self.styleModel.maxAlertWidth;
    CGFloat lineSpace = self.styleModel.lineSpaceHeight;
    CGFloat leftPadding = self.styleModel.leftPadding;

    self.titleLabel.frame = self.styleModel.layoutTitleFrame;

    if (self.styleModel.hasTitle) {
        self.titleLine.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), widthMax, lineSpace);
        self.titleLine.hidden = NO;
    } else {
        self.titleLine.hidden = YES;
    }

    CGFloat contentTopPadding = leftPadding * (self.styleModel.hasTitle ? 1.0 : 1.5);
    self.textView.frame = CGRectMake(leftPadding,
                                     CGRectGetMaxY(self.titleLabel.frame) + contentTopPadding,
                                     MAX(0, widthMax - leftPadding * 2),
                                     self.styleModel.layoutContentHeight);

    CGFloat buttonAreaHeight = self.styleModel.selectButtonHeight + lineSpace;
    CGFloat buttonY = CGRectGetHeight(self.bounds) - buttonAreaHeight;
    self.buttonView.frame = CGRectMake(0, buttonY, widthMax, buttonAreaHeight);
    self.buttonTopLine.frame = CGRectMake(0, 0, widthMax, lineSpace);

    self.cancelButton.hidden = !self.styleModel.isOptional;
    self.cancelButton.frame = self.styleModel.layoutCancelButtonFrame;
    self.sureButton.frame = self.styleModel.layoutSureButtonFrame;

    if (self.styleModel.isOptional) {
        self.buttonMiddleLine.hidden = NO;
        self.buttonMiddleLine.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                                 lineSpace,
                                                 lineSpace,
                                                 self.styleModel.selectButtonHeight);
    } else {
        self.buttonMiddleLine.hidden = YES;
    }
}

#pragma mark - Private Methods

- (void)loadConfig {
    self.backgroundColor = UIColor.clearColor;
}

- (void)addSubviews {
    [self addSubview:self.backgroundEffectView];
    CACornerMask allCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner |
                              kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    [WDSelectAlertHelper applyMaterialStyle:self.styleModel.materialStyle
                            backgroundColor:self.styleModel.backgroundColor
                       hasCustomBackground:self.styleModel.hasCustomBackgroundColor
                               cornerRadius:self.styleModel.alertCornerRadius
                              maskedCorners:allCorners
                               toEffectView:self.backgroundEffectView];
    UIView *container = self.backgroundEffectView.contentView;
    [container addSubview:self.titleLine];
    [container addSubview:self.titleLabel];
    [container addSubview:self.textView];

    [container addSubview:self.buttonView];
    [self.buttonView addSubview:self.buttonTopLine];
    [self.buttonView addSubview:self.buttonMiddleLine];
    [self.buttonView addSubview:self.sureButton];
    [self.buttonView addSubview:self.cancelButton];
}

- (void)loadData {
    self.textView.attributedText = [self attributesMessage];
    self.textView.linkTextAttributes = [self linkTextAttributes];
}

- (void)handleButtonTap:(UIButton *)sender {
    BOOL isSure = (sender == self.sureButton);
    NSString *message = isSure ? self.styleModel.sureTitle : self.styleModel.cancelTitle;
    if (self.selectAction) {
        self.selectAction(isSure, message);
    }
}

- (BOOL)handleInteractWithURL:(nullable NSURL *)URL {
    if (URL.scheme.length == 0) {
        return YES;
    }
    for (NSUInteger i = 0; i < self.styleModel.linkArr.count; i++) {
        NSString *target = [NSString stringWithFormat:kSelectAlertActionTag, (unsigned long)i];
        if ([URL.scheme caseInsensitiveCompare:target] == NSOrderedSame) {
            if (self.clickLinkAction) {
                self.clickLinkAction((NSInteger)i);
            }
            return NO;
        }
    }
    return YES;
}

#pragma mark - Public Methods

- (CGFloat)layoutAlertHeight {
    CGFloat leftPadding = self.styleModel.leftPadding;
    CGFloat contentTopPadding = leftPadding * (self.styleModel.hasTitle ? 1.0 : 1.5);
    CGFloat heightMax = self.styleModel.maxAlertHeight;
    CGFloat titleHeight = self.styleModel.layoutTitleFrame.size.height;

    CGSize maxSize = CGSizeMake(MAX(0, self.styleModel.maxAlertWidth - leftPadding * 2), CGFLOAT_MAX);
    self.textView.textAlignment = self.styleModel.contentTextAlignment;
    CGRect contentRect = [[self attributesMessage] boundingRectWithSize:maxSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                context:nil];
    CGFloat layoutMessageHeight = ceil(contentRect.size.height + 4.0);
    CGFloat selectHeight = self.styleModel.selectButtonHeight + self.styleModel.lineSpaceHeight;

    CGFloat maxContentHeight = MAX(40.0, heightMax - titleHeight - selectHeight - contentTopPadding * 2);
    BOOL canScrollEnabled = layoutMessageHeight > maxContentHeight;
    CGFloat messageHeight = MIN(maxContentHeight, layoutMessageHeight) + contentTopPadding * 2;

    CGFloat layoutAlertHeight = titleHeight + messageHeight + selectHeight;
    self.textView.scrollEnabled = canScrollEnabled;
    self.styleModel.layoutContentHeight = canScrollEnabled ? maxContentHeight : layoutMessageHeight;
    self.styleModel.layoutAlertHeight = layoutAlertHeight;
    return layoutAlertHeight;
}

- (NSAttributedString *)attributesMessage {
    NSMutableAttributedString *attributeStr = [self.styleModel layoutAttributesContent];
    NSString *fullText = attributeStr.string;
    if (fullText.length == 0) {
        return attributeStr;
    }

    // 匹配所有高亮文本区间
    for (NSUInteger i = 0; i < self.styleModel.highlightArr.count; i++) {
        NSString *item = self.styleModel.highlightArr[i];
        if (item.length == 0) {
            continue;
        }
        NSRange searchRange = NSMakeRange(0, fullText.length);
        while (searchRange.location < fullText.length) {
            NSRange foundRange = [fullText rangeOfString:item options:0 range:searchRange];
            if (foundRange.location == NSNotFound) {
                break;
            }
            NSMutableDictionary<NSAttributedStringKey, id> *dic = [NSMutableDictionary dictionary];
            if (self.styleModel.highlightColor) {
                dic[NSForegroundColorAttributeName] = self.styleModel.highlightColor;
            }
            if (self.styleModel.highlightFont) {
                dic[NSFontAttributeName] = self.styleModel.highlightFont;
            }
            [attributeStr addAttributes:dic range:foundRange];
            NSUInteger nextLoc = NSMaxRange(foundRange);
            searchRange = NSMakeRange(nextLoc, fullText.length - nextLoc);
        }
    }

    // 匹配所有自定义链接区间
    for (NSUInteger i = 0; i < self.styleModel.linkArr.count; i++) {
        NSString *item = self.styleModel.linkArr[i];
        if (item.length == 0) {
            continue;
        }
        NSString *actionURLString = [NSString stringWithFormat:@"%@://", [NSString stringWithFormat:kSelectAlertActionTag, (unsigned long)i]];
        NSRange searchRange = NSMakeRange(0, fullText.length);
        while (searchRange.location < fullText.length) {
            NSRange foundRange = [fullText rangeOfString:item options:0 range:searchRange];
            if (foundRange.location == NSNotFound) {
                break;
            }
            NSMutableDictionary<NSAttributedStringKey, id> *dic = [NSMutableDictionary dictionary];
            if (self.styleModel.linkFont) {
                dic[NSFontAttributeName] = self.styleModel.linkFont;
            }
            dic[NSLinkAttributeName] = actionURLString;
            [attributeStr addAttributes:dic range:foundRange];
            NSUInteger nextLoc = NSMaxRange(foundRange);
            searchRange = NSMakeRange(nextLoc, fullText.length - nextLoc);
        }
    }

    return attributeStr;
}

- (NSDictionary<NSAttributedStringKey, id> *)linkTextAttributes {
    NSMutableDictionary<NSAttributedStringKey, id> *dic = [NSMutableDictionary dictionary];
    if (self.styleModel.linkColor) {
        dic[NSForegroundColorAttributeName] = self.styleModel.linkColor;
    }
    return dic;
}

#pragma mark - UITextViewDelegate

- (nullable UIAction *)textView:(UITextView *)textView
       primaryActionForTextItem:(UITextItem *)textItem
                  defaultAction:(UIAction *)defaultAction API_AVAILABLE(ios(17.0)) {
    if (textItem.contentType == UITextItemContentTypeLink && textItem.link != nil) {
        NSURL *linkURL = textItem.link;
        for (NSUInteger i = 0; i < self.styleModel.linkArr.count; i++) {
            NSString *target = [NSString stringWithFormat:kSelectAlertActionTag, (unsigned long)i];
            if ([linkURL.scheme caseInsensitiveCompare:target] == NSOrderedSame) {
                __weak typeof(self) weakSelf = self;
                return [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    [weakSelf handleInteractWithURL:linkURL];
                }];
            }
        }
    }
    return defaultAction;
}

- (nullable UITextItemMenuConfiguration *)textView:(UITextView *)textView
                      menuConfigurationForTextItem:(UITextItem *)textItem
                                       defaultMenu:(UIMenu *)defaultMenu API_AVAILABLE(ios(17.0)) {
    return nil;
}

- (nullable UIMenu *)textView:(UITextView *)textView
       editMenuForTextInRange:(NSRange)range
             suggestedActions:(NSArray<UIMenuElement *> *)suggestedActions API_AVAILABLE(ios(16.0)) {
    return [UIMenu menuWithChildren:@[]];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
     interaction:(UITextItemInteraction)interaction {
    if (interaction == UITextItemInteractionInvokeDefaultAction ||
        interaction == UITextItemInteractionPresentActions) {
        return [self handleInteractWithURL:URL];
    }
    return NO;
}
#pragma clang diagnostic pop

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return NO;
}

#pragma mark - Getters

- (UIVisualEffectView *)backgroundEffectView {
    if (!_backgroundEffectView) {
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
    }
    return _backgroundEffectView;
}

- (UIView *)titleLine {
    if (!_titleLine) {
        _titleLine = [[UIView alloc] init];
        _titleLine.backgroundColor = self.styleModel.lineSpaceColor;
    }
    return _titleLine;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.styleModel.titleFont;
        label.textColor = self.styleModel.titleColor;
        label.text = self.styleModel.title;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        UITextView *view = [[UITextView alloc] init];
        view.backgroundColor = UIColor.clearColor;
        view.textContainerInset = UIEdgeInsetsZero;
        view.textContainer.lineFragmentPadding = 0;
        view.showsVerticalScrollIndicator = NO;
        view.alwaysBounceVertical = NO;
        view.editable = NO;
        view.selectable = YES;
        view.dataDetectorTypes = UIDataDetectorTypeLink;
        view.delegate = self;
        _textView = view;
    }
    return _textView;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        _buttonView.backgroundColor = UIColor.clearColor;
    }
    return _buttonView;
}

- (UIView *)buttonTopLine {
    if (!_buttonTopLine) {
        _buttonTopLine = [[UIView alloc] init];
        _buttonTopLine.backgroundColor = self.styleModel.lineSpaceColor;
    }
    return _buttonTopLine;
}

- (UIView *)buttonMiddleLine {
    if (!_buttonMiddleLine) {
        _buttonMiddleLine = [[UIView alloc] init];
        _buttonMiddleLine.backgroundColor = self.styleModel.lineSpaceColor;
    }
    return _buttonMiddleLine;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = UIColor.clearColor;
        [button setTitleColor:self.styleModel.sureTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = self.styleModel.sureTitleFont;
        if (self.styleModel.sureTitleAdjusts) {
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = self.styleModel.sureTitleMinimumScaleFactor > 0 ? self.styleModel.sureTitleMinimumScaleFactor : 0.5;
            button.titleLabel.lineBreakMode = NSLineBreakByClipping;
        }
        [button setTitle:self.styleModel.sureTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = button;
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = UIColor.clearColor;
        [button setTitleColor:self.styleModel.cancelTitleColor forState:UIControlStateNormal];
        [button setTitle:self.styleModel.cancelTitle forState:UIControlStateNormal];
        button.titleLabel.font = self.styleModel.cancelTitleFont;
        if (self.styleModel.cancelTitleAdjusts) {
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = self.styleModel.cancelTitleMinimumScaleFactor > 0 ? self.styleModel.cancelTitleMinimumScaleFactor : 0.5;
            button.titleLabel.lineBreakMode = NSLineBreakByClipping;
        }
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

@end
