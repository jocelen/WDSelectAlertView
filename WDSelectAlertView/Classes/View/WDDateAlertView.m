//
//  WDDateAlertView.m
//  WDSelectAlertView
//
//  Created by 文波 on 2019/6/18.
//  Copyright © 2019 mimiao. All rights reserved.
//

#import "WDDateAlertView.h"
#import "WDSelectAlertHelper.h"

@interface WDDateAlertView ()

@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *toolbarLine;

@end

@implementation WDDateAlertView

@synthesize styleModel = _styleModel;

- (instancetype)initWithModel:(WDDateAlertStyleModel *)model {
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model ?: [WDDateAlertStyleModel defaultStyle];
        [self loadConfig];
        [self addSubviews];
        [self applyStyleModelData];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_styleModel) {
        _styleModel = [WDDateAlertStyleModel defaultStyle];
    }
    [self loadConfig];
    [self addSubviews];
    [self applyStyleModelData];
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
    CGRect pickerFrame = CGRectMake(0, buttonHeight, width, pickerHeight);

    BOOL isFullDate = (self.styleModel.style == WDDateAlertStyleYYYYMMDD);
    self.datePick.hidden = !isFullDate;
    self.datePick.frame = pickerFrame;
    self.datePickView.hidden = isFullDate;
    self.datePickView.frame = pickerFrame;
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
    [container addSubview:self.datePick];
    [container addSubview:self.datePickView];
}

- (UIColor *)resolvedPickerFillColor {
    if (self.styleModel.materialStyle == WDAlertMaterialStyleSolid) {
        return self.styleModel.dateBackgroundColor ?: UIColor.secondarySystemGroupedBackgroundColor;
    }
    return UIColor.clearColor;
}

- (void)applyStyleModelData {
    CACornerMask topCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [WDSelectAlertHelper applyMaterialStyle:self.styleModel.materialStyle
                            backgroundColor:self.styleModel.backgroundColor
                       hasCustomBackground:self.styleModel.hasCustomBackgroundColor
                               cornerRadius:self.styleModel.cornerRadius
                              maskedCorners:topCorners
                               toEffectView:self.backgroundEffectView];
    UIColor *pickerFill = [self resolvedPickerFillColor];
    self.datePick.backgroundColor = pickerFill;
    self.datePickView.backgroundColor = pickerFill;
    self.toolbarLine.backgroundColor = self.styleModel.lineSpaceColor;

    NSDate *targetDate = self.styleModel.date ?: [NSDate date];
    if (self.styleModel.style == WDDateAlertStyleYYYYMMDD) {
        self.datePick.minimumDate = self.styleModel.minimumDate;
        self.datePick.maximumDate = self.styleModel.maximumDate;
        self.datePick.date = targetDate;
    } else {
        self.datePickView.style = self.styleModel.style;
        self.datePickView.minimumDate = self.styleModel.minimumDate;
        self.datePickView.maximumDate = self.styleModel.maximumDate;
        self.datePickView.date = targetDate;
    }
    [self setNeedsLayout];
}

- (void)clickAction:(UIButton *)sender {
    if (self.didClickButton) {
        BOOL isSure = (sender == self.sureButton);
        NSDate *selected = (self.styleModel.style == WDDateAlertStyleYYYYMMDD) ? self.datePick.date : self.datePickView.date;
        self.didClickButton(isSure, selected ?: [NSDate date]);
    }
}

- (void)dateChanged:(UIDatePicker *)sender {
    if (self.didSelectDate) {
        self.didSelectDate(sender.date);
    }
}

- (void)dateViewChanged:(WDDatePickView *)sender {
    if (self.didSelectDate && sender.date) {
        self.didSelectDate(sender.date);
    }
}

#pragma mark - Public Methods

- (void)setDefaultDate:(NSDate *)date {
    if (!date) {
        return;
    }
    if (self.styleModel.style == WDDateAlertStyleYYYYMMDD) {
        self.datePick.date = date;
    } else {
        self.datePickView.date = date;
    }
}

