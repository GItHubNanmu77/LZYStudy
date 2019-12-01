//
//  LZYPullTableView.h
//  LZYStudy
//
//  Created by cisdi on 2019/8/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYPullTableView : UIView
@property (nonatomic, copy) void(^selectedBlock) (NSString *text);
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
