//
//  MyOtherAppsView.h
//  MyOtherApps
//
//  Created by Gordan Glavas on 02/02/15.
//  Copyright (c) 2015 Gordan Glavas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOtherAppsView : UIView

@property (strong, nonatomic) NSString *appId;

- (void)initView;

- (void)fillWithAppId:(NSString *)appId;

@end
