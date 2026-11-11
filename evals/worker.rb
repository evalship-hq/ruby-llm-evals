# tinyeval worker: builds the client once, then answers each test case.
# A 401, 429, 5xx, timeout or lost connection counts as couldn't run; any other error fails the eval.
require "tinyeval/worker" # before the app, so its output stays off the replies
require_relative "../lib/support"

support = Support.new
Tinyeval.worker { |input| support.answer(input) }
