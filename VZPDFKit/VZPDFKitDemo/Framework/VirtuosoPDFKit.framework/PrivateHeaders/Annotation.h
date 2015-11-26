//
//  Annotation.h
//  LazyPDFKitDemo
//
//  Created by Palanisamy Easwaramoorthy on 3/3/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Annotation : NSObject

//@property (nonatomic, retain) NSData * image;
//@property (nonatomic, retain) NSNumber * page;
//@property (nonatomic, retain) File *file;

@property (nonatomic,strong) NSString *pageNumber;
@property (nonatomic,strong) NSString *textViewString;
@property (nonatomic,strong) NSString *textViewX;
@property (nonatomic,strong) NSString *textViewY;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *path;

@end


@interface BufferObject : NSObject
@property (nonatomic,strong) Annotation *mPathObject;
@property (nonatomic,strong) NSString *operation;

@end
