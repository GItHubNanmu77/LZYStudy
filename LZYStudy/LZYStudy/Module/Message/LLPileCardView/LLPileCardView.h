//
//  LLPileCardView.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/25.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LLPileCardViewDataSource, LLPileCardViewDelegate;

@interface LLPileCardView : UIView

@property (nonatomic, weak) id<LLPileCardViewDataSource> dataSource;
@property (nonatomic, weak) id<LLPileCardViewDelegate> delegate;

// Default is YES
@property (nonatomic, assign) BOOL showedCyclically;

// We will creat this number of views, so not too many; default is 3
@property (nonatomic, assign) NSInteger numberOfVisibleItems;

// Offset for the next card to the current card, (it will decide the cards appearance, the top card is on top-left, top, or bottom-right and so on; default is (5, 5)
@property (nonatomic, assign) CGSize offset;

// If there is only one card, maybe you don't want to swipe it
@property (nonatomic, assign) BOOL swipeEnabled;

// The first visible card on top
@property (nonatomic, strong, readonly) UIView *topCard;

/**
 *  Refresh to show data source
 */
- (void)reloadData;

@end

@protocol LLPileCardViewDataSource <NSObject>
@required

- (NSInteger)numberOfItemsInCards:(LLPileCardView *)cards;
- (UIView *)cards:(LLPileCardView *)cards viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

@end

@protocol LLPileCardViewDelegate <NSObject>
@optional

- (void)cards:(LLPileCardView *)cards beforeSwipingItemAtIndex:(NSInteger)index;
- (void)cards:(LLPileCardView *)cards didRemovedItemAtIndex:(NSInteger)index;
- (void)cards:(LLPileCardView *)cards didLeftRemovedItemAtIndex:(NSInteger)index;
- (void)cards:(LLPileCardView *)cards didRightRemovedItemAtIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
