//
//  AppDescriptionView.h
//  MyOtherApps
//
//  Created by Gordan Glavas on 02/02/15.
//  Copyright (c) 2015 Gordan Glavas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kAppDescriptionImageSize 100
#define kAppDescriptionViewHeight (kAppDescriptionImageSize + 50)
#define kAppDescriptionViewWidth (kAppDescriptionViewHeight + 90)

@interface AppDescriptionView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *appId;

- (id)initWithFrame:(CGRect)frame appId:(NSString *)appId;

- (void)update;
- (void)updateOfflineWithAppId:(NSString *)appId name:(NSString *)name imageUrl:(NSString *)imageUrlStr description:(NSString *)description;

@end
