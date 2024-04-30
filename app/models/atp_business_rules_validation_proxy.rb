# frozen_string_literal: true

# Proxies to a shelled-out java validator for the schematron rules.
# Nokogiri is based on libxml2 - which currently doesn't support the needed
# protocols for schematron.
#
# The jar itself lives in lib/atp_validator-0.1.0-jar-with-dependencies.jar.
# The repository for the code is: https://github.com/ideacrew/atp_validator
class AtpBusinessRulesValidationProxy
  WORKING_DIRECTORY = File.expand_path(Rails.root).freeze

  def self.boot!(count = 5)
    config = RexPort::ChildConfig.new(
      "RUBYOPT=\"-W0\" java -jar lib/atp_validator-0.3.0-jar-with-dependencies.jar",
      WORKING_DIRECTORY
    )
    @pool = Pond.new(:maximum_size => count, :timeout => 3, :eager => true) do
      RexPort::Child.new(config, true)
    end
  end

  def self.run_validation(data)
    @pool.checkout do |port|
      port.request(data)
    end
  end
end
