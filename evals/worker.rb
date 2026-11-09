# tinyeval worker: builds the client once, then answers each input up to a NUL byte.
require_relative "../lib/support"

# Failures that say nothing about the reply: no key or a bad one, rate limits, 5xx, timeouts, network.
COULDNT_RUN = [
  Anthropic::Errors::AuthenticationError,
  Anthropic::Errors::RateLimitError,
  Anthropic::Errors::InternalServerError,
  Anthropic::Errors::APIConnectionError
].freeze

support = Support.new
$stdout.sync = true
while (input = $stdin.gets("\0"))
  reply =
    begin
      support.answer(input.chomp("\0"))
    rescue *COULDNT_RUN => e
      "#tinyeval couldnt_run #{e.class.name.split("::").last}#{" #{e.status}" if e.status}\n"
    end
  print reply, "\0"
end
