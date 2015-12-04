//
//  SearchResultsTableViewController.h
//  VZPDFKitDemo
//
//  Created by Subodh Parulekar on 03/12/15.
//  Copyright © 2015 Lazyprogram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scanner.h"
#import <VirtuosoPDFKit/VZPDFKit.h>
#import "SearchResultTableViewCell.h"

@interface SearchResultsTableViewController : UITableViewController<UISearchBarDelegate,VZPDFViewControllerDelegate>

@end