- (void)setStyleModel:(WDDateAlertStyleModel *)styleModel {
    _styleModel = styleModel ?: [WDDateAlertStyleModel defaultStyle];
    [self applyStyleModelData];
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

- (WDDatePicker *)datePick {
    if (!_datePick) {
        WDDatePicker *view = [[WDDatePicker alloc] init];
        view.showTextColor = self.styleModel.dateTextColor;
        view.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = (self.styleModel.locale.length > 0)
                               ? [[NSLocale alloc] initWithLocaleIdentifier:self.styleModel.locale]
                               : NSLocale.currentLocale;
        view.locale = locale;
        [view addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePick = view;
    }
    return _datePick;
}

- (WDDatePickView *)datePickView {
    if (!_datePickView) {
        __weak typeof(self) weakSelf = self;
        WDDatePickView *pick = [[WDDatePickView alloc] init];
        pick.style = self.styleModel.style;
        pick.textColor = self.styleModel.dateTextColor;
        pick.lineSpaceColor = self.styleModel.lineSpaceColor;
        pick.valueChanged = ^(WDDatePickView * _Nonnull view, NSDate * _Nonnull value) {
            [weakSelf dateViewChanged:view];
        };
        _datePickView = pick;
    }
    return _datePickView;
}

@end

#pragma mark - WDDatePicker

@implementation WDDatePicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    return self;
}

@end

#pragma mark - WDDatePickView

static NSInteger const kYearMonthCycleMultiplier = 100;

@interface WDDatePickView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, nullable) NSArray<NSString *> *showYearData;
@property (nonatomic, strong) NSArray<NSString *> *showMonthData;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *indexArr;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;

@end

@implementation WDDatePickView

@synthesize date = _date;

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
    [self rebuildIndexArrayForCurrentStyle];
}

