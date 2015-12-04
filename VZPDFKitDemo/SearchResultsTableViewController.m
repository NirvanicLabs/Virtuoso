//
//  SearchResultsTableViewController.m
//  VZPDFKitDemo
//
//  Created by Subodh Parulekar on 03/12/15.
//  Copyright © 2015 Lazyprogram. All rights reserved.
//

#import "SearchResultsTableViewController.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController{
    CGRect _screenRect;
    CGFloat _screenWidth;
    CGFloat _screenHeight;
    UISearchBar *_searchBar;
    NSMutableArray *_parentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = _screenRect.size.width;
    _screenHeight = _screenRect.size.height;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, _screenWidth, 50)];
    _searchBar.placeholder = @"Search";
    _searchBar.delegate = self;
    
    self.tableView.tableHeaderView = _searchBar;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Searching.." delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
    [alert show];
   
    
    

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSArray *userDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSURL *docementsURL = [NSURL fileURLWithPath:[userDocuments lastObject]];
        NSArray *documentsURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docementsURL
                                                               includingPropertiesForKeys:nil
                                                                                  options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                    error:nil];
        NSArray *bundledResources = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"pdf" subdirectory:nil];
        documentsURLs = [documentsURLs arrayByAddingObjectsFromArray:bundledResources];
        
        Scanner *scanner = [[Scanner alloc] init];
        [scanner setKeyword:aSearchBar.text];
        _parentArray = [[NSMutableArray alloc]init];
        for (NSURL *docURL in documentsURLs)
        {
            CGPDFDocumentRef document1 = CGPDFDocumentCreateWithURL((CFURLRef)docURL);
            for(int i=0;i<CGPDFDocumentGetNumberOfPages(document1);i++)
            {
                scanner.selections = nil;
                scanner.selections = [[NSMutableArray alloc]init];
                [scanner scanPage:CGPDFDocumentGetPage(document1, i+1)];
                
                if([[scanner selections] count ]>0)
                {
                    NSMutableString  *strTest = scanner.strContent;
                    NSError *error = nil;
                    NSString *pattern = [NSString stringWithFormat:@"(\\w+)?\\s*\\b(\\w+)?\\s*%@\\s*(\\w+)\\b\\s*((\\w+))?", aSearchBar.text];
                    NSRange range = NSMakeRange(0, strTest.length);
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
                    NSArray *matches = [regex matchesInString:strTest options:0 range:range];
                    NSMutableArray *arrStrContent = [[NSMutableArray alloc]init];
                    for (NSTextCheckingResult *match in matches) {
                        NSRange matchRange = [match range];
                        NSString *m = [strTest substringWithRange:matchRange];
                        [arrStrContent addObject:m];
                    }
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[NSString stringWithFormat:@"%li",(long)i+1] forKey:@"number"];
                    [dict setValue:arrStrContent forKey:@"content"];
                    [dict setValue:[[docURL lastPathComponent] stringByDeletingPathExtension]forKey:@"title"];
                    [_parentArray addObject:dict];
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
    
    
}

-(void)filterSearchResults{
    
    if (_parentArray.count==0)
        return;
    
    NSArray *lArrayOfCopiedObjects = [NSArray arrayWithArray:_parentArray];
    _parentArray = nil;
    _parentArray = [NSMutableArray array];
    
    for (NSDictionary *dict in lArrayOfCopiedObjects) {
        NSArray *arrayOfContent =[dict valueForKey:@"content"];
        
        if (arrayOfContent.count>0) {
            if (![arrayOfContent[0]isEqualToString:@""]) {
                [_parentArray addObject:dict];
            }
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    if (searchBar.text.length < 3)
        return;
    
    searchBar.showsCancelButton = true;
    [self searchBarSearchButtonClicked:searchBar];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _parentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"SearchResultTableViewCell";
    SearchResultTableViewCell *cell = (SearchResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dict = [_parentArray objectAtIndex:indexPath.row];
    
    NSArray *arrayOfContent =[dict valueForKey:@"content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (arrayOfContent.count>0) {
        cell.mLabelText.text = arrayOfContent[0];
    }
    cell.mLabelTitle.text = [dict valueForKey:@"title"];
    cell.mLablePageNo.text = [NSString stringWithFormat:@"Page Number : %@",[dict valueForKey:@"number"]];
    return cell;
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
