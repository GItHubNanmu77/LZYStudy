//
//  LZYDateTimePickerView.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/29.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYDateTimePickerView.h"
#import "LZYMacro.h"




#define MAXYEAR 2199
#define MINYEAR 1900
static const CGFloat kPickerViewHeight = 216.0;
static const CGFloat kPickerButtonHeight = 44.0;


@interface LZYDateTimePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    /// 数据组数
    NSInteger _componentNumber;
    /// 内容区高度
    CGFloat _contentViewHeight;
}

/// 背景遮罩
@property (nonatomic, strong) UIView *coverView;
/// 内容视图
@property (nonatomic, strong) UIView *contentView;
/// 选择容器
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) BOOL isDouble;
/// 双选的结果显示view
@property (nonatomic, strong) UIView *resultView;
/// 开始时间
@property (nonatomic, strong) UILabel *startLabel;
/// 开始时间下划线
@property (nonatomic, strong) UIImageView *startLabelLine;
/// @”至“
@property (nonatomic, strong) UILabel *unitLabel;
/// 结束时间
@property (nonatomic, strong) UILabel *endLabel;
/// 结束时间下划线
@property (nonatomic, strong) UIImageView *endLabelLine;
/// 是否是修改开始时间
@property (nonatomic, assign) BOOL isChangeStartTime;
/// 高度默认为60
@property (nonatomic, assign) CGFloat resultViewHeight;

/// 选择器类型
@property (nonatomic, assign) LZYDateTimePickerStyle datePickerStyle;
/// 滚到指定日期
@property (nonatomic, retain) NSDate *scrollToDate;
/// 默认显示日期
@property (nonatomic, copy) NSString *defaultDateStr;

//日期存储数组
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;
@property (nonatomic, strong) NSString *dateFormatter;
/// 后缀文字数组
@property (nonatomic, strong) NSArray *nameArray;
//记录位置
@property (nonatomic, assign) NSInteger yearIndex;
@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger dayIndex;
@property (nonatomic, assign) NSInteger hourIndex;
@property (nonatomic, assign) NSInteger minuteIndex;

@property (nonatomic, assign) NSInteger preRow;

@end

@implementation LZYDateTimePickerView

/**
 *  Window
 *
 *  @return <#return value description#>
 */
- (UIView *)initTopWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.subviews[0];
}


/**
 *  初始化
 *
 *  @param style                  选择器类型
 *  @param defaultDateStr         默认选中时间
 *
 *  @return return value description
 */
- (instancetype)initWithDatePickerStyle:(LZYDateTimePickerStyle )style defaultDateStr:(nullable NSString *)defaultDateStr isDoubleSelected:(BOOL)isDouble{
    self = [super init];
    if (self) {
        
        self.datePickerStyle = style;
        self.defaultDateStr = defaultDateStr;
        self.isDouble = isDouble;
        if (isDouble) {
            self.resultViewHeight = 60.0;
        } else {
            self.resultViewHeight = 0.0;
        }
        _contentViewHeight = kPickerViewHeight + 1.0 + kPickerButtonHeight + self.resultViewHeight + LZY_TAB_BAR_SAFE_BOTTOM_MARGIN;
        
        
        
        switch (style) {
            case LZYDateTimePickerStyleYearMonthDayHourMinute: {
                _nameArray = @[@"年",@"月",@"日",@"时",@"分"];
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                _componentNumber = 5;
            } break;
            case LZYDateTimePickerStyleYearMonthDay: {
                _nameArray = @[@"年",@"月",@"日"];
                _dateFormatter = @"yyyy-MM-dd";
                _componentNumber = 3;
            } break;
            case LZYDateTimePickerStyleMonthDayHourMinute: {
                _nameArray = @[@"月",@"日",@"时",@"分"];
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                _componentNumber = 4;
            } break;
            case LZYDateTimePickerStyleMonthDay: {
                _nameArray = @[@"月",@"日"];
                _dateFormatter = @"yyyy-MM-dd";
                _componentNumber = 2;
            } break;
            case LZYDateTimePickerStyleHourMinute: {
                _nameArray = @[@"时",@"分"];
                _dateFormatter = @"HH:mm";
                _componentNumber = 2;
            } break;
            default: {
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                _componentNumber = 0;
            } break;
        }
        
        self.viewBackgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
        self.pickerItemBackgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        self.pickerItemSeparatorColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        self.pickerItemTitleColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
        self.buttonBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.00];
        self.buttonTitleNormalColor = [UIColor colorWithRed:76/255.0 green:131/255.0 blue:244/255.0 alpha:1.00];
        
        [self setupContent];
        [self setupPickerView];
        [self setupButton];
        [self setDefaultConfig];
        if (isDouble) {
            [self setupResultView];
        }
        
        
    }
    return self;
}


