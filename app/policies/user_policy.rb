# frozen_string_literal: true

# policy for user
class UserPolicy < ApplicationPolicy

  def transfer_summary?
    permission&.can_view_transfer_summary
  end

  def transfers_sent?
    permission&.can_view_transfers_sent
  end

  def transfers_received?
    permission&.can_view_transfers_received
  end

  def determinations?
    permission&.can_view_determinations
  end

  def mec_checks?
    permission&.can_view_mec_checks
  end

  def irs_content?
    permission&.can_pull_irs_consent
  end

  def permission
    user.permission
  end
end
