//
//  textRoutesDetailsScrollView.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/1/29.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "textRoutesDetailsScrollView.h"

@implementation textRoutesDetailsScrollView
@synthesize dragEnable,index,allRoutes,buslineArray,totalDisArray,walkDisArray,durationArray,currentIndex,startName,endName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        initPoint = self.center;                     //获取起始位置
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //self.layer.shadowOffset = CGSizeMake(1, 1);
        //self.layer.shadowOpacity = 1;
        //self.layer.shadowColor = [UIColor blackColor].CGColor;
        
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
    self.scrollEnabled = YES;
    
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
    
    self.scrollEnabled = NO;
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
    self.scrollEnabled = YES;
    
    if (!dragEnable) {
        return;
    }

    //NSLog(@"self.center.y = %f", self.center.y);
    //NSLog(@"currentPage = %ld", (long)currentPage);
    
    if (isUp == TRUE) {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, self.superview.center.y);
            
        }];
        
        //箭头有问题！！
        UIImageView *currentIamgeView= [arrowImageViewArray objectAtIndex:currentIndex];
        currentIamgeView.image = [UIImage imageNamed:@"disclosure_arrow_180"];
        
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, initPoint.y);
        }];
        
        UIImageView *currentIamgeView = [arrowImageViewArray objectAtIndex:currentIndex];
        currentIamgeView.image = [UIImage imageNamed:@"disclosure_arrow"];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    if (self.center.y == initPoint.y) {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, self.superview.center.y);
        }];
        
        UIImageView *currentIamgeView = [arrowImageViewArray objectAtIndex:currentIndex];
        currentIamgeView.image = [UIImage imageNamed:@"disclosure_arrow_180"];
        
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            self.center = CGPointMake(self.center.x, initPoint.y);
        }];
        
        UIImageView *currentIamgeView = [arrowImageViewArray objectAtIndex:currentIndex];
        currentIamgeView.image = [UIImage imageNamed:@"disclosure_arrow"];
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
    busNameLabelArray = [[NSMutableArray alloc] init];
    detailsLabelArray = [[NSMutableArray alloc] init];
    arrowImageViewArray = [[NSMutableArray alloc] init];
    exTableViewArray = [[NSMutableArray alloc] init];
    UIView * briefView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, [self superview].bounds.size.width * allRoutes.transits.count + 2, 84)];
    briefView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:briefView];
    
    for (int i = 0; i < allRoutes.transits.count; i++) {
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.center.x - 8) + [self superview].bounds.size.width * i, 5, 16, 10)];
        arrowImageView.image = [UIImage imageNamed:@"disclosure_arrow"];
        [briefView addSubview:arrowImageView];
        
        UILabel *busNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + [self superview].bounds.size.width * i, 20, 200, 20)];
        busNameLabel.text = @"";
        busNameLabel.font = [UIFont fontWithName:@"Heiti SC-Bold" size:14.0f];
        [briefView addSubview:busNameLabel];
        
        UIButton *setoutchButton = [[UIButton alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 20 - 42 + [self superview].bounds.size.width * i, 19, 42, 50)];
        /*
        setoutchButton.backgroundColor = myColor;
        [setoutchButton setTitle:@"AR导航" forState:UIControlStateNormal];
        [setoutchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        */
        [setoutchButton setImage:[UIImage imageNamed:@"摄像头166x200"] forState:UIControlStateNormal];
        [setoutchButton addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [briefView addSubview:setoutchButton];
        
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + [self superview].bounds.size.width * i, 46, 200, 20)];
        detailsLabel.text = @"";
        detailsLabel.textColor = [UIColor grayColor];
        detailsLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
        [briefView addSubview:detailsLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width * i, 84, [self superview].bounds.size.width, 10)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        
        ExtensibleTableView *exTableView = [[ExtensibleTableView alloc] initWithFrame:CGRectMake(0 + [self superview].bounds.size.width * i, 105, [self superview].bounds.size.width, [self superview].bounds.size.height - 159)];   //159 = 64 + 95
        //exTableView.delegate = self;
        //exTableView.dataSource = self;
        //exTableView.delegate_extend = self;
        exTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        exTableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //去掉线条
        exTableView.showsHorizontalScrollIndicator = NO;
        exTableView.showsVerticalScrollIndicator = NO;
        
        [arrowImageViewArray addObject:arrowImageView];
        [busNameLabelArray addObject:busNameLabel];
        [detailsLabelArray addObject:detailsLabel];
        [exTableViewArray addObject:exTableView];
        
    }
    
}

