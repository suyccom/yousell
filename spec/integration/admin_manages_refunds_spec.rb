# encoding: UTF-8

require 'spec_helper'

feature 'The admin manages different kinds of refund situations:', :driver => :selenium do

  before do
    User.current_user = User.last
    login
  end

  scenario 'a client refunds an item and that\'s it' do
    # The admin goes to new sale (no lines)
    # The admin scans the product or type it in
    # The admin sets a negative ammount of that item
    # The admin sees that the sale button has changed (This a Refund or something like that)
    # The admin clicks on it and a refund ticket is generated (flash message with a link and the ticket is printed)
  end

  scenario 'a client refunds an item and buys another one (or more): client must pay' do
    # The admin goes to new sale (no lines)
    # The admin scans the products or type them in (the one being refunded and the new one)
    # The admin sets negative ammount on the refunded item
    # The total ammount is positive, so the client must pay (and the message of Sale button is the same as usual)
    # The ticket is printed and it has all the lines specified
  end

  scenario 'a client refunds an item and buys another one (or more): we are even' do
    # The admin goes to new sale (no lines)
    # The admin scans the products or type them in (the one being refunded and the new one)
    # The admin sets negative ammount on the refunded item
    # The total ammount is zero (and the message of Sale button is the same as usual)
    # The ticket is printed and it has all the lines specified
  end

  scenario 'a client refunds an item and buys another one (or more): the store must refund' do
    # Same as first scenario (this scenario should be removed then)
  end

  # Notes on this test to developers:
  # Scenarios 2 and 3 are like regular sales, so controller actions don't need to be changed.
  # Scenario 1 is a special sell. I guess that the best approach is to override all the controller actions, and just create a new refund ticket and print it.

end
