//
//  WDDateAlertView.m
//  WDSelectAlertView
//
//  Created by 文波 on 2019/6/18.
//  Copyright © 2019 mimiao. All rights reserved.
//

#import "WDDateAlertView.h"

@interface WDDateAlertView ()

/**  取消*/
@property (nonatomic, strong) UIButton * cancelButton;

/**  确定*/
@property (nonatomic, strong) UIButton * sureButton;

@end


@implementation WDDateAlertView


// MARK: -  life cycle
@synthesize styleModel = _styleModel;
-(instancetype)initWithModel:(WDDateAlertStyleModel *)model;
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.styleModel = model;
        [self loadConfig];
        [self addSubviews];
        [self loadData];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadConfig];
    [self addSubviews];
    [self loadData];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonHeight = 50;
    CGSize buttonSize = CGSizeMake(90, buttonHeight);
    
    _cancelButton.frame = CGRectMake(14, 0, buttonSize.width, buttonSize.height);
    _sureButton.frame = CGRectMake(self.frame.size.width - buttonSize.width - 14, 0, buttonSize.width, buttonSize.height);
    
    _datePick.hidden = _styleModel.style != WDDateAlertAlertStyleYYYYMMDD;
    _datePick.frame = CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight);
    _datePickView.hidden = _styleModel.style == WDDateAlertAlertStyleYYYYMMDD;
    _datePickView.frame = CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight);
}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    self.backgroundColor = _styleModel.backgroudColor;
    
}

// 添加view
-(void)addSubviews {
    [self addSubview:self.cancelButton];
    [self addSubview:self.sureButton];
    [self addSubview:self.datePick];
    [self addSubview:self.datePickView];
}

// 加载数据
-(void)loadData {
    
    
}

-(void)clickAction:(UIButton *)sender
{
    if (_didClickButton) {
        BOOL isSure = [sender isEqual:_sureButton];
        NSDate * date = _styleModel.style == WDDateAlertAlertStyleYYYYMMDD ? _datePick.date : _datePickView.date;
        _didClickButton(isSure,date);
    }
}

-(void)dateChanged:(UIDatePicker *)sender
{
    if (_didSelectDate) {
        NSDate * date = sender.date;
        _didSelectDate(date);
    }
}

-(void)dateViewChanged:(WDDatePickView *)sender;
{
    if (_didSelectDate) {
        NSDate * date = sender.date;
        _didSelectDate(date);
    }
}

// MARK: -  public methods
-(void)setDefaultDate:(NSDate *)date;
{
    self.datePick.date = date;
}

-(void)setStyleModel:(WDDateAlertStyleModel * _Nonnull)styleModel
{
    _styleModel = styleModel;
    NSDate * date = _styleModel.date ? _styleModel.date : [NSDate date];
    if (styleModel.style == WDDateAlertAlertStyleYYYYMMDD) {
        self.datePick.date = date;
        if (_styleModel.minimumDate) {
            self.datePick.minimumDate = _styleModel.minimumDate;
        }
        
        if (_styleModel.maximumDate) {
            self.datePick.maximumDate = _styleModel.maximumDate;
        }
    }
    else {
        self.datePickView.date = date;
    }
    [self layoutIfNeeded];
}

