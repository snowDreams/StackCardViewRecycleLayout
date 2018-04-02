//
//  ViewController.m
//  StackCardViewRecycleLayout
//
//  Created by fen on 2018/3/27.
//  Copyright © 2018年 testDefaultImage. All rights reserved.
//

#import "ViewController.h"
#import "Scrollerview.h"

@interface ViewController ()
@property(nonatomic,strong) Scrollerview *scrollview;
@property(nonatomic,strong) NSMutableArray *cardImageViews;
@property(nonatomic,strong) NSArray *imagesArray;
@property(nonatomic,assign) NSInteger imagesTotalCount;
@property(nonatomic,assign) NSInteger cardViewMixCount;
@end


#define cardContentViewCount 7 //显示循环用的view个数


@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _imagesArray = @[@{@"title":@"1",@"img":@"1.jpg"},@{@"title":@"2",@"img":@"2.jpg"},@{@"title":@"3",@"img":@"3.jpg"},@{@"title":@"4",@"img":@"4.jpg"},@{@"title":@"5",@"img":@"5.jpg"},@{@"title":@"6",@"img":@"6.jpg"},@{@"title":@"7",@"img":@"7.jpg"},@{@"title":@"8",@"img":@"8.jpg"}];
    _imagesTotalCount = [_imagesArray count];
    _scrollview = [[Scrollerview alloc] initWithFrame:CGRectMake(13, 200, 375-13, CardH)];
    _scrollview.dataSourceDelegate = self;
    [self.view addSubview:_scrollview];

    _cardImageViews = [NSMutableArray new];

    NSInteger cardViewMixCount = _imagesTotalCount<cardContentViewCount?((cardContentViewCount/_imagesTotalCount+1)*_imagesTotalCount):_imagesTotalCount;
    [_scrollview  setCount:cardViewMixCount withCurrentIndex:0];
}


-(UIImageView *)imageViewAtIndex:(NSUInteger)index{
    UIImageView *view;
    while(_cardImageViews.count <= index){
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CardW, CardH)];
        view.userInteractionEnabled = YES;
        [_cardImageViews addObject:view];
    }
    return _cardImageViews[index];
}

static NSInteger safeIndexValue(NSInteger totalCount,NSInteger index){
    if(totalCount <= 0) return 0;
    if(index<0){
        index = index %totalCount;
        if(index<0)
            index= (totalCount+index);
    }
    else if(index>=totalCount)
            index = (index%totalCount);
    return index;
}

-(UIView *)imageViewAtIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex{
    UIImageView *imageView = [self imageViewAtIndex:index];
    index = safeIndexValue(_imagesTotalCount, index);
    [imageView setImage:[UIImage imageNamed:(NSString *)[_imagesArray[index] objectForKey:@"img"]]];
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
