//
//  ViewController.m
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/4/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import "FlickrSearchResultsTableViewController.h"
#import "SearchResultViewCell.h"
#import "parser/FlickrPhotosParser.h"
#import "Photo.h"


@interface FlickrSearchResultsTableViewController ()

@end

@implementation FlickrSearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeProperties];
    [self.flickrDataRetriever initializeRequestWithKey:@"aeb0e43135b65ae0b026363d35ed3d9c" Page:1 SearchWord:@"bend"];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initializeProperties{
    self.searchResultsArray = [NSMutableArray array];
    pageIndex=1;
    self.flickrDataRetriever = [[FlickrDataRetriever alloc]init];
    self.flickrDataRetriever.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchResultsArray.count==0)
        return 1;
    return self.searchResultsArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchResultsArray.count>=indexPath.row-1 ) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0]};
        CGRect rect = [((Photo*)[self.searchResultsArray objectAtIndex:indexPath.row]).photoTitle boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        if (rect.size.height<80)
            return 80;
        return rect.size.height;
    }
    return 80;
}

+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    if (text) {
        CGSize size;
        if (TRUE) {
            //iOS 7
            CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        }
        result = MAX(size.height, result); //At least one row
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.searchResultsArray count] == 0){ // Special Case 1
        
        // Disable user interaction for this cell.
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"no results";
        return cell;
    }
    
    else if (indexPath.row == [self.searchResultsArray count] - 1){ // Special Case 2
        //        [self launchReload];
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"load more..";
        [self.flickrDataRetriever initializeRequestWithKey:@"aeb0e43135b65ae0b026363d35ed3d9c" Page:pageIndex SearchWord:@"bend"];
        return cell;
    }
    
    static NSString *CellIdentifier = @"searchTableCell";
    SearchResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.cellTitle.numberOfLines = 0;
    [cell.cellTitle sizeToFit];
    cell.cellTitle.lineBreakMode = NSLineBreakByWordWrapping;
    if (!cell) {
        cell = [[SearchResultViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.cellTitle.text=((Photo*)[self.searchResultsArray objectAtIndex:indexPath.row]).photoTitle;
    if (((Photo*)[self.searchResultsArray objectAtIndex:indexPath.row]).photoData) {
        UIImage *image = [UIImage imageWithData:((Photo*)[self.searchResultsArray objectAtIndex:indexPath.row]).photoData];
        [cell.cellImageView setImage:image];        
    }
    else
        [cell.cellImageView setImage:nil];
    return cell;
}

-(void)DidDataReceivedWithPhotos:(NSArray*)photos
{
    FlickrPhotosParser* parser = [[FlickrPhotosParser alloc]init];
    [self.searchResultsArray addObjectsFromArray:[parser photoObjectsFromPhotosTag:photos]];
    [self.tableView reloadData];
    pageIndex++;
    [self performSelector:@selector(imagesAsynchrounsly) withObject:nil afterDelay:1];
}

-(void)imagesAsynchrounsly
{
    dispatch_queue_t imagesQueue = dispatch_queue_create("Image", NULL);
    
    dispatch_async(imagesQueue, ^{
        for (int i=0; i<self.searchResultsArray.count; i++)
        {
            Photo* photo = [self.searchResultsArray objectAtIndex:i];
            if (photo.photoData) {
                continue;
            }
            NSError* error = nil;
            photo.photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.photoUrl]];
            if (error)
                return;                
            NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForItem:i inSection:0]];
            if (photo.photoData)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                });
        }
    });
    
    [self.tableView reloadData];
}


//- (void)scrollViewDidScroll: (UIScrollView *)scroll {
//    NSInteger actualPosition = scroll.contentOffset.y;
//    NSInteger contentHeight = scroll.contentSize.height - scroll.frame.size.height;
//    
//    if (actualPosition >= contentHeight) {
//        [self.tableView reloadData];
//    }
//}
@end
