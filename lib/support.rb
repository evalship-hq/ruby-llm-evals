require "anthropic"

# A web shop's support bot: one Claude call per customer message.
class Support
  PROMPT = File.read(File.expand_path("../prompts/support.md", __dir__))

  def initialize(client: Anthropic::Client.new) # reads ANTHROPIC_API_KEY
    @client = client
  end

  def answer(message)
    reply = @client.messages.create(
      model: :"claude-opus-5-5",
      max_tokens: 1024,
      output_config: { effort: :low }, # Opus 5.5 always thinks; a short reply needs little
      system_: PROMPT,
      messages: [{ role: "user", content: message }]
    )
    reply.content.select { _1.type == :text }.map(&:text).join
  end
end
