//
//  LLUserInfoViewController.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/17.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUserInfoViewController : UIViewController  <JXPagerViewListViewDelegate>

- (void)changeDataSource;
@end

NS_ASSUME_NONNULL_END
