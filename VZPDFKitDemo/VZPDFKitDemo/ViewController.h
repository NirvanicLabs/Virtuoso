//
//  ViewController.h
//  LazyPDFKitDemo
//
//  Created by Palanisamy Easwaramoorthy on 26/3/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scanner.h"
#import "SearchResultsTableViewController.h"

@interface ViewController : UIViewController<UISearchBarDelegate>

- (IBAction)searchButtonClicked:(id)sender;
@end

