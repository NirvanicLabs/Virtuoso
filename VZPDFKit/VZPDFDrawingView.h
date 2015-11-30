//
// LazyPDFDrawingView.h
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
#import "VZPDFViewController.h"
#import <CoreData/CoreData.h>
#import "Annotation.h"

#define LazyPDFDrawingViewVersion   1.0.0

typedef enum {
    VZPDFDrawingToolTypePen,
    VZPDFDrawingToolTypeText
} VZPDFDrawingToolType;

@protocol VZPDFDrawingViewDelegate, VZPDFDrawingTool;

@interface VZPDFDrawingView : UIView<UITextViewDelegate>

@property (nonatomic, assign) VZPDFDrawingToolType drawTool;
@property (nonatomic, assign) id<VZPDFDrawingViewDelegate> delegate;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) UIImage *prev_image;
@property (nonatomic, readonly) NSUInteger undoSteps;
@property (nonatomic) CGMutablePathRef path;
@property (nonatomic) CGPoint currPoint;
@property (nonatomic,strong) NSString *mStringOfTextView;
@property (nonatomic)NSInteger currentPage;

// load external image
- (void)loadImage:(UIImage *)image;
- (void)loadImageData:(NSData *)imageData;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;

- (void) initializeTextBox: (CGPoint)startingPoint;
- (void)commitAfterDoneButtonPressed;

@end

#pragma mark -

@protocol VZPDFDrawingViewDelegate <NSObject>
@required
- (void)finishDrawing:(CGPoint)lastPoint ;
@optional
- (void)drawingView:(VZPDFDrawingView *)view willBeginDrawUsingTool:(id<VZPDFDrawingTool>)tool;
- (void)drawingView:(VZPDFDrawingView *)view didEndDrawUsingTool:(id<VZPDFDrawingTool>)tool;

@end
