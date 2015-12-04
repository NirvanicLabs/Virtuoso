//
//  ViewController.m
//  LazyPDFKitDemo
//
//  Created by Palanisamy Easwaramoorthy on 26/3/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//

#import "ViewController.h"
#import <VirtuosoPDFKit/VZPDFKit.h>

@interface ViewController ()<VZPDFViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)open:(id)sender {
    [self openVZPDF];
    //[self searchBarSearchButtonClicked];
}


- (void)openVZPDF
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
    
    VZPDFDocument *document = [VZPDFDocument withDocumentFilePath:filePath password:phrase];
    
    if (document != nil) // Must have a valid LazyPDFDocument object in order to proceed with things
    {
        VZPDFViewController *vzPDFViewController = [[VZPDFViewController alloc] initWithLazyPDFDocument:document];
        
        vzPDFViewController.delegate = self; // Set the LazyPDFViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:lazyPDFViewController animated:YES];
        
#else // present in a modal view controller
        
        vzPDFViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vzPDFViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:vzPDFViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
//        NSLog(@"%s [LazyPDFDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

#pragma mark - LazyPDFViewControllerDelegate methods

- (void)dismissLazyPDFViewController:(VZPDFViewController *)viewController
{
    // dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)searchButtonClicked:(id)sender {
    SearchResultsTableViewController *lSVCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsTableViewController"];
    [self.navigationController pushViewController:lSVCtrl animated:YES];
}
@end
