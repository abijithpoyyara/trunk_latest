![N](http://bayasys.in/assets/img/baya-logo.png)

# Base Package

Base package for bayasys mobile applications created and managed by Bayasys. 

## Introduction
This package consist of various widgets and utilities that simplify the total task in developing an application. 
 ##### why a library? 
  1. Easy Maintenance
  2. Easy Code Integration / Deployment
  3. Uniform Problem Solving approach
  4. Minimizes Communication
  5. Prevent Repeating Occurrence of Particular Problem
  6. Minimizes Performance Pitfalls   

>Audience: This document is created for software professionals who want to learn additional features of flutter and our customized programming concepts in simple and easy steps. It describes additional features (we added) in flutter components with suitable examples.

>Prerequisite: You should have a basic understanding of Dart,Flutter and any text editor. As we are going to develop mobile-based applications using Flutter, it will be good if you have an understanding of other technologies such as Java, js, React, Swift etc.


### Architecture Diagram

#### Tire 1 - Presentation layer
    This is the topmost level of the application. The presentation tier displays information related to app. It communicates with other tiers by which it puts out the results to the browser/client tier and all other tiers in the network. In simple terms, it is a layer which users can access directly (such as a mobile screen, or an operating system's GUI).Frameworks used here is the Dart framework Flutter

#### Tire 2 - Application layer
    The logical tier is pulled out from the presentation tier and, as its own layer, it controls an application’s functionality by performing detailed processing.Here we handle the data formatting ,seccurity management,report management,file uploading etc.

#### Tire 3 - Business layer

    Layer for applying real-world business rules that determine how data can be created, stored, and changed. It is contrasted with the remainder of the software that might be concerned with lower-level details of managing a database or displaying the user interface, system infrastructure, or generally connecting various parts of the program.Frameworks used here is the java framework Maven,Spring and Hibernate

#### Tire 4 - Data access layer

    The data tier includes the data persistence mechanisms (database servers, file shares, etc.) and the data access layer that encapsulates the persistence mechanisms and exposes the data. (Sql /PgSql were used here).
    
    
## Use this package as a library
#### 1. Depend on it
Add this to your package's pubspec.yaml file:
```sh
dependencies:
  base:
    path: <base package path>
```
####  2. Install it
You can install packages from the command line:
```sh
$ flutter pub get
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

####  3. Import it
Now in your Dart code, you can use:
```sh
import 'package:base/';
```

## Application Development Guidelines

### Names

Naming is an important part of writing readable, maintainable code.
The following best practices can help you achieve that goal.
#### 1. Use terms consistently.

Use the same name for the same thing, throughout your code. If a precedent
already exists outside your API that users are likely to know, follow that
precedent.

 *good*
 ```
 pageCount           // A field.
updatePageCount()   // Consistent with pageCount.
toSomething()       // Consistent with Iterable's toList().
asSomething()       // Consistent with List's asMap().
Point               // A familiar concept.
```

*bad*
```
renumberPages()      // Confusingly different from pageCount.
convertToSomething() // Inconsistent with toX() precedent.
wrappedAsSomething() // Inconsistent with asX() precedent.
Cartesian            // Unfamiliar to most users.
```

The goal is to take advantage of what the user already knows. This includes
their knowledge of the problem domain itself, the conventions of the core
libraries, and other parts of your own API.

#### 2. Avoid abbreviations.
Unless the abbreviation is more common than the unabbreviated term, don't
abbreviate. 

#### 3. Prefer putting the most descriptive noun last.
The last word should be the most descriptive of what the thing is. You can
prefix it with other words,
```
pageCount             // A count (of pages).
CssFontFaceRule       // A rule for font faces in CSS.
```
#### 4. Consider making the code read like a sentence.
When in doubt about naming, write some code that uses your API, and try to read
it like a sentence

```
// "If errors is empty..."
if (errors.isEmpty) ...

// "Hey, subscription, cancel!"
subscription.cancel();
```
#### 5. Prefer a non-imperative verb phrase for a boolean property or variable.

Boolean names are often used as conditions in control flow, so you want a name
that reads well there. 

These are, by far, the most common.
>  `isEnabled`, `wasShown`, `willFire`. 

#### 6. Pefer the "positive" name for a boolean property or variable.
Most boolean names have conceptually "positive" and "negative" forms where the
former feels like the fundamental concept and the latter is its
negation&mdash; *"open" and "closed" , "enabled" and "disabled",* etc.

**Exception:** With some properties, the negative form is what users
overwhelmingly need to use. Choosing the positive case would force them to
negate the property with `!` everywhere. Instead, it may be better to use the
negative case for that property.

#### 7. Avoid starting a method name with `get`.
For example, instead of a method named `getBreakfastOrder()`, define a getter
named `breakfastOrder`.

### Libraries / Dart Files
A leading underscore character ( `_` ) indicates that a member is private to its
library. This is not mere convention, but is built into the language itself.
 - **  Prefer making declarations private.**
-  ** Consider declaring multiple classes in the same library.**

### Classes and mixins
1. Avoid defining a one-member abstract class when a simple function will do.
    >    Promote use of `typedf` and `Callbacks`.
2. Avoid extending a class that isn't intended to be subclassed.
3. Do document if your class supports being extended.
    > If you want to allow subclasses of your class, state that. Suffix the class name with `Base`.
    > Don't forget to write proper comments in your functions,callback and classes whenever something is not very obvious. It will help the other developers to understand your code easily. Don’t worry about the lines of the comments in your code.

### Constructors
1.  Consider making your constructor `const` if the class supports it.
2.  prefer making fields and top-level variables `final`.
3.  Don't define a setter without a corresponding getter.
4.  Do annotate when Dart infers the wrong type.

### Identifiers

##### Name types using `UpperCamelCase`.
Classes, enums, typedefs, and type parameters should capitalize the first letter
of each word (including the first word), and use no separators.
```
class SliderMenu { ... }

class HttpRequest { ... }

typedef Predicate<T> = bool Function(T value);
```

##### Name libraries, packages, directories, and source files using `lowercase_with_underscores`
Name Libraries, packages, directories, and file in lowercase_with_under_score
```
library peg_parser.source_scanner;

import 'file_system.dart';
import 'slider_menu.dart';
```

##### Name other identifiers using `lowerCamelCase`.
Class members, top-level definitions, variables, parameters, and named
parameters should capitalize the first letter of each word *except* the first
word, and use no separators.

```
var item;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
```

## General Guidelines
- Comment section need to include in every library/ file. This should place before declaration section in the procedure. [Standard template for comment section ]()
- Don't forget to write proper comments in your classes, methods and Functions whenever something is not very obvious.
- Variables and Identifiers created should be self-explanatory.
- Unwanted variables should not be created.
- Unwanted codes should be removed.
- There should not be any commented codes unless for any specific reasons.
- Downloaded codes should not be used in the system without permission..
- If there is any error occurs then proper error message should be displayed, error messages raised should be easily traceable.
- Loops used should be properly ended.
- Don’t update pubspec.yaml in the app without permission.
- 
#### Architecture Standards
We are following `Redux` for state management, and thus ease of maintenance. Developers should follow keep these standards while developing the program. [Standard template for Redux folder structure]()
- `Redux Components` should comes under the desired folders
    > Do not place a `State` component under `viewmodel` folder.
- Flies name should end with component name.
    ```
     basic_input_reducer.dart
     basic_input_action.dart
     basic_input_viewmodel.dart
     basic_input_state.dart
        ```
- Don’t keep any unwanted objects in state.
- Don’t keep references to view in any of the architecture component.
- Dispose state on dismiss.
- Avoid state reference in views.
- Allow long running process only in Thunk-Action.
- Long validation should be done in middle ware.  
- Always use named parameters in architecture components
- Comment description for complex logic.

#### Style, Theme & Assets

- Use colors and strings only from the app standard libraries.
- Use styles and themes only from a App Statndard theme library.
- Should not edit or create a new style unless it is required (with permission).
- Place assets only in desired folders
- File name should be meaning full and precise.
- There should be file that provide these assets to the app
- There should not be any asset unless for any specific reasons. 
 
# Using Base Package

#### Base View
BaseView is a mixin for the app, which simplifies the connection between `Redux` and `Widget`. It returns a `Scaffold` Widget connected to the Store that mentioned in the inilializers. [more..]

*Usage*
```sh
class DocumentScanner extends StatelessWidget
    with BaseView<AppState, ScanViewModel> {
  @override
  void init(Store store) {
    store.dispatch(
        OptionInitAction(option: store.state.homeState.selectedOption));
    store.dispatch(fetchDocumentTypes());
  }

/// store to viewmodel convertion
  @override
  ScanViewModel converter(store) => ScanViewModel.fromStore(store);
  
/// Function that build app bar
  @override
  BaseAppBar buildAppBar(String title) {
    return super.buildAppBar("Document Scanner");
  }
  
  /// Function that build the body of the screen
    @override
  Widget buildChild(BuildContext context, ScanViewModel viewModel) {
    if (viewModel.showDocumentTypes) displayListDialog(context, viewModel);
    if (viewModel.savedDocument != null && viewModel.filesUploaded)
      showSuccessDialog(context, viewModel);

    return _Body(viewModel);
  }

}
```

which will automatically manage the loading and error notification;

#### Base State & Base Viewmodel

Every state that defined in the app state should extend the BaseState class and corresponding viewmodel classes should extend the BaseViewmodel class to work the loading and error management in **BaseView** to work.

#### Common Actions

Commons actions that frequently used in the app are defined here, such as `ChangeLoadingAction `. `InitFilePathAction` etc. 

> Note: If you notice certain actions are repeating in multiple action files then you can include such action in CommonAction library.

#### Local Storage Middleware

A middleware that handles storeage related activities, if certain action need local storage resources (Shared Pref). then you can extented the LocalstorageMiddleware or you can add those action in the base itself.


#### Http Request Helper
It is a http request manager handles all request with in the app, It accepts the inputs as `Map<String,dynamic>` request params , service and callbacks for `onRequestSucess` and `onRequestFailure`.
*Usage*

``` HttpRequestHelper(
          service: service,
          requestParams: body.toMap(),
          onRequestFailure: onRequestFailure,
          onRequestSuccess: (result) => {
                responseJson = DocumentTypeModel.fromJson(result),
                if (responseJson.statusCode == 1)
                  {
                    documentTypes = responseJson.documentTypes,
                    documentTypes
                        .sort((a, b) => (a.sortorder > b.sortorder) ? 1 : -1),
                    onRequestSuccess(documentTypes)
                  }
                else
                  onRequestFailure(
                      InvalidInputException(responseJson.statusMessage))
     }
) 
```     
#### Base Repository

Base repository contains basic operions performed in a repository such as fetching data from network(REST) and fetchin data from offline database (mobile inbuild db).

##### Methods

```
 performRequest(
      {List jsonArr,
      String service,
      String url,
      Function(Map<String, dynamic> response) onRequestSuccess,
      Function(AppException exception) onRequestFailure})
```
#### File Upload Repository
Repository that extends from base repository and handle file uploaded related tasks.
##### Callbacks
```
 Function(List<ImageModel> documents) onRequestSuccess;
 Function(AppException exception) onRequestFailure;
```
##### Methods


```

void uploadDocuments(
    List<String> filePaths, {
    Function(int progress) uploadProgress,
  })
  
void uploadDocumentsWithName(List<File> files, List<String> fileName,
      {Function(double progress) uploadProgress})
```
#### Lookup Repository 
[Read documentation]()
#### User Repository
[Read documentation]()

## Base Widgets
#### App Charts
A powerful widget capable of building charts for flutter app.
[Read documentation]()

#### App Date Picker
A widget used for selecting date.[Read documentation]()

#### App Lookup dialog
Custom widget specially designed to work with bayasys lookups.[Read documentation]()

#### App Preferences
Shared Preference manager that handles all kind of read and write operations in shared prefernces.[Read documentation]()

#### App Tabs
Customised Scrollable and static tabs for mobiles.[Read documentation]()

#### App AppBar
Customised appbar for mobile apps. [Read documentation]()

## Empty Views

- Empty Result View
- Error Result View
- Access denied view



 