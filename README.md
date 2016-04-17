# kramdown-service gem - kramdown HTTP JSON API service (convert markdown to HTML or LaTeX)

* home  :: [github.com/writekit/kramdown-service](https://github.com/writekit/kramdown-service)
* bugs  :: [github.com/writekit/kramdown-service/issues](https://github.com/writekit/kramdown-service/issues)
* gem   :: [rubygems.org/gems/kramdown-service](https://rubygems.org/gems/kramdown-service)
* rdoc  :: [rubydoc.info/gems/kramdown-service](http://rubydoc.info/gems/kramdown-service)


## Usage - Web Service / HTTP (JSON) API - `GET /markdown`

Try the `markdown` HTTP (JSON) API running
on Heroku [`trykramdown.herokuapp.com`](http://trykramdown.herokuapp.com).


Example 1 - Converting to Hypertext (HTML):

    GET /markdown?text=Hello+World!
    
    <p>Hello World!</p>


Example 2 - Converting to LaTeX:

    GET /markdown?text=Hello+World!&to=latex
    
    Hello World!




## License

The `kramdown-service` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[wwwmake forum/mailing list](http://groups.google.com/group/wwwmake).
Thanks!

