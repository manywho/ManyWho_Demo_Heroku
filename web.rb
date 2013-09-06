=begin

Copyright 2013 Manywho, Inc.

Licensed under the Manywho License, Version 1.0 (the "License"); you may not use this
file except in compliance with the License.

You may obtain a copy of the License at: http://manywho.com/sharedsource

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the specific language governing
permissions and limitations under the License.

=end

require 'sinatra'
require 'haml'
require 'manywho-sdk'
require 'rack-ssl-enforcer'
use Rack::SslEnforcer

# Initialize the Manywho engine
Engine = Manywho::Engine.new()

# Show the index page
get '/' do
    haml :index
end

# Prepare to run a new flow. Clear any old values so they can't cause errors
get '/run' do
    Engine.reset()
    $tenantId = false
    $flowId = false
    $flowResp = false
    haml :run
end


post '/execute' do
    # First time this is called, set the values which will be used lated in running the flow
    if (!$tenantId) || (!$flowId) || (!$flowResp)
        $tenantId = params[:tenantid]
        $flowId = params[:flowid]
        username = params[:username]
        password = params[:password]
        
        # Load the first step of the flow
        $flowResp = Engine.load_flow($tenantId, $flowId, username=username, password=password)
        
        # Display the step
        haml :execute
    else
        # Load the next step using the selected step to navigate
        selectedStep = params[:steps]
        $flowResp = Engine.select_OutcomeResponse($flowResp, selectedStep)
        
        # Display the step
        haml :execute
    end
end

# haml layouts
__END__
@@ layout
%html
  %head
    %title ManyWho Ruby Heroku example!
  %body
    =yield

@@ index
%p
  Welcome to the ManyWho Ruby Heroku example!
%ul
  %li
    %h3
      %a(href='/run') Run a flow!

@@ run
%form(action='/execute' method='POST')
  Tenant Id:
  %input(type='text' name='tenantid')
  <br>
  
  Flow Id:
  %input(type='text' name='flowid')
  <br>
  
  
  Username (optional):
  %input(type='text' name='username')
  <br>
  
  Password (optional):
  %input(type='password' name='password')
  <br>
  
  %input(type='submit')

@@ execute
%p
  - if ($flowResp) && ($flowResp.mapElementInvokeResponses.length)
    %h2
      #{$flowResp.mapElementInvokeResponses[0].pageResponse.label}
    #{$flowResp.mapElementInvokeResponses[0].pageResponse.pageComponentDataResponses[0].content}
    
    
    - if ($flowResp.mapElementInvokeResponses[0].outcomeResponses != nil)
      %form(action='/execute' method='POST')
    
        - $flowResp.mapElementInvokeResponses[0].outcomeResponses.each do |outcomeresponse|
          %input(type='radio' name='steps' value='#{outcomeresponse.developerName.to_s()}')
            #{outcomeresponse.developerName.to_s()+": "+outcomeresponse.label.to_s()}
        %input(type='submit')
    - else
      %a(href='/run') Run a new flow!
  - else
    Something went wrong :(<br>
    Do you need to login to the flow?