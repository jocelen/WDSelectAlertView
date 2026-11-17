//
//  WDSheetAlertView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSheetAlertView.h"
#import "WDSelectAlertHelper.h"

static NSInteger const kSheetButtonTagBase = 1000;

@interface WDSheetAlertButton ()
@property (nonatomic, assign) NSDirectionalRectEdge iconPlacement;
@property (nonatomic, assign) CGFloat iconPadding;
@property (nonatomic, strong, nullable) UIColor *normalStateTitleColor;
@property (nonatomic, strong, nullable) UIColor *disabledStateTitleColor;
@property (nonatomic, strong, nullable) UIColor *normalStateBackgroundColor;
@property (nonatomic, assign) BOOL isApplyingConfiguration;
@end

@interface WDSheetAlertView ()

@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleBottomLine;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *cancelGapView;
@property (nonatomic, strong) WDSheetAlertButton *cancelButton;

@end

@implementation WDSheetAlertView

@synthesize styleModel = _styleModel;

- (instancetype)initWithModel:(WDSheetAlertStyleModel *)model {
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model ?: [WDSheetAlertStyleModel defaultStyle];
        [self loadConfig];
        [self addSubviews];
        [self rebuildItemsAndLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_styleModel) {
        _styleModel = [WDSheetAlertStyleModel defaultStyle];
    }
    [self loadConfig];
    [self addSubviews];
    [self rebuildItemsAndLayout];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self updateLayoutMetricsUpdatingOwnFrame:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundEffectView.frame = self.bounds;
    [self updateLayoutMetricsUpdatingOwnFrame:NO];
}

#pragma mark - Private Methods

- (void)loadConfig {
    self.backgroundColor = UIColor.clearColor;
}

- (void)addSubviews {
    [self addSubview:self.backgroundEffectView];
    UIView *container = self.backgroundEffectView.contentView;
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.titleBottomLine];
    [container addSubview:self.titleView];
    [container addSubview:self.scrollView];
    [container addSubview:self.cancelGapView];
    [container addSubview:self.cancelButton];
}

- (void)updateEffectAppearance {
    self.backgroundEffectView.frame = self.bounds;
    CACornerMask topCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [WDSelectAlertHelper applyMaterialStyle:self.styleModel.materialStyle
                            backgroundColor:self.styleModel.backgroundColor
                       hasCustomBackground:self.styleModel.hasCustomBackgroundColor
                               cornerRadius:self.styleModel.sheetCornerRadius
                              maskedCorners:topCorners
                               toEffectView:self.backgroundEffectView];
}

- (UIColor *)resolvedCellFillColor {
    if (self.styleModel.materialStyle == WDAlertMaterialStyleSolid || self.styleModel.hasCustomCellBackgroundColor) {
        return self.styleModel.cellBackgroundColor ?: UIColor.secondarySystemGroupedBackgroundColor;
    }
    return UIColor.clearColor;
}

- (void)selectAction:(UIButton *)sender {
    if (self.didSelect) {
        self.didSelect(sender.tag - kSheetButtonTagBase);
    }
}

- (void)cancelAction:(UIButton *)sender {
    if (self.didClickCancel) {
        self.didClickCancel();
    }
}

#pragma mark - Public Methods

- (void)setStyleModel:(WDSheetAlertStyleModel *)styleModel {
    _styleModel = styleModel ?: [WDSheetAlertStyleModel defaultStyle];
    self.titleLabel.font = _styleModel.titleFont;
    self.titleLabel.textColor = _styleModel.titleColor;
    self.titleLabel.text = _styleModel.title;
    self.titleLabel.numberOfLines = _styleModel.titleNumberOfLines;
    [self rebuildItemsAndLayout];
}

- (void)updateFrame {
    [self rebuildItemsAndLayout];
}

