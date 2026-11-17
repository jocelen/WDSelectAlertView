//
//  WDKeyValueAlertView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2021/1/6.
//  Copyright © 2021 mimiao. All rights reserved.
//

#import "WDKeyValueAlertView.h"
#import "WDSelectAlertHelper.h"

@interface WDKeyValueAlertView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *toolbarLine;
@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation WDKeyValueAlertView

- (instancetype)initWithModel:(WDKeyValueAlertStyleModel *)model {
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model ?: [WDKeyValueAlertStyleModel defaultStyle];
        [self loadConfig];
        [self addSubviews];
        [self syncInitialSelection];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_styleModel) {
        _styleModel = [WDKeyValueAlertStyleModel defaultStyle];
    }
    [self loadConfig];
    [self addSubviews];
    [self syncInitialSelection];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.backgroundEffectView.frame = self.bounds;

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat buttonHeight = 50.0;
    CGSize buttonSize = CGSizeMake(90.0, buttonHeight);
    CGFloat lineHeight = 1.0 / MAX([WDSelectAlertHelper activeWindowScene].screen.scale, 2.0);
    CGFloat safeBottom = [WDSelectAlertHelper safeAreaInsetsForView:self].bottom;

    self.cancelButton.frame = CGRectMake(16.0, 0, buttonSize.width, buttonSize.height);
    self.sureButton.frame = CGRectMake(MAX(16.0, width - buttonSize.width - 16.0), 0, buttonSize.width, buttonSize.height);
    self.toolbarLine.frame = CGRectMake(0, buttonHeight - lineHeight, width, lineHeight);

    CGFloat pickerHeight = MAX(0, height - buttonHeight - safeBottom);
    self.picker.frame = CGRectMake(0, buttonHeight, width, pickerHeight);
}

#pragma mark - Private Methods

- (NSInteger)totalRowCount {
    return (NSInteger)MAX(self.styleModel.keyArr.count, self.styleModel.valueArr.count);
}

- (void)loadConfig {
    self.backgroundColor = UIColor.clearColor;
    _selectIndex = -1;
}

- (void)addSubviews {
    [self addSubview:self.backgroundEffectView];
    UIView *container = self.backgroundEffectView.contentView;
    [container addSubview:self.cancelButton];
    [container addSubview:self.sureButton];
    [container addSubview:self.toolbarLine];
    [container addSubview:self.picker];
}

- (void)syncInitialSelection {
    CACornerMask topCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [WDSelectAlertHelper applyMaterialStyle:self.styleModel.materialStyle
                            backgroundColor:self.styleModel.backgroundColor
                       hasCustomBackground:self.styleModel.hasCustomBackgroundColor
                               cornerRadius:self.styleModel.cornerRadius
                              maskedCorners:topCorners
                               toEffectView:self.backgroundEffectView];
    self.picker.backgroundColor = (self.styleModel.materialStyle == WDAlertMaterialStyleSolid)
                                      ? (self.styleModel.pickerBackgroundColor ?: UIColor.secondarySystemGroupedBackgroundColor)
                                      : UIColor.clearColor;
    NSInteger rows = [self totalRowCount];
    self.sureButton.enabled = (rows > 0);
    if (rows > 0 && _selectIndex < 0) {
        self.selectIndex = 0;
    } else if (rows == 0) {
        _selectIndex = -1;
    }
}

- (void)clickAction:(UIButton *)sender {
    if (self.didClickButton) {
        BOOL isSure = (sender == self.sureButton);
        NSInteger rows = [self totalRowCount];
        NSInteger idx = (rows > 0) ? [self.picker selectedRowInComponent:0] : -1;
        self.didClickButton(isSure, idx);
    }
}

#pragma mark - Public Methods

- (void)setSelectIndex:(NSInteger)selectIndex {
    NSInteger rows = [self totalRowCount];
    if (rows <= 0) {
        _selectIndex = -1;
        self.sureButton.enabled = NO;
        return;
    }
    self.sureButton.enabled = YES;
    NSInteger clamped = MIN(MAX(0, selectIndex), rows - 1);
    _selectIndex = clamped;
    [self.picker reloadAllComponents];
    [self.picker selectRow:clamped inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self totalRowCount];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(nullable UIView *)view {
    WDKeyValueAlertViewCell *cell = [view isKindOfClass:[WDKeyValueAlertViewCell class]]
                                        ? (WDKeyValueAlertViewCell *)view
                                        : [[WDKeyValueAlertViewCell alloc] init];
    cell.textColor = self.styleModel.textColor;
    cell.selectTextColor = self.styleModel.selectTextColor;

    BOOL hasKeys = (self.styleModel.keyArr.count > 0);
    BOOL hasValues = (self.styleModel.valueArr.count > 0);
    cell.showLeft = hasKeys;
    cell.showRight = hasValues;

    if (hasKeys) {
        cell.leftLabel.text = ((NSUInteger)row < self.styleModel.keyArr.count) ? self.styleModel.keyArr[(NSUInteger)row] : @"";
    } else {
        cell.leftLabel.text = nil;
    }

    if (hasValues) {
        cell.rightLabel.text = ((NSUInteger)row < self.styleModel.valueArr.count) ? self.styleModel.valueArr[(NSUInteger)row] : @"";
    } else {
        cell.rightLabel.text = nil;
    }

    cell.isSelect = (row == self.selectIndex);
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectIndex = row;
    [pickerView reloadComponent:component];
    if (self.didSelectDate) {
        self.didSelectDate(row);
    }
}

#pragma mark - Getters

- (UIVisualEffectView *)backgroundEffectView {
    if (!_backgroundEffectView) {
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
    }
    return _backgroundEffectView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        [button setTitle:self.styleModel.cancelTitle forState:UIControlStateNormal];
        [button setTitleColor:self.styleModel.cancelTitleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [button setTitle:self.styleModel.sureTitle forState:UIControlStateNormal];
        [button setTitleColor:self.styleModel.sureTitleColor forState:UIControlStateNormal];
        [button setTitleColor:self.styleModel.sureTitleDisableColor forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = button;
    }
    return _sureButton;
}

- (UIView *)toolbarLine {
    if (!_toolbarLine) {
        _toolbarLine = [[UIView alloc] init];
        _toolbarLine.backgroundColor = self.styleModel.lineSpaceColor;
    }
    return _toolbarLine;
}

- (UIPickerView *)picker {
    if (!_picker) {
        UIPickerView *pick = [[UIPickerView alloc] init];
        pick.delegate = self;
        pick.dataSource = self;
        _picker = pick;
    }
    return _picker;
}

@end

#pragma mark - WDKeyValueAlertViewCell

@implementation WDKeyValueAlertViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);

    self.leftLabel.hidden = !self.showLeft;
    self.rightLabel.hidden = !self.showRight;

    if (self.showLeft && self.showRight) {
        CGFloat half = w / 2.0;
        self.leftLabel.frame = CGRectMake(0, 0, half, h);
        self.rightLabel.frame = CGRectMake(half, 0, half, h);
    } else if (self.showLeft) {
        self.leftLabel.frame = CGRectMake(0, 0, w, h);
    } else if (self.showRight) {
        self.rightLabel.frame = CGRectMake(0, 0, w, h);
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    UIColor *color = isSelect ? (self.selectTextColor ?: UIColor.systemRedColor) : (self.textColor ?: UIColor.labelColor);
    UIFont *font = isSelect ? [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold] : [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.leftLabel.textColor = color;
    self.rightLabel.textColor = color;
    self.leftLabel.font = font;
    self.rightLabel.font = font;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        _leftLabel = label;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        _rightLabel = label;
    }
    return _rightLabel;
}

@end
