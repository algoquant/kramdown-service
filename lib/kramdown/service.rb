# encoding: utf-8

######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run Kramdown::Service


# 3rd party libs/gems

require 'sinatra/base'

require 'kramdown'


# require 'logutils'
# require 'logutils/activerecord'


# our own code

require 'kramdown/service/version'   # let version always go first



module Kramdown
  
class Service < Sinatra::Base

  PUBLIC_FOLDER = "#{KramdownService.root}/lib/kramdown/service/public"
  VIEWS_FOLDER  = "#{KramdownService.root}/lib/kramdown/service/views"

  puts "[boot] kramdown-service - setting public folder to: #{PUBLIC_FOLDER}"
  puts "[boot] kramdown-service - setting views folder to: #{VIEWS_FOLDER}"

  set :public_folder, PUBLIC_FOLDER   # set up the static dir (with images/js/css inside)   
  set :views,         VIEWS_FOLDER    # set up the views dir

  set :static, true   # set up static file routing


  ##############################################
  # Controllers / Routing / Request Handlers

  def welcome_markdown
    ## todo: rotate welcome / use random number for index
    # place markdown docs in server/docs
     text = File.read( "#{KramdownService.root}/lib/markdown/service/docs/welcome.md" )
     text
  end


  get %r{/(service|services|srv|s)$} do
    erb :service
  end

  get %r{/(note|notes|n)$} do
    # for testing/debugging use copied sources 1:1 from markdown-notepad repo
    redirect '/note.html'
  end

  get %r{/(editor|edit|ed|e)$} do
    # NB: use editor for "ruby-enhanced" parts of note
    @welcome_markdown = welcome_markdown
    @welcome_html = Kramdown::Document.new( @welcome_markdown ).to_html

    erb :editor
  end

  get '/' do
    @welcome_markdown = welcome_markdown
    @welcome_html = Kramdown::Document.new( @welcome_markdown ).to_html

    erb :index
  end


  ## todo: use 3rd party services from markdown.yml (lets you configure)
  #   e.g. http://johnmacfarlane.net/cgi-bin/pandoc-dingus?text=hi


  def markdownify( params, opts={} )
    pp params
    text = params[:text]
    lib  = params[:lib]   # optional
    pp text
    pp lib

    Kramdown::Document.new( text, opts ).to_html
  end


  # return babelmark2/dingus-style json
  get '/markdown/dingus' do
    html = markdownify( params )
            
    data = {
      name:    'kramdown',
      html:    html,
      version: Kramdown::VERSION
    }
    
    json_or_jsonp( data.to_json )
  end


  # return hypertext (html)
  get '/markdown' do
    content_type 'text/html'
    markdownify( params )
  end

  # return html wrapped in json (follows babelfish2 dingus service api)
  get '/dingus' do
    html = markdownify( params )
            
    data = {
      name: 'kramdown',
      html: html,
      version: Kramdown::Version
    }
    
    json_or_jsonp( data.to_json )
  end


  get '/d*' do
    erb :debug
  end


### helper for json or jsonp response (depending on callback para)

private
def json_or_jsonp( json )
  callback = params.delete('callback')
  response = ''

  if callback
    content_type :js
    response = "#{callback}(#{json})"
  else
    content_type :json
    response = json
  end
  
  response
end


end # class Service
end #  module Kramdown


# say hello
puts KramdownService.banner

