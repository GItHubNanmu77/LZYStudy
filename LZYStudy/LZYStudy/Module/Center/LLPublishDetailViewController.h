//
//  LLPublishDetailViewController.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/7.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLPublishDetailViewController : UIViewController
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) LLDynamicModel *model;
@end

NS_ASSUME_NONNULL_END
