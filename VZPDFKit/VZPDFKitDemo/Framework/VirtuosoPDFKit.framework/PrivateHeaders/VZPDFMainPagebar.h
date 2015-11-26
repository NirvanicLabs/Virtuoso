//
//	LazyPDFMainPagebar.h
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

#import "VZPDFThumbView.h"

@class VZPDFMainPagebar;
@class VZPDFTrackControl;
@class VZPDFPagebarThumb;
@class VZPDFDocument;

@protocol VZPDFMainPagebarDelegate <NSObject>

@required // Delegate protocols

- (void)pagebar:(VZPDFMainPagebar *)pagebar gotoPage:(NSInteger)page;

@end

@interface VZPDFMainPagebar : UIView

@property (nonatomic, weak, readwrite) id <VZPDFMainPagebarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame document:(VZPDFDocument *)object;

- (void)updatePagebar;

- (void)hidePagebar;
- (void)showPagebar;

@end

#pragma mark -

//
//	LazyPDFTrackControl class interface
//

@interface VZPDFTrackControl : UIControl

@property (nonatomic, assign, readonly) CGFloat value;

@end

#pragma mark -

//
//	LazyPDFPagebarThumb class interface
//

@interface VZPDFPagebarThumb : VZPDFThumbView

- (instancetype)initWithFrame:(CGRect)frame small:(BOOL)small;

@end

#pragma mark -

//
//	LazyPDFPagebarShadow class interface
//

@interface VZPDFPagebarShadow : UIView

@end