#pragma mark - 初始化
/**
 *  初始化内容控件
 */
- (void)setupContent {
    //
    self.frame = [UIScreen mainScreen].bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    [[self initTopWindow] addSubview:self];
    
    // 遮罩
    self.coverView = [[UIView alloc] initWithFrame:self.frame];
    self.coverView.userInteractionEnabled = YES;
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.0;
    [self addSubview:self.coverView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.coverView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    // 内容
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height + _contentViewHeight, self.frame.size.width, _contentViewHeight)];
    self.contentView.backgroundColor = self.viewBackgroundColor;
    [self addSubview:self.contentView];
}

/**
 *  初始化选择器
 */
- (void)setupPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,kPickerButtonHeight + 1.0 + self.resultViewHeight, self.frame.size.width, kPickerViewHeight)];
    self.pickerView.backgroundColor = self.pickerItemBackgroundColor;
    self.pickerView.delegate = self;
    [self.contentView addSubview:self.pickerView];
    
    // 分隔线颜色
    [self.pickerView.subviews[1] setBackgroundColor:self.pickerItemSeparatorColor];
    [self.pickerView.subviews[2] setBackgroundColor:self.pickerItemSeparatorColor];
}

/**
 *  初始化按钮
 */
- (void)setupButton {
    CGFloat rectW = self.contentView.frame.size.width / 3.0;
    CGFloat rectX = 0.0;
    
    NSArray *buttonTitles = @[@"取消", @"", @"确定"];
    for (NSInteger index = 0; index < buttonTitles.count; index++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(rectX, 0.0, rectW, kPickerButtonHeight)];
        button.tag = index;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        button.backgroundColor = self.buttonBackgroundColor;
        [button setTitle:buttonTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:self.buttonTitleNormalColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        rectX += rectW;
    }
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kPickerButtonHeight, self.contentView.frame.size.width, 0.5)];
    separatorView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.contentView addSubview:separatorView];
}

/**
 初始化双选结果view
 */
