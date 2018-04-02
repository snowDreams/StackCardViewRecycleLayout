//
//  CardContentView.h
//  StackCardViewRecycleLayout
//
//  Created by fen on 2018/3/28.
//  Copyright © 2018年 testDefaultImage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardContentView : UIView
@property(nonatomic) CGFloat currentOffset;
@property(nonatomic) CGFloat visibleOffset;
@property(nonatomic,strong) UIView *contentImgView;
@end
