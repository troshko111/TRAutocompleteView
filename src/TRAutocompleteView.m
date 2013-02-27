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

#import <CoreGraphics/CoreGraphics.h>
#import "TRAutocompleteView.h"
#import "TRAutocompleteItemsSource.h"
#import "TRSuggestion.h"

@interface TRAutocompleteView () <UITableViewDelegate, UITableViewDataSource>

@property(readwrite) TRSuggestion *selectedSuggestion;
@property(readwrite) NSArray *suggestions;

@end

@implementation TRAutocompleteView
{
    BOOL _visible;

    __weak UITextField *_queryTextField;
    __weak UIViewController *_contextController;

    UITableView *_table;
    id <TRAutocompleteItemsSource> _itemsSource;
}

+ (TRAutocompleteView *)autocompleteViewBindedTo:(UITextField *)textField
                                     usingSource:(id <TRAutocompleteItemsSource>)itemsSource
                                    presentingIn:(UIViewController *)controller
{
    return [[TRAutocompleteView alloc] initWithFrame:CGRectZero
                                           textField:textField
                                         itemsSource:itemsSource
                                          controller:controller];
}

- (id)initWithFrame:(CGRect)frame
          textField:(UITextField *)textField
        itemsSource:(id <TRAutocompleteItemsSource>)itemsSource
         controller:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadDefaults];

        _queryTextField = textField;
        _itemsSource = itemsSource;
        _contextController = controller;

        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorColor = self.separatorColor;
        _table.separatorStyle = self.separatorStyle;
        _table.delegate = self;
        _table.dataSource = self;

        [[NSNotificationCenter defaultCenter]
                               addObserver:self
                                  selector:@selector(queryChanged:)
                                      name:UITextFieldTextDidChangeNotification
                                    object:_queryTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        [self addSubview:_table];
    }

    return self;
}

- (void)loadDefaults
{
    self.backgroundColor = [UIColor whiteColor];
    self.foregroundColor = [UIColor darkGrayColor];
    self.separatorColor = [UIColor lightGrayColor];
    self.fontSize = 14;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.topMargin = 0;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGFloat calculatedY = _queryTextField.frame.origin.y + _queryTextField.frame.size.height + self.topMargin;
    CGFloat calculatedHeight = _contextController.view.frame.size.height - calculatedY - kbSize.height;

    calculatedHeight += _contextController.tabBarController.tabBar.frame.size.height; //keyboard is shown over it, need to compensate

    self.frame = CGRectMake(_queryTextField.frame.origin.x, calculatedY, _queryTextField.frame.size.width, calculatedHeight);
    _table.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self removeFromSuperview];
    _visible = NO;
}

- (void)queryChanged:(id)sender
{
    if ([_queryTextField.text length] >= _itemsSource.minimumCharactersToTrigger)
    {
        [_itemsSource itemsFor:_queryTextField.text whenReady:
                                                            ^(NSArray *suggestions)
                                                            {
                                                                if (_queryTextField.text.length < _itemsSource.minimumCharactersToTrigger)
                                                                {
                                                                    self.suggestions = nil;
                                                                    [_table reloadData];
                                                                }
                                                                else
                                                                {
                                                                    self.suggestions = suggestions;
                                                                    [_table reloadData];

                                                                    if (self.suggestions.count > 0 && !_visible)
                                                                    {
                                                                        [_contextController.view addSubview:self];
                                                                        _visible = YES;
                                                                    }
                                                                }
                                                            }];
    }
    else
    {
        self.suggestions = nil;
        [_table reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TRAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:self.fontSize];
        cell.textLabel.textColor = self.foregroundColor;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = self.selectionStyle;
    }

    TRSuggestion *suggestion = self.suggestions[(NSUInteger) indexPath.row];
    cell.textLabel.text = suggestion.suggestionText;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRSuggestion *suggestion = self.suggestions[(NSUInteger) indexPath.row];
    self.selectedSuggestion = suggestion;

    _queryTextField.text = self.selectedSuggestion.suggestionText;
    [_queryTextField resignFirstResponder];
}

@end