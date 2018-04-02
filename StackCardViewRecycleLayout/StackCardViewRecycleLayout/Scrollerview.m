//
//  Scrollerview.m
//  StackCardViewRecycleLayout
//
//  Created by fen on 2018/3/27.
//  Copyright © 2018年 testDefaultImage. All rights reserved.
//

#import "Scrollerview.h"
#import "CardContentView.h"


@interface Scrollerview ()
@property(nonatomic,strong)UIScrollView *contentScrollView;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)NSInteger totalCount;
@property(nonatomic,strong)NSArray *cardContentViews;
@property(nonatomic) CGFloat currentIndexOffset;
@property(nonatomic) CGFloat oldOffset;
@end

@implementation Scrollerview

-(void)dealloc{
    [_contentView removeObserver:self forKeyPath:@"contentOffset"];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollV.delegate = self;
        scrollV.contentSize = CGSizeMake(CGFLOAT_MAX, self.bounds.size.height);
        scrollV.showsVerticalScrollIndicator = NO;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.bounces = NO;
        _contentScrollView = scrollV;
        [self addSubview:scrollV];

        _contentView = [[UIView alloc] initWithFrame:_contentScrollView.bounds];
        [_contentScrollView addSubview:_contentView];

        [_contentScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
        NSMutableArray *views = [NSMutableArray new];
        for(NSInteger i=0;i<MAXCOUNT;i++){
            CardContentView *cardView = [[CardContentView alloc] initWithFrame:CGRectMake(0, 0, CardW, CardH)];
            cardView.layer.cornerRadius = 3.f;
            cardView.layer.masksToBounds = YES;
            cardView.currentOffset = PAGEWIDTH *i;
            [_contentView addSubview:cardView];
            [views addObject:cardView];
        }
        _cardContentViews = views;
    }
    return self;
}


-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self loadData];
    _currentIndexOffset = MAXOFFSET;
    [_contentScrollView setContentOffset:CGPointMake(_currentIndexOffset,0) animated:false];
}

-(void)setCount:(NSInteger)count withCurrentIndex:(NSInteger)index{
    _totalCount = count;
    self.currentIndex = index;
}

static NSInteger safeIndex(NSInteger totalCount,NSInteger index){
    if(totalCount <= 0) return 0;
    if(index<0){
        index = index%totalCount;
        if(index<0) index += totalCount;
    }
    else index = index%totalCount;
    NSCParameterAssert(index >= 0);
    return index;
}

-(void)loadData{

     for(NSInteger i=0;i<MAXCOUNT;i++){
         CardContentView *cardView =  _cardContentViews[i];
         NSInteger index = safeIndex(_totalCount, _currentIndex+i-MAXCOUNT/2);
         UIView *v = [self.dataSourceDelegate imageViewAtIndex:index currentIndex:_currentIndex];
         [cardView setContentImgView:v];
     }

}

//监听contentOffset,
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){
        [self offsetChange];
    }
}

-(void)offsetChange{
    if(_cardContentViews.count<1) return;
    _contentView.frame = _contentScrollView.bounds;

    CGFloat x = _contentScrollView.contentOffset.x;
    //计算相对位置
    CGFloat offsetX = x - _currentIndexOffset + PAGEWIDTH*(MAXCOUNT/2);

    [_cardContentViews enumerateObjectsUsingBlock:^(CardContentView* view, NSUInteger idx, BOOL * _Nonnull stop) {

        view.visibleOffset = offsetX - view.currentOffset;
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldOffset = _contentScrollView.contentOffset.x;
}

//随着contentOffset.x更新currentIndex,同时参照的currentIndexOffset加相对应的页*PAGEWIDTH
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    if(x>=_currentIndexOffset+PAGEWIDTH){
        NSInteger n = (x-_currentIndexOffset)/PAGEWIDTH;
        _currentIndex = safeIndex(_totalCount, _currentIndex+(int)n);
        [self loadData];
        _currentIndexOffset += n*PAGEWIDTH;
    }
    else if(x<=_currentIndexOffset-PAGEWIDTH){
        NSInteger n = (_currentIndexOffset-x)/PAGEWIDTH;
        _currentIndex = safeIndex(_totalCount, _currentIndex-(int)n);
        [self loadData];
        _currentIndexOffset -= n*PAGEWIDTH;
    }
}

//设定期望停靠contentOffset,判断靠左或右
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint offset = *targetContentOffset;
    NSInteger centerPos = MAXCOUNT/2;
    offset.x = offset.x - _currentIndexOffset + PAGEWIDTH*centerPos;
    NSInteger index = offset.x / PAGEWIDTH;
#define NearToRight (fabs(velocity.x)<0.1 && offset.x > PAGEWIDTH * index+PAGEWIDTH/8)
#define NearToLeft (fabs(velocity.x)<0.1 && offset.x < PAGEWIDTH * index-PAGEWIDTH/8)
    if(_oldOffset<scrollView.contentOffset.x && (velocity.x >0 || NearToRight)) index += 1;
    else if(_oldOffset>scrollView.contentOffset.x && (velocity.x <0 || NearToLeft)) index -= 1;

    targetContentOffset->x = index*PAGEWIDTH + _currentIndexOffset - PAGEWIDTH *centerPos;
}

//停止滑动时重设ContentOffset
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentIndexOffset = MAXOFFSET;
    [_contentScrollView setContentOffset:CGPointMake(_currentIndexOffset, 0) animated:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
