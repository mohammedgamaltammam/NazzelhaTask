//
//  ViewController.h
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/4/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flickr/FlickrDataRetrieverDelegate.h"
#import "flickr/FlickrDataRetriever.h"

@interface FlickrSearchResultsTableViewController : UITableViewController <FlickrDataRetrieverDelegate>
{
    @private
    NSInteger pageIndex;
}
@property(nonatomic, strong) NSMutableArray *searchResultsArray;
@property(nonatomic,strong) FlickrDataRetriever* flickrDataRetriever;


+(CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

@end

