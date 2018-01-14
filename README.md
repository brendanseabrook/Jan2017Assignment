#  Jan 2017 Assignment

Hello. This is an assignment to demo some of my Swift skills in early Jan 2017. The requirements are paraphrased as follows.

* Build an iOS app (in Swift or Objective-C)
* Containing a scrolling grid of 10 restaurants and latest review
* Where you can search, sort, and tap to view more details 
    * Whatever details you feel are important with the latest 10 photos posted from users
* Use Yelp's API (https://www.yelp.com/developers)
* Default the search to Ethiopian
* Make your app look visually appealing
* Don't over do it. *A reasonable solution in a reasonable amount of time*

## Assumptions

So normally I would ask the client for way more detail before starting the code however in this case I can just make some basic assumptions and get stuck in

* I'm not sure how to interperit the "10" restaurants part. Searching for Ethiopian should get more than 10 returns so I'm going forward assuming ~10 on screen at once. Maybe I will try to implement the infinite scroll paging to 10 at a time.
* The instructions deliberatly use the word grid, which in iOS land points towards using a collection view rather than any kind of list view.
* It says to *default* the search. This reads differently to *placeholder*. I will be artificially populating the searchbar on load and firing off the event on load.
* I will be using auto-layout and will try to make it as nice looking as possible but I think the assignment issuer will understand that I'm not a graphic designer.
* I will try to get this all done today (to be reasonable) however if I come across anything which is a learning experience I might as well spend a little bit of time on it. *Note, I had stuff to do sat evening so this was finished sun afternoon*
* The result will only be in English however I will still embed userstrings in the translate macro (because thats just a good habit to be in)
* While I'm going to use unit tests I'm not going to be doing automated UI tests because that would be a little over the top
* I'm not going to cache any data unless thats the easy path
* The app should work on iPad however I'm not going to spend much time optimizing UI for iPad
* While I should have helpful errors I'm not going to provide specific errors for every status code back from the API
* I'm not going to support autorotate
* I'm going to make it look as clean as possible, however the layout would be the first thing I spend more time on if this was a real app
* Sometimes yelp resonds with different sets of restaurants for the same search. They should look into that.

## Conclusion
* The project was completed slightly over my goal time
* I would spend more time on making it look nice, however as I'm being judged less on UX I'm going to stop here
    * I would have liked to implement the details page as a stack view however I was having some trouble with these components. Will circle back for my own knowledge
    * I did not spend any significant time on content scaling so the app looks bad on iPhone SE of lesser resolutons
    * The details page needs a textured background however photoshop isn't a good use of my time here
* All in all happy with the result given the time frame
* If the mystery reviewer has any questions about this or any other aspects of my experience, please feel free to get in contact

## Screen shots

![Search screen](https://github.com/brendanseabrook/Jan2017Assignment/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202018-01-14%20at%2014.21.24.png?raw=true)

![Details screen](https://github.com/brendanseabrook/Jan2017Assignment/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202018-01-14%20at%2014.22.31.png?raw=true)