- (void)setupResultView {
    @LZY_weakify(self)
    self.resultView = [[UIView alloc] initWithFrame:CGRectMake(0, kPickerButtonHeight + 1.0, self.frame.size.width, self.resultViewHeight)];
    self.resultView.backgroundColor = [UIColor whiteColor];
    self.startLabelLine = [[UIImageView alloc] init];
    self.startLabelLine.backgroundColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
    self.startLabel = [[UILabel alloc] init];
    self.startLabel.textAlignment = NSTextAlignmentCenter;
    self.startLabel.textColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
    self.startLabel.text = @"开始时间";
    self.startLabel.font = [UIFont systemFontOfSize:14];
    self.startLabel.userInteractionEnabled = YES;
    [self.startLabel bk_whenTapped:^{
        @LZY_strongify(self)
        self.startLabel.textColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
        self.startLabelLine.backgroundColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
        self.endLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        self.endLabelLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        self.isChangeStartTime = YES;
    }];
    self.isChangeStartTime = YES;
    
    self.endLabelLine = [[UIImageView alloc] init];
    self.endLabelLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    self.endLabel = [[UILabel alloc] init];
    self.endLabel.textAlignment = NSTextAlignmentCenter;
    self.endLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    self.endLabel.font = [UIFont systemFontOfSize:14];
    self.endLabel.text = @"结束时间";
    self.endLabel.userInteractionEnabled = YES;
    [self.endLabel bk_whenTapped:^{
        self.endLabel.textColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
        self.endLabelLine.backgroundColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
        self.startLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        self.startLabelLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        self.isChangeStartTime = NO;
    }];
    
    self.unitLabel = [[UILabel alloc] init];
    self.unitLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    self.unitLabel.text = @"至";
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.font = [UIFont systemFontOfSize:14];
    [self.unitLabel sizeToFit];
    
    [self.resultView addSubview:self.unitLabel];
    [self.resultView addSubview:self.startLabelLine];
    [self.resultView addSubview:self.startLabel];
    [self.resultView addSubview:self.endLabelLine];
    [self.resultView addSubview:self.endLabel];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.resultView);
        make.centerY.equalTo(self.resultView);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unitLabel.mas_left).mas_offset(-40);
        make.left.equalTo(self).mas_offset(30);
        make.centerY.equalTo(self.unitLabel);
        make.height.mas_equalTo(20);
    }];
    [self.startLabelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startLabel.mas_bottom).mas_offset(8);
        make.centerX.equalTo(self.startLabel);
        make.width.equalTo(self.startLabel).multipliedBy(1.7);
        make.height.mas_equalTo(1);
    }];
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unitLabel.mas_right).mas_offset(40);
        make.right.equalTo(self).mas_offset(-30);
        make.centerY.equalTo(self.unitLabel);
        make.height.mas_equalTo(20);
    }];
    [self.endLabelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endLabel.mas_bottom).mas_offset(8);
        make.centerX.equalTo(self.endLabel);
        make.width.equalTo(self.endLabel).multipliedBy(1.7);;
        make.height.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.resultView];
}
/**
 默认配置
 */
-(void)setDefaultConfig {
    if (self.defaultDateStr.length > 0) {
        _scrollToDate = [self.defaultDateStr parseToDate:_dateFormatter];
    } else {
        _scrollToDate = [NSDate date];
    }
    
    //循环滚动时需要用到
    self.preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [_monthArray addObject:num];
        if (i<24)
            [_hourArray addObject:num];
        [_minuteArray addObject:num];
    }
    for (NSInteger i=MINYEAR; i<MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [@"2199-12-31 23:59" parseToDate:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [@"1900-01-01 00:00" parseToDate:@"yyyy-MM-dd HH:mm"];
    }
}

/**
 添加文字后缀
 */
-(void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.pickerView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i = 0; i < nameArr.count; i++) {
        CGFloat labelX = self.frame.size.width / (nameArr.count * 2) + 18 + self.frame.size.width / nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.pickerView.frame.size.height / 2 - 15 / 2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self.pickerView addSubview:label];
    }
}


- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray) {
        [mutableArray removeAllObjects];
    } else {
        mutableArray = [NSMutableArray array];
    }
    return mutableArray;
}


#pragma amrk - 按钮事件
/**
 *  按钮点击事件
 *
 *  @param sender <#sender description#>
 */
- (void)pressedButton:(UIButton *)sender {
    if (sender.tag == 0) {
        // 取消
        [self hide];
    } else if (sender.tag == 1) {
        // 标题
        
    } else if (sender.tag == 2) {
        // 确定
        if (self.isDouble) {
            if(self.doubleConfirmButtonPressedCallback){
                self.doubleConfirmButtonPressedCallback(self.startLabel.text, self.endLabel.text);
                NSLog(@"选中开始时间：%@",self.startLabel.text);
                NSLog(@"选中结束时间：%@",self.endLabel.text);
            }
        } else {
            if(self.confirmButtonPressedCallback){
                NSString *dateString = [self.scrollToDate formterToStringByStyle:_dateFormatter];
                self.confirmButtonPressedCallback(dateString);
                NSLog(@"选中结果：%@",dateString);
            }
        }
        [self hide];
    }
}


