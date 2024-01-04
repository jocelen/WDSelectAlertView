//
//  WDViewController.m
//  WDSelectAlertView
//
//  Created by jocelen on 04/16/2021.
//  Copyright (c) 2021 jocelen. All rights reserved.
//

#import "WDViewController.h"
#import "UIViewController+SelectPopView.h"
#import "WDAlertWindowViewController.h"

@interface WDViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
/**  表格*/
@property (nonatomic, strong) UITableView * tableView;

/**  数据源*/
@property (nonatomic, strong) NSArray<NSString *> * titleArr;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> * dataArr;

@end

@implementation WDViewController

// MARK: -  life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadConfig];
    [self addSubviews];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    
    
}

// 添加view
-(void)addSubviews {
    [self.view addSubview:self.tableView];
}

// 加载数据
-(void)loadData {
    _titleArr = @[@"自定义弹框",@"确认弹框", @"选项弹框", @"时间选择", @"时段选择", @"其他选择"];
    _dataArr = @[@[@"上-模糊",@"中-点击取消",@"下"],
                 @[@"单选",@"多选",@"多行多选",@"富文本多选"],
                 @[@"选项",@"选项(有标题)",],
                 @[@"时间YYYYMMDD",@"时间YYYYMM",@"时间YYYY",],
                 @[@"时段",],
                 @[@"键值对",]];
    
}

// MARK: -  public methods



// MARK: -  getters and setters
-(UITableView *)tableView
{
    if (!_tableView) {
        UITableView * table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        _tableView = table;
    }
    return _tableView;;
}



// MARK: -  <UITableViewDelegate,UITableViewDataSource>
/// UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr[section].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * headerID = @"headerID";
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    }
    header.textLabel.text = _titleArr[section];
    return header;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
    return cell;
}

/// UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat section = indexPath.section;
    CGFloat row = indexPath.row;

    if (section == 0) {
        
        WDAlertWindowStyleModel * style = [WDAlertWindowStyleModel defaultStyle];
        
        if (row == 0) {
            style.isGroundGlass = YES;
            style.canTouchCancel = YES;
            style.position = BCAlertViewPositionTypeTop;
        }
        else if (row == 1) {
            style.isGroundGlass = NO;
            style.canTouchCancel = NO;
            style.position = BCAlertViewPositionTypeCenter;
        }
        else if (row == 2) {
            style.isGroundGlass = NO;
            style.canTouchCancel = YES;
            style.position = BCAlertViewPositionTypeBottom;
        }
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 150);
        [button setTitle:@"点击我" forState:UIControlStateNormal];
        button.backgroundColor = UIColor.redColor;
        [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        
        WDAlertWindowViewController * vc = [[WDAlertWindowViewController alloc] initWithModel:style];
        vc.contentView = button;
        [self presentViewController:vc animated:NO completion:nil];
    }
    else if (section == 1) {
        if (row == 0) {
            [self showAlertSure:nil message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子" sureTitle:@"追求" selectAction:^(BOOL isSure, NSString *message) {
                
            }];
        }
        else if (row == 1) {
            [self showAlertSelect:@"关雎" message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，日日夜夜都想追求她。" selectAction:^(BOOL isSure, NSString *message) {
                
            }];
        }
        else if (row == 2) {
            [self showAlertSelect:@"关雎" message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，日日夜夜都想追求她。\n追求却没法得到，日日夜夜总思念她。绵绵不断的思念，叫人翻来覆去难入睡。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，弹琴鼓瑟来亲近她。" sureTitle:@"背诵十遍" selectAction:^(BOOL isSure, NSString *message) {
                
            }];
        }
        else if (row == 2) {
            [self showAlertSelect:@"关雎" message:@"关关和鸣的雎鸠，栖息在河中的小洲。贤良美好的女子，是君子好的配偶。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，日日夜夜都想追求她。\n追求却没法得到，日日夜夜总思念她。绵绵不断的思念，叫人翻来覆去难入睡。\n参差不齐的荇菜，在船的左右两边摘取。贤良美好的女子，弹琴鼓瑟来亲近她。\n参差不齐的荇菜，在船的左右两边去挑选它。贤良美好的女子，敲起钟鼓来取悦她" sureTitle:@"背诵十遍" cancelTitle:@"才不要" selectAction:^(BOOL isSure, NSString *message) {
                
            }];
        }
        else {
            WDSelectAlertStyleModel * model = [WDSelectAlertStyleModel defaultStyle];
            model.contentTextAlignment = NSTextAlignmentRight;
            model.title = @"关雎";
            model.titleColor = UIColor.greenColor;
            model.contentColor = UIColor.redColor;
            model.content = @"关关雎鸠，在河之洲。窈窕淑女，君子好逑。\n参差荇菜，左右流之。窈窕淑女，寤寐求之。\n求之不得，寤寐思服。悠哉悠哉，辗转反侧。\n参差荇菜，左右采之。窈窕淑女，琴瑟友之。\n参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。";
            model.highlightArr = @[@"在河之洲",@"左右流之",@"寤寐思服"];
            model.highlightFont = [UIFont systemFontOfSize:15];
            model.highlightColor = UIColor.yellowColor;

            model.linkArr = @[@"窈窕淑女",@"左右芼之",@"悠哉悠哉"];
            model.linkFont = [UIFont systemFontOfSize:20];
            model.linkColor = UIColor.greenColor;

            model.sureTitle = @"追求✅";
            model.sureTitleColor = UIColor.yellowColor;
            model.sureTitleFont = [UIFont systemFontOfSize:30];
            
            model.cancelTitle = @"放弃❌";
            model.cancelTitleColor = UIColor.redColor;
            model.cancelTitleFont = [UIFont systemFontOfSize:10];
            
            [self showAlertCustomize:model clickAction:^(NSInteger index) {
                NSLog(@"%ld",index);

            } selectAction:^(BOOL isSure, NSString *message) {
                
            }];
            
        }
        
        
    }
    else if (section == 2) {
        NSString * title = row == 1 ? @"温馨提示\n 关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。" : @"";
        NSArray * selects = @[@"拍照",@"不可选",@"图片"];
        [self showSheetSelect:title selectItems:selects disAbleItems:@[@"不可选"] selectAction:^(NSInteger index) {
            NSLog(@"%ld",index);
        }];
        
    }
    else if (section == 3) {
        
        WDDateAlertAlertStyle style = WDDateAlertAlertStyleYYYYMMDD;
        if (row == 1) {
            style = WDDateAlertAlertStyleYYYYMM;
        }
        else if (row == 2) {
            style = WDDateAlertAlertStyleYYYY;
        }
        
        NSDate * date = [NSDate new];
        [self showDateSelect:date minimumDate:nil maximumDate:nil style:style changeAction:^(NSDate * _Nonnull date) {
            NSLog(@"%@",date);
        } selectAction:^(BOOL isSure, NSDate * _Nonnull date) {
            NSLog(@"%@",date);
        }];
    }
    else if (section == 4) {
        
        NSArray * dates = @[@"08:00",@"12:00"];
        [self showDateParagraphSelect:dates style:WDDateIntervalAlertStyleHH selectAction:^(BOOL isSure, NSString * _Nonnull begin, NSString * _Nonnull end) {
            NSLog(@"%@ -- %@",begin,end);
        }];
    }
    else if (section == 5) {
        
        NSArray * keys = @[@"一",@"二",@"三",@"四",@"一",@"二",@"三",@"四"];
        NSArray * values = @[@"One",@"Two",@"Three",@"Four",@"One",@"Two",@"Three",@"Four"];
        [self showKeyValueSelect:keys valueArr:values index:1 selectAction:^(BOOL isSure, NSInteger index) {
            NSLog(@"%ld",index);
        }];
    }
}





@end
