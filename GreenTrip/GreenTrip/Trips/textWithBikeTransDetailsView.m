//
//  textWithBikeTransDetailsView.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/3/2.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "textWithBikeTransDetailsView.h"

@implementation textWithBikeTransDetailsView

@synthesize dragEnable,busRoute,bikeRoute,walkingRoute,startName,endName,allRoutesDictionary,busName,startBikeStopName,endBikeStopName,flag;

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
    if (current.y < initPoint.y && current.y > self.superview.center.y) {
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
            self.center = CGPointMake(self.center.x, self.superview.center.y);
            
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
            self.center = CGPointMake(self.center.x, self.superview.center.y);
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
    
    strategyArray   = [[NSMutableArray alloc] init];
    strDetailsArray = [[NSMutableArray alloc] init];
    stopArray       = [[NSMutableArray alloc] init];
    detailWaysArray = [[NSMutableArray alloc] init];
    flagArray       = [[NSMutableArray alloc] init];
    
    bikeSteps = [[NSArray alloc] init];
    
    
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
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, 320, 20)];
    //detailsLabel.text = @"test";
    detailsLabel.text = [NSString stringWithFormat:@"共%@ | 步行%@ | 骑行%@ | 约%@",
                          [self distanceFormatted:totalDistance],
                          [self distanceFormatted:totalWalkingDistance],
                          [self distanceFormatted:totalBikeDistance],
                          [self timeFormatted:totalDuration]];;

    detailsLabel.textColor = [UIColor grayColor];
    detailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:10.0f];
    [briefView addSubview:detailsLabel];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 84, [self superview].bounds.size.width, 2)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:line];
    
    listTableView = [[ExtensibleTableView alloc] initWithFrame:CGRectMake(0, 95, [self superview].bounds.size.width, [self superview].bounds.size.height - 99)];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.showsHorizontalScrollIndicator = NO;
    listTableView.showsVerticalScrollIndicator   = NO;
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.delegate_extend = self;

    [self addSubview:listTableView];
    
}

#pragma mark - UITableView Source Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //原先这里是stopArray，修改过
    return [flagArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //若当前行被选中，则返回展开的cell
    if([listTableView isEqualToSelectedIndexPath:indexPath])
    {
        return [self tableView:tableView extendedCellForRowAtIndexPath:indexPath];
    }
    
    //当前行数
    NSUInteger row=[indexPath row];
    
    //NSMutableDictionary *user = [dataList_ objectAtIndex:row];
    //每个cell的标识
    NSString *CellTableIdentifier=[[NSString alloc]initWithFormat:@"cell%lu",(unsigned long)row];
    //获得cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    
    //未展开的cell，只显示名字
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"] || [[flagArray objectAtIndex:row] isEqualToString:@"1"]) {            //步行
        //创建步行公共cell
        [self creatWalkingCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        [cell addSubview:megeImg];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 88 - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:line2];
        
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"2"]) {    //公交
        //创建公交公共cell
        [self creatBuslineCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        [cell addSubview:megeImg];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 102 - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [cell addSubview:line2];
        
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"3"]) {   //自行车
        [self creatBikeCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        [cell addSubview:megeImg];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 88 - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:line2];
    }
    else {                                                              //终点
        //创建额外的CellView
        [self createxCell:cell inTheRow:row];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - ExtensibleTableViewDelegate
//返回展开之后的cell
- (UITableViewCell *)tableView:(UITableView *)tableView extendedCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //当前行数
    NSUInteger row=[indexPath row];
    
    //NSMutableDictionary *user = [dataList_ objectAtIndex:row];
    //每个cell的标识
    NSString *CellTableIdentifier=[[NSString alloc]initWithFormat:@"extentedCell%lu",(unsigned long)row];
    //获得cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"] || [[flagArray objectAtIndex:row] isEqualToString:@"1"]) {            //步行
        //创建步行公共cell
        [self creatWalkingCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        megeImg.transform = CGAffineTransformMakeRotation(M_PI);
        [cell addSubview:megeImg];
        
        //添加具体的路段信息(步行)
        NSArray *stepsArray = [[NSArray alloc] init];
        stepsArray = [detailWaysArray objectAtIndex:row];
        UIButton *detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 95, [self superview].bounds.size.width, 20 * stepsArray.count)];
        //detailsButton.backgroundColor = [UIColor redColor];
        [detailsButton addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchUpInside];
        detailsButton.tag = row;
        [cell addSubview:detailsButton];
        
        for (int i = 0; i < stepsArray.count; i ++) {
            AMapStep *s = (AMapStep *)stepsArray[i];
            UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0 + 20 * i, 200, 12)];
            detailsLabel.text = s.instruction;
            detailsLabel.textColor = [UIColor blackColor];
            detailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
            [detailsButton addSubview:detailsLabel];
            
            /*
             UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0 + 20 * i, 2, 20)];
             lineView.backgroundColor = [UIColor lightGrayColor];
             [detailsButton addSubview:lineView];
             */
            
            UIView *litteIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 0 + 20 * i, 14, 20)];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 6, 6)];
            imgV.image = [UIImage imageNamed:@"10x10"];
            [litteIconView addSubview:imgV];
            [detailsButton addSubview:litteIconView];
        }
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 95 + 20 * stepsArray.count - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:line2];
        
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"2"]) {    //公交
        //创建公交公共cell
        [self creatBuslineCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        megeImg.transform = CGAffineTransformMakeRotation(M_PI);
        [cell addSubview:megeImg];
        
        NSArray *stopsArray = [[NSArray alloc] init];
        stopsArray = [detailWaysArray objectAtIndex:row];
        UIButton *detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, [self superview].bounds.size.width, 20 * stopsArray.count)];
        detailsButton.tag = row;
        [cell addSubview:detailsButton];
        
        for (int i = 0; i < stopsArray.count; i++) {
            AMapBusStop *bs = (AMapBusStop *)stopsArray[i];
            UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0 + 20 * i, 200, 12)];
            detailsLabel.text = bs.name;
            detailsLabel.textColor = [UIColor blackColor];
            detailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
            [detailsButton addSubview:detailsLabel];
            
            /*
             UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0 + 20 * i, 2, 20)];
             lineView.backgroundColor = myColor;
             [detailsButton addSubview:lineView];
             */
            UIView *litteIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 0 + 20 * i, 14, 20)];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 6, 6)];
            imgV.image = [UIImage imageNamed:@"10x10"];
            [litteIconView addSubview:imgV];
            [detailsButton addSubview:litteIconView];
        }
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 110 + 20 * stopsArray.count - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [cell addSubview:line2];
        
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"3"]) {   //自行车
        [self creatBikeCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        megeImg.transform = CGAffineTransformMakeRotation(M_PI);
        [cell addSubview:megeImg];
        
        //添加具体的路段信息(步行)
        NSArray *stepsArray = [[NSArray alloc] init];
        stepsArray = [detailWaysArray objectAtIndex:row];
        UIButton *detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 95, [self superview].bounds.size.width, 20 * stepsArray.count)];
        //detailsButton.backgroundColor = [UIColor redColor];
        [detailsButton addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchUpInside];
        detailsButton.tag = row;
        [cell addSubview:detailsButton];
        
        for (int i = 0; i < stepsArray.count; i ++) {
            AMapStep *s = (AMapStep *)stepsArray[i];
            UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0 + 20 * i, 200, 12)];
            detailsLabel.text = s.instruction;
            detailsLabel.textColor = [UIColor blackColor];
            detailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
            [detailsButton addSubview:detailsLabel];

            UIView *litteIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 0 + 20 * i, 14, 20)];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 6, 6)];
            imgV.image = [UIImage imageNamed:@"10x10"];
            [litteIconView addSubview:imgV];
            [detailsButton addSubview:litteIconView];
        }
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 95 + 20 * stepsArray.count - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:line2];
        
    } else {                                                               //终点
        //创建额外的CellView
        [self createxCell:cell inTheRow:row];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//返回展开之后的cell的高度
- (CGFloat)tableView:(UITableView *)tableView extendedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *detailsArray = [[NSArray alloc] init];
    detailsArray = [detailWaysArray objectAtIndex:row];
    
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"] || [[flagArray objectAtIndex:row] isEqualToString:@"1"]) {            //步行
        return 90 + 20 * detailsArray.count;
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"2"]) {    //公交
        return 105 + 20 * detailsArray.count;
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"3"]) {    //自行车
        return 90 + 20 * detailsArray.count;
    } else {                                                              //终点
        return 105;
    }
}

