//
//  finishTripResultView.m
//  GreenTrip
//
//  Created by Mr.OJ on 15/5/19.
//  Copyright (c) 2015年 Mr.OJ. All rights reserved.
//

#import "finishTripResultView.h"

@implementation finishTripResultView

@synthesize totalDistance,busDistance,bikeDistance,walkingDistance,transCount;
@synthesize departureTime,departurePoint,arrivalPoint,arrivalTime,strategy;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initSubViews
{
    CGSize mainSize = self.bounds.size;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainSize.width, 45)];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, mainSize.width, mainSize.height - 45)];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttomView];
    
    UIImageView *portraitImgView= [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 45, 0, 90, 90)];
    portraitImgView.image = [UIImage imageNamed:@"proxy.png"];
    portraitImgView.layer.masksToBounds = YES;
    portraitImgView.layer.borderColor = myColor.CGColor;
    portraitImgView.layer.borderWidth = 2.0f;
    portraitImgView.layer.cornerRadius = 90 / 2;
    [self addSubview:portraitImgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 115, 200, 20)];
    titleLabel.text = @"行程结束，此次行程：";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    NSLog(@"总路程：%ldm",(long)totalDistance);
    NSLog(@"公交路程：%ldm",(long)busDistance);
    NSLog(@"步行路程：%ldm",(long)walkingDistance);
    NSLog(@"骑行路程：%ldm",(long)bikeDistance);
    
    NSLog(@"出发时间：%@",departureTime);
    NSLog(@"到达时间：%@",arrivalTime);
    NSLog(@"%@",departurePoint);
    NSLog(@"%@",arrivalPoint);
    NSLog(@"%ld",(long)strategy);
    
    consumeCalStr = [NSString stringWithFormat:@"%.1f", (walkingDistance / 1000.0) * 117 + (bikeDistance / 1000.0) *66];
    //小汽车一般碳排放在每km 0.4kg二氧化碳左右,公交2.1kg/km。假如一辆公交车50人，那么节省的碳排就是   0.4 * (50 / 5) - 2.1 = 1.9
    reduceCarbonStr = [NSString stringWithFormat:@"%.1f", 1.9 * (busDistance / 1000.0) + 0.4 * (walkingDistance + bikeDistance) / 1000];
    
    NSArray *iconImgsArray    = [[NSArray alloc] initWithObjects:@"4-54x92",@"5-76x92",@"3-144x92",@"",@"", nil];
    NSArray *iconLabelsArray  = [[NSArray alloc] initWithObjects:@"行走：",@"乘坐公交：",@"骑行：",@"燃烧热量：",@"减排：", nil];
    NSArray *unitsArray       = [[NSArray alloc] initWithObjects:@"km",@"趟",@"km",@"cal",@"kg", nil];
    NSArray *valuesArray      = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%.1f",walkingDistance / 1000.0],
                                                                 [NSString stringWithFormat:@"%ld",(long)transCount],
                                                                 [NSString stringWithFormat:@"%.1f",bikeDistance / 1000.0],
                                                                  consumeCalStr,
                                                                  reduceCarbonStr, nil];
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 120 + i * 32, 14, 14)];
        iconImgView.image = [UIImage imageNamed:[iconImgsArray objectAtIndex:i]];
        [buttomView addSubview:iconImgView];
        
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 110 + i * 32, 100, 30)];
        iconLabel.textAlignment = NSTextAlignmentLeft;
        iconLabel.text = [iconLabelsArray objectAtIndex:i];
        iconLabel.font = [UIFont systemFontOfSize:14.0];
        iconLabel.textColor = [UIColor lightGrayColor];
        [buttomView addSubview:iconLabel];
        
        UILabel *valuesLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainSize.width - 61 - 100, 110 + i * 32, 100, 30)];
        valuesLabel.textAlignment = NSTextAlignmentRight;
        valuesLabel.text = [valuesArray objectAtIndex:i];
        valuesLabel.textColor = myColor;
        valuesLabel.font = [UIFont systemFontOfSize:16.0];
        [buttomView addSubview:valuesLabel];
        
        UILabel *unitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainSize.width - 35 - 26, 110 + i * 32, 26, 30)];
        unitsLabel.textAlignment = NSTextAlignmentRight;
        unitsLabel.text = [unitsArray objectAtIndex:i];
        unitsLabel.textColor = [UIColor lightGrayColor];
        unitsLabel.font = [UIFont systemFontOfSize:14.0];
        [buttomView addSubview:unitsLabel];
        
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(32, 142 + 43, mainSize.width - 32 * 2, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(32, 142 + 43 + 32, mainSize.width - 32 * 2, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(32, 142 + 43 + 32 * 2, mainSize.width - 32 * 2, 2)];
    lineView3.backgroundColor = myColor;
    [self addSubview:lineView3];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(32, 142 + 43 + 32 * 3, mainSize.width - 32 * 2, 1)];
    lineView4.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView4];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, mainSize.height - 40, mainSize.width, 40)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.backgroundColor = myColor;
    [shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    [self uploadInfo];
    
}

- (void)uploadInfo {

    //更新数据库数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2.设置登录参数
    NSDictionary *dict = @{ @"username":[YDConfigurationHelper getStringValueForConfigurationKey:@"username"],
                            //@"departure_time":departureTime,
                            @"departure_point":departurePoint,
                            @"arrival_time":arrivalTime,
                            @"arrival_point":arrivalPoint,
                            @"strategy":[NSString stringWithFormat:@"%ld", (long)strategy],
                            @"total_distance":[NSString stringWithFormat:@"%.1f", totalDistance / 1000.0],
                            @"walking_distance":[NSString stringWithFormat:@"%.1f", walkingDistance / 1000.0],
                            @"bike_distance":[NSString stringWithFormat:@"%.1f", bikeDistance / 1000.0],
                            @"trans_count":[NSString stringWithFormat:@"%ld", (long)transCount],
                            @"consume_cal":consumeCalStr,
                            @"reduce_carbon":reduceCarbonStr};
    
    //3.请求
    [manager GET:@"http://192.168.1.104:1200/uploadTripsInfo" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET --> %@", responseObject); //自动返回主线程
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorWithMessage:@"信息上传失败"];
    }];

}

- (void)shareButton:(id)sender
{
    NSLog(@"SHARE");
}

-(void)showErrorWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