// MARK: -  getters and setters
-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [button setTitle:_styleModel.cancelTitle forState:UIControlStateNormal];
        [button setTitleColor:_styleModel.cancelTitleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

-(UIButton *)sureButton
{
    if (!_sureButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Heavy" size:18];
        [button setTitle:_styleModel.sureTitle forState:UIControlStateNormal];
        [button setTitleColor:_styleModel.sureTitleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = button;
    }
    return _sureButton;
}


-(WDDatePicker *)datePick
{
    if (!_datePick) {
        WDDatePicker * view = [[WDDatePicker alloc] init];
        view.showTextColor = _styleModel.dateTextColor;
        view.backgroundColor = _styleModel.dateBackgroudColor;
        view.datePickerMode = UIDatePickerModeDate;
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:_styleModel.locale];
        [view setLocale:locale];
        [view addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePick = view;
    }
    
    return _datePick;
}

-(WDDatePickView *)datePickView
{
    if (!_datePickView) {
        __weak typeof(self) weakSelf = self;

        WDDatePickView * pick = [[WDDatePickView alloc] init];
        pick.style = _styleModel.style;
        pick.backgroundColor = _styleModel.dateBackgroudColor;
        pick.textColor = _styleModel.dateTextColor;
        pick.lineSpaceColor = _styleModel.lineSpaceColor;
        pick.valueChangeed = ^(WDDatePickView * _Nonnull view, NSDate * _Nonnull value) {
            [weakSelf dateViewChanged:view];
        };
        _datePickView = pick;
    }
    
    return _datePickView;
}

@end

@implementation WDDatePicker

-(instancetype)init {
    if (self = [super init]) {
        if (@available(iOS 13.4, *)) {
            self.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([self respondsToSelector:sel_registerName("setHighlightsToday:")]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wundeclared-selector"
            [self performSelector:@selector(setHighlightsToday:) withObject:[NSNumber numberWithBool:NO]];
    #pragma clang diagnostic pop
    }
    [self setValue:_showTextColor forKey:@"textColor"];
}

@end



static NSInteger DateSelectMultiple = 100;

@interface WDDatePickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)NSArray<NSString *> *showYearData;
@property (nonatomic, strong)NSArray<NSString *> *showMonthData;
/**  选中index*/
@property (nonatomic, strong)NSMutableArray<NSNumber *> * indexArr;

@end


@implementation WDDatePickView


// MARK: -  life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadConfig];
        [self addSubviews];
        [self loadData];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadConfig];
    [self addSubviews];
    [self loadData];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    self.delegate = self;
    self.dataSource = self;
    
    [self scrollToIndex:_indexArr animated:NO];
}

// 添加view
-(void)addSubviews {
    
    
}

// 加载数据
-(void)loadData {
    
    
}

-(void)scrollToIndex:(NSArray<NSNumber *> *)indexArr animated:(BOOL)animated
{
    for (int i = 0; i < indexArr.count; i++) {
        NSInteger row = indexArr[i].integerValue;
        [self selectRow:row inComponent:i animated:animated];
    }
}

// MARK: -  public methods

/// 刷新
-(void)updateDateValue;
{
    NSMutableString * string = [NSMutableString string];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = _style ==  WDDateAlertAlertStyleYYYYMM ? @"yyyy-MM" : @"yyyy";
    for (int i = 0; i < _indexArr.count; i++) {
        NSInteger index = _indexArr[i].integerValue;
        if (i == 0) {
            [string appendString:self.showYearData[index%self.showYearData.count]];
        }
        else {
            [string appendFormat:@"-%@",self.showMonthData[index%self.showMonthData.count]];
        }
    }
    _date = [dateFormatter dateFromString:string];
}

// MARK: -  getters and setters
-(void)setStyle:(WDDateAlertAlertStyle)style
{
    _style = style;
    
    _indexArr = [NSMutableArray array];
    [_indexArr addObject:@(self.showMonthData.count/2)];
    
    if (_style ==  WDDateAlertAlertStyleYYYYMM) {
        [_indexArr addObject:@(DateSelectMultiple*self.showYearData.count/2)];
    }
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    NSCalendarUnit unit = _style == WDDateAlertAlertStyleYYYY ? NSCalendarUnitYear : NSCalendarUnitYear|NSCalendarUnitMonth;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unit fromDate:date];
    
    for (int i = 0; i < self.showYearData.count ; i++) {
        if ([[NSString stringWithFormat:@"%ld", components.year] isEqualToString:self.showYearData[i]]) {
            [_indexArr replaceObjectAtIndex:0 withObject:@(i)];
            break;
        }
    }
    
    for (int i = 0; i < self.showMonthData.count ; i++) {
        if ([[NSString stringWithFormat:@"%ld", components.month] isEqualToString:self.showMonthData[i]]) {
            NSInteger index = DateSelectMultiple*self.showMonthData.count/2 + i;
            if (_indexArr.count > 1) {
                [_indexArr replaceObjectAtIndex:1 withObject:@(index)];
            }
            break;
        }
    }
    [self scrollToIndex:_indexArr animated:NO];
}

-(NSArray<NSString *> *)showYearData {
    if (!_showYearData) {
        NSMutableArray<NSString *> * arr = [NSMutableArray array];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        int begin = (int)components.year - 100;
        int end = (int)components.year + 100;
        for (int i = begin; i < end; i++) {
            [arr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _showYearData = arr;
    }
    return _showYearData;
}

-(NSArray<NSString *> *)showMonthData {
    if (!_showMonthData) {
        NSMutableArray<NSString *> * arr = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            [arr addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
        _showMonthData = arr;
    }
    return _showMonthData;
}


// MARK: -  UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return _indexArr.count;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger row = component == 0 ? self.showYearData.count : DateSelectMultiple*self.showMonthData.count;
    return row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = _lineSpaceColor;
        }
    }

    //设置文字的属性
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    NSString * title  = component == 0 ? self.showYearData[row%self.showYearData.count] : self.showMonthData[row%self.showMonthData.count];

    label.text = title;
    label.textColor = _textColor;

    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView selectRow:row inComponent:component animated:NO];
    
    [_indexArr replaceObjectAtIndex:component withObject:@(row)];
    [self updateDateValue];
    if (_valueChangeed) {
        _valueChangeed(self,self.date);
    }
}

@end
