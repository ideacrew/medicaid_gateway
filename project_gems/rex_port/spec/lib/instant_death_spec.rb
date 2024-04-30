require "spec_helper"
require "rex_port"

require "spec_helper"

require "rex_port"

describe RexPort, "given a poorly behaved program, named instant_death.rb" do
  let(:command) { "ruby instant_death.rb" }
  let(:dir) do
    File.expand_path(
      File.join(
        File.dirname(__FILE__),
        "..",
        "example_programs"
      )
    )
  end

  let(:child_config) do
    RexPort::ChildConfig.new(
      command,
      dir
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
    expect { child.request(message) }.to raise_error(RexPort::Errors::ResponseReadError)
  end
end