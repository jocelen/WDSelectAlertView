//
//  WDDateIntervalAlertView.m
//  WDSelectAlertView
//
//  Created by 文波 on 2020/4/1.
//  Copyright © 2020 mimiao. All rights reserved.
//

#import "WDDateIntervalAlertView.h"
#import "WDSelectAlertHelper.h"

@interface WDDateIntervalAlertView ()

@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *toolbarLine;
@property (nonatomic, strong) WDDateIntervalPickView *beginPicker;
@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) WDDateIntervalPickView *endPicker;

@end

@implementation WDDateIntervalAlertView

@synthesize styleModel = _styleModel;

- (instancetype)initWithModel:(WDDateIntervalAlertStyleModel *)model {
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model ?: [WDDateIntervalAlertStyleModel defaultStyle];
        [self loadConfig];
        [self addSubviews];
        [self syncStyleModelToPickers];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_styleModel) {
        _styleModel = [WDDateIntervalAlertStyleModel defaultStyle];
    }
    [self loadConfig];
    [self addSubviews];
    [self syncStyleModelToPickers];
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

    CGFloat toWidth = 50.0;
    CGFloat pickerWidth = MAX(0, (width - toWidth) / 2.0);
    CGFloat pickerHeight = MAX(0, height - buttonHeight - safeBottom);

    self.beginPicker.frame = CGRectMake(0, buttonHeight, pickerWidth, pickerHeight);
    self.toLabel.frame = CGRectMake(pickerWidth, buttonHeight, toWidth, pickerHeight);
    self.endPicker.frame = CGRectMake(pickerWidth + toWidth, buttonHeight, pickerWidth, pickerHeight);
}

#pragma mark - Private Methods

- (void)loadConfig {
    self.backgroundColor = UIColor.clearColor;
}

- (void)addSubviews {
    [self addSubview:self.backgroundEffectView];
    UIView *container = self.backgroundEffectView.contentView;
    [container addSubview:self.cancelButton];
    [container addSubview:self.sureButton];
    [container addSubview:self.toolbarLine];
    [container addSubview:self.beginPicker];
    [container addSubview:self.toLabel];
    [container addSubview:self.endPicker];
}

- (void)syncStyleModelToPickers {
    CACornerMask topCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [WDSelectAlertHelper applyMaterialStyle:self.styleModel.materialStyle
                            backgroundColor:self.styleModel.backgroundColor
                       hasCustomBackground:self.styleModel.hasCustomBackgroundColor
                               cornerRadius:self.styleModel.cornerRadius
                              maskedCorners:topCorners
                               toEffectView:self.backgroundEffectView];
    UIColor *pickerFill = (self.styleModel.materialStyle == WDAlertMaterialStyleSolid)
                              ? (self.styleModel.dateBackgroundColor ?: UIColor.secondarySystemGroupedBackgroundColor)
                              : UIColor.clearColor;
    self.beginPicker.backgroundColor = pickerFill;
    self.endPicker.backgroundColor = pickerFill;
    self.toLabel.backgroundColor = pickerFill;
    self.toolbarLine.backgroundColor = self.styleModel.lineSpaceColor;

    self.beginPicker.style = self.styleModel.style;
    self.endPicker.style = self.styleModel.style;
    self.beginPicker.currentValue = self.styleModel.beginDate ?: (self.styleModel.style == WDDateIntervalAlertStyleHH ? @"08" : @"08:00");
    self.endPicker.currentValue = self.styleModel.endDate ?: (self.styleModel.style == WDDateIntervalAlertStyleHH ? @"12" : @"12:00");
}

- (void)clickAction:(UIButton *)sender {
    if (self.didClickButton) {
        BOOL isSure = (sender == self.sureButton);
        self.didClickButton(isSure, self.beginPicker.currentValue ?: @"", self.endPicker.currentValue ?: @"");
    }
}

- (void)dateChanged:(WDDateIntervalPickView *)sender {
    if ([self.beginPicker.currentValue isEqualToString:self.endPicker.currentValue]) {
        if (sender == self.beginPicker) {
            [self.endPicker nextStep];
        } else {
            [self.beginPicker previousStep];
        }
    }
    if (self.didSelectDate) {
        self.didSelectDate(self.beginPicker.currentValue ?: @"", self.endPicker.currentValue ?: @"");
    }
}

#pragma mark - Public Methods

- (void)setStyleModel:(WDDateIntervalAlertStyleModel *)styleModel {
    _styleModel = styleModel ?: [WDDateIntervalAlertStyleModel defaultStyle];
    [self syncStyleModelToPickers];
    [self setNeedsLayout];
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

- (WDDateIntervalPickView *)beginPicker {
    if (!_beginPicker) {
        __weak typeof(self) weakSelf = self;
        WDDateIntervalPickView *pick = [[WDDateIntervalPickView alloc] init];
        pick.style = self.styleModel.style;
        pick.textColor = self.styleModel.dateTextColor;
        pick.lineSpaceColor = self.styleModel.lineSpaceColor;
        pick.valueChanged = ^(WDDateIntervalPickView * _Nonnull view, NSString * _Nonnull value) {
            [weakSelf dateChanged:view];
        };
        _beginPicker = pick;
    }
    return _beginPicker;
}

- (UILabel *)toLabel {
    if (!_toLabel) {
        UILabel *view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        view.textColor = self.styleModel.toTitleColor;
        view.text = self.styleModel.toTitle;
        _toLabel = view;
    }
    return _toLabel;
}

- (WDDateIntervalPickView *)endPicker {
    if (!_endPicker) {
        __weak typeof(self) weakSelf = self;
        WDDateIntervalPickView *pick = [[WDDateIntervalPickView alloc] init];
        pick.style = self.styleModel.style;
        pick.textColor = self.styleModel.dateTextColor;
        pick.lineSpaceColor = self.styleModel.lineSpaceColor;
        pick.valueChanged = ^(WDDateIntervalPickView * _Nonnull view, NSString * _Nonnull value) {
            [weakSelf dateChanged:view];
        };
        _endPicker = pick;
    }
    return _endPicker;
}

@end

#pragma mark - WDDateIntervalPickView

static NSInteger const kIntervalCycleMultiplier = 100;

@interface WDDateIntervalPickView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *showHourData;
@property (nonatomic, strong) NSArray<NSString *> *showMinuteData;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *indexArr;

@end

@implementation WDDateIntervalPickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadConfig];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadConfig];
}

- (void)loadConfig {
    self.delegate = self;
    self.dataSource = self;
    _textColor = UIColor.labelColor;
    [self setStyle:WDDateIntervalAlertStyleHH];
}

- (void)scrollToIndex:(NSArray<NSNumber *> *)indexArr animated:(BOOL)animated {
    [self reloadAllComponents];
    for (NSUInteger i = 0; i < indexArr.count; i++) {
        if ((NSInteger)i >= [self numberOfComponents]) {
            break;
        }
        NSInteger maxRows = [self numberOfRowsInComponent:(NSInteger)i];
        if (maxRows <= 0) {
            continue;
        }
        NSInteger row = MIN(MAX(0, indexArr[i].integerValue), maxRows - 1);
        [self selectRow:row inComponent:(NSInteger)i animated:animated];
    }
}

#pragma mark - Public Step Methods

- (void)previousStep {
    if (self.indexArr.count == 0) {
        return;
    }
    NSUInteger lastIdx = self.indexArr.count - 1;
    NSInteger current = self.indexArr[lastIdx].integerValue;
    if (current <= 0) {
        return;
    }
    [self.indexArr replaceObjectAtIndex:lastIdx withObject:@(current - 1)];

    // 分钟从 00 退回 59 时向小时借位
    if (self.indexArr.count > 1 && (current % (NSInteger)self.showMinuteData.count == 0)) {
        NSInteger hourIndex = self.indexArr[0].integerValue;
        if (hourIndex > 0) {
            [self.indexArr replaceObjectAtIndex:0 withObject:@(hourIndex - 1)];
        }
    }

    [self updateDateValue];
    [self scrollToIndex:self.indexArr animated:YES];
}

- (void)nextStep {
    if (self.indexArr.count == 0) {
        return;
    }
    NSUInteger lastIdx = self.indexArr.count - 1;
    NSInteger maxRows = [self numberOfRowsInComponent:(NSInteger)lastIdx];
    NSInteger next = self.indexArr[lastIdx].integerValue + 1;
    if (next >= maxRows) {
        return;
    }
    [self.indexArr replaceObjectAtIndex:lastIdx withObject:@(next)];

    // 分钟从 59 进到 00 时向小时进位
    if (self.indexArr.count > 1 && (next % (NSInteger)self.showMinuteData.count == 0)) {
        NSInteger hourIndex = self.indexArr[0].integerValue;
        NSInteger maxHourRows = [self numberOfRowsInComponent:0];
        if (hourIndex + 1 < maxHourRows) {
            [self.indexArr replaceObjectAtIndex:0 withObject:@(hourIndex + 1)];
        }
    }

    [self updateDateValue];
    [self scrollToIndex:self.indexArr animated:YES];
}

- (void)updateDateValue {
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < self.indexArr.count; i++) {
        NSUInteger index = (NSUInteger)MAX(0, self.indexArr[i].integerValue);
        if (i == 0) {
            [string appendString:self.showHourData[index % self.showHourData.count]];
        } else {
            [string appendFormat:@":%@", self.showMinuteData[index % self.showMinuteData.count]];
        }
    }
    _currentValue = [string copy];
}

#pragma mark - Getters & Setters

- (void)setStyle:(WDDateIntervalAlertStyle)style {
    _style = style;
    _indexArr = [NSMutableArray array];
    [_indexArr addObject:@(kIntervalCycleMultiplier * (NSInteger)self.showHourData.count / 2)];
    if (style == WDDateIntervalAlertStyleHHMM) {
        [_indexArr addObject:@(kIntervalCycleMultiplier * (NSInteger)self.showMinuteData.count / 2)];
    }
    [self updateDateValue];
}

- (void)setCurrentValue:(NSString *)currentValue {
    if (currentValue.length == 0) {
        [self updateDateValue];
        [self scrollToIndex:self.indexArr animated:NO];
        return;
    }

    NSArray<NSString *> *parts = [currentValue componentsSeparatedByString:@":"];
    NSString *hour = parts.firstObject ?: @"00";
    NSString *min = (parts.count > 1) ? parts[1] : @"00";

    for (NSUInteger i = 0; i < self.showHourData.count; i++) {
        if ([hour isEqualToString:self.showHourData[i]]) {
            NSInteger index = (kIntervalCycleMultiplier * (NSInteger)self.showHourData.count / 2) + (NSInteger)i;
            [self.indexArr replaceObjectAtIndex:0 withObject:@(index)];
            break;
        }
    }

    if (self.indexArr.count > 1) {
        for (NSUInteger i = 0; i < self.showMinuteData.count; i++) {
            if ([min isEqualToString:self.showMinuteData[i]]) {
                NSInteger index = (kIntervalCycleMultiplier * (NSInteger)self.showMinuteData.count / 2) + (NSInteger)i;
                [self.indexArr replaceObjectAtIndex:1 withObject:@(index)];
                break;
            }
        }
    }

    [self updateDateValue];
    [self scrollToIndex:self.indexArr animated:NO];
}

- (NSArray<NSString *> *)showHourData {
    if (!_showHourData) {
        NSMutableArray<NSString *> *arr = [NSMutableArray arrayWithCapacity:24];
        for (int i = 0; i < 24; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        _showHourData = [arr copy];
    }
    return _showHourData;
}

- (NSArray<NSString *> *)showMinuteData {
    if (!_showMinuteData) {
        NSMutableArray<NSString *> *arr = [NSMutableArray arrayWithCapacity:60];
        for (int i = 0; i < 60; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        _showMinuteData = [arr copy];
    }
    return _showMinuteData;
}

- (void (^)(WDDateIntervalPickView *, NSString *))valueChangeed {
    return self.valueChanged;
}

- (void)setValueChangeed:(void (^)(WDDateIntervalPickView *, NSString *))valueChangeed {
    self.valueChanged = valueChangeed;
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return (NSInteger)self.indexArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0)
               ? kIntervalCycleMultiplier * (NSInteger)self.showHourData.count
               : kIntervalCycleMultiplier * (NSInteger)self.showMinuteData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(nullable UIView *)view {
    UILabel *label = [view isKindOfClass:[UILabel class]] ? (UILabel *)view : [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor ?: UIColor.labelColor;
    label.text = (component == 0)
                     ? self.showHourData[(NSUInteger)row % self.showHourData.count]
                     : self.showMinuteData[(NSUInteger)row % self.showMinuteData.count];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component >= 0 && (NSUInteger)component < self.indexArr.count) {
        [self.indexArr replaceObjectAtIndex:(NSUInteger)component withObject:@(row)];
    }
    [self updateDateValue];
    if (self.valueChanged) {
        self.valueChanged(self, self.currentValue ?: @"");
    }
}

@end
