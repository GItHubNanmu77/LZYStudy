//
//  LLPileCardViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/25.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLPileCardViewController.h"
#import "LLPileCardView.h"

@interface LLPileCardViewController ()<LLPileCardViewDelegate, LLPileCardViewDataSource>

@property (nonatomic, strong) LLPileCardView *pileCardView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LLPileCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pileCardView = [[LLPileCardView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    self.pileCardView.delegate = self;
    self.pileCardView.dataSource = self;
    [self.view addSubview:self.pileCardView];
}


#pragma mark - LLPileCardViewDataSource methods

- (NSInteger)numberOfItemsInCards:(LLPileCardView *)cards {
    return self.dataArray.count;
}

- (UIView *)cards:(LLPileCardView *)cards viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *imageView = (UIImageView *)view;
    if (!view) {
        imageView = [[UIImageView alloc] initWithFrame:cards.bounds];
        NSString *name = [NSString stringWithFormat:@"%ld.jpg",(long)index];
        imageView.image = [UIImage imageNamed:name];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
    return imageView;
}

#pragma mark - LLPileCardViewDelegate methods

- (void)cards:(LLPileCardView *)cards beforeSwipingItemAtIndex:(NSInteger)index {
    NSLog(@"Begin swiping card %ld!", index);
}

- (void)cards:(LLPileCardView *)cards didLeftRemovedItemAtIndex:(NSInteger)index {
    NSLog(@"<--%ld", index);
}

- (void)cards:(LLPileCardView *)cards didRightRemovedItemAtIndex:(NSInteger)index {
    NSLog(@"%ld-->", index);
}

- (void)cards:(LLPileCardView *)cards didRemovedItemAtIndex:(NSInteger)index {
    NSLog(@"index of removed card: %ld", index);
}

#pragma mark - Setter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [_dataArray addObject:str];
        }
    }
    return _dataArray;
}

@end
