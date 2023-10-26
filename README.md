<p align="center">
  <img width="100" height="100" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/6b530774-a45f-486f-9a78-bfdc465d29a2">
</p>
<h1 align="center">
Meet Cocktails
</h1>
<p align="center">
  <img src="https://github.com/hudsoncc/cocktails-test/assets/51756871/785bf45c-844c-40c3-a66c-a32cac7287ab.gif">
</p>

This is a sample project that allows user's to search for cocktail recipes. 

## A Brief Overview

### Architecture
- The app uses the MVVM-C design pattern to aid with structure, seperating concerns, and testabilty.
- The UI layer is written 100% in code, favoring a programmatic approach over use of storyboards. I decided to utilise my [`UIView` extension](https://github.com/hudsoncc/cocktails-test/blob/main/Cocktails/UI/Extensions/UIView%2BAnchors.swift#L9C1-L10C10), which makes light work of writting declaritive UI code with AutoLayout anchors.
- UI factory methods are abstracted away from `ViewController` classes, into their own [`ViewControllerUI`](https://github.com/hudsoncc/cocktails-test/blob/main/Cocktails/UI/Search/SearchViewUI.swift#L73-L106) class, whose sole responsibilty is to define and create the VC's subviews, layout, and geometry.
- The app consumes the [search](https://www.thecocktaildb.com/api/json/v1/1/search.php?s=lemon) endpoint of cocktail DB's public API, to render cocktail meta within the app.
- To be a good citizen of the API, requests made to the `search` endpoint triggered by keyboard input are debounced with a ~0.5 interval while the user types. This also protects against making unnecessary roundtrips and local fetch requests to CoreData. 
- The JSON response returned by the API is converted to struct objects that conform to `Decodable` for easy parsing, then mapped to `NSManagedObject`s, for local storage in the persistent store. 
- I made a conscious decision not to include any third-party dependencies. I felt it was unecessary given the project's scope and deadline, and would be a good opportunity to enjoy the journey, as well as have 100% ownership over the code and decision making.
- The app works 100% offline, with all search query results and web images cached locally for offline use.
- You can explore development of the app chronologically in my [PR](https://github.com/hudsoncc/cocktails-test/pull/1) where I've mades changes [commit by commit](https://github.com/hudsoncc/cocktails-test/pull/1).

### State

**Search View - Default**

Empty Data Set | Cached Results | Debug Menu
--|--|--
<img width="349" alt="Empty Data Set" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/01ab12ed-65ff-474c-a384-e3f29b05f0a9">|<img width="349" alt="Cached Results" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/6efe3a0b-b2b9-40f4-8260-645da10a3bd5">|<img width="349" alt="Screenshot 2023-10-25 at 20 34 44" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/9d29d950-dfed-4bee-96f7-3f08b4a6ab33">

**Search View - Search Mode**

Empty Data Set | Results | No Results
--|--|--
<img width="349" alt="Screenshot 2023-10-25 at 17 11 28" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/eb13b4ea-5d9e-44ae-ba36-cef773280ab4">|<img width="349" alt="Screenshot 2023-10-25 at 17 14 22" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/15d69524-c746-4a33-a8fb-2942e8017595">|<img width="349" alt="Screenshot 2023-10-25 at 17 14 42" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/6fcf6695-b6fc-4dce-a1be-271a1b187517">

**Detail View**

Default | With Video | Dark Mode
--|--|--
<img width="349" alt="Screenshot 2023-10-25 at 19 14 01" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/1f45a9ab-2ff3-4518-a2bf-111852534c95">|<img width="349" alt="Screenshot 2023-10-25 at 19 14 01" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/912c200b-c1f4-42ca-a5af-58d40146b386">|<img width="349" alt="Screenshot 2023-10-25 at 17 15 37" src="https://github.com/hudsoncc/cocktails-test/assets/51756871/f328de48-1441-4b0b-a827-6cc9a12f1c92">

### Functionality
**Search View**
- Tap the search bar and type a cocktail name to start searching.
- Tap a cocktail in the search results list to see more detail.

**Details View**
- The details screen displays meta including a cocktail's name, tags, ingredients and instructions.
- Tapping the cocktail's image opens it in the browser.
- Some cocktails have a corresponding video. When a video is present, a play button will appear on the detail screen. Tapping the play button will open the video in the browser.

**Debug Menu**
- I decided to commit my basic debug menu that allowed me to quickly delete the CoreData cache or image cache respectively, or delete all app data without having to delete and re-install the app.
 
### Extras
- Cocktail images are lazily fetched asynchronously, and cached to disk in a subdirectory `imageCache` of the app's `documentDirectory`. Due to the project scope, it felt overkill to to include an in-memory cache to reduce file system I/O operations.
- I've written test coverage for the app's [coordiniator](https://github.com/hudsoncc/cocktails-test/blob/main/Cocktails/UI/Coordinator/Tests/ViewCoordinatorTests.swift) navigation logic, as well as for the app's two view models, [`SearchViewModel`](https://github.com/hudsoncc/cocktails-test/blob/main/Cocktails/UI/Search/Tests/SearchViewModelTests.swift#L27) and [`DetailViewModel`](https://github.com/hudsoncc/cocktails-test/blob/main/Cocktails/UI/Detail/Tests/DetailViewModelTests.swift).
- I utilised `UIView.animate` to add some minor polish to the app's state transitions, without going too overboard.

### Discoveries
- It turns out that the `strImageSource` attribute in the API's response is ~90% always `null`. I had to use `strDrinkThumb` for fetching images instead.  

