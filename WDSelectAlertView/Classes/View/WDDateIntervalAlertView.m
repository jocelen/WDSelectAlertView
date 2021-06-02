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


static NSInteger Multiple = 10000;


@interface WDDateIntervalPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)NSArray<NSString *> *showData;

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
    
    _currentIndex = Multiple*self.showData.count/2;
    [self scrollToIndex:_currentIndex animated:NO];
}

// 添加view
-(void)addSubviews {
    
    
}

// 加载数据
-(void)loadData {
    
    
}

-(void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    [self selectRow:index inComponent:0 animated:animated];
    [self pickerView:self didSelectRow:index inComponent:0];
}

// MARK: -  public methods
/// 前进一步
-(void)previousStep;
{
    _currentIndex -= 1;
    [self scrollToIndex:_currentIndex animated:YES];
}

/// 后退一步
-(void)nextStep;
{
    _currentIndex += 1;
    [self scrollToIndex:_currentIndex animated:YES];
}


// MARK: -  getters and setters
-(void)setCurrentValue:(NSString *)currentValue
{
    NSInteger index = 0;
    
    for (int i = 0; i < self.showData.count ; i++) {
        if ([currentValue isEqualToString:self.showData[i]]) {
            index = i;
            break;
        }
    }
    
    _currentValue = currentValue;
    _currentIndex = Multiple*self.showData.count/2 + index;
    [self scrollToIndex:_currentIndex animated:NO];
}


-(NSArray<NSString *> *)showData{
    if (!_showData) {
        _showData = @[@"00:00",
                      @"01:00",
                      @"02:00",
                      @"03:00",
                      @"04:00",
                      @"05:00",
                      @"06:00",
                      @"07:00",
                      @"08:00",
                      @"09:00",
                      @"10:00",
                      @"11:00",
                      @"12:00",
                      
                      @"13:00",
                      @"14:00",
                      @"15:00",
                      @"16:00",
                      @"17:00",
                      @"18:00",
                      @"19:00",
                      @"20:00",
                      @"21:00",
                      @"22:00",
                      @"23:00",
        ];
    }
    return _showData;
}


// MARK: -  UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return Multiple*self.showData.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.showData[row%self.showData.count];
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
    label.text = self.showData[row%self.showData.count];
    label.textColor = _textColor;

    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentIndex = Multiple*self.showData.count/2 + row%self.showData.count;
    [pickerView selectRow:_currentIndex inComponent:component animated:NO];
    
    _currentValue = self.showData[row%self.showData.count];
    if (_valueChangeed) {
        _valueChangeed(self,_currentValue);
    }
}

@end
