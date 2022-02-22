# frozen_string_literal: true

# Permission to set for roles.
class Permission
  include Mongoid::Document
  include Mongoid::Timestamps

  KINDS = %w[hbx_staff hbx_read_only hbx_csr_supervisor hbx_csr_tier1 hbx_csr_tier2 hbx_tier3 developer super_admin].freeze

  field :name, type: String

  field :can_view_transfer_summary,                type: Boolean, default: true
  field :can_view_transfers_sent,                  type: Boolean, default: true
  field :can_view_transfers_received,              type: Boolean, default: true
  field :can_view_determinations,                  type: Boolean, default: true
  field :can_view_mec_checks,                      type: Boolean, default: true
  field :can_pull_irs_consent,                     type: Boolean, default: false

  class << self
    def hbx_staff
      where(name: 'hbx_staff').first
    end

    def hbx_read_only
      where(name: 'hbx_read_only').first
    end

    def hbx_csr_supervisor
      where(name: 'hbx_csr_supervisor').first
    end

    def hbx_csr_tier1
      where(name: 'hbx_csr_tier1').first
    end

    def hbx_csr_tier2
      where(name: 'hbx_csr_tier2').first
    end

    def hbx_tier3
      where(name: 'hbx_tier3').first
    end

    def developer
      where(name: 'developer').first
    end

    def super_admin
      where(name: 'super_admin').first
    end
  end
end