#pragma mark -
#pragma mark table view delegate methods
//起始cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([listTableView isEqualToSelectedIndexPath:indexPath])
    {
        return [self tableView:tableView extendedHeightForRowAtIndexPath:indexPath];
    }
    
    NSInteger row = indexPath.row;
    
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"] || [[flagArray objectAtIndex:row] isEqualToString:@"1"]) {            //步行
        return 90;
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"2"]) {    //公交
        return 105;
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"3"]){     //自行车
        return 90;
    } else {                                                   //终点
        return 115;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([listTableView isEqualToSelectedIndexPath:indexPath]) {
        [listTableView shrinkCellWithAnimated:YES];
    } else {
        [listTableView extendCellAtIndexPath:indexPath animated:YES goToTop:NO];
    }
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

    [stopArray addObject:startName];
    //NSMutableDictionary遍历
    NSEnumerator *enumerator = [allRoutesDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        AMapRoute *route = [allRoutesDictionary objectForKey:key];
        
        if ([key isEqualToString:@"walking"]) {
            NSInteger walkingDis = 0;
            for (AMapPath *p in route.paths) {
                walkingDis += p.distance;
                totalDistance += p.distance;
                totalWalkingDistance += p.distance;
                totalDuration += p.duration;
            }
            
            //处理paths
            NSMutableArray *temArray = [[NSMutableArray alloc] init];
            for(AMapPath *p in route.paths) {
                for (AMapStep *s in p.steps) {
                    [temArray addObject:s];
                }
            }
            NSArray *walkArray = [[NSArray alloc] init];
            walkArray = [temArray copy];
            
            [strategyArray addObject:[NSString stringWithFormat:@"步行%@",[self distanceFormatted:walkingDis]]];
            [detailWaysArray addObject:walkArray];     //统一储存steps
            [strDetailsArray addObject:@""];
            [flagArray addObject:@"0"];              //0表示纯粹步行
        } else if ([key isEqualToString:@"bike"]) {
            NSInteger bikeDis = 0;
            for (AMapPath *p in route.paths) {
                bikeDis += p.distance;
                totalDistance += p.distance;
                totalBikeDistance += p.distance;
                totalDuration += p.duration / 2.5 ;    //自行车的速度接近步行的2.5倍
            }
            
            //处理paths
            NSMutableArray *temArray = [[NSMutableArray alloc] init];
            for(AMapPath *p in route.paths) {
                for (AMapStep *s in p.steps) {
                    [temArray addObject:s];
                }
            }

            bikeSteps = [temArray copy];
            
            bikeStr = [NSString stringWithFormat:@"骑行%@",[self distanceFormatted:bikeDis]];
            //bikePaths = route.paths;
            //[stopArray addObject:startBikeStopName];
            //[stopArray addObject:endBikeStopName];
            
        } else {
            AMapTransit *transit = route.transits[0];
            totalDuration += transit.duration;
            totalWalkingDistance += transit.walkingDistance;
            totalDistance += transit.walkingDistance;
            for (AMapSegment *s in transit.segments) {
                if (s.walking != nil) {
                    [strategyArray addObject:[NSString stringWithFormat:@"步行%@",[self distanceFormatted:s.walking.distance]]];
                    [detailWaysArray addObject:s.walking.steps];
                    [strDetailsArray addObject:@""];
                    [flagArray addObject:@"1"];  //1表示公交中的步行
                }
                
                if (s.busline != nil) {
                    totalDistance += s.busline.distance;
                    
                    [stopArray addObject:s.busline.departureStop.name];
                    [stopArray addObject:s.busline.arrivalStop.name];
                    
                    [strategyArray addObject:[NSString stringWithFormat:@"乘坐%@",[self busNameTrans:s.busline.name]]];
                    
                    [detailWaysArray addObject:s.busline.busStops];
                    [strDetailsArray addObject:[NSString stringWithFormat:@"%@方向 | %ld站",[self getBusDirection:s.busline.name],(long)s.busline.busStopsNum]];
                    [flagArray addObject:@"2"];      //2表示公交
                }
            }
        }
    }
    
    if (flag == 1) {
        [stopArray insertObject:endBikeStopName atIndex:1];
        [stopArray insertObject:startBikeStopName atIndex:1];
        
        [strategyArray insertObject:bikeStr atIndex:1];
        [detailWaysArray insertObject:bikeSteps atIndex:1];
        [strDetailsArray insertObject:@"" atIndex:1];
        [flagArray insertObject:@"3" atIndex:1];                    //3表示骑自行车
        
    } else {
        [stopArray addObject:startBikeStopName];
        [stopArray addObject:endBikeStopName];
        
        [strategyArray addObject:bikeStr];
        [detailWaysArray addObject:bikeSteps];
        [strDetailsArray addObject:@""];
        [flagArray addObject:@"3"];                                //3表示骑自行车
    }
    
    if (![endName isEqualToString:@""]) {
        [stopArray addObject: endName];
        [strategyArray addObject:@""];
        [detailWaysArray addObject:@""];
        [strDetailsArray addObject:@""];
        [flagArray addObject:@"4"];      //4标记为终点
    } else {
        [stopArray addObject:@" "];
        [strategyArray addObject:@""];
        [detailWaysArray addObject:@""];
        [strDetailsArray addObject:@""];
        [flagArray addObject:@"4"];      //4标记为终点
    }
    
    /*
    for (int i = 0; i < stopArray.count; i++) {
        NSLog(@"stop = %@; strategy = %@; detailWays = %@; strDetail = %@; flag = %@.",stopArray[i],strategyArray[i],detailWaysArray[i],strDetailsArray[i],flagArray[i]);
    }
    */
    
    //NSLog(@"stopArray = %@",stopArray);
    //NSLog(@"strategy = %@",strategyArray);
}

