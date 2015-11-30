//
//  PathDataManager.h
//  LazyPDFKit
//
//  Created by Subodh Parulekar on 07/09/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Annotation.h"
#import "Constants.h"

@interface PathDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (PathDataManager *)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)getAnnotation;
-(void)savePath:(NSString *)data :(CGFloat)x :(CGFloat)y :(NSString *)textViewString :(NSString *)type :(NSInteger)pageNumber;
-(void)deleteCurrentPageContent:(NSInteger)pageNumber;
-(void)deleteCurrentObject:(NSManagedObject *)object;
-(void)editCurrentObject:(NSManagedObject *)object :(NSString *)textViewString;

-(BufferObject *)undoLastStep;
-(BufferObject *)redoLastStep;
//-(void)refreshCurrentPageData;
@end