#pragma mark - 方法
/**
 *  显示
 */
- (void)show {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.coverView.alpha = 0.3;
                         self.contentView.frame = CGRectMake(0.0, self.frame.size.height - self->_contentViewHeight, self.frame.size.width, self->_contentViewHeight);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

/**
 *  隐藏
 */
- (void)hide {
    if (self.pickerBeforeDismissCallback) {
        self.pickerBeforeDismissCallback();
    }
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.coverView.alpha = 0.0;
                         self.contentView.frame = CGRectMake(0.0, self.frame.size.height + self->_contentViewHeight, self.frame.size.width, self->_contentViewHeight);
                     }
                     completion:^(BOOL finished) {
                         [self.resultView removeFromSuperview];
                         self.resultView = nil;
                         [self.pickerView removeFromSuperview];
                         self.pickerView = nil;
                         [self.contentView removeFromSuperview];
                         self.contentView = nil;
                         [self.coverView removeFromSuperview];
                         self.coverView = nil;
                         [self removeFromSuperview];
                     }];
}


#pragma mark - PickerView 委托事件
/**
 *  选择器分组数
 *
 *  @param pickerView <#pickerView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [self addLabelWithName:self.nameArray];
    return _componentNumber;
}

/**
 *  选择器组总行数
 *
 *  @param pickerView <#pickerView description#>
 *  @param component  <#component description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

// 计算每个component的rows
-(NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    
    switch (self.datePickerStyle) {
        case LZYDateTimePickerStyleYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case LZYDateTimePickerStyleMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case LZYDateTimePickerStyleYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case LZYDateTimePickerStyleMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case LZYDateTimePickerStyleHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
    
}

/**
 *  选择器自定义标题
 *
 *  @param pickerView <#pickerView description#>
 *  @param row        <#row description#>
 *  @param component  <#component description#>
 *  @param view       <#view description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *title = @"";
    
    UILabel *retval = (id)view;
    if (!retval) {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, [pickerView rowSizeForComponent:component].width - 12.0, [pickerView rowSizeForComponent:component].height)];
    }
    retval.font = [UIFont systemFontOfSize:18.0];
    retval.backgroundColor = [UIColor clearColor];
    retval.textColor = self.pickerItemTitleColor;
    retval.textAlignment = NSTextAlignmentCenter;
    
    switch (self.datePickerStyle) {
        case LZYDateTimePickerStyleYearMonthDayHourMinute: {
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            if (component==3) {
                title = _hourArray[row];
            }
            if (component==4) {
                title = _minuteArray[row];
            }
        } break;
        case LZYDateTimePickerStyleYearMonthDay: {
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
        } break;
        case LZYDateTimePickerStyleMonthDayHourMinute: {
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            if (component==2) {
                title = _hourArray[row];
            }
            if (component==3) {
                title = _minuteArray[row];
            }
        } break;
        case LZYDateTimePickerStyleMonthDay: {
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
        } break;
        case LZYDateTimePickerStyleHourMinute: {
            if (component==0) {
                title = _hourArray[row];
            }
            if (component==1) {
                title = _minuteArray[row];
            }
        } break;
        default: {
            title = @"";
        } break;
    }
    
    retval.text = title;
    
    return retval;
}

/**
 *  选择器行选中
 *
 *  @param pickerView <#pickerView description#>
 *  @param row        <#row description#>
 *  @param component  <#component description#>
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.datePickerStyle) {
        case LZYDateTimePickerStyleYearMonthDayHourMinute:{
            
            if (component == 0) {
                _yearIndex = row;
            }
            if (component == 1) {
                _monthIndex = row;
            }
            if (component == 2) {
                _dayIndex = row;
            }
            if (component == 3) {
                _hourIndex = row;
            }
            if (component == 4) {
                _minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
                if (_dayArray.count-1<_dayIndex) {
                    _dayIndex = _dayArray.count-1;
                }
                
            }
        } break;
            
        case LZYDateTimePickerStyleYearMonthDay: {
            if (component == 0) {
                _yearIndex = row;
            }
            if (component == 1) {
                _monthIndex = row;
            }
            if (component == 2) {
                _dayIndex = row;
            }
            if (component == 0 || component == 1) {
                [self DaysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
                if (_dayArray.count-1<_dayIndex) {
                    _dayIndex = _dayArray.count-1;
                }
            }
        } break;
            
        case LZYDateTimePickerStyleMonthDayHourMinute: {
            if (component == 1) {
                _dayIndex = row;
            }
            if (component == 2) {
                _hourIndex = row;
            }
            if (component == 3) {
                _minuteIndex = row;
            }
            if (component == 0) {
                
                [self yearChange:row];
                
                if (_dayArray.count-1<_dayIndex) {
                    _dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
            
        } break;
            
        case LZYDateTimePickerStyleMonthDay: {
            if (component == 1) {
                _dayIndex = row;
            }
            if (component == 0) {
                
                [self yearChange:row];
                
                if (_dayArray.count-1<_dayIndex) {
                    _dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
        } break;
            
        case LZYDateTimePickerStyleHourMinute: {
            if (component == 0) {
                _hourIndex = row;
            }
            if (component == 1) {
                _minuteIndex = row;
            }
        } break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[_yearIndex],_monthArray[_monthIndex],_dayArray[_dayIndex],_hourArray[_hourIndex],_minuteArray[_minuteIndex]];
    
    NSDate *allDate = [dateStr parseToDate:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = _dateFormatter;
    NSString *selfStr = [fmt stringFromDate:allDate];
    self.scrollToDate = [fmt dateFromString:selfStr];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    if (self.isDouble) {
    NSString *resultDateString = [self.scrollToDate formterToStringByStyle:_dateFormatter];
        if (self.isChangeStartTime) {
            if ([self.endLabel.text isEqualToString:@"结束时间"]) {
                self.startLabel.text = resultDateString;
            } else {
                if ([resultDateString compare:self.endLabel.text] == NSOrderedAscending) {
                    self.startLabel.text = resultDateString;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"开始时间不得大于结束时间"];
                }
            }
        } else {
            if ([self.startLabel.text isEqualToString:@"开始时间"]) {
                self.endLabel.text = resultDateString;
            } else {
                if ([self.startLabel.text compare:resultDateString] == NSOrderedAscending) {
                    self.endLabel.text = resultDateString;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"结束时间不得小于开始时间"];
                }
            }
        }
    }
}

-(void)yearChange:(NSInteger)row {
    
    _monthIndex = row % 12;
    
    //年份状态变化
    if (row- _preRow < 12 && row -_preRow > 0 && [_monthArray[_monthIndex] integerValue] < [_monthArray[_preRow % 12] integerValue]) {
        _yearIndex ++;
    } else if(_preRow - row < 12 && _preRow - row > 0 && [_monthArray[_monthIndex] integerValue] > [_monthArray[_preRow % 12] integerValue]) {
        _yearIndex --;
    }else {
        NSInteger interval = (row-_preRow) / 12;
        _yearIndex += interval;
    }
    
    _preRow = row;
}

#pragma mark - Sets
/**
 *  背景颜色
 *
 *  @param viewBackgroundColor <#viewBackgroundColor description#>
 */
- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    _viewBackgroundColor = viewBackgroundColor;
    
    self.contentView.backgroundColor = viewBackgroundColor;
}

/**
 选择器背景颜色
 
 @param pickerItemBackgroundColor <#pickerItemBackgroundColor description#>
 */
- (void)setPickerItemBackgroundColor:(UIColor *)pickerItemBackgroundColor {
    _pickerItemBackgroundColor = pickerItemBackgroundColor;
    
    self.pickerView.backgroundColor = pickerItemBackgroundColor;
}

/**
 选择器分隔线颜色
 
 @param pickerItemSeparatorColor <#pickerItemSeparatorColor description#>
 */
- (void)setPickerItemSeparatorColor:(UIColor *)pickerItemSeparatorColor {
    _pickerItemSeparatorColor = pickerItemSeparatorColor;
    
    [self.pickerView.subviews[1] setBackgroundColor:self.pickerItemSeparatorColor];
    [self.pickerView.subviews[2] setBackgroundColor:self.pickerItemSeparatorColor];
}

/**
 *  选择器文字颜色
 *
 *  @param pickerItemTitleColor <#pickerItemTitleColor description#>
 */
- (void)setPickerItemTitleColor:(UIColor *)pickerItemTitleColor {
    _pickerItemTitleColor = pickerItemTitleColor;
    
    [self.pickerView reloadAllComponents];
}

/**
 *  按钮背景颜色
 *
 *  @param buttonBackgroundColor <#buttonBackgroundColor description#>
 */
- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
    _buttonBackgroundColor = buttonBackgroundColor;
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.backgroundColor = buttonBackgroundColor;
        }
    }
}

/**
 *  按钮文字正常颜色
 *
 *  @param buttonTitleNormalColor <#buttonTitleNormalColor description#>
 */
- (void)setButtonTitleNormalColor:(UIColor *)buttonTitleNormalColor {
    _buttonTitleNormalColor = buttonTitleNormalColor;
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button setTitleColor:buttonTitleNormalColor forState:UIControlStateNormal];
        }
    }
}

/**
 *  按钮文字高亮颜色
 *
 *  @param buttonTitleHighlightedColor <#buttonTitleHighlightedColor description#>
 */
- (void)setButtonTitleHighlightedColor:(UIColor *)buttonTitleHighlightedColor {
    _buttonTitleHighlightedColor = buttonTitleHighlightedColor;
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button setTitleColor:buttonTitleHighlightedColor forState:UIControlStateHighlighted];
        }
    }
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    if (_titleName && _titleName.length > 0) {
        for (UIView *view in self.contentView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag == 1) {
                    [button setTitle:_titleName forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
                    break;
                }
            }
        }
    }
}



#pragma mark - dataSource setter
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    _yearIndex = date.year - MINYEAR;
    _monthIndex = date.month - 1;
    _dayIndex = date.day - 1;
    _hourIndex = date.hour;
    _minuteIndex = date.minute;
    
    //循环滚动时需要用到
    _preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == LZYDateTimePickerStyleYearMonthDayHourMinute)
        indexArray = @[@(_yearIndex),@(_monthIndex),@(_dayIndex),@(_hourIndex),@(_minuteIndex)];
    if (self.datePickerStyle == LZYDateTimePickerStyleYearMonthDay)
        indexArray = @[@(_yearIndex),@(_monthIndex),@(_dayIndex)];
    if (self.datePickerStyle == LZYDateTimePickerStyleMonthDayHourMinute)
        indexArray = @[@(_monthIndex),@(_dayIndex),@(_hourIndex),@(_minuteIndex)];
    if (self.datePickerStyle == LZYDateTimePickerStyleMonthDay)
        indexArray = @[@(_monthIndex),@(_dayIndex)];
    if (self.datePickerStyle == LZYDateTimePickerStyleHourMinute)
        indexArray = @[@(_hourIndex),@(_minuteIndex)];
    
    [self.pickerView reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == LZYDateTimePickerStyleMonthDayHourMinute || self.datePickerStyle == LZYDateTimePickerStyleMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - MINYEAR));
            [self.pickerView selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.pickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
        
    }
}

-(void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}

@end
