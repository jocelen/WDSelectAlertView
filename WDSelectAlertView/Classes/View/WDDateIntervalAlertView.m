//
//  WDDateIntervalAlertView.m
//  WDSelectAlertView
//
//  Created by 文波 on 2020/4/1.
//  Copyright © 2020 mimiao. All rights reserved.
//

#import "WDDateIntervalAlertView.h"

@interface WDDateIntervalAlertView()

/**  取消*/
@property (nonatomic, strong) UIButton * cancelButton;

/**  确定*/
@property (nonatomic, strong) UIButton * sureButton;


/**  开始时间*/
@property (nonatomic, strong) WDDateIntervalPickView * beginPicker;
/**  至*/
@property (nonatomic, strong) UILabel * toLabel;
/**  结束时间*/
@property (nonatomic, strong) WDDateIntervalPickView * endPicker;


@end


@implementation WDDateIntervalAlertView


// MARK: -  life cycle

-(instancetype)initWithModel:(WDDateIntervalAlertStyleModel *)model;
{
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model;
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
    
    CGFloat toWidth = 50;
    CGFloat pickerWidth = (self.frame.size.width - toWidth)/2;
    _beginPicker.frame = CGRectMake(0, buttonHeight, pickerWidth, self.frame.size.height - buttonHeight);
    _toLabel.frame = CGRectMake(pickerWidth, buttonHeight, toWidth, self.frame.size.height - buttonHeight);
    _endPicker.frame = CGRectMake(pickerWidth+toWidth, buttonHeight, pickerWidth, self.frame.size.height - buttonHeight);
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
    [self addSubview:self.beginPicker];
    [self addSubview:self.toLabel];
    [self addSubview:self.endPicker];
    
}

// 加载数据
-(void)loadData {

}

-(void)clickAction:(UIButton *)sender
{
    if (_didClickButton) {
        BOOL isSure = [sender isEqual:_sureButton];
        _didClickButton(isSure,_beginPicker.currentValue,_endPicker.currentValue);
    }
}

-(void)dateChanged:(WDDateIntervalPickView *)sender value:(NSString *)value;
{    
    if ([_beginPicker.currentValue isEqualToString:_endPicker.currentValue])
    {
        if ([sender isEqual:_beginPicker])
        {
            [_endPicker nextStep];
        }
        else
        {
             [_beginPicker previousStep];
        }
    }
    else
    {
        if (_didSelectDate) {
            _didSelectDate(_beginPicker.currentValue,_endPicker.currentValue);
        }
    }
    
}

// MARK: -  public methods
-(void)setStyleModel:(WDDateIntervalAlertStyleModel * _Nonnull)styleModel
{
    _styleModel = styleModel;
    self.beginPicker.currentValue = styleModel.beginDate;
    self.endPicker.currentValue = styleModel.endDate;
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

-(WDDateIntervalPickView *)beginPicker
{
    if (!_beginPicker) {
        __weak typeof(self) weakSelf = self;

        WDDateIntervalPickView * pick = [[WDDateIntervalPickView alloc] init];
        pick.style = _styleModel.style;
        pick.backgroundColor = _styleModel.dateBackgroudColor;
        pick.textColor = _styleModel.dateTextColor;
        pick.lineSpaceColor = _styleModel.lineSpaceColor;
        pick.currentValue = _styleModel.beginDate;
        pick.valueChangeed = ^(WDDateIntervalPickView * _Nonnull view, NSString * _Nonnull value) {
            [weakSelf dateChanged:view value:value];
        };
        _beginPicker = pick;
    }
    
    return _beginPicker;
}

-(UILabel *)toLabel
{
    if (!_toLabel) {
        UILabel * view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor = _styleModel.dateBackgroudColor;
        view.textColor = _styleModel.toTitleColor;
        view.text = _styleModel.toTitle;
        _toLabel = view;
    }
    return _toLabel;
}


-(WDDateIntervalPickView *)endPicker
{
    if (!_endPicker) {
        __weak typeof(self) weakSelf = self;

        WDDateIntervalPickView * pick = [[WDDateIntervalPickView alloc] init];
        pick.style = _styleModel.style;
        pick.backgroundColor = _styleModel.dateBackgroudColor;
        pick.textColor = _styleModel.dateTextColor;
        pick.lineSpaceColor = _styleModel.lineSpaceColor;
        pick.currentValue = _styleModel.endDate;
        pick.valueChangeed = ^(WDDateIntervalPickView * _Nonnull view, NSString * _Nonnull value) {
            [weakSelf dateChanged:view value:value];
        };
        _endPicker = pick;
    }
    
    return _endPicker;
}

@end


static NSInteger DateSelectMultiple = 100;

@interface WDDateIntervalPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)NSArray<NSString *> *showHourData;
@property (nonatomic, strong)NSArray<NSString *> *showMinuteData;
/**  选中index*/
@property (nonatomic, strong)NSMutableArray<NSNumber *> * indexArr;

