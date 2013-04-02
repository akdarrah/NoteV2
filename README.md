# [Notemare v2](http://alpha.notemare.com)

Try it yourself at [http://alpha.notemare.com](http://alpha.notemare.com). Created by [Adam Darrah](http://twitter.com/1bertlol).

<a href="http://content.screencast.com/users/onebert/folders/Jing/media/605dc754-a073-481c-a3c6-33b31d50a27d/00000093.png">
  <img
src="http://content.screencast.com/users/onebert/folders/Jing/media/605dc754-a073-481c-a3c6-33b31d50a27d/00000093.png"
width="100%">
</a>

## Installation

* Clone the repo: `git clone git@github.com:akdarrah/NoteV2.git`.
* Perform standard Rails installation (bundle and config/database.yml)
* Configure config/last_fm.yml and youtube.yml with your API keys

## To Add an Artist

```
Artist.create!(:name => "The Decemberists")
```

