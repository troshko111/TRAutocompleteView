//
// Copyright (c) 2013, Taras Roshko
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// The views and conclusions contained in the software and documentation are those
// of the authors and should not be interpreted as representing official policies,
// either expressed or implied, of the FreeBSD Project.
//

#import "TRViewController.h"
#import "TRAutocompleteView.h"
#import "TRGoogleMapsAutocompleteItemsSource.h"
#import "TRTextFieldExtensions.h"
#import "TRGoogleMapsAutocompletionCellFactory.h"

@implementation TRViewController
{
    __weak IBOutlet UITextField *_defaultQueryTextField;
    __weak IBOutlet UITextField *_customQueryTextField;

    TRAutocompleteView *_autocompleteViewForDefault;
    TRAutocompleteView *_autocompleteViewForCustom;
}

- (void)loadView
{
    [super loadView];

    [_defaultQueryTextField setLeftPadding:2];
    _autocompleteViewForDefault = [TRAutocompleteView autocompleteViewBindedTo:_defaultQueryTextField
                                                                   usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc]
                                                                                                                     initWithMinimumCharactersToTrigger:2]
                                                                   cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc]
                                                                                                                       initWithCellForegroundColor:[UIColor darkGrayColor]
                                                                                                                                          fontSize:14]
                                                                  presentingIn:self];

    [_customQueryTextField setLeftPadding:9];
    _autocompleteViewForCustom = [TRAutocompleteView autocompleteViewBindedTo:_customQueryTextField
                                                                  usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2]
                                                                  cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc]
                                                                                                                      initWithCellForegroundColor:[UIColor whiteColor]
                                                                                                                                         fontSize:14]
                                                                 presentingIn:self];
    _autocompleteViewForCustom.topMargin = -5;
    _autocompleteViewForCustom.backgroundColor = [UIColor colorWithRed:(27) / 255.0f
                                                                 green:(27) / 255.0f
                                                                  blue:(27) / 255.0f
                                                                 alpha:1];
}

@end
