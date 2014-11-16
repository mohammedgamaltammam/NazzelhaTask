//
//  Photo.h
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/5/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property(nonatomic,strong)NSString *photoTitle;
@property(nonatomic,strong)NSData *photoData;
@property(nonatomic,strong)NSString *photoUrl;
@end