//构建步行cell
- (void)creatWalkingCell:(UITableViewCell *)cell inTheRow:(NSInteger)row
{
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 0, [self superview].bounds.size.width - 52, 30)];
    //titleButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    titleLabel.text = [stopArray objectAtIndex:row];
    //titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleButton addSubview:titleLabel];
    [cell addSubview:titleButton];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 13, 13)];
    iconImageView.image = [UIImage imageNamed:@"50x50"];
    [cell addSubview:iconImageView];
    
    UILabel *strategyLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 50, 200, 30)];
    strategyLabel.text = [strategyArray objectAtIndex:row];
    strategyLabel.font = [UIFont systemFontOfSize:15.0f];
    strategyLabel.textColor = [UIColor grayColor];
    [cell addSubview:strategyLabel];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 55, 12, 21)];
    iconImg.image = [UIImage imageNamed:@"48x84"];
    [cell addSubview:iconImg];
    
    UIView *litteIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - 20, 14, 20)];
    //litteIconView.backgroundColor = myColor;
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
    imgV1.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
    imgV2.image = [UIImage imageNamed:@"10x10"];
    [litteIconView addSubview:imgV1];
    [litteIconView addSubview:imgV2];
    [cell addSubview:litteIconView];
    
    UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 55 + 21, 14, 20)];
    //litteIconView2.backgroundColor = myColor;
    UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
    imgV3.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
    imgV4.image = [UIImage imageNamed:@"10x10"];
    [litteIconView2 addSubview:imgV3];
    [litteIconView2 addSubview:imgV4];
    [cell addSubview:litteIconView2];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(52, cell.bounds.size.height - 2, [self superview].bounds.size.width - 52 - 30, 2)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line];
    
    if (row != 0) {
        UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 14, 20)];
        //litteIconView2.backgroundColor = myColor;
        UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
        imgV3.image = [UIImage imageNamed:@"10x10"];
        UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
        imgV4.image = [UIImage imageNamed:@"10x10"];
        [litteIconView2 addSubview:imgV3];
        [litteIconView2 addSubview:imgV4];
        [cell addSubview:litteIconView2];
    }
}

