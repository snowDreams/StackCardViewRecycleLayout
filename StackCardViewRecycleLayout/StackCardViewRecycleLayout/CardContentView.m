//
//  CardContentView.m
//  StackCardViewRecycleLayout
//
//  Created by fen on 2018/3/28.
//  Copyright © 2018年 testDefaultImage. All rights reserved.
//

#import "CardContentView.h"
#import "Scrollerview.h"
@implementation CardContentView

-(void)setContentImgView:(UIView *)contentImgView{
    if(contentImgView != _contentImgView){
        if(_contentImgView.superview == self)
          [_contentImgView removeFromSuperview];
    }
    _contentImgView = contentImgView;
    [self addSubview:_contentImgView];
}

-(void)setVisibleOffset:(CGFloat)visibleOffset{
    _visibleOffset = visibleOffset;
    CGFloat initCenter = CardW/2.0 + 17;
    if(_visibleOffset>0){
        CGFloat maxOffset = PAGEWIDTH * 3;
        if(visibleOffset>maxOffset) self.alpha = 0;
        else{
            CGFloat percent = visibleOffset / PAGEWIDTH;

            CGFloat scale = 1-0.15*percent;
            self.transform = CGAffineTransformMakeScale(scale, scale);

            CGFloat firstCenter = CardW / 2.0 * 0.85 + 7;
            CGFloat secondCenter = CardW / 2.0 * 0.7;
            CGFloat thirdCenter = CardW / 2.0 * 0.55;
            CGPoint center = self.center;
            if(percent<=1){
                self.alpha = 1-0.5*percent;
                center.x = initCenter+(firstCenter-initCenter)*percent;
            }
            else if (percent <= 2) {
                self.alpha = 0.5;
                center.x = firstCenter + (secondCenter - firstCenter) * (percent - 1) ;  // 偏移量加缩小偏移量
            } else { // < 3
                self.alpha = 0.5 - (percent - 2) * 0.5;
                center.x = secondCenter + (thirdCenter - secondCenter) * (percent - 2);  // 偏移量加缩小偏移量
            }

            self.center = center;
        }
    }
    else{
        self.alpha = 1;
        CGFloat percent = (-visibleOffset ) / PAGEWIDTH;
        CGFloat oneCenter = initCenter + CardW / 2 + 9 + CardW * 0.85 / 2;
        CGPoint center = self.center;
        if (percent > 1) {
            self.transform = CGAffineTransformMakeScale(0.85, 0.85);
            center.x = oneCenter + (percent - 1) * (9 + CardW * 0.85);
        } else {
            CGFloat scale = 1 - 0.15 * percent;
            self.transform = CGAffineTransformMakeScale(scale, scale);
            center.x = initCenter + (oneCenter - initCenter) * percent;
        }
        self.center = center;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
