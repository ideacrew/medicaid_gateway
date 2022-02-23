# frozen_string_literal: true

# RAILS_ENV=production bundle exec rake permissions:dc
# RAILS_ENV=production bundle exec rake permissions:me
# RAILS_ENV=production bundle exec rake permissions:set_role_and_permissions email="admin@ideacrew.com" role='super_admin'

namespace :permissions do
  desc 'set DC permissions'
  task :dc => :environment do
    puts ":::: Setting Permissions ::::"
    # hbx_staff
    Permission
      .find_or_initialize_by(name: 'hbx_staff')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)
    # hbx_read_only
    Permission
      .find_or_initialize_by(name: 'hbx_read_only')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # hbx_csr_supervisor
    Permission
      .find_or_initialize_by(name: 'hbx_csr_supervisor')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # hbx_csr_tier1
    Permission
      .find_or_initialize_by(name: 'hbx_csr_tier1')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: true)

    # hbx_csr_tier2
    Permission
      .find_or_initialize_by(name: 'hbx_csr_tier2')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # hbx_tier3
    Permission
      .find_or_initialize_by(name: 'hbx_tier3')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # developer
    Permission
      .find_or_initialize_by(name: 'developer')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)
    # super_admin
    Permission
      .find_or_initialize_by(name: 'super_admin')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: true)

    puts ":::: Permissions Set ::::"
  end

  task :me => :environment do
    puts ":::: Setting Permissions ::::"
    # hbx_staff
    Permission
      .find_or_initialize_by(name: 'hbx_staff')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)
    # hbx_read_only
    Permission
      .find_or_initialize_by(name: 'hbx_read_only')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # hbx_csr_supervisor
    Permission
      .find_or_initialize_by(name: 'hbx_csr_supervisor')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # hbx_csr_tier1
    Permission
      .find_or_initialize_by(name: 'hbx_csr_tier1')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: true)

    # hbx_csr_tier2
    Permission
      .find_or_initialize_by(name: 'hbx_csr_tier2')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # hbx_tier3
    Permission
      .find_or_initialize_by(name: 'hbx_tier3')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)

    # developer
    Permission
      .find_or_initialize_by(name: 'developer')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: false)
    # super_admin
    Permission
      .find_or_initialize_by(name: 'super_admin')
      .update_attributes(can_view_transfer_summary: true, can_view_transfers_sent: true, can_view_transfers_received: true,
                         can_view_determinations: true, can_view_mec_checks: true, can_pull_irs_consent: true)
    puts ":::: Permissions Set ::::"
  end

  task :set_role_and_permissions => :environment do
    role = ENV['role']
    email = ENV['email']
    valid_kinds = ::Permission::KINDS

    abort "Error: Email is missing" if email.blank?
    abort "Error: Role is missing" if role.blank?

    puts ":::: Setting Role and Permission for - #{email} - #{role}::::"

    user = User.where(email: email).first

    abort "Error: user not found with given email: #{email}" if user.blank?
    abort "Error: #{role} is unknown. Valid roles are - #{valid_kinds}" unless valid_kinds.include? role

    permission = Permission.where(name: role).first

    if permission.blank?
      abort "Error: No permission found with role: #{role}. Try after running rake RAILS_ENV=production bundle exec rake permissions:<client>"
    end

    if user.hbx_staff_role.blank?
      if user.create_hbx_staff_role(is_active: true, subrole: role, permission_id: permission.id)
        puts "Succesfully Created #{role}"
      else
        puts "Failed to create staff role with errors: #{user.errors.full_messages}"
      end
    else
      user.hbx_staff_role.update_attributes!(permission_id: permission.id)
      puts "Succesfully Updated to #{role}"
    end
  end
end
