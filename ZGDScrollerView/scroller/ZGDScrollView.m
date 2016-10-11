//
//  ZGDScrollView.m
//  双图轮播
//
//  Created by 赵国栋 on 16/10/10.
//  Copyright © 2016年 赵国栋. All rights reserved.
//

#import "ZGDScrollView.h"
#import "myCollectionViewCell.h"
#import <UIImageView+WebCache.h>
static NSInteger const scetionCount = 100;
static NSInteger rowCount = 0;
static NSInteger seccount = scetionCount/2;

@interface ZGDScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,copy)NSArray *picAry;

@property(nonatomic,strong)UICollectionView *collection;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,copy)ActionBack actionBack;

@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,assign)BOOL isWeb;
@end
@implementation ZGDScrollView

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        flow.minimumLineSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collection = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flow];
        [_collection registerNib:[UINib nibWithNibName:@"myCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myCollectionViewCell"];
        _collection.pagingEnabled = YES;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.delegate = self;
        _collection.dataSource = self;
    }
    
    return _collection;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.height-30, 100, 40)];
        _pageControl.numberOfPages = self.picAry.count;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventValueChanged];
        
    }
    return _pageControl;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (instancetype)initWithFrame:(CGRect)frame picArray:(NSArray *)array block:(ActionBack)block isweb:(BOOL)isweb
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isWeb = isweb;
        self.actionBack = block;
        self.picAry = array;
      
        [self addSubview:self.collection];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picAry.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return scetionCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    myCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCell" forIndexPath:indexPath];
    if (self.isWeb) {
        [cell.imagae sd_setImageWithURL:self.picAry[indexPath.row]];
    }else{
    cell.imagae.image = self.picAry[indexPath.row];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.actionBack) {
        self.actionBack(indexPath.row);
    }
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self insertSubview:self.pageControl atIndex:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.timer fire];
    });
    
   [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:scetionCount/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}


- (void)nextPage{
        rowCount++;
    if (rowCount==self.picAry.count) {
        rowCount=0;
        seccount++;
    }
    if (seccount==scetionCount-1) {
        seccount=scetionCount/2;
    }
    
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:rowCount inSection:seccount] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{
    [self.timer invalidate];
    self.timer=nil;
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width) % self.picAry.count;
}
- (void)pageAction{
    
    
}

@end
