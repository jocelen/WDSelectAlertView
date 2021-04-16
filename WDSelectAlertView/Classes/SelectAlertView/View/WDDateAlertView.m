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

-(instancetype)initWithModel:(WDDateSlertStyleModel *)model;
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
    
    _datePick.frame = CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight);
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
    
}

// 加载数据
-(void)loadData {
    
    
}

-(void)clickAction:(UIButton *)sender
{
    if (_didClickButton) {
        BOOL isSure = [sender isEqual:_sureButton];
        NSDate * date = _datePick.date;
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

// MARK: -  public methods
-(void)setDefaultDate:(NSDate *)date;
{
    self.datePick.date = date;
}

-(void)setStyleModel:(WDDateSlertStyleModel * _Nonnull)styleModel
{
    _styleModel = styleModel;
    
    self.datePick.date = _styleModel.date ? _styleModel.date : [NSDate date];
    if (_styleModel.minimumDate) {
        self.datePick.minimumDate = _styleModel.minimumDate;
    }
    
    if (_styleModel.maximumDate) {
        self.datePick.maximumDate = _styleModel.maximumDate;
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
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = button;
    }
    return _sureButton;
}


-(UIDatePicker *)datePick
{
    if (!_datePick) {
        UIDatePicker * view = [[UIDatePicker alloc] init];
        [view setValue:_styleModel.dateTextColor forKey:@"textColor"];
        view.backgroundColor = _styleModel.dateBackgroudColor;
        view.datePickerMode = UIDatePickerModeDate;
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:_styleModel.locale];
        [view setLocale:locale];
        [view addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePick = view;
    }
    
    return _datePick;
}


@end