- (void)showOnTheView:(NSInteger)i
{
    UILabel *getBusNameLabel = [busNameLabelArray objectAtIndex:i];
    getBusNameLabel.text = [buslineArray objectAtIndex:i];
    getBusNameLabel.textColor = myColor;
    
    UILabel *getDetailsLabel = [detailsLabelArray objectAtIndex:i];
    NSString *duration = [[NSString alloc] initWithString:[durationArray objectAtIndex:i]];
    NSString *totalDis = [[NSString alloc] initWithString:[totalDisArray objectAtIndex:i]];
    NSString *walkDis  = [[NSString alloc] initWithString:[walkDisArray objectAtIndex:i]];
    NSString *detailText = [[NSString alloc] initWithFormat:@"约%@ | %@ | 步行%@", duration ,totalDis ,walkDis];
    getDetailsLabel.text = detailText;
    
    /*BUG -------------此处有一个BUG，点击响应在EXTableView上时，无法左右滑动------------ BUG*/
    ExtensibleTableView *tableViewOfIndex = [[ExtensibleTableView alloc] init];
    tableViewOfIndex = [exTableViewArray objectAtIndex:i];
    tableViewOfIndex.delegate = self;
    tableViewOfIndex.dataSource = self;
    tableViewOfIndex.delegate_extend = self;
    [self addSubview:tableViewOfIndex];
    
    strategyArray   = [[NSMutableArray alloc] init];
    strDetailsArray = [[NSMutableArray alloc] init];
    stopArray       = [[NSMutableArray alloc] init];
    flagArray       = [[NSMutableArray alloc] init];
    detailWaysArray = [[NSMutableArray alloc] init];
    busStopArray    = [[NSMutableArray alloc] init];
    
    AMapTransit *transitOfIndex = [allRoutes.transits objectAtIndex:i];
    [stopArray addObject:startName];
    for (AMapSegment *s in transitOfIndex.segments) {
        //NSLog(@"segement = %@",s);
        //break;
        if (s.walking != nil) {
            //NSLog(@"wakling...");
            NSInteger walkDis = s.walking.distance;
            [strategyArray addObject:[NSString stringWithFormat:@"步行%ld米",(long)walkDis]];
            [flagArray addObject:@"0"];
            [strDetailsArray addObject:@""];
            [detailWaysArray addObject:s.walking.steps];
            
        } else {
            [stopArray removeLastObject];           //当发现没有步行的时候，这里必须要移走！！！只有有BUG出现在这里
        }
        
        if (s.busline != nil) {
            [busStopArray addObject:s.busline.departureStop];
            [busStopArray addObject:s.busline.arrivalStop];
            NSString *departureStopStr = s.busline.departureStop.name;
            NSString *arrivalStopStr = s.busline.arrivalStop.name;
            /*
            if (![departureStopStr isEqualToString:[stopArray lastObject]]) {
                [stopArray addObject:departureStopStr];
                [stopArray addObject:arrivalStopStr];
                [strategyArray addObject:[NSString stringWithFormat:@"乘坐%@",[buslineArray objectAtIndex:i]]];
                [flagArray addObject:@"1"];
            } else {
                [stopArray addObject:arrivalStopStr];
            }
            */
            [stopArray addObject:[NSString stringWithFormat:@"%@站上车",departureStopStr]];
            [stopArray addObject:[NSString stringWithFormat:@"%@站下车",arrivalStopStr]];
            [strategyArray addObject:[NSString stringWithFormat:@"乘坐%@",[self busNameTrans:s.busline.name]]];
            [flagArray addObject:@"1"];
            [strDetailsArray addObject:[NSString stringWithFormat:@"%@方向 |  %ld站",[self getBusDirection:s.busline.name],(long)s.busline.busStopsNum]];
            [detailWaysArray addObject:s.busline.busStops];
            //NSLog(@"TakingBus... %@",s.busline.name);
            
        }
    }
    
    if (![endName isEqualToString:[stopArray lastObject]]) {
        [stopArray addObject:[NSString stringWithFormat:@"到达%@",endName]];
        [strategyArray addObject:@""];
        [flagArray addObject:@"2"];
        [strDetailsArray addObject:@""];
        [detailWaysArray addObject:@""];
    }

    //NSLog(@"%@",strategyArray);
}


//进入AR导航
- (void)go:(UIButton *)sender
{
    //NSLog(@"go!");
    ARViewController *ARVC = [[ARViewController alloc] init];
    
    //通过uiview 获取这个view的viewcontroller
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&object != nil) {
        
        object = [object nextResponder];
        
    }
    
    UIViewController *uc=(UIViewController*)object;

    ARVC.busStopArray = busStopArray;
    
    [uc.navigationController pushViewController:ARVC animated:NO];
    
    [UIView animateWithDuration:0.6 animations:^{
        self.center = CGPointMake(self.center.x, initPoint.y);
    }];
    
    UIImageView *currentIamgeView = [arrowImageViewArray objectAtIndex:currentIndex];
    currentIamgeView.image = [UIImage imageNamed:@"disclosure_arrow"];
    
    
    MAMapView *myMap = (MAMapView *)[self superview];
    //myMap.visibleMapRect = [CommonUtility minMapRectForAnnotations:[self getAnnotationsFromSteps:[detailWaysArray objectAtIndex:sender.tag]]];
    AMapTransit *t = allRoutes.transits[currentIndex];
    AMapSegment *seg = t.segments[0];
    AMapWalking *w = seg.walking;
    
    //设置显示范围
    myMap.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(w.origin.latitude, w.origin.longitude), MACoordinateSpanMake(0.003f, 0.003f));
    
}

