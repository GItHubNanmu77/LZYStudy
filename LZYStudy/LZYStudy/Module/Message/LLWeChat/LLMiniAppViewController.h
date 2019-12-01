//
//  LLMiniAppViewController.h
//  LZYStudy
//
//  Created by cisdi on 2019/7/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMiniAppViewController : UIViewController
@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, copy) void(^hideCollViewBlock) (void);

@end

NS_ASSUME_NONNULL_END
