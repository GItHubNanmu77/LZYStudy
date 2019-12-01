//
//  LLGCDViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/9/29.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLGCDViewController.h"

@interface LLGCDViewController ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, copy) NSString *search;
@end

@implementation LLGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.btn];
    [self.view addSubview:self.inputTextField];
    
}

- (void)loadData:(BOOL)isStop {
    __block BOOL gcdFlag = isStop;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (long i=0; i<100; i++) {
            NSLog(@"正在执行第i次:%ld",i);
            sleep(2);
            if (gcdFlag==YES) {
                NSLog(@"终止");
                gcdFlag = NO;
                return ;
            }
        }
        
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                  (int64_t)(10 * NSEC_PER_SEC)),
//    dispatch_get_main_queue(), ^{
//        NSLog(@"我要停止啦");
//        gcdFlag = YES;
//
//    });
}

 
- (void)textFieldDidChange:(UITextField *)textField {
    
    if (![textField.text isEqualToString:self.search]) {
        self.search = textField.text;
//        [self loadData:NO];
    } else {
        
    }
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 150, 40)];
//            textField.delegate = self;
            textField.font = LZY_FONT_FROM_NAME_SIZE(16.0);
            textField.textAlignment = NSTextAlignmentRight;
            textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            textField.placeholder = @"请输入";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField;
        });
    }
    return _inputTextField;
}
 
@end