//构建公交车的cell
- (void)creatBuslineCell:(UITableViewCell *)cell inTheRow:(NSInteger)row
{
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 0, [self superview].bounds.size.width - 52, 30)];
    //titleButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    titleLabel.text = [stopArray objectAtIndex:row];
    //titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleButton addSubview:titleLabel];
    [cell addSubview:titleButton];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 13, 13)];
    iconImageView.image = [UIImage imageNamed:@"50x50"];
    [cell addSubview:iconImageView];
    
    /*
     UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 30, 2, 95 - 30)];
     lineView.backgroundColor = myColor;
     [cell addSubview:lineView];
     */
    
    UILabel *strategyLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 50, 200, 30)];
    strategyLabel.text = [strategyArray objectAtIndex:row];
    strategyLabel.font = [UIFont systemFontOfSize:15.0f];
    strategyLabel.textColor = iosBlue;
    [cell addSubview:strategyLabel];
    
    UILabel *strDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 82, 200, 12)];
    strDetailsLabel.text = [strDetailsArray objectAtIndex:row];
    strDetailsLabel.textColor = [UIColor lightGrayColor];
    strDetailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
    [cell addSubview:strDetailsLabel];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 55, 17, 21)];
    iconImg.image = [UIImage imageNamed:@"68x84"];
    [cell addSubview:iconImg];
    
    UIView *litteIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - 20, 14, 20)];
    //litteIconView.backgroundColor = myColor;
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
    imgV1.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
    imgV2.image = [UIImage imageNamed:@"10x10"];
    [litteIconView addSubview:imgV1];
    [litteIconView addSubview:imgV2];
    [cell addSubview:litteIconView];
    
    UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 55 + 21, 14, 40)];
    //litteIconView2.backgroundColor = myColor;
    UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
    imgV3.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
    imgV4.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV5 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 19, 3, 3)];
    imgV5.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV6 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 26, 3, 3)];
    imgV6.image = [UIImage imageNamed:@"10x10"];
    [litteIconView2 addSubview:imgV3];
    [litteIconView2 addSubview:imgV4];
    [litteIconView2 addSubview:imgV5];
    [litteIconView2 addSubview:imgV6];
    [cell addSubview:litteIconView2];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(52, cell.bounds.size.height - 2, [self superview].bounds.size.width - 52 - 30, 2)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line];
    
    if (row != 0) {
        UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 14, 20)];
        //litteIconView2.backgroundColor = myColor;
        UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
        imgV3.image = [UIImage imageNamed:@"10x10"];
        UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
        imgV4.image = [UIImage imageNamed:@"10x10"];
        [litteIconView2 addSubview:imgV3];
        [litteIconView2 addSubview:imgV4];
        [cell addSubview:litteIconView2];
    }

}