- (NSCalendar *)gregorianCalendar {
    if (!_gregorianCalendar) {
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorianCalendar;
}

- (void)rebuildIndexArrayForCurrentStyle {
    _indexArr = [NSMutableArray array];
    NSUInteger yearCount = MAX(1, self.showYearData.count);
    [_indexArr addObject:@(yearCount / 2)];
    if (self.style == WDDateAlertStyleYYYYMM) {
        [_indexArr addObject:@(kYearMonthCycleMultiplier * self.showMonthData.count / 2)];
    }
}

- (void)scrollToIndex:(NSArray<NSNumber *> *)indexArr animated:(BOOL)animated {
    [self reloadAllComponents];
    for (NSUInteger i = 0; i < indexArr.count; i++) {
        NSInteger compCount = [self numberOfComponents];
        if ((NSInteger)i >= compCount) {
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

- (void)updateDateValue {
    if (self.showYearData.count == 0 || self.indexArr.count == 0) {
        return;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = self.gregorianCalendar;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = (self.style == WDDateAlertStyleYYYYMM) ? @"yyyy-MM" : @"yyyy";

    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < self.indexArr.count; i++) {
        NSInteger index = MAX(0, self.indexArr[i].integerValue);
        if (i == 0) {
            [string appendString:self.showYearData[index % self.showYearData.count]];
        } else {
            [string appendFormat:@"-%@", self.showMonthData[index % self.showMonthData.count]];
        }
    }

    NSDate *parsed = [dateFormatter dateFromString:string];
    if (parsed) {
        if (self.minimumDate && [parsed compare:self.minimumDate] == NSOrderedAscending) {
            parsed = self.minimumDate;
        }
        if (self.maximumDate && [parsed compare:self.maximumDate] == NSOrderedDescending) {
            parsed = self.maximumDate;
        }
        _date = parsed;
    }
}

#pragma mark - Setters & Getters

- (void)setStyle:(WDDateAlertStyle)style {
    _style = style;
    [self rebuildIndexArrayForCurrentStyle];
    if (_date) {
        [self syncSelectionToDate:_date animated:NO];
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    _showYearData = nil;
    [self rebuildIndexArrayForCurrentStyle];
    if (_date) {
        [self syncSelectionToDate:_date animated:NO];
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    _showYearData = nil;
    [self rebuildIndexArrayForCurrentStyle];
    if (_date) {
        [self syncSelectionToDate:_date animated:NO];
    }
}

- (void)setDate:(NSDate *)date {
    NSDate *resolved = date ?: [NSDate date];
    if (self.minimumDate && [resolved compare:self.minimumDate] == NSOrderedAscending) {
        resolved = self.minimumDate;
    }
    if (self.maximumDate && [resolved compare:self.maximumDate] == NSOrderedDescending) {
        resolved = self.maximumDate;
    }
    _date = resolved;
    [self syncSelectionToDate:resolved animated:NO];
}

- (NSDate *)date {
    if (!_date) {
        [self updateDateValue];
    }
    return _date ?: [NSDate date];
}

- (void)syncSelectionToDate:(NSDate *)date animated:(BOOL)animated {
    if (self.indexArr.count == 0) {
        [self rebuildIndexArrayForCurrentStyle];
    }

    NSCalendarUnit unit = (self.style == WDDateAlertStyleYYYY)
                              ? NSCalendarUnitYear
                              : (NSCalendarUnitYear | NSCalendarUnitMonth);
    NSDateComponents *components = [self.gregorianCalendar components:unit fromDate:date];

    NSString *yearTarget = [NSString stringWithFormat:@"%ld", (long)components.year];
    for (NSUInteger i = 0; i < self.showYearData.count; i++) {
        if ([yearTarget isEqualToString:self.showYearData[i]]) {
            [self.indexArr replaceObjectAtIndex:0 withObject:@(i)];
            break;
        }
    }

    if (self.style == WDDateAlertStyleYYYYMM && self.indexArr.count > 1) {
        NSString *monthTarget = [NSString stringWithFormat:@"%02ld", (long)components.month];
        NSString *shortMonthTarget = [NSString stringWithFormat:@"%ld", (long)components.month];
        for (NSUInteger i = 0; i < self.showMonthData.count; i++) {
            NSString *item = self.showMonthData[i];
            if ([monthTarget isEqualToString:item] || [shortMonthTarget isEqualToString:item]) {
                NSInteger index = (kYearMonthCycleMultiplier * self.showMonthData.count / 2) + (NSInteger)i;
                [self.indexArr replaceObjectAtIndex:1 withObject:@(index)];
                break;
            }
        }
    }

    [self scrollToIndex:self.indexArr animated:animated];
}

- (NSArray<NSString *> *)showYearData {
    if (!_showYearData) {
        NSInteger currentYear = [self.gregorianCalendar component:NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger beginYear = currentYear - 100;
        NSInteger endYear = currentYear + 100;

        if (self.minimumDate) {
            beginYear = [self.gregorianCalendar component:NSCalendarUnitYear fromDate:self.minimumDate];
        }
        if (self.maximumDate) {
            endYear = [self.gregorianCalendar component:NSCalendarUnitYear fromDate:self.maximumDate];
        }
        if (endYear < beginYear) {
            endYear = beginYear;
        }

        NSMutableArray<NSString *> *arr = [NSMutableArray arrayWithCapacity:(NSUInteger)(endYear - beginYear + 1)];
        for (NSInteger year = beginYear; year <= endYear; year++) {
            [arr addObject:[NSString stringWithFormat:@"%ld", (long)year]];
        }
        _showYearData = [arr copy];
    }
    return _showYearData;
}

- (NSArray<NSString *> *)showMonthData {
    if (!_showMonthData) {
        NSMutableArray<NSString *> *arr = [NSMutableArray arrayWithCapacity:12];
        for (NSInteger m = 1; m <= 12; m++) {
            [arr addObject:[NSString stringWithFormat:@"%02ld", (long)m]];
        }
        _showMonthData = [arr copy];
    }
    return _showMonthData;
}

- (void (^)(WDDatePickView *, NSDate *))valueChangeed {
    return self.valueChanged;
}

- (void)setValueChangeed:(void (^)(WDDatePickView *, NSDate *))valueChangeed {
    self.valueChanged = valueChangeed;
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return (NSInteger)self.indexArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return (NSInteger)self.showYearData.count;
    }
    return kYearMonthCycleMultiplier * (NSInteger)self.showMonthData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(nullable UIView *)view {
    UILabel *label = [view isKindOfClass:[UILabel class]] ? (UILabel *)view : [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:21 weight:UIFontWeightRegular];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor ?: UIColor.labelColor;

    if (component == 0 && self.showYearData.count > 0) {
        label.text = self.showYearData[(NSUInteger)row % self.showYearData.count];
    } else if (self.showMonthData.count > 0) {
        label.text = self.showMonthData[(NSUInteger)row % self.showMonthData.count];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component >= 0 && (NSUInteger)component < self.indexArr.count) {
        [self.indexArr replaceObjectAtIndex:(NSUInteger)component withObject:@(row)];
    }
    [self updateDateValue];
    if (self.valueChanged) {
        self.valueChanged(self, self.date);
    }
}

@end
