//
//  Scrollerview.h
//  StackCardViewRecycleLayout
//
//  Created by fen on 2018/3/27.
//  Copyright © 2018年 testDefaultImage. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  CardW 143
#define  CardH 104
#define  PAGEWIDTH 100
#define  MAXOFFSET 50000
#define MAXCOUNT 7
@protocol scrollCycleDelegate <NSObject>
-(UIView *)imageViewAtIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;
@end

@interface Scrollerview : UIView<UIScrollViewDelegate>
@property(nonatomic,weak) id<scrollCycleDelegate> dataSourceDelegate;

-(void)setCount:(NSInteger)count withCurrentIndex:(NSInteger)index;
@end
