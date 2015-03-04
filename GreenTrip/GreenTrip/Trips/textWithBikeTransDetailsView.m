//
//  textWithBikeTransDetailsView.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/2.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "textWithBikeTransDetailsView.h"

@implementation textWithBikeTransDetailsView

@synthesize dragEnable,busRoute,bikeRoute,walkingRoute,startName,endName,allRoutesDictionary,busName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        initPoint = self.center;                     //获取起始位置
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        //添加点击响应
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        
        //[self showOnTheView];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    //beginPoint = self.center;
    //NSLog(@"beginPoint = %f",beginPoint.y);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    //float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    //NSLog(@"%f",offsetY);
    if (offsetY < 0) {
        isUp = TRUE;
    } else {
        isUp = FALSE;
    }
    
    CGPoint current = CGPointMake(self.center.x, self.center.y + offsetY);
    
    //防止其他区域滑动
    if (current.y < initPoint.y && current.y > self.superview.center.y + 64 / 2) {
        self.center = CGPointMake(self.center.x, self.center.y + offsetY);
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    
    //NSLog(@"self.center.y = %f", self.center.y);
    //NSLog(@"currentPage = %ld", (long)currentPage);
    
    if (isUp == TRUE) {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, self.superview.center.y + 64 / 2);
            
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow_180"];
        
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, initPoint.y);
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow"];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    if (self.center.y == initPoint.y) {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, self.superview.center.y + 64 / 2);
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow_180"];
        
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, initPoint.y);
        }];
        
        arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow"];
    }
    
}


//实现手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    CGPoint point = [touch locationInView:self];
    
    // 判断是不是点击顶部的brief栏，如果不是,则tap手势不响应事件
    if ((point.y >= 0.0 && point.y <= 84.0)) {
        return YES;
    }
    //self.scrollEnabled = YES;
    return NO;
    
}

