ENV["RAILS_ENV"] = "test"

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib')) #add lib folder to path
$:.unshift(File.expand_path(File.dirname(__FILE__))) #add test folder to path

require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_controller/test_case'
require 'action_controller/test_process'

require 'memorize/support'    #mocks and necessary Rails setup
require 'memorize'
require 'memorize/initialize'  #simulates a rails initialize file
