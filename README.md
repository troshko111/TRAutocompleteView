What is TRAutocompleteView?
---------------------
<p align="center">
  <img src="/screenshots/iphone_portrait.png" />
</p>

<p align="center">
  <img src="/screenshots/ipad.png" />
</p>

TRAutocompleteView is highly customizable autocomplete/suggestionslist view. No inheritance, just a single line of code - attach TRAutocompleteView 
to any existing instance of UITextField, customize look and feel (optional), and that's it!
It works on the iPhone and iPad and supports all possible orientations.


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
                                                     usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2 apiKey:@"INSERT_YOUR_PLACES_API_KEY_HERE"]
                                                     cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc] initWithCellForegroundColor:[UIColor lightGrayColor] fontSize:14]
                                                    presentingIn:self];
````

What's going on here?
You've just binded _autocompleteView to _textField, and used google maps completion source with google maps cell factory. Positioning, resizing, etc will be handled for you automatically.
As you can see from the example above, if you want completely different items source and customized cells - there is nothing easier:
````objective-c
@protocol TRAutocompleteItemsSource <NSObject>

- (NSUInteger)minimumCharactersToTrigger;
- (void)itemsFor:(NSString *)query whenReady:(void (^)(NSArray *))suggestionsReady;

@end

@protocol TRSuggestionItem <NSObject>

- (NSString *)completionText;

@end

@protocol TRAutocompletionCell <NSObject>

- (void)updateWith:(id <TRSuggestionItem>)item;

@end

@protocol TRAutocompletionCellFactory <NSObject>

- (id <TRAutocompletionCell>)createReusableCellWithIdentifier:(NSString *)identifier;

@end

````

Conform TRAutocompleteItemsSource to provide your own items source, conform TRAutocompletionCellFactory to provide your custom cells.

Step 4: Customize TRAutocompleteView
------------------------
  
**TRAutocompleteView Customizations**

Main customization step is to create your own cell and use it with CellFactory, but also you can use following properties

````objective-c
@property(nonatomic) UIColor *separatorColor;
@property(nonatomic) UITableViewCellSeparatorStyle separatorStyle;

@property(nonatomic) CGFloat topMargin;
````

Also, properties for tracking completion state:

````objective-c
@property(readonly) id<TRSuggestionItem> selectedSuggestion;
@property(readonly) NSArray *suggestions;
@property(copy) void (^didAutocompleteWith)(id <TRSuggestionItem>);
````

Step 5: Customize TRAutocompleteView
------------------------
Check out Demo project, it's extremely easy to get started and requires a few simple steps to configure view for your needs,
Google maps source/factory code will help you to understand what's going on

Using google places autocomplete
------------------------
TRAutocompleteView ships with google places autocompletion source. In order to use it, you must generate YOUR OWN api key (get it here: https://code.google.com/apis/console)
and pass it to TRGoogleMapsAutocompleteItemsSource initWithMinimumCharactersToTrigger:apiKey initializer.
TRGoogleMapsAutocompleteItemsSource uses new Places API for autocompletion: https://developers.google.com/places/documentation/autocomplete 

**P.S Common mistake: DON NOT USE Google Maps API v3 key, 
you need Places API KEY instead, otherwise all requests will just fail with REQUEST_DENIED status code**

Cocoapods
------------------------
Coming soon
