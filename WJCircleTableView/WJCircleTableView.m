//
//  WJCircleTableView.m
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJCircleTableView.h"
#import "WJCircleTableViewInterceptor.h"
#import "WJCircleTabCell.h"

#define HORIZONTAL_RADIUS_RATIO 0.8
#define VERTICAL_RADIUS_RATIO 1.2
#define CIRCLE_DIRECTION_RIGHT 0

#define MORPHED_INDEX_PATH( __INDEXPATH__ ) [self morphedIndexPathForIndexPath:__INDEXPATH__  totalRows:_totalRows]

@interface WJCircleTableView ()

@property (nonatomic,assign) NSInteger totalCellsVisible;
@property (nonatomic,strong) WJCircleTableViewInterceptor *dataSourceInterceptor;
@property (nonatomic,assign) NSInteger totalRows;

@end

@implementation WJCircleTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if( self )
    {
        [self customIntitialization];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self customIntitialization];
        self.rowHeight = 100;
    }
    return self;
}

- (void)customIntitialization
{
    self.backgroundColor = [UIColor whiteColor];
    //方向
    _contentAlignment = WJCircleTableViewContentAlignmentRight;
    //是否允许循环滚动
    self.enableInfiniteScrolling = YES;
    //默认横向距离
    self.horizontalRadiusCorrection=1.0;
}

#pragma mark Layout

- (void)layoutSubviews
{
    _totalCellsVisible = self.frame.size.height / self.rowHeight;
    //重制内容，开启无限滚动用的
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
    
//    开启转盘模式
    [self setupShapeFormationInVisibleCells];
}

#pragma mark - setter
- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if( !_dataSourceInterceptor)
    {
        _dataSourceInterceptor = [[WJCircleTableViewInterceptor alloc] init];
    }
    
    _dataSourceInterceptor.receiver = dataSource;
    _dataSourceInterceptor.middleMan = self;
    
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    _totalRows = [_dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section  ];
    //复制3分数据用来无限循环
    return _totalRows *(self.enableInfiniteScrolling ? 3 : 1 );
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:MORPHED_INDEX_PATH(indexPath)];
}

#pragma mark Private methods
- (CGFloat)getAngleForYOffset:(CGFloat)yOffset
{
    //normalise into 0 ...... rowheight
    //所有高度相同的情况下
    CGFloat shift = ((int)self.contentOffset.y % (int)self.rowHeight);
    CGFloat percentage = shift / self.rowHeight ;
    
    CGFloat angle_gap = M_PI/(_totalCellsVisible+1);
    
    int rows = 0;
    if( yOffset < 0.0 )
    {
        rows = fabs(yOffset) / self.rowHeight;
    }
    
    return fabs(angle_gap * (1.0f -percentage)) + rows * angle_gap;
}

- (NSIndexPath*)morphedIndexPathForIndexPath:(NSIndexPath*)oldIndexPath totalRows:(NSInteger)totalRows
{
    return self.enableInfiniteScrolling ? [NSIndexPath indexPathForRow:oldIndexPath.row % totalRows inSection:oldIndexPath.section] : oldIndexPath;
}

//开启无限循环（原理，重制滚动坐标，因为改了这个数据源也要相应的改变）
- (void)resetContentOffsetIfNeeded
{
    //是否开启无限循环
    if( !self.enableInfiniteScrolling )
        return;
    
    NSArray *indexpaths = [self indexPathsForVisibleRows];
    NSInteger totalVisibleCells =[indexpaths count];
    if( _totalCellsVisible > totalVisibleCells )
    {
        //we dont have enough content to generate scroll
        return;
    }
    CGPoint contentOffset  = self.contentOffset;
    
    //check the top condition
    //check if the scroll view reached its top.. if so.. move it to center.. remember center is the start of the data repeating for 2nd time.
    //往上滑的时候，移动到1/3内容处
    if( contentOffset.y<=0.0)
    {
        contentOffset.y = self.contentSize.height/3.0f;
    }
    //快要到底的时候移动到最前的位置
    else if( contentOffset.y >= ( self.contentSize.height - self.bounds.size.height) )//scrollview content offset reached bottom minus the height of the tableview
    {
        //this scenario is same as the data repeating for 2nd time minus the height of the table view
        contentOffset.y = self.contentSize.height/3.0f- self.bounds.size.height;
    }
    [self setContentOffset: contentOffset];
}

- (void)setupShapeFormationInVisibleCells
{
    //获取所有可见的cell下标
    NSArray *indexpaths = [self indexPathsForVisibleRows];
    NSUInteger totalVisibleCells =[indexpaths count];
    
    CGFloat angle_gap = M_PI/(_totalCellsVisible+1); // find the angle difference after dividing the table into totalVisibleCells +1
    
    //减去2个行高得到中心区域的一半
    
    //(self.frame.size.height - self.rowHeight*2.0f)/2.0f
    CGFloat vRadius = (self.frame.size.height - self.rowHeight*2.0f)/2.0f;
    //宽度的一半
    CGFloat hRadius = (self.frame.size.width )/2.0f;
    //那个小就用哪个
    CGFloat radius = (vRadius <  hRadius) ? vRadius : hRadius;
    
    CGFloat xRadius = radius;
    
    //初始cell的偏移
    CGFloat firstCellAngle = [self getAngleForYOffset:self.contentOffset.y];
    
    for( NSUInteger index =0; index < totalVisibleCells; index++ )
    {
        //得到对应的cell
        WJCircleTabCell *cell = (WJCircleTabCell*)[self cellForRowAtIndexPath:[ indexpaths objectAtIndex:index]];
        //得到cell的frame
        CGRect frame = cell.frame;

        //We can find the x Point by finding the Angle from the Ellipse Equation of finding y
//        i.e. Y= vertical_radius * sin(t )
//         t= asin(Y / vertical_radius) or asin = sin inverse
//        CGFloat angle = (index +1)*angle_gap -( ( percentage_visible) * angle_gap);
        
        //变更角度
        CGFloat angle = firstCellAngle;
        NSLog(@"angle = %f",angle);
        firstCellAngle+= angle_gap;
        if( _contentAlignment == WJCircleTableViewContentAlignmentLeft )
        {
            angle =  angle + M_PI_2;
        }
        else {
            angle -= M_PI_2;
        }
        
        //Apply Angle in X point of Ellipse equation
        //i.e. X = horizontal_radius * cos( t )
        //here horizontal_radius would be some percentage off the vertical radius. percentage is defined by HORIZONTAL_RADIUS_RATIO
        //HORIZONTAL_RADIUS_RATIO of 1 is equal to circle
        
        //
        CGFloat x = xRadius  * cosf(angle );
        
        //Assuming, you have laid your tableview so that the entire frame is visible
        //TO DISPLAY RIGHT: then to display the circle towards right move the cellX (var x here) by half the width towards the right
        //TO DISPLAY LEFT : move the cellX by quarter the radius
        //FEEL FREE to play with x to allign the circle as per your needs
        
        
        if( _contentAlignment == WJCircleTableViewContentAlignmentLeft )
        {
            x = x + self.frame.size.width/2;// we have to shift the center of the circle toward the right
        }
        
        //算出x坐标改变位置，主要就是酸楚x位置进行改变
        frame.origin.x = x - 60;
        cell.deviation = x - 60;
        NSLog(@"x = %f",x);
        
        if( !isnan(x))
        {
//            frame.size.height = x/(self.frame.size.width/2) *60;
//            frame.size.height = x/100 * 100;
            cell.frame = frame;
//            cell.alpha = x/(self.frame.size.width/2);
        
        }
    }
}


@end
