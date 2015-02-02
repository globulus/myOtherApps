//
//  MyOtherAppsView.m
//  MyOtherApps
//
//  Created by Gordan Glavas on 02/02/15.
//  Copyright (c) 2015 Gordan Glavas. All rights reserved.
//

#import "MyOtherAppsView.h"

#import "Reachability.h"
#import "AppDescriptionView.h"

@interface MyOtherAppsView ()

@property (strong, nonatomic) UIScrollView *scvApps;
@property (strong, nonatomic) UIActivityIndicatorView *aciApps;

@end

@implementation MyOtherAppsView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    CGRect frame = self.frame;
    
    self.scvApps = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.scvApps.showsHorizontalScrollIndicator = YES;
    self.scvApps.showsVerticalScrollIndicator = NO;
    self.scvApps.scrollEnabled = YES;
    self.scvApps.pagingEnabled = NO;
    self.scvApps.bounces = YES;
    [self addSubview:self.scvApps];
    
    self.aciApps = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    const CGFloat indicatorSize = 20;
    self.aciApps.frame = CGRectMake(CGRectGetMidX(frame) - indicatorSize, CGRectGetMidY(frame) - indicatorSize, indicatorSize, indicatorSize);
    self.aciApps.hidesWhenStopped = YES;
    [self addSubview:self.aciApps];

}

- (void)fillWithAppId:(NSString *)appId {
    self.appId = appId;
    [self.aciApps startAnimating];
    dispatch_queue_t appsQueue = dispatch_queue_create(strcat("myAppsQueue", appId.UTF8String) , NULL);
    dispatch_async(appsQueue, ^
                   {
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self fillAppsScrollView];
                                          [self.aciApps stopAnimating];
                                      });
                   });
}

#pragma mark - Private

- (void)fillAppsScrollView
{
    for (UIView *v in self.scvApps.subviews) {
        [v removeFromSuperview];
    }
    
    Reachability *reach = [[Reachability alloc] init];
    NetworkStatus netStatus = [reach internetConnectionStatus];
    if (netStatus == NotReachable) {
        UILabel *lblNoConn = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        lblNoConn.center = self.scvApps.center;
        lblNoConn.font = [UIFont systemFontOfSize:24];
        lblNoConn.text = @"Sorry, no Internet connection!";
        [self.scvApps addSubview:lblNoConn];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&entity=software", self.appId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *json = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    NSArray *results = [dict objectForKey:@"results"];
    NSUInteger len = [results count];
    int x = 10;
    for (int i = 1; i < len; i++, x += kAppDescriptionViewWidth + 10) {
        NSDictionary *result = [results objectAtIndex:i];
        NSString *appId = [result objectForKey:@"trackId"];
        NSString *name = [result objectForKey:@"trackName"];
        NSString *description = [result objectForKey:@"description"];
        NSString *imageUrlStr = [result objectForKey:@"artworkUrl512"]; // or 512, or 60
        imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@".png" withString:[NSString stringWithFormat:@".%dx%d-75.png", kAppDescriptionImageSize, kAppDescriptionImageSize]];
        
        AppDescriptionView *adv = [[AppDescriptionView alloc] initWithFrame:CGRectMake(x, 0, 0, 0)];
        [adv updateOfflineWithAppId:appId name:name imageUrl:imageUrlStr description:description];
        [self.scvApps addSubview:adv];
        
    }
    
    self.scvApps.contentOffset = CGPointMake(0, 0);
    self.scvApps.contentSize = CGSizeMake(x, self.scvApps.frame.size.height);
}

@end
