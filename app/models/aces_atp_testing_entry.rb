# frozen_string_literal: true

# A test payload submitted by ACES to us.  This is a stopgap measure for
# connectivity testing, and should be replaced by a proper large form of
# large object storage.
class AcesAtpTestingEntry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :payload, type: String
  field :result, type: String
end