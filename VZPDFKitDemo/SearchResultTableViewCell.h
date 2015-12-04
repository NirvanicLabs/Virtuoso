//
//  SearchResultTableViewCell.h
//  VZPDFKitDemo
//
//  Created by Subodh Parulekar on 03/12/15.
//  Copyright © 2015 Lazyprogram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLablePageNo;
@property (weak, nonatomic) IBOutlet UILabel *mLabelText;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTitle;

@end