- (void)rebuildItemsAndLayout {
    for (UIView *sub in [self.scrollView.subviews copy]) {
        [sub removeFromSuperview];
    }

    UIColor *cellFill = [self resolvedCellFillColor];
    self.titleView.backgroundColor = cellFill;
    self.titleLabel.font = self.styleModel.titleFont;
    self.titleLabel.textColor = self.styleModel.titleColor;
    self.titleLabel.text = self.styleModel.title;
    self.titleLabel.numberOfLines = self.styleModel.titleNumberOfLines;
    self.titleBottomLine.backgroundColor = self.styleModel.lineSpaceColor;

    NSUInteger count = self.styleModel.dataArr.count;
    for (NSUInteger i = 0; i < count; i++) {
        WDSheetAlertButton *button = [self createItemButtonWithFillColor:cellFill];
        button.tag = kSheetButtonTagBase + (NSInteger)i;
        NSString *itemTitle = self.styleModel.dataArr[i];
        [button setTitle:itemTitle forState:UIControlStateNormal];

        if ((NSInteger)i == self.styleModel.selectedIndex) {
            button.enabled = self.styleModel.selectedEnabled;
            [button setTitleColor:self.styleModel.selectedTextColor forState:UIControlStateNormal];
            [button setTitleColor:self.styleModel.selectedTextColor forState:UIControlStateDisabled];
            if (self.styleModel.selectedItemImage) {
                [button setImage:self.styleModel.selectedItemImage forState:UIControlStateNormal];
                if (self.styleModel.iconPositionLeft) {
                    [button setIconInLeftWithSpacing:self.styleModel.iconSpacing];
                } else {
                    [button setIconInRightWithSpacing:self.styleModel.iconSpacing];
                }
            }
        } else {
            BOOL isDisabled = [self.styleModel.disabledDataArr containsObject:itemTitle];
            button.enabled = !isDisabled;
        }

        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];

        if (i + 1 < count) {
            UIView *separator = [[UIView alloc] init];
            separator.tag = -100 - (NSInteger)i;
            separator.backgroundColor = self.styleModel.lineSpaceColor;
            [self.scrollView addSubview:separator];
        }
    }

    self.cancelGapView.backgroundColor = (self.styleModel.materialStyle == WDAlertMaterialStyleSolid)
                                             ? self.styleModel.backgroundColor
                                             : UIColor.quaternarySystemFillColor;
    self.cancelButton.backgroundColor = cellFill;
    [self.cancelButton setTitle:self.styleModel.cancelTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.styleModel.cancelTitleTextColor forState:UIControlStateNormal];

    [self updateLayoutMetricsUpdatingOwnFrame:YES];
    [self updateEffectAppearance];
}

- (void)updateLayoutMetricsUpdatingOwnFrame:(BOOL)updateOwnFrame {
    CGFloat width = CGRectGetWidth(self.bounds);
    if (width <= 0) {
        width = [WDSelectAlertHelper containerBoundsForView:self].size.width;
    }

    CGRect titleViewFrame = [self.styleModel layoutTitleViewFrameWithMaxWidth:width];
    CGRect titleLabelFrame = [self.styleModel layoutTitleFrameWithMaxWidth:width];
    self.titleView.frame = titleViewFrame;
    self.titleLabel.frame = titleLabelFrame;
    if (titleViewFrame.size.height > 0) {
        self.titleBottomLine.hidden = NO;
        self.titleBottomLine.frame = CGRectMake(0,
                                                titleViewFrame.size.height - self.styleModel.lineHeight,
                                                width,
                                                self.styleModel.lineHeight);
    } else {
        self.titleBottomLine.hidden = YES;
    }

    NSUInteger count = self.styleModel.dataArr.count;
    CGFloat cellHeight = self.styleModel.cellHeight;
    CGFloat lineHeight = self.styleModel.lineHeight;

    for (UIView *sub in self.scrollView.subviews) {
        if ([sub isKindOfClass:[WDSheetAlertButton class]]) {
            NSInteger idx = sub.tag - kSheetButtonTagBase;
            if (idx >= 0) {
                sub.frame = CGRectMake(0, idx * (cellHeight + lineHeight), width, cellHeight);
            }
        } else if (sub.tag <= -100) {
            NSInteger idx = -(sub.tag + 100);
            sub.frame = CGRectMake(0, (idx + 1) * cellHeight + idx * lineHeight, width, lineHeight);
        }
    }

    NSInteger maxShow = MAX(1, self.styleModel.maxShowCount);
    CGFloat scrollHeight = 0;
    if ((NSInteger)count > maxShow) {
        self.scrollView.scrollEnabled = YES;
        scrollHeight = (maxShow + 0.6) * cellHeight + MAX(0, maxShow - 1) * lineHeight;
    } else {
        self.scrollView.scrollEnabled = NO;
        scrollHeight = count * cellHeight + (count > 0 ? (count - 1) * lineHeight : 0);
    }

    CGRect scrollFrame = CGRectMake(0, CGRectGetMaxY(titleViewFrame), width, scrollHeight);
    self.scrollView.frame = scrollFrame;
    CGFloat totalContentHeight = count * cellHeight + (count > 0 ? (count - 1) * lineHeight : 0);
    self.scrollView.contentSize = CGSizeMake(width, totalContentHeight);

    CGFloat gapHeight = 8.0;
    self.cancelGapView.frame = CGRectMake(0, CGRectGetMaxY(scrollFrame), width, gapHeight);

    CGFloat safeBottom = [WDSelectAlertHelper safeAreaInsetsForView:self].bottom;
    CGFloat cancelTotalHeight = cellHeight + safeBottom;
    self.cancelButton.edgeInsets = UIEdgeInsetsMake(0, 16, safeBottom, 16);
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.cancelGapView.frame), width, cancelTotalHeight);

    CGFloat panelHeight = CGRectGetMaxY(self.cancelButton.frame);
    if (updateOwnFrame && (fabs(CGRectGetHeight(self.frame) - panelHeight) > 0.5 || fabs(CGRectGetWidth(self.frame) - width) > 0.5)) {
        CGRect updated = self.frame;
        updated.size = CGSizeMake(width, panelHeight);
        self.frame = updated;
        self.backgroundEffectView.frame = self.bounds;
    }
}

#pragma mark - Subviews

- (UIVisualEffectView *)backgroundEffectView {
    if (!_backgroundEffectView) {
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
    }
    return _backgroundEffectView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)titleBottomLine {
    if (!_titleBottomLine) {
        _titleBottomLine = [[UIView alloc] init];
    }
    return _titleBottomLine;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.backgroundColor = UIColor.clearColor;
        view.showsHorizontalScrollIndicator = NO;
        view.directionalLockEnabled = YES;
        view.alwaysBounceVertical = NO;
        _scrollView = view;
    }
    return _scrollView;
}

- (UIView *)cancelGapView {
    if (!_cancelGapView) {
        _cancelGapView = [[UIView alloc] init];
    }
    return _cancelGapView;
}

- (WDSheetAlertButton *)cancelButton {
    if (!_cancelButton) {
        WDSheetAlertButton *button = [WDSheetAlertButton buttonWithType:UIButtonTypeCustom];
        button.buttonTitleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        button.buttonNumberOfLines = 1;
        [button setTitle:self.styleModel.cancelTitle forState:UIControlStateNormal];
        [button setTitleColor:self.styleModel.cancelTitleTextColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

- (WDSheetAlertButton *)createItemButtonWithFillColor:(UIColor *)fillColor {
    WDSheetAlertButton *button = [WDSheetAlertButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = fillColor;
    button.buttonNumberOfLines = self.styleModel.cellNumberOfLines;
    button.edgeInsets = self.styleModel.cellEdgeInsets;
    button.buttonTitleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [button setTitleColor:self.styleModel.cellTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.styleModel.disableCellTextColor forState:UIControlStateDisabled];
    return button;
}

@end

#pragma mark - WDSheetAlertButton (UIButtonConfiguration iOS 15+)

@implementation WDSheetAlertButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupModernButtonConfiguration];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupModernButtonConfiguration];
    }
    return self;
}

- (void)setupModernButtonConfiguration {
    _iconPlacement = NSDirectionalRectEdgeLeading;
    _iconPadding = 0.0;
    _buttonTitleFont = [UIFont systemFontOfSize:16];
    _buttonNumberOfLines = 1;
    _normalStateTitleColor = UIColor.labelColor;
    _disabledStateTitleColor = UIColor.tertiaryLabelColor;
    _normalStateBackgroundColor = UIColor.clearColor;

    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
    config.background.cornerRadius = 0;
    config.titleAlignment = UIButtonConfigurationTitleAlignmentCenter;
    self.configuration = config;

    __weak typeof(self) weakSelf = self;
    self.configurationUpdateHandler = ^(__kindof UIButton * _Nonnull btn) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf applyButtonConfiguration];
    };
    [self applyButtonConfiguration];
}

- (void)applyButtonConfiguration {
    if (self.isApplyingConfiguration) {
        return;
    }
    self.isApplyingConfiguration = YES;
    UIButtonConfiguration *updated = self.configuration ?: [UIButtonConfiguration plainButtonConfiguration];
    updated.imagePlacement = self.iconPlacement;
    updated.imagePadding = self.iconPadding;
    updated.contentInsets = NSDirectionalEdgeInsetsMake(self.edgeInsets.top,
                                                        self.edgeInsets.left,
                                                        self.edgeInsets.bottom,
                                                        self.edgeInsets.right);
    updated.titleLineBreakMode = (self.buttonNumberOfLines == 1)
                                     ? NSLineBreakByTruncatingTail
                                     : NSLineBreakByWordWrapping;

    UIColor *activeColor = self.isEnabled
                               ? (self.normalStateTitleColor ?: UIColor.labelColor)
                               : (self.disabledStateTitleColor ?: UIColor.tertiaryLabelColor);
    UIFont *font = self.buttonTitleFont ?: [UIFont systemFontOfSize:16];
    updated.baseForegroundColor = activeColor;
    updated.titleTextAttributesTransformer = ^NSDictionary<NSAttributedStringKey, id> * _Nonnull(NSDictionary<NSAttributedStringKey, id> * _Nonnull incoming) {
        NSMutableDictionary<NSAttributedStringKey, id> *outgoing = [incoming mutableCopy];
        outgoing[NSFontAttributeName] = font;
        outgoing[NSForegroundColorAttributeName] = activeColor;
        return outgoing;
    };

    if (self.isHighlighted && self.isEnabled) {
        updated.background.backgroundColor = [UIColor.labelColor colorWithAlphaComponent:0.08];
    } else {
        updated.background.backgroundColor = self.normalStateBackgroundColor ?: UIColor.clearColor;
    }

    self.configuration = updated;
    self.titleLabel.numberOfLines = self.buttonNumberOfLines;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.isApplyingConfiguration = NO;
}

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor {
    self.normalStateBackgroundColor = backgroundColor;
    [super setBackgroundColor:UIColor.clearColor];
    [self applyButtonConfiguration];
}

- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state {
    if (state == UIControlStateDisabled) {
        self.disabledStateTitleColor = color;
    } else if (state == UIControlStateNormal) {
        self.normalStateTitleColor = color;
    }
    [super setTitleColor:color forState:state];
    [self applyButtonConfiguration];
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    [self applyButtonConfiguration];
}

- (void)setButtonNumberOfLines:(NSInteger)buttonNumberOfLines {
    _buttonNumberOfLines = buttonNumberOfLines;
    [self applyButtonConfiguration];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self applyButtonConfiguration];
}

- (void)setIconInLeftWithSpacing:(CGFloat)spacing {
    self.iconPlacement = NSDirectionalRectEdgeLeading;
    self.iconPadding = spacing;
    [self applyButtonConfiguration];
}

- (void)setIconInRightWithSpacing:(CGFloat)spacing {
    self.iconPlacement = NSDirectionalRectEdgeTrailing;
    self.iconPadding = spacing;
    [self applyButtonConfiguration];
}

@end
