//
//  AsyncImageView.m
//  putio-atv
//
//  Created by Anthony May on 17/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "AsyncImageView.h"

@implementation AsyncImageView

/**
 Horrible dirty way to set image for demo purposes only.
 */
- (void)setImageURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (data) {
                self.image = [UIImage imageWithData:data];
            }
        }];
        
    }] resume];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
