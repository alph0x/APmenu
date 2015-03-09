//
//  ViewController.m
//  APmenu
//
//  Created by Alfredo E. Pérez L. on 3/7/15.
//  Copyright (c) 2015 Alfredo E. Pérez L. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ShareAPI.h"
#import "CategoryViewCell.h"
#import "HeaderCollectionReusableView.h"
#import <CacheKit/CacheKit.h>

//BASE URL:
static NSString * const BaseURLString = @"https://www.getpostman.com/collections/2a9f34a396ef5cd2822a";

@interface ViewController (){
    __strong NSDictionary *responseJSON;
    __strong NSArray *requestsObject;
    IBOutlet UICollectionView *collectionView;
    int numberOfItems;
    BOOL dataGathered;
    NSArray *paths;
    NSString  *arrayPath;
    NSString  *dictPath;
    CKFileCache *cache;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    self.title = @"PICCOLI'S MENU";
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.557 green:0.157 blue:0 alpha:1]];
    [self setTitleOnView];
    cache = [[CKFileCache alloc] initWithName:@"Cache"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cache"]) {
        dataGathered = YES;
        [ShareAPI sharedInstance].Category = [cache objectForKey:@"Category"];
        [ShareAPI sharedInstance].Categories = [cache objectForKey:@"Categories"];
        NSLog(@"%@",[[ShareAPI sharedInstance].Categories description]);
        NSLog(@"%@",[[ShareAPI sharedInstance].Category description]);
    }else{
        [self performConnection];
    }
    
}

-(void)setTitleOnView {
    
    
    // Init views with rects with height and y pos
    CGFloat titleHeight = self.navigationController.navigationBar.frame.size.height;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.text = @"PICCOLI'S MENU";
    //    [titleView setBackgroundColor:[UIColor greenColor]];
    // Set font for sizing width
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    titleLabel.textColor = [UIColor colorWithRed:0.557 green:0.157 blue:0 alpha:1];
    // Set the width of the views according to the text size
    CGFloat desiredWidth = [self.title sizeWithFont:titleLabel.font
                                  constrainedToSize:CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, titleLabel.frame.size.height)
                                      lineBreakMode:UILineBreakModeCharacterWrap].width;
    CGRect frame;
    
    frame = titleLabel.frame;
    frame.size.height = titleHeight;
    frame.size.width = desiredWidth;
    titleLabel.frame = frame;
    
    frame = titleView.frame;
    frame.size.height = titleHeight;
    frame.size.width = desiredWidth;
    titleView.frame = frame;
    
    // Ensure text is on one line, centered and truncates if the bounds are restricted
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    titleLabel.textAlignment = UITextAlignmentCenter;
    
    // Use autoresizing to restrict the bounds to the area that the titleview allows
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //    titleView.autoresizesSubviews = YES;
    //    titleLabel.autoresizingMask = titleView.autoresizingMask;
    
    // Add as the nav bar's titleview
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
}

-(void)gatherCategoryWithURL:(NSString *)URLString {
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ShareAPI sharedInstance].Category = responseObject;
        [cache setObject:responseObject forKey:@"Category"];
        
        dataGathered = YES;
        [collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Information"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

-(void)gatherCategoriesWithURL:(NSString *)URLString {
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", [responseObject description]);
        [ShareAPI sharedInstance].Categories = responseObject;
        [cache setObject:responseObject forKey:@"Categories"];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Information"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [ShareAPI sharedInstance].Category.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (dataGathered) {
        NSLog(@"%@", [[ShareAPI sharedInstance].Category description]);
        NSDictionary *data = [[ShareAPI sharedInstance].Category objectAtIndex:section];
        NSArray *subcategory = [data objectForKey:@"subcategory"];
        numberOfItems = subcategory.count;
    }else{
        numberOfItems = 0;
    }
    return numberOfItems;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    if (dataGathered) {
        NSDictionary *data = [[ShareAPI sharedInstance].Category objectAtIndex:indexPath.section];
        NSArray *subcategory = [data objectForKey:@"subcategory"];
        NSDictionary *subData = [subcategory objectAtIndex:indexPath.row];
        cell.titleLabel.text = [subData objectForKey:@"name"];

    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (dataGathered) {
            NSDictionary *data = [[ShareAPI sharedInstance].Category objectAtIndex:indexPath.section];
            NSString *img_path = [data objectForKey:@"img_path"];
            header.titleLabel.text = [data objectForKey:@"name"];
            NSURL *imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ShareAPI sharedInstance].mainURL, img_path]];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cache"]) {
                header.categoryPic.image = [cache objectForKey:[NSString stringWithFormat:@"Category-%@",[data objectForKey:@"name"]]];
                if (!header.categoryPic.image) {
                    [header.categoryPic setImageWithURL:imageURL];
                    [cache setObject:header.categoryPic.image forKey:[NSString stringWithFormat:@"Category-%@",[data objectForKey:@"name"]]];
                }
            }else{
                [header.categoryPic setImageWithURL:imageURL];
                [cache setObject:header.categoryPic.image forKey:[NSString stringWithFormat:@"Category-%@",[data objectForKey:@"name"]]];
            }
            
      
            return header;
        }
        
    }
    return nil;
    
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *row = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    NSString *section = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    [ShareAPI sharedInstance].row = row;
    [ShareAPI sharedInstance].section = section;
    NSDictionary *data = [[ShareAPI sharedInstance].Category objectAtIndex:indexPath.section];
    NSArray *subcategory = [data objectForKey:@"subcategory"];
    NSDictionary *subData = [subcategory objectAtIndex:indexPath.row];
    [ShareAPI sharedInstance].tableTitle = [subData objectForKey:@"name"];
}

-(void)performConnection{
    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseJSON = responseObject;
        
        requestsObject = [responseJSON objectForKey:@"requests"];
        
        for (NSDictionary *a in requestsObject) {
            
            if ([[a objectForKey:@"name"] isEqualToString:@"Category"]) {
                [self gatherCategoriesWithURL:[a objectForKey:@"url"]];
            }else{
                [self gatherCategoryWithURL:[a objectForKey:@"url"]];
            }
           
            //For images purpose
            [ShareAPI sharedInstance].mainURL = [[a objectForKey:@"url"] substringToIndex:36];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Information"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
