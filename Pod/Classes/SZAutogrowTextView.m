//
//  SZAutogrowTextView.m
//  Pods
//
//  Created by Сергей Галездинов on 05.09.15.
//
//

#import "SZAutogrowTextView.h"

@interface SZAutogrowTextView()<UITextViewDelegate>

@end

@implementation SZAutogrowTextView{
    BOOL _hasLastIntrinsicSize;
    BOOL _textChanged;
    CGSize _lastIntrinsicSize;

    __weak id<UITextViewDelegate> _oldDelegate;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.delegate = self;
        self.animateHeightChange = YES;
    }

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.animateHeightChange = YES;
    }
    return self;
}

#pragma mark logic

//the main idea is to return intrinsic size with height corrected to text height
-(CGSize)intrinsicContentSize {
    if ([self.text length] == 0)
        return [super intrinsicContentSize];

    CGSize intrinsicSize = _lastIntrinsicSize;

    if (!_hasLastIntrinsicSize || _textChanged) {
        intrinsicSize = [super intrinsicContentSize];

        //normally, we should be using [NSLayoutManager usedRectForTextContainer:] here, but it returns wrong size here, so using sizeThatFits: instead
        intrinsicSize.height = [self sizeThatFits:self.bounds.size].height;

        _hasLastIntrinsicSize = YES;
        _lastIntrinsicSize = intrinsicSize;
    }

    _textChanged = NO;
    return intrinsicSize;
}

#pragma mark setters

-(void)setDelegate:(id<UITextViewDelegate>)delegate {
    if (delegate == self) {
        _oldDelegate = self.delegate;
        [super setDelegate:delegate];
    } else {
        _oldDelegate = delegate;
    }
}

-(void)setText:(NSString *)text {
    [super setText:text];
    [self _doTextChanged];
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self _doTextChanged];
}

-(void)setBounds:(CGRect)bounds {
    CGFloat prevHeight = CGRectGetHeight(self.bounds);
    CGFloat prevWidth  = CGRectGetWidth(self.bounds);
    [super setBounds:bounds];
    if ((int)prevHeight != (int)CGRectGetHeight(bounds)) {
        [self _scrollToVisibleCaretAnimated:NO];
        [self _checkScrollErrors];
    }

    //in case rotation occurs or width significantly changes - there must be some recalc need
    if (prevWidth != self.bounds.size.width) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _hasLastIntrinsicSize = NO;
            [self invalidateIntrinsicContentSize];
        });
    }
}

#pragma mark private methods

- (void)_scrollToVisibleCaretAnimated:(BOOL)animated
{
    UITextPosition *textPosition = self.selectedTextRange.end;
    CGRect caretRect = [self caretRectForPosition:textPosition];
    CGPoint caretBottomPos = CGPointMake(ceil(caretRect.origin.x), ceil(caretRect.origin.y + caretRect.size.height));
    CGSize contentSize = self.contentSize;
    if(caretBottomPos.y > contentSize.height)
        caretBottomPos.y = contentSize.height;
    CGFloat requiredContentOffsetY = (self.contentSize.height - caretBottomPos.y);
    CGPoint contentOffset = self.contentOffset;
    if(requiredContentOffsetY > contentOffset.y)
        [self setContentOffset:CGPointMake(0., requiredContentOffsetY) animated:animated];
}

- (void)_checkScrollErrors
{
    CGPoint contentOffset = self.contentOffset;
    CGSize contentSize = self.contentSize;
    CGRect visibleFrame = self.bounds;
    if(contentOffset.y < 0.)
    {
        contentOffset.y = 0.;
        [UIView performWithoutAnimation:^{
            [self setContentOffset:contentOffset animated:NO];
        }];
    }
    else if((contentSize.height - visibleFrame.size.height) >= 0)
    {
        contentOffset.y = contentSize.height - visibleFrame.size.height;
        [UIView performWithoutAnimation:^{
            [self setContentOffset:contentOffset animated:NO];
        }];
    }
}

-(void)_doTextChanged {
    _textChanged = YES;
    if (self.animateHeightChange) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self invalidateIntrinsicContentSize];
                             [UIView performWithoutAnimation:^{
                                 [self _scrollToVisibleCaretAnimated:NO];
                                 [self _checkScrollErrors];
                             }];
                             [self.superview setNeedsLayout];
                             [self.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {

                         }];
    } else {

        [self invalidateIntrinsicContentSize];

        [self _scrollToVisibleCaretAnimated:NO];
        [self _checkScrollErrors];
        
        [self.superview layoutIfNeeded];
    }
}

#pragma mark delegate methods

-(void)textViewDidChange:(UITextView *)textView {
    [self _doTextChanged];

    if ([_oldDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [_oldDelegate textViewDidChange:textView];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([_oldDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [_oldDelegate textViewDidBeginEditing:textView];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([_oldDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [_oldDelegate textViewDidEndEditing:textView];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_oldDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [_oldDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([_oldDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [_oldDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([_oldDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [_oldDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView {
    if ([_oldDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [_oldDelegate textViewDidChangeSelection:textView];
    }
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([_oldDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [_oldDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if ([_oldDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [_oldDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

@end

