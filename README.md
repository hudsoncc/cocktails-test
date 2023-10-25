<p align="center">
  <img width="100" height="100" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/da65146c-9c4c-481d-808e-83317ba74c0c">
</p>
<h1 align="center">
Meet Cocktails
</h1>
<p align="center">
  <img src="https://github.com/hudsoncc/cocktails-test/assets/51756871/14a7a6a8-2f9c-463d-a03a-6db8d8f2da5d.gif">
</p>

This is a sample project that allows user's to search for cocktail recipes. 

## A Brief Overview

### Architecture
- The app uses the MVVM-C design pattern to aid with structure, seperating concerns, and testabilty.
- The UI layer is written 100% in code, favoring a programmatic approach over use of storyboards. I decided to utilise my UIView extension, which makes light work of writting UI code declaratively with AutoLayout anchors.
- UI factory methods are abstracted away from `ViewController` classes, into their own `ViewControllerUI` class, whose sole responsibilty is to define and creaate the VC's subviews, layout, and geometry.
- The app consumes the [search](https://www.thecocktaildb.com/api/json/v1/1/search.php?s=lemon) endpoint of cocktail DB's public API, to render cocktail meta within the app.
- To be a good citizen of the API, requests made to the `search` endpoint triggered via keyboard input, are debounced with a ~0.5 interval while the user types. This also protects against making unnecessary roundtrips and local fetches requests to CoreData. 
- The JSON response returned by the API is converted to struct objects that conform to `Decodable` for easy parsing, then mapped to `NSManagedObject`s, for local storage in the persistent store. 
- I made an consciouse decision not to include any third-party dependencies. I felt it was unecessary given the project's scope and deadlines, and would a good opportunity to enjoy the journey, as well as have 100% ownership over the code and decision making.
- The app works 100% offline. As mentioned above, all search query results and web images are cached locally for offline use.

### State

**Search View - Default**

Empty Data Set | Cached Results | Debug Menu
--|--|--
<img width="349" alt="Screenshot 2023-10-25 at 17 11 11" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/f6b9f7f9-78f1-43ed-8a9b-ef1cc41d5dbc">|<img width="349" alt="Screenshot 2023-10-25 at 17 11 28" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/4a0bcbda-b8ca-4751-a60e-fe81533d0176">|<img width="349" alt="Screenshot 2023-10-25 at 17 12 29" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/dcdc4db2-7c80-4ab3-b046-03655ec502ec">

**Search View - Search Mode**

Empty Data Set | Results | No Results
--|--|--
<img width="349" alt="Screenshot 2023-10-25 at 17 11 28" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/4a0bcbda-b8ca-4751-a60e-fe81533d0176">|<img width="349" alt="Screenshot 2023-10-25 at 17 14 22" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/ae823b06-402b-4217-b658-2fb1ac7da7cc">|<img width="349" alt="Screenshot 2023-10-25 at 17 14 42" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/6da8d5cd-3586-4f5a-ac83-dd10308dce1d">

**Detail View**

Default | With Video | Dark Mode
--|--|--
<img width="349" alt="Screenshot 2023-10-25 at 17 12 35" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/55a0f08c-fc25-4f4b-80f3-5e2f654ff01b">|<img width="349" alt="Screenshot 2023-10-25 at 19 14 01" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/e5cfd5f8-224f-4f94-98b9-b2c2fea12edb">|<img width="349" alt="Screenshot 2023-10-25 at 17 15 37" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/f5d84e3c-4122-41a5-8a1a-2cc597d949ae">
### Functionality
**Search View**
- Tap the saerch bar and type a cocktail name to start searching.
- Tap a cocktail in the search results list to see more detail.

**Details View**
- The details screen displays meta including a cocktail's name, tags, ingredients and instructions.
- Tapping the cocktail's image on the details screen opens the image in the browser.
- Some cocktails have a corresponding video. When a video is present, a play button will appear on the detail screen. Tapping the play button will open the video in the browser.

**Debug Menu**
- I decided to commit my basic debug menu that allowed me to quickly delete the CoreData cache, image cache, or all app data, while debuggin the app.
 
### Extras
- Cocktail images are lazily fetched asynchronously, and cached to disk in a subdirectory `imageCache` of the app's `documentDirectory` dir. Due the project scope, it felt overkill to to include an in-memory cache to assist the on disk cache.
- I've written test coverage for the app's coordiniator navigation logic, as well as for the app's two view models.
- I utilised `UIView.animate` to add some minor polish to the app's state transitions, without going too overboard.

### Discoveries
- It turns out that the `strImageSource` attribute in the API's response is ~90% always `null`. I had to use `strDrinkThumb` for fetching images instead.  

