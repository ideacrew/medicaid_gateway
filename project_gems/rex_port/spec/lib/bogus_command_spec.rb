require "spec_helper"
require "rex_port"

require "spec_helper"

require "rex_port"

describe RexPort, "given a bogus command" do
  let(:command) { "3142fdsgsdfgsruby instant_death.rb" }

  let(:child_config) do
    RexPort::ChildConfig.new(
      command,
      ".",
      10
    )
  end

  let(:message) { "PING!" }

  let(:child) do
    RexPort::Child.new(
      child_config,
      true
    )
  end

  it "raises a read error" do
    expect { child.request(message) }.to raise_error(RexPort::Errors::StartupError)
  end
end