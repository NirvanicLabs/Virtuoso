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
    searchBar.delegate=self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)open:(id)sender {
    [self openVZPDF];
    //[self searchBarSearchButtonClicked];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    NSArray *userDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *docementsURL = [NSURL fileURLWithPath:[userDocuments lastObject]];
    NSLog(@"%@", docementsURL);
    NSArray *documentsURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docementsURL
                                                           includingPropertiesForKeys:nil
                                                                              options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                error:nil];
    NSArray *bundledResources = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"pdf" subdirectory:nil];
    documentsURLs = [documentsURLs arrayByAddingObjectsFromArray:bundledResources];
    
    Scanner *scanner = [[Scanner alloc] init];
    [scanner setKeyword:aSearchBar.text];
    //NSMutableDictionary *dict = [NSMutableDictionary alloc]initWithObjectsAndKeys:<#(id), ...#>, nil
    NSMutableArray *pageNumbers = [[NSMutableArray alloc]init];
    NSMutableArray *parentArray = [[NSMutableArray alloc]init];
    NSMutableArray *selections = [[NSMutableArray alloc]init];
    NSMutableDictionary *parentDict = [[NSMutableDictionary alloc]init];
    for (NSURL *docURL in documentsURLs)
    {
//    NSURL *docURL = documentsURLs[3];
        CGPDFDocumentRef document1 = CGPDFDocumentCreateWithURL((CFURLRef)docURL);
        for(int i=0;i<CGPDFDocumentGetNumberOfPages(document1);i++)
        {
            scanner.selections = nil;
            //scanner.rawTextContent =nil;
            scanner.selections = [[NSMutableArray alloc]init];
            [scanner scanPage:CGPDFDocumentGetPage(document1, i+1)];
            
            if([[scanner selections] count ]>0)
            {
                NSMutableString  *strTest = scanner.strContent;
                NSError *error = nil;
                NSString *pattern = [NSString stringWithFormat:@"(\\w+)?\\s*\\b(\\w+)?\\s*\\b%@\\b\\s*(\\w+)\\b\\s*((\\w+))?", aSearchBar.text];
                NSRange range = NSMakeRange(0, strTest.length);
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
                NSArray *matches = [regex matchesInString:strTest options:0 range:range];
                for (NSTextCheckingResult *match in matches) {
                    NSRange matchRange = [match range];
                    NSString *m = [strTest substringWithRange:matchRange];
                    NSLog(@"Matched string: %@", m);
                }
                [selections addObject:[scanner selections]];
                
                for (Selection *sel in scanner.selections) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    //NSString *string = [NSString stringWithFormat:@"%d", i+1];
                    [dict setValue:sel forKey:[@((1)) stringValue]];
                    [dict setValue:[NSString stringWithFormat:@"%li",(long)i+1] forKey:@"number"];
                    [dict setValue:[NSNumber numberWithFloat:((sel.transform.a*sel.frame.origin.x)+(sel.transform.c*sel.frame.origin.y)+sel.transform.tx
                                                              )] forKey:@"x"];
                    [dict setValue:[NSNumber numberWithFloat:((sel.transform.b*sel.frame.origin.x)+(sel.transform.d*sel.frame.origin.y)+sel.transform.ty)] forKey:@"y"];
                    [dict setValue:[[docURL lastPathComponent] stringByDeletingPathExtension]forKey:@"title"];
                    
                    [pageNumbers addObject:dict];
                }
                
                //NSLog(@"page number is %d",i+1);
                //[parentDict setValue:strTest forKey:@"pageContent"];
                //[parentDict setValue:pageNumbers forKey:@"selections"];
                [parentArray addObject:strTest];
                
            }
        }
    }
    
    [parentDict setValue:pageNumbers forKey:@"selections"];
    [parentDict setValue:parentArray forKey:@"stringContent"];
    
    
    
    
    
    
    //    UIImageView *imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(400, 300, 100, 30)];
    //    imgVw.backgroundColor = [UIColor blueColor];
    //    NSDictionary *dict = [pageNumbers lastObject];
    ////    //NSString *strFrame = [dict valueForKey:@"frame"];
    //    UIImage *img = [self imageFromPDF:document withPageNumber:[[dict valueForKey:@"number"] integerValue] withScale:1.0 :[[dict valueForKey:@"x"] floatValue] :[[dict valueForKey:@"y"] floatValue]];
    ////
    //  imgVw.image = img;
    ////
    ////     CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, [dict valueForKey:@"number"]);
    //////    new x position = old x position * a + old y position * c + tx
    //////    new y position = old x position*b + old y position * d + ty
    ////     //pageRe
    ////
    //    [self.view addSubview:imgVw];
    
    //    for (NSDictionary *dict in pageNumbers) {
    NSLog(@"page number %@",parentDict);
    //    }
    
//    [keyword release];
//    keyword = [[aSearchBar text] retain];
//    [pageView setKeyword:keyword];
    //
    [aSearchBar resignFirstResponder];
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
        NSLog(@"%s [LazyPDFDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

#pragma mark - LazyPDFViewControllerDelegate methods

- (void)dismissLazyPDFViewController:(VZPDFViewController *)viewController
{
    // dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