#pragma mark - UITableView Source Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stopArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //若当前行被选中，则返回展开的cell
    if([[exTableViewArray objectAtIndex:currentIndex] isEqualToSelectedIndexPath:indexPath])
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
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //未展开的cell，只显示名字
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"]) {            //步行
        //创建步行公共cell
        [self creatWalkingCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        [cell addSubview:megeImg];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 88 - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:line2];
        
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"1"]) {    //公交
        //创建公交公共cell
        [self creatBuslineCell:cell inTheRow:row];
        
        //添加指示箭头
        UIImageView *megeImg = [[UIImageView alloc] initWithFrame:CGRectMake([self superview].bounds.size.width - 45, 64, 15, 8)];
        megeImg.image = [UIImage imageNamed:@"箭头3-54x30px"];
        [cell addSubview:megeImg];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(52, 102 - 2, [self superview].bounds.size.width - 52 - 30, 2)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [cell addSubview:line2];
        
    } else {                                                              //终点
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

    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"]) {            //步行
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
        
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"1"]) {    //公交
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
        
    } else {                                                              //终点
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
    
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"]) {            //步行
        return 90 + 20 * detailsArray.count;
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"1"]) {    //公交
        return 105 + 20 * detailsArray.count;
    } else {                                                              //终点
        return 115;
    }
}

#pragma mark -
#pragma mark table view delegate methods
//起始cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[exTableViewArray objectAtIndex:currentIndex] isEqualToSelectedIndexPath:indexPath])
    {
        return [self tableView:tableView extendedHeightForRowAtIndexPath:indexPath];
    }
    
    NSInteger row = indexPath.row;
    
    if ([[flagArray objectAtIndex:row] isEqualToString:@"0"]) {            //步行
        return 90;
    } else if ([[flagArray objectAtIndex:row] isEqualToString:@"1"]) {    //公交
        return 105;
    } else {                                                              //终点
        return 115;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //若选择的cell是已经展开的，则收缩
    if ([[exTableViewArray objectAtIndex:currentIndex] isEqualToSelectedIndexPath:indexPath]) {
        [[exTableViewArray objectAtIndex:currentIndex] shrinkCellWithAnimated:YES];
    }
    //展开
    else{
        [[exTableViewArray objectAtIndex:currentIndex] extendCellAtIndexPath:indexPath animated:YES goToTop:NO];
    }
}

- (void)showOnMap:(UIButton *)sender
{
    //NSLog(@"hello！");
    [UIView animateWithDuration:0.6 animations:^{
        self.center = CGPointMake(self.center.x, initPoint.y);
    }];
    
    UIImageView *currentIamgeView = [arrowImageViewArray objectAtIndex:currentIndex];
    currentIamgeView.image = [UIImage imageNamed:@"disclosure_arrow"];
    
    int iOfSeg = [self getTheWalkIndex:flagArray tagOfsender:sender.tag];
    //NSLog(@"%d",iOfSeg);
    
    MAMapView *myMap = (MAMapView *)[self superview];
    //myMap.visibleMapRect = [CommonUtility minMapRectForAnnotations:[self getAnnotationsFromSteps:[detailWaysArray objectAtIndex:sender.tag]]];
    AMapTransit *t = allRoutes.transits[currentIndex];
    AMapSegment *seg = t.segments[iOfSeg];
    AMapWalking *w = seg.walking;
    
    //设置显示范围
    myMap.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(w.origin.latitude, w.origin.longitude), MACoordinateSpanMake(0.003f, 0.003f));

}

//获得步行在哪个路段
- (int)getTheWalkIndex:(NSArray *)array tagOfsender:(NSInteger)tagS
{
    int k = 0;
    for (int i = 0; i < tagS; i++) {
        if ([array[i] isEqualToString:@"1"]) {
            k++;
        }
    }
    return k;
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
    strategyLabel.textColor = myColor;
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

//获得经纬度
- (NSMutableArray *)getAnnotationsFromSteps:(NSArray *)stepArray
{
    NSMutableArray *annArray = [[NSMutableArray alloc] init];
    for (AMapStep *s in stepArray) {
        
        NSArray *splitArray = [[NSArray alloc] init];
        splitArray = [s.polyline componentsSeparatedByString:@";"];
        for (NSString *s in splitArray) {
            NSArray *tmpSplitArray = [[NSArray alloc] init];
            tmpSplitArray = [s componentsSeparatedByString:@","];
            float latitude = [tmpSplitArray[1] floatValue];
            float longtitude = [tmpSplitArray[0] floatValue];
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
            [annArray addObject:pointAnnotation];
        }
        
    }
    
    return annArray;
    
}

//截取字符
- (NSString *)getBusDirection:(NSString *)busName
{
    NSRange range1 = [busName rangeOfString:@"("];
    NSString *result = [busName substringFromIndex:range1.location+1];
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
