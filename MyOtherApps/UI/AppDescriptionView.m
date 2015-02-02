//
//  AppDescriptionView.m
//  MyOtherApps
//
//  Created by Gordan Glavas on 02/02/15.
//  Copyright (c) 2015 Gordan Glavas. All rights reserved.
//

#import "AppDescriptionView.h"

@implementation AppDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame appId:nil];
}

- (id)initWithFrame:(CGRect)frame appId:(NSString *)appId
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kAppDescriptionViewWidth, kAppDescriptionViewHeight)])
    {
        self.appId = appId;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0.890 green:0.894 blue:0.898 alpha:0.75];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAppDescriptionViewWidth, 30)];
        self.titleLabel.userInteractionEnabled = YES;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.titleLabel];
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, kAppDescriptionImageSize, kAppDescriptionImageSize)];
        self.iconImage.userInteractionEnabled = YES;
        [self addSubview:self.iconImage];
        
        float lblx = self.iconImage.frame.origin.x + kAppDescriptionImageSize + 10;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblx, self.iconImage.frame.origin.y, kAppDescriptionViewWidth - lblx, kAppDescriptionImageSize)];
        self.descriptionLabel.userInteractionEnabled = YES;
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:12];
        self.descriptionLabel.numberOfLines = 5;
        [self addSubview:self.descriptionLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.titleLabel addGestureRecognizer:tap];
        [self.iconImage addGestureRecognizer:tap];
        [self.descriptionLabel addGestureRecognizer:tap];
        [self addGestureRecognizer:tap];
        
        [self update];
    }
    return self;
}

- (void)update {
    if (self.appId == nil) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", self.appId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *json = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    NSArray *results = [dict objectForKey:@"results"];
    NSDictionary *result = [results objectAtIndex:0];
    
    self.titleLabel.text = [result objectForKey:@"trackName"];
    
    NSString *imageUrlStr = [result objectForKey:@"artworkUrl512"]; // or 512, or 60
    imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@".png" withString:[NSString stringWithFormat:@".%dx%d-75.png", (int) self.iconImage.bounds.size.width, (int) self.iconImage.bounds.size.height]];
    NSURL *artworkURL = [NSURL URLWithString:imageUrlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:artworkURL];
    UIImage *artworkImage = [UIImage imageWithData:imageData];
    self.iconImage.image = artworkImage;
    
    self.descriptionLabel.text = [result objectForKey:@"description"];
}

- (void)updateOfflineWithAppId:(NSString *)appId name:(NSString *)name imageUrl:(NSString *)imageUrlStr description:(NSString *)description {
    self.appId = appId;
    
    self.titleLabel.text = name;
    
    NSURL *artworkURL = [NSURL URLWithString:imageUrlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:artworkURL];
    UIImage *artworkImage = [UIImage imageWithData:imageData];
    self.iconImage.image = artworkImage;
    
    self.descriptionLabel.text = description;
}


#pragma mark - Actions

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", self.appId]]];
}

@end
