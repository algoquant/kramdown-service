require 'hoe'
require './lib/kramdown/service/version.rb'

Hoe.spec 'kramdown-service' do

  self.version = KramdownService::VERSION

  self.summary = 'kramdown-service gem - kramdown HTTP JSON API service (convert markdown to HTML or LaTeX)'
  self.description = summary

  self.urls    = ['https://github.com/writekit/kramdown-service']

  self.author  = 'Gerald Bauer'
  self.email   = 'wwwmake@googlegroups.com'
  
  self.extra_deps = [
    ['kramdown'],  ##  markdown converter
    ['rouge'],     ## syntax highlighter
    ['sinatra'],
  ]
  
  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 1.9.2'
  }

end
