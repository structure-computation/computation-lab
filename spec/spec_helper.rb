# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# require File.dirname(__FILE__) + "/factories"  

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true       
end

module ControllerSpecHelper

  # # get all actions for specified controller
  # # Take a symbol or a string. ie : :user for UserController
  # def get_all_actions(controller)
  #   controllerClass = Module.const_get(controller.to_s.pluralize.capitalize + "Controller")
  #   controllerClass.public_instance_methods(false).reject{ |action| action.match /_one_time_conditions/ }
  # end
  # 
  # # controller.class.public_instance_methods(false).reject{ |action| action.match /_one_time_conditions/ }
  # 
  # 
  # # test actions fail if not logged in
  # # opts[:exclude] contains an array of actions to skip
  # # opts[:include] contains an array of actions to add to the test in addition
  # # to any found by get_all_actions
  # def controller_actions_should_fail_if_not_logged_in(cont, opts={})
  #   except = opts[:except] || []
  #   actions_to_test  = get_all_actions(cont).reject{ |a| except.include?(a) }
  #   actions_to_test += opts[:include] if opts[:include]
  #   actions_to_test.each do |a|
  #   #puts "... #{a}"
  #   get a
  #   response.should_not be_success
  #   response.should redirect_to('http://test.host/login')
  #   flash[:warning].should == @login_warning
  # end
  
  # Prend en paramètre un workspace_member, un hash d'actions, ex {:show=>{:workspace_id=>3}} et un bloc
  # qui sera éxécuté après chaque action.
  def ws_member_for_theses_actions_and_get_param(ws_member, action)
    action.each do |action, params|
      get action, params
      yield(response)
    end
  end
  
  
  
  # Take an array of action name, a workspace member and for each a
  def controller_actions_alowed_for_workspace_member(ws_member, actions)
    ws_member_for_theses_actions_and_get_param ws_member, actions do |response|
      response.code.should eq("200")
      # response.should be :success
    end
  end

  # Exemples : 
  # eng = Factory.create(:engineer)
  # controller_actions_alowed_for_workspace_member(eng, {:index=>{:workspace_id=>3}, :show=>{}, :create=>{}, :new=>{}})
    
  
end