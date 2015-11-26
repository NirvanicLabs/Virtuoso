//
//	LazyPDFMainToolbar.h
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

#import "UIXToolbarView.h"

@class VZPDFMainToolbar;
@class VZPDFDocument;

@protocol VZPDFMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(VZPDFMainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(VZPDFMainToolbar *)toolbar thumbsButton:(UIButton *)button;
- (void)tappedInToolbar:(VZPDFMainToolbar *)toolbar exportButton:(UIButton *)button;
- (void)tappedInToolbar:(VZPDFMainToolbar *)toolbar printButton:(UIButton *)button;
- (void)tappedInToolbar:(VZPDFMainToolbar *)toolbar emailButton:(UIButton *)button;
- (void)tappedInToolbar:(VZPDFMainToolbar *)toolbar markButton:(UIButton *)button;

@end

@interface VZPDFMainToolbar : UIXToolbarView

@property (nonatomic, weak, readwrite) id <VZPDFMainToolbarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame document:(VZPDFDocument *)document;

- (void)setBookmarkState:(BOOL)state;

- (void)hideToolbar;
- (void)showToolbar;

@end
