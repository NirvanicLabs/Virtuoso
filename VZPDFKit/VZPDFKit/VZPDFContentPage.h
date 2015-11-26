//
//	LazyPDFContentPage.h
//
//  Created by Palanisamy Easwaramoorthy on 23/2/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import <UIKit/UIKit.h>
#import "VZPDFDrawingView.h"
#import <QuartzCore/QuartzCore.h>
#import "Annotation.h"

@protocol VZPDFContentPageDelegate <NSObject>
@required
-(void)enableOrDisableUndo :(BOOL)canUndo :(BOOL)canRedo;
@optional
@end

@interface VZPDFContentPage : UIView<UITextViewDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) id<VZPDFContentPageDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase;

- (id)processSingleTap:(UITapGestureRecognizer *)recognizer;

- (void)showDrawingView :(NSInteger)pageNumber;
//- (void)hideDrawingView;
//- (UIImage *)getDrawingImage;
-(void)removeAllSublayers;
-(void)commitAfterDoneButtonPressed;
-(void)undoLastStep;
-(void)redoLastStep;
-(void)removeAllSubviews;
//paths and layers array
@property (nonatomic,strong) NSMutableArray *mArrayOfPaths;
@property (nonatomic,strong) NSMutableArray *mArrayOfLayers;
@property (nonatomic,strong) NSMutableArray *mArrayOfPathObjects;
@property(nonatomic) NSInteger currentPage;
@property(nonatomic) NSInteger fixedTag;
@property (nonatomic,strong) NSString *mStringOfTextView;
//text view
@property (nonatomic,strong) UITextView *mTextView;

//segment control
@property (nonatomic,strong) UIView *mViewSegmentControl;
@end




#pragma mark -

//
//	LazyPDFDocumentLink class interface
//

@interface VZPDFDocumentLink : NSObject <NSObject>

@property (nonatomic, assign, readonly) CGRect rect;

@property (nonatomic, assign, readonly) CGPDFDictionaryRef dictionary;

+ (instancetype)newWithRect:(CGRect)linkRect dictionary:(CGPDFDictionaryRef)linkDictionary;
@end


