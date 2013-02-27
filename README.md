What is TRAutocompleteView?
---------------------
![Alt text](/screenshots/dark.png "Dark-styled")    ![Alt text](/screenshots/light.png "Light-styled")  ![Alt text](/screenshots/landscape.png "Landscape")

TRAutocompleteView is customizable autocomplete/suggestionslist view. No inheritance, just a single line of code - attach TRAutocompleteView 
to any existing instance of UITextField, customize look and feel (optional), and that's it!
It works on the iPhone and iPad, with or without rotation.


Step 0: Prerequisites
---------------------
You'll need an iOS 5.1+ project


Step 1: Get TRAutocompleteView files (add as Git submodule)(recommended)
----------------
In terminal navigate to the root of your project directory and run these commands:

    git submodule add git://github.com/TarasRoshko/TRAutocompleteView.git thirdparty/TRAutocompleteView
    git commit -m 'TRAutocompleteView'

This creates new submodule, downloads the files to thirdparty/TRAutocompleteView directory within your project and creates new commit with updated git repo settings.
Next run

    git submodule update --init --recursive


Step 2: Add TRAutocompleteView to your project
------------------------------------

Simply add all files from src directory (make sure you UNCHECK "Copy items"),
If you want to use TRGoogleMapsAutocompleteItemsSource - you'll need to add AFNetworking as well (no worries, it's registered as submodule in TRAutocompleteView)


Step 3: Use it
------------------------

Assume you have two ivars in your view controller:

````objective-c
    IBOutlet UITextField *_textField;
    TRAutocompleteView *_autocompleteView;
````

Bind autocompleteview to that UITextField (e.g in loadView method):

````objective-c
    _autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:_textField
                                                         usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] init]
                                                        presentingIn:self];
````

What's going on here?
You've just binded _autocompleteView to _textField, and used google maps completion source. Positioning, resizing, etc will be handled for you automatically.
If you want to use custom autocompletion source, no problem - conform TRAutocompleteItemsSource, and pass it as source to autocompleteViewBindedTo method. 
Every TRAutocompleteItemsSource must provide minimumCharactersToTrigger method, returning NSUinteger, 
so it's extremely easy to configure when TRAutocompleteView should appear. In example above, it's shown after you type >= 2 symbols (for network traffic and performance reasons)


Step 4: Customize TRAutocompleteView
------------------------
  
**TRAutocompleteView Customizations**

You can use these properties to customize colors, selection style, separators and adjust vertical margin:

````objective-c
@property(nonatomic) UIColor *foregroundColor;
@property(nonatomic) UIColor *separatorColor;
@property(nonatomic) CGFloat fontSize;
@property(nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property(nonatomic) UITableViewCellSeparatorStyle separatorStyle;

@property(nonatomic) CGFloat topMargin;
````

Also, there are two more properties for tracking completion state:

````objective-c
@property(readonly) TRSuggestion *selectedSuggestion;
@property(readonly) NSArray *suggestions;
````

Cocoapods
------------------------
Coming soon