- (void)buildingView
{
    
    UIView * briefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self superview].bounds.size.width, 84)];
    briefView.backgroundColor = [UIColor clearColor];
    [self addSubview:briefView];
    
    //添加箭头
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.center.x - 8), 5, 16, 10)];
    arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow"];
    [briefView addSubview:arrowImageView];
    
    //NSLog(@"busname = %@",[NSString stringWithFormat:@"公共自行车 & %@",busName]);
    UILabel *busNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 20)];
    busNameLabel.text = [NSString stringWithFormat:@"公共自行车 & %@",busName];
    busNameLabel.font = [UIFont fontWithName:@"Heiti SC-Bold" size:14.0f];
    [briefView addSubview:busNameLabel];
    
    [self getRoutesDetails:allRoutesDictionary];
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42, 320, 20)];
    detailsLabel.text = [NSString stringWithFormat:@"共%@ | 步行%@ | 骑行%@ | 约%@",
                          [self distanceFormatted:totalDistance],
                          [self distanceFormatted:totalWalkingDistance],
                          [self distanceFormatted:totalBikeDistance],
                          [self timeFormatted:totalDuration]];;
    detailsLabel.textColor = [UIColor grayColor];
    detailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
    [briefView addSubview:detailsLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 84, [self superview].bounds.size.width - 10 * 2, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    /*
    
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, [self superview].bounds.size.width, [self superview].bounds.size.height - 159)];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.showsHorizontalScrollIndicator = NO;
    listTableView.showsVerticalScrollIndicator   = NO;
    listTableView.delegate = self;
     
     
     
    listTableView.dataSource = self;
    [self addSubview:listTableView];
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [stepArray count] - 1) {
        return 110;
    } else {
        return 50;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%ld",(long)transCount);
    return [stepArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //本函数用于显示每行的内容
    NSString *CellTableIdentifier=[[NSString alloc]initWithFormat:@"cell%lu",(unsigned long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (!cell)
    {
        // Use the default cell style.
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
        
        if (row == [stepArray count] - 1) {            //最后一个添加额外的收藏与分享按钮
            //NSLog(@"hello");
            UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, (50 - 14) / 2, [self superview].bounds.size.width, 14)];
            stepLabel.text = [stepArray objectAtIndex:row];
            stepLabel.textColor = [UIColor blackColor];
            stepLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, [self superview].bounds.size.width, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            
            [cell addSubview:line];
            [cell addSubview:stepLabel];
            
            UIView *exView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, [self superview].bounds.size.width, 60)];
            //exView.backgroundColor = [UIColor redColor];
            [cell addSubview:exView];
            
            UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, ([self superview].bounds.size.width - 10 * 2) / 2, 40)];
            [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
            [collectButton setTitleColor:iosBlue forState:UIControlStateNormal];
            collectButton.layer.borderWidth = 0.5;
            [exView addSubview:collectButton];
            
            UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0 + ([self superview].bounds.size.width - 10 * 2) / 2, 10, ([self superview].bounds.size.width - 10 * 2) / 2, 40)];
            [shareButton setTitle:@"分享" forState:UIControlStateNormal];
            [shareButton setTitleColor:iosBlue forState:UIControlStateNormal];
            shareButton.layer.borderWidth = 0.5;
            [exView addSubview:shareButton];
            
        } else {
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //UILabel重写会被覆盖，需要写在这个里面
            UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, (50 - 14) / 2, [self superview].bounds.size.width, 14)];
            stepLabel.text = [stepArray objectAtIndex:row];
            stepLabel.textColor = [UIColor blackColor];
            stepLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 49, [self superview].bounds.size.width - 50 - 20, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            
            [cell addSubview:line];
            [cell addSubview:stepLabel];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.center = CGPointMake(self.center.x, initPoint.y);
    }];
    
    arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow"];
    
    MAMapView *myMap = (MAMapView *)[self superview];
    AMapGeoPoint *origin = (AMapGeoPoint *)[originPonitArray objectAtIndex:row];
    //设置显示范围
    [myMap setRegion:MACoordinateRegionMake(CLLocationCoordinate2DMake(origin.latitude, origin.longitude), MACoordinateSpanMake(0.003f, 0.003f)) animated:YES];
    
}

- (void)processData:(AMapRoute *)route
{
    stepArray     = [[NSMutableArray alloc] init];
    originPonitArray = [[NSMutableArray alloc] init];
    
    [stepArray addObject:[NSString stringWithFormat:@"从 %@ 出发",startName]];
    [originPonitArray addObject:walkingRoute.origin];
    for (AMapPath *p in route.paths) {
        for (AMapStep *s in p.steps) {
            //NSLog(@"instruction = %@",s.instruction);
            [stepArray addObject:s.instruction];
            //NSLog(@"polyline = %@",s.polyline);
            [originPonitArray addObject:[self getAnnotationFromString:s.polyline][0]];
        }
    }
    
    [stepArray addObject:[NSString stringWithFormat:@"到达终点 %@",endName]];
    [originPonitArray addObject:walkingRoute.destination];
    
    //NSLog(@"stepArray = %@",stepArray);
}

- (void)getRoutesDetails:(NSMutableDictionary *)dic
{
    totalDistance = 0;
    totalWalkingDistance = 0;
    totalBikeDistance = 0;
    totalDuration = 0;

    //NSMutableDictionary遍历
    NSEnumerator *enumerator = [allRoutesDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        //NSLog(@"key = %@", key);
        //NSLog(@"value = %@", [allRoutesDictionary objectForKey:key]);
        AMapRoute *route = [allRoutesDictionary objectForKey:key];
        if ([key isEqualToString:@"walking"]) {
            for (AMapPath *p in route.paths) {
                totalDistance += p.distance;
                totalWalkingDistance += p.distance;
                totalDuration += p.duration;
            }
        } else if ([key isEqualToString:@"bike"]) {
            for (AMapPath *p in route.paths) {
                totalDistance += p.distance;
                totalBikeDistance += p.distance;
                totalDuration += p.duration / 2.5 ;    //自行车的速度接近步行的2.5倍
            }
        } else {
            AMapTransit *transit = route.transits[0];
            totalDuration += transit.duration;
            totalWalkingDistance += transit.walkingDistance;
            totalDistance += transit.walkingDistance;
            for (AMapSegment *s in transit.segments) {
                if (s.walking != nil) {
                    
                }
                
                if (s.busline != nil) {
                    totalDistance += s.busline.distance;
                }
            }
        }
        
    }
    
    //NSLog(@"totalDistance = %@",[self distanceFormatted:totalDistance]);
    //NSLog(@"totalWalkingDistance = %@",[self distanceFormatted:totalWalkingDistance]);
    //NSLog(@"totalBikeDistance = %@",[self distanceFormatted:totalBikeDistance]);
    
    //NSLog(@"totaltotalDuration = %@",[self timeFormatted:totalDuration]);
    /*
    for (AMapPath *p in walkingRoute.paths) {
        totalDistance += p.distance;
        totalDuration += p.duration;
    }
    */
}

//获得经纬度坐标
- (NSMutableArray *)getAnnotationFromString:(NSString *)polylineStr
{
    NSMutableArray *polylineArray = [[NSMutableArray alloc] init];
    
    NSArray *splitArray = [[NSArray alloc] init];
    splitArray = [polylineStr componentsSeparatedByString:@";"];
    
    for (NSString *s in splitArray) {
        NSArray *tmpSplitArray = [[NSArray alloc] init];
        tmpSplitArray = [s componentsSeparatedByString:@","];
        float latitude = [tmpSplitArray[1] floatValue];
        float longtitude = [tmpSplitArray[0] floatValue];
        
        AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
        point.latitude = latitude;
        point.longitude = longtitude;
        
        [polylineArray addObject:point];
    }
    
    return polylineArray;
}

//时间转换
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    //NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours < 1) {
        return [NSString stringWithFormat:@"%ld分钟", (long)minutes];
    } else {
        return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hours, (long)minutes];
    }
    
}

//路程转换
- (NSString *)distanceFormatted:(NSInteger)totalDis
{
    if (totalDis < 1000) {
        return [NSString stringWithFormat:@"%ld米",(long)totalDis];
    } else {
        return [NSString stringWithFormat:@"%.1f公里", (float)totalDis / 1000];
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
