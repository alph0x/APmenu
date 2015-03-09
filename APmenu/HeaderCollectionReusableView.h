//
//  HeaderCollectionReusableView.h
//  APmenu
//
//  Created by Alfredo E. Pérez L. on 3/8/15.
//  Copyright (c) 2015 Alfredo E. Pérez L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *categoryPic;

@end
