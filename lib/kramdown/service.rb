# encoding: utf-8

######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run Kramdown::Service


require 'json'


# 3rd party libs/gems

require 'sinatra/base'

require 'kramdown'

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


  get %r{/(service|services|srv|s)$} do
    erb :service
  end

  get %r{/(editor|edit|ed|e)$} do
    # NB: use editor for "ruby-enhanced" parts of note
    @welcome_markdown = welcome_markdown
    @welcome_html     = Kramdown::Document.new( @welcome_markdown, input: 'GFM' ).to_html

    erb :editor
  end

  get '/' do
    @welcome_markdown = welcome_markdown
    @welcome_html     = Kramdown::Document.new( @welcome_markdown, input: 'GFM' ).to_html

    erb :index
  end

  # return hypertext (html)
  get '/markdown' do

    text = params.delete('text')
    to   = params.delete('to')   || 'html'  ## optional - default to html
 
    ## todo: pretty print params / print class/type- is just a hash ??

    ## assume all other params are kramdown options

    if ['latex','l','tex'].include?( to.downcase )
      content_type 'text/latex'
      text_to_latex( text, params )
    else  ## assume html (default)
      content_type 'text/html'
      text_to_html( text, params )
    end
    
 end


  # return babelmark2/dingus-style json
  # return html wrapped in json (follows babelmark2 dingus service api)
  get '/babelmark' do
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


private

  def welcome_markdown
    ## todo: rotate welcome / use random number for index
    # place markdown docs in server/docs
     text = File.read( "#{KramdownService.root}/lib/kramdown/service/docs/welcome.md" )
     text
  end


  def text_to_html( text, params )
    puts "text_to_html:"
    pp params
    pp text

    ## fix - change params to opts - can be used "outside" too (just a "simple" helper)
    ## add if opts/params  input empty (always use/default to GFM)
    ##  check if input is std/standard/classic/kramdown than remove and keep empty !!!

    opts={ input: 'GFM' }

    Kramdown::Document.new( text, opts ).to_html
  end

  def text_to_latex( text, params )
    puts "text_to_latex:"
    pp params
    pp text

    opts={ input: 'GFM' }

    Kramdown::Document.new( text, opts ).to_latex
  end

### helper for json or jsonp response (depending on callback para)

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