//构建额外ViewCell
- (void)createxCell:(UITableViewCell *)cell inTheRow:(NSInteger)row
{
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 0, [self superview].bounds.size.width - 52, 30)];
    //titleButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    titleLabel.text = [stopArray objectAtIndex:row];
    //titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleButton addSubview:titleLabel];
    [cell addSubview:titleButton];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 13, 13)];
    iconImageView.image = [UIImage imageNamed:@"50x50"];
    [cell addSubview:iconImageView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 2, [self superview].bounds.size.width, 2)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line];
    
    UIView *exView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [self superview].bounds.size.width, 80)];
    exView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:exView];
    
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ([self superview].bounds.size.width - 10 * 2) / 2, 40)];
    collectButton.backgroundColor = myColor;
    [collectButton setTitle:@" 收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"五角星56x56"] forState:UIControlStateNormal];
    [exView addSubview:collectButton];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + ([self superview].bounds.size.width - 10 * 2) / 2, 10, ([self superview].bounds.size.width - 10 * 2) / 2, 40)];
    shareButton.backgroundColor = [UIColor whiteColor];
    [shareButton setTitle:@" 分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"分享48x52"] forState:UIControlStateNormal];
    [exView addSubview:shareButton];
    
    if (row != 0) {
        UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 14, 20)];
        //litteIconView2.backgroundColor = myColor;
        UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
        imgV3.image = [UIImage imageNamed:@"10x10"];
        UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
        imgV4.image = [UIImage imageNamed:@"10x10"];
        [litteIconView2 addSubview:imgV3];
        [litteIconView2 addSubview:imgV4];
        [cell addSubview:litteIconView2];
    }
}

//构建自行车的cell
- (void)creatBikeCell:(UITableViewCell *)cell inTheRow:(NSInteger)row
{
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 0, [self superview].bounds.size.width - 52, 30)];
    //titleButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    titleLabel.text = [stopArray objectAtIndex:row];
    //titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleButton addSubview:titleLabel];
    [cell addSubview:titleButton];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 13, 13)];
    iconImageView.image = [UIImage imageNamed:@"50x50"];
    [cell addSubview:iconImageView];
    
    UILabel *strategyLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 50, 200, 30)];
    strategyLabel.text = [strategyArray objectAtIndex:row];
    strategyLabel.font = [UIFont systemFontOfSize:15.0f];
    strategyLabel.textColor = myColor;
    [cell addSubview:strategyLabel];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 55, 12, 21)];
    iconImg.image = [UIImage imageNamed:@"bikeIcon"];
    [cell addSubview:iconImg];
    
    UIView *litteIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 55 - 20, 14, 20)];
    //litteIconView.backgroundColor = myColor;
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
    imgV1.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
    imgV2.image = [UIImage imageNamed:@"10x10"];
    [litteIconView addSubview:imgV1];
    [litteIconView addSubview:imgV2];
    [cell addSubview:litteIconView];
    
    UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 55 + 21, 14, 20)];
    //litteIconView2.backgroundColor = myColor;
    UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
    imgV3.image = [UIImage imageNamed:@"10x10"];
    UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
    imgV4.image = [UIImage imageNamed:@"10x10"];
    [litteIconView2 addSubview:imgV3];
    [litteIconView2 addSubview:imgV4];
    [cell addSubview:litteIconView2];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(52, cell.bounds.size.height - 2, [self superview].bounds.size.width - 52 - 30, 2)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line];
    
    if (row != 0) {
        UIView *litteIconView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 14, 20)];
        //litteIconView2.backgroundColor = myColor;
        UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 3, 3)];
        imgV3.image = [UIImage imageNamed:@"10x10"];
        UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 3, 3)];
        imgV4.image = [UIImage imageNamed:@"10x10"];
        [litteIconView2 addSubview:imgV3];
        [litteIconView2 addSubview:imgV4];
        [cell addSubview:litteIconView2];
    }
}

- (void)showOnMap:(UIButton *)sender
{
    NSLog(@"未实现");
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

//截取字符
- (NSString *)getBusDirection:(NSString *)getbusName
{
    NSRange range1 = [getbusName rangeOfString:@"("];
    NSString *result = [getbusName substringFromIndex:range1.location+1];
    NSRange range2 = [result rangeOfString:@")"];
    NSString *result2 = [result substringToIndex:range2.location];
    return result2;
}

//线路名称处理函数
- (NSString *)busNameTrans:(NSString *)originName
{
    NSRange subRange = [originName rangeOfString:@"("];
    if (subRange.length == 0 && subRange.location == 0) {
        return originName;
    } else {
        return [originName substringToIndex:subRange.location];
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
