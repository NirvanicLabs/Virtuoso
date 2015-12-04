//
//  PathDataManager.m
//  LazyPDFKit
//
//  Created by Subodh Parulekar on 07/09/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//

#import "PathDataManager.h"

@interface PathDataManager (){
    NSString *pathEntity;
}

@end

@implementation PathDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static PathDataManager *instance = nil;


+ (PathDataManager *)sharedInstance {
    
    @synchronized(self) {
        
        if ( !instance || instance == NULL )
        {
            instance = [[PathDataManager alloc] init];
        }
        
        return instance;
    }
}

-(id)init {
    
    if (self = [super init]) {
        pathEntity = [NSString stringWithFormat:@"Path"];
        
        return self;
    }
    
    return nil;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
           // NSLog(@"LazyPDF :: Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setUndoManager:[NSUndoManager new]];
        _managedObjectContext.undoManager.groupsByEvent = NO;
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"PathModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //NSLog(@"[self applicationDocumentsDirectory] : %@",[self applicationDocumentsDirectory]);
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PathModel"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        NSLog(@"Path :: Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core data operations

- (NSArray *)getAnnotation
{
    NSArray *path = [[NSArray alloc]init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:pathEntity];
    path = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return path;
}

-(void)savePath:(NSString *)data :(CGFloat)x :(CGFloat)y :(NSString *)textViewString :(NSString *)type :(NSInteger)pageNumber{
    
    [[self.managedObjectContext undoManager]beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:ADD_OPERATION];
    
    NSManagedObject *newPath = [NSEntityDescription insertNewObjectForEntityForName:pathEntity inManagedObjectContext:self.managedObjectContext];
    [newPath setValue:data forKey:@"path"];
    [newPath setValue:[NSString stringWithFormat:@"%f",x] forKey:@"textViewX"];
    [newPath setValue:[NSString stringWithFormat:@"%f",y] forKey:@"textViewY"];
    [newPath setValue:[NSString stringWithFormat:@"%li",(long)pageNumber] forKey:@"pageNumber"];
    [newPath setValue:textViewString forKey:@"textViewString"];
    [newPath setValue:type forKey:@"type"];

    
    NSError *error = nil;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
//    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [[self.managedObjectContext undoManager]endUndoGrouping];
}

-(void)deleteCurrentPageContent:(NSInteger)pageNumber{
    
    [[self.managedObjectContext undoManager]beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:DELETE_ALL_OPERATION];
    
    NSArray *path = [[NSArray alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:pathEntity];
    path = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
 
    for (int i = 0; i<path.count; i++) {
        NSManagedObject *pathObject = [path objectAtIndex:i];
        NSInteger pageNum = [[pathObject valueForKey:@"pageNumber"]integerValue];
        if (pageNumber==pageNum) {
            [self.managedObjectContext deleteObject:pathObject];
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
    [[self.managedObjectContext undoManager]endUndoGrouping];
}

-(void)deleteCurrentObject:(NSManagedObject *)object{
    
    [[self.managedObjectContext undoManager]beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:DELETE_OPERATION];
   
    [self.managedObjectContext deleteObject:object];
   
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
   
    [[self.managedObjectContext undoManager]endUndoGrouping];

}

-(void)editCurrentObject:(NSManagedObject *)object :(NSString *)textViewString{
    [[self.managedObjectContext undoManager]beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:EDIT_OPERATION];
    [object setValue:textViewString forKey:@"textViewString"];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    [[self.managedObjectContext undoManager]endUndoGrouping];
}


/*------Getting annotation object from NSManagedObject----------*/
-(Annotation *)getAnnotationObject:(NSManagedObject *)pathObject{
    Annotation *annote = [[Annotation alloc]init];
    
    annote.textViewString = [pathObject valueForKey:@"textViewString"];
    annote.textViewX = [pathObject valueForKey:@"textViewX"];
    annote.textViewY = [pathObject valueForKey:@"textViewY"];
    annote.type = [pathObject valueForKey:@"type"];
    annote.pageNumber = [pathObject valueForKey:@"pageNumber"];
    annote.path = [pathObject valueForKey:@"path"];
    
    return annote;
}

/*--------Undo/Redo operation----------*/
-(BufferObject *)undoLastStep
{
    NSMutableArray *lArrayOfEntireObjectsBefore = [[NSMutableArray alloc]initWithArray:[self getAnnotation]];
    
    [self.managedObjectContext undo];
    [self.managedObjectContext save:nil];
    
    BufferObject *buffObj = [[BufferObject alloc]init];
    
    
    NSMutableArray *lArrayOfEntireObjectsAfter = [[NSMutableArray alloc]initWithArray:[self getAnnotation]];
    
    if (lArrayOfEntireObjectsAfter.count > lArrayOfEntireObjectsBefore.count) {
        [lArrayOfEntireObjectsAfter filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ![lArrayOfEntireObjectsBefore containsObject:evaluatedObject];
        }]];
        Annotation *annote = [self getAnnotationObject:[lArrayOfEntireObjectsAfter lastObject]];
        buffObj.mPathObject = annote;
        buffObj.operation = self.managedObjectContext.undoManager.undoActionName ;
        return buffObj;
    }else{
        NSArray *result = [lArrayOfEntireObjectsBefore arrayByAddingObjectsFromArray:lArrayOfEntireObjectsAfter];
        NSSet *filterSet = [NSSet setWithArray:result];
        
        //Finally, transmogrify that NSSet into an NSArray:
        NSArray *arrayOfUniqueness = [filterSet allObjects];
        
        Annotation *annote = [self getAnnotationObject:[arrayOfUniqueness lastObject]];
        buffObj.mPathObject = annote;
        buffObj.operation = self.managedObjectContext.undoManager.undoActionName ;
        return buffObj;
    }
    
    return nil;
}

-(BufferObject *)redoLastStep
{
    NSMutableArray *lArrayOfEntireObjectsBefore = [[NSMutableArray alloc]initWithArray:[self getAnnotation]];
    
    [self.managedObjectContext redo];
    [self.managedObjectContext save:nil];
    
    BufferObject *buffObj = [[BufferObject alloc]init];
    
    NSMutableArray *lArrayOfEntireObjectsAfter = [[NSMutableArray alloc]initWithArray:[self getAnnotation]];
    
    //return buffer object according to delete or edit operation
    if (lArrayOfEntireObjectsAfter.count > lArrayOfEntireObjectsBefore.count) {
        [lArrayOfEntireObjectsAfter filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            
            return ![lArrayOfEntireObjectsBefore containsObject:evaluatedObject];
        }]];
        Annotation *annote = [self getAnnotationObject:[lArrayOfEntireObjectsAfter lastObject]];
        buffObj.mPathObject = annote;
        buffObj.operation = self.managedObjectContext.undoManager.undoActionName ;
        return buffObj;
    }else{
        NSArray *result = [lArrayOfEntireObjectsBefore arrayByAddingObjectsFromArray:lArrayOfEntireObjectsAfter];
        NSSet *filterSet = [NSSet setWithArray:result];
        
        //Finally, transmogrify that NSSet into an NSArray:
        NSArray *arrayOfUniqueness = [filterSet allObjects];
        
        Annotation *annote = [self getAnnotationObject:[arrayOfUniqueness lastObject]];
        buffObj.mPathObject = annote;
        buffObj.operation = self.managedObjectContext.undoManager.undoActionName ;
        return buffObj;
    }
    
//    NSArray *lArrayOfEntireObjects = [self getAnnotation];
//    if (lArrayOfEntireObjects.count>0) {
//        Annotation *annote = [self getAnnotationObject:[lArrayOfEntireObjects lastObject]];
//        
//        BufferObject *buffObj = [[BufferObject alloc]init];
//        buffObj.mPathObject = annote;
//        buffObj.operation = self.managedObjectContext.undoManager.undoActionName;
//        
//        return buffObj;
//    } else if ([self.managedObjectContext.undoManager.undoActionName isEqualToString:DELETE_OPERATION]) {
//        buffObj.operation = DELETE_OPERATION;
//        return buffObj;
//    }
    
    return nil;
}

@end
