//
//  SZAutogrowTextView.h
//  Pods
//
//  Created by Сергей Галездинов on 05.09.15.
//
//

#import <UIKit/UIKit.h>

@interface SZAutogrowTextView : UITextView

/**
 Set this bool to YES if you want to change height on text input with animation
 @note
 default is YES
 */
@property (nonatomic) IBInspectable BOOL animateHeightChange;

/**
 Set this bool to YES if you want to patch the scroll position closer to caret
 @note
 Experimental. Default is NO
 */
@property (nonatomic) IBInspectable BOOL adjustScrollPosition;

@end
