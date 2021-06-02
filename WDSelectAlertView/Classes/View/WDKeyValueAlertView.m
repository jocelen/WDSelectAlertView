//
//  WDKeyValueAlertView.m
//  BOC
//
//  Created by dzkj on 2021/1/6.
//  Copyright © 2021 mimiao. All rights reserved.
//

#import "WDKeyValueAlertView.h"

@interface WDKeyValueAlertView()<UIPickerViewDelegate,UIPickerViewDataSource>

/**  取消*/
@property (nonatomic, strong) UIButton * cancelButton;

/**  确定*/
@property (nonatomic, strong) UIButton * sureButton;

/**  picker*/
@property (nonatomic, strong) UIPickerView * picker;

@end

@implementation WDKeyValueAlertView


// MARK: -  life cycle

-(instancetype)initWithModel:(WDKeyValueAlertStyleModel *)model;
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
    
    _picker.frame = CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight);
}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    _selectIndex = -1;
    self.backgroundColor = _styleModel.backgroudColor;
}

// 添加view
-(void)addSubviews {
    [self addSubview:self.cancelButton];
    [self addSubview:self.sureButton];
    [self addSubview:self.picker];
}

// 加载数据
-(void)loadData {

}

-(void)clickAction:(UIButton *)sender
{
    if (_didClickButton) {
        BOOL isSure = [sender isEqual:_sureButton];
        _didClickButton(isSure,[self.picker selectedRowInComponent:0]);
    }
}

//-(void)dateChanged:(BCDateIntervalPickView *)sender value:(NSString *)value;
//{
//    if ([_beginPicker.currentValue isEqualToString:_endPicker.currentValue])
//    {
//        if ([sender isEqual:_beginPicker])
//        {
//            [_endPicker nextStep];
//        }
//        else
//        {
//             [_beginPicker previousStep];
//        }
//    }
//    else
//    {
//        if (_didSelectDate) {
//            _didSelectDate(_beginPicker.currentValue,_endPicker.currentValue);
//        }
//    }
//
//}

// MARK: -  public methods
-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [self.picker selectRow:_selectIndex inComponent:0 animated:NO];
}


// MARK: -  UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX(_styleModel.keyArr.count, _styleModel.valueArr.count);
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = _styleModel.lineSpaceColor;
        }
    }
    
    WDKeyValueAlertViewCell * cell = (WDKeyValueAlertViewCell *)view;
    if (view == nil) {
        cell = [[WDKeyValueAlertViewCell alloc] init];
        cell.textColor = _styleModel.textColor;
        cell.selectTextColor = _styleModel.selectTextColor;
    }

    if (_styleModel.keyArr.count) {
        cell.leftLabel.text = (row < _styleModel.keyArr.count) ? _styleModel.keyArr[row] : @"";
    }
    if (_styleModel.valueArr.count) {
        cell.rightLabel.text = (row < _styleModel.valueArr.count) ? _styleModel.valueArr[row] : @"";
    }
    cell.isSelect = (row == _selectIndex);
    return cell;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_didSelectDate) {
        _didSelectDate(row);
    }
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
        [button setTitleColor:_styleModel.sureTitleDisableColor forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = button;
    }
    return _sureButton;
}

-(UIPickerView *)picker
{
    if (!_picker) {
        UIPickerView * pick = [[UIPickerView alloc] init];
        pick.backgroundColor = _styleModel.pickBackgroudColor;
        pick.delegate = self;
        pick.dataSource = self;
        _picker = pick;
    }
    
    return _picker;
}


@end



@interface WDKeyValueAlertViewCell()



@end


@implementation WDKeyValueAlertViewCell



// MARK: -  life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadConfig];
        [self addSubviews];
        [self loadData];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_leftLabel && _rightLabel) {
        CGFloat width = self.frame.size.width/2;
        _leftLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
        _rightLabel.frame = CGRectMake(width, 0, width, self.frame.size.height);
    }
    else if (_leftLabel || _rightLabel) {
        _leftLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _rightLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    else {
        _leftLabel.frame = CGRectZero;
        _rightLabel.frame = CGRectZero;
    }
}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    
}

// 添加view
-(void)addSubviews {
    
}

// 加载数据
-(void)loadData {
    
    
}

// MARK: -  public methods
-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    UIColor * color = _isSelect ? _selectTextColor: _textColor;
    _leftLabel.textColor = color;
    _rightLabel.textColor = color;
}


// MARK: -  getters and setters
-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _textColor;
        _leftLabel = label;
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}


-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _textColor;
        _rightLabel = label;
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}


@end