@end


@implementation WDDateIntervalPickView


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
/// 前进一步
-(void)previousStep;
{
    NSInteger index = _indexArr.lastObject.integerValue;
    [_indexArr replaceObjectAtIndex:_indexArr.count-1 withObject:@(index-1)];
    
    /// 借位
    if (_indexArr.count > 1 && index%self.showMinuteData.count == 0) {
        NSInteger index = _indexArr[_indexArr.count-2].integerValue;
        [_indexArr replaceObjectAtIndex:_indexArr.count-2 withObject:@(index-1)];
    }
    
    [self updateDateValue];
    [self scrollToIndex:_indexArr animated:YES];
}

/// 后退一步
-(void)nextStep;
{
    NSInteger index = _indexArr.lastObject.integerValue + 1;
    [_indexArr replaceObjectAtIndex:_indexArr.count-1 withObject:@(index)];
    [self updateDateValue];
    [self scrollToIndex:_indexArr animated:YES];
}

/// 刷新
-(void)updateDateValue;
{
    NSMutableString * string = [NSMutableString string];
    for (int i = 0; i < _indexArr.count; i++) {
        NSInteger index = _indexArr[i].integerValue;
        if (i == 0) {
            [string appendString:self.showHourData[index%self.showHourData.count]];
        }
        else {
            [string appendFormat:@":%@",self.showMinuteData[index%self.showMinuteData.count]];
        }
    }
    _currentValue = string;
}

// MARK: -  getters and setters
-(void)setStyle:(WDDateIntervalAlertStyle)style
{
    _style = style;
    
    _indexArr = [NSMutableArray array];
    [_indexArr addObject:@(DateSelectMultiple*self.showMinuteData.count/2)];
    
    if (_style ==  WDDateIntervalAlertStyleHHMM) {
        [_indexArr addObject:@(DateSelectMultiple*self.showHourData.count/2)];
    }
}

-(void)setCurrentValue:(NSString *)currentValue
{
    NSString * hour = [currentValue componentsSeparatedByString:@":"].firstObject;
    NSString * min = [currentValue componentsSeparatedByString:@":"].lastObject;
    
    _currentValue = _style == WDDateIntervalAlertStyleHH ? hour : currentValue;
    
    for (int i = 0; i < self.showHourData.count ; i++) {
        if ([hour isEqualToString:self.showHourData[i]]) {
            NSInteger index = DateSelectMultiple*self.showHourData.count/2 + i;
            [_indexArr replaceObjectAtIndex:0 withObject:@(index)];
            break;
        }
    }
    
    for (int i = 0; i < self.showMinuteData.count ; i++) {
        if ([min isEqualToString:self.showMinuteData[i]]) {
            NSInteger index = DateSelectMultiple*self.showMinuteData.count/2 + i;
            if (_indexArr.count > 1) {
                [_indexArr replaceObjectAtIndex:1 withObject:@(index)];
            }
            
            break;
        }
    }
    [self scrollToIndex:_indexArr animated:NO];
}


-(NSArray<NSString *> *)showHourData{
    if (!_showHourData) {
        NSMutableArray<NSString *> * arr = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        _showHourData = arr;
    }
    return _showHourData;
}

-(NSArray<NSString *> *)showMinuteData{
    if (!_showMinuteData) {
        NSMutableArray<NSString *> * arr = [NSMutableArray array];
        for (int i = 0; i < 60; i++) {
            [arr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        _showMinuteData = arr;
    }
    return _showMinuteData;
}


// MARK: -  UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return _indexArr.count;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger row = component == 0 ? DateSelectMultiple*self.showHourData.count : DateSelectMultiple*self.showMinuteData.count;
    return row;
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
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    NSString * title  = component == 0 ? self.showHourData[row%self.showHourData.count] : self.showMinuteData[row%self.showMinuteData.count];

    label.text = title;
    label.textColor = _textColor;

    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView selectRow:row inComponent:component animated:NO];
    
    [_indexArr replaceObjectAtIndex:component withObject:@(row)];
    [self updateDateValue];
    if (_valueChangeed) {
        _valueChangeed(self,_currentValue);
    }
}

@end
