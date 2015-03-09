//
//  ItemsTableViewController.m
//  APmenu
//
//  Created by Alfredo E. Pérez L. on 3/8/15.
//  Copyright (c) 2015 Alfredo E. Pérez L. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "CategoryItemsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ShareAPI.h"
#import <CacheKit/CacheKit.h>
@interface ItemsTableViewController () {
    
    IBOutlet UITableView *tableView;
    NSDictionary *section;
    NSArray *sectionData;
    NSDictionary *row;
    NSArray *rowData;
    CKCache *cache;
}

@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    self.title = [ShareAPI sharedInstance].tableTitle;
    cache = [[CKFileCache alloc] initWithName:@"Cache"];
    if ([[ShareAPI sharedInstance].section integerValue] == 0) {
        sectionData = [[ShareAPI sharedInstance].Categories objectForKey:@"subcategory"];
        row = [sectionData objectAtIndex:[[ShareAPI sharedInstance].row integerValue]];
        rowData = [row objectForKey:@"items"];
    }
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [self leftBarButtonWithTitle:@"BACK" andSelector:@selector(goBack)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setTitleOnView];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UIBarButtonItem *)leftBarButtonWithTitle:(NSString *)title andSelector:(SEL)selector
{
    UIBarButtonItem *lb=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    [lb setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"HelveticaNeue-Thin" size:12.], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    return lb;
}

-(void)setTitleOnView {
    
    
    // Init views with rects with height and y pos
    CGFloat titleHeight = self.navigationController.navigationBar.frame.size.height;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.text = [ShareAPI sharedInstance].tableTitle;
    NSLog(@"%@",[ShareAPI sharedInstance].tableTitle);
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

-(void)viewWillAppear:(BOOL)animated {
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return rowData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryItemsTableViewCell *table = [tableView dequeueReusableCellWithIdentifier:@"table" forIndexPath:indexPath];
   
    NSDictionary *item = [rowData objectAtIndex:indexPath.row];
    
    table.titleLabel.text = [item objectForKey:@"name"];
    table.descriptionLabel.text = [item objectForKey:@"description"];
    
    NSString *img_path = [item objectForKey:@"img_path"];
    
    NSURL *imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ShareAPI sharedInstance].mainURL, img_path]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cache"]) {
        table.itemPic.image = [cache objectForKey:[NSString stringWithFormat:@"Category-%@",[item objectForKey:@"name"]]];
        if (!table.itemPic.image) {
            [table.itemPic setImageWithURL:imageURL];
            [cache setObject:table.itemPic.image forKey:[NSString stringWithFormat:@"Category-%@",[item objectForKey:@"name"]]];
        }
    }else{
        [table.itemPic setImageWithURL:imageURL];
        [cache setObject:table.itemPic.image forKey:[NSString stringWithFormat:@"Category-%@",[item objectForKey:@"name"]]];
    }
    
;
    return table;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
