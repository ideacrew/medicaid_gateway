# frozen_string_literal: true

require File.join(Rails.root, "lib/mongoid_migration_task")

# This class is used to swap the applicaiton wide configuration between different clients (I.E. DC to Maine)
class ClientConfigurationToggler < MongoidMigrationTask
  def system_config_target_folder
    "#{Rails.root}/system"
  end

  def target_config_folder
    "#{Rails.root}/config/client_config/#{@target_client_state_abbreviation}"
  end

  def old_config_folder
    "#{Rails.root}/config/client_config/#{@old_configured_state_abbreviation}"
  end

  def old_configured_state_abbreviation
    MedicaidGatewayRegistry[:state_abbreviation].item.downcase
  end

  def target_client_state_abbreviation
    missing_state_abbreviation_message = "Please set your target client as an arguement. " \
    "The rake command should look like:" \
    " RAILS_ENV=production bundle exec rake configuration:client_configuration_toggler client='me'"
    raise(missing_state_abbreviation_message) if ENV['client'].blank?
    incorrect_state_abbreviation_format_message = "Incorrect state abbreviation length. Set abbreviation to two letters like 'ME' or 'DC'"
    raise(incorrect_state_abbreviation_format_message) if ENV['client'].length > 2
    ENV['client'].downcase
  end

  def copy_target_configuration_to_system_folder
    target_configuration_files = Dir.glob("#{target_config_folder}/system/**/*.yml")
    raise("No configuration files present in target directory.") if target_configuration_files.blank?
    `rm -rf #{Rails.root}/system` if Dir.exist?("#{Rails.root}/system")
    `cp -r #{target_config_folder}/system #{Rails.root}`

    # No settings.yml needed in MG
    #   if File.exist?("#{target_config_folder}/config/settings.yml")
    #     puts("Settings.yml present for target configuration, setting it as current settings.")
    #   else
    #     puts("No settings.yml file present for target configuration")
    #   end
    #   `cp -r #{target_config_folder}/config/settings.yml config/settings.yml`
  end

  def copy_app_assets_and_straggler_files
    # Need to make this only return files
    target_configuration_files = Dir.glob("#{target_config_folder}/**/*").select { |e| File.file? e }
    target_configuration_files.reject { |file| file.include?('system') || file.include?('settings') }.each do |filename_in_config_directory|
      # Cut off the filename parts with config namespace
      puts("Swapping app assets and other straggler files.")
      actual_filename = filename_in_config_directory.sub("#{target_config_folder}/", '')
      `cp -r #{filename_in_config_directory} #{actual_filename}`
    end
  end

  def checkout_straggler_files
    straggler_files = Dir.glob("#{old_config_folder}/**/*").select { |e| File.file? e }
    # TODO: Deprecate settings and move this eventually
    straggler_files.reject { |file| file.include?('system') || file.include?('settings') }.each do |filename_in_config_directory|
      # Cut off the filename parts with config namespace
      puts("Checking out old config app assets and other straggler files.")
      filename_without_root = filename_in_config_directory.sub("#{old_config_folder}/", '')
      `git checkout #{filename_without_root}`
    end
  end

  def migrate
    @old_configured_state_abbreviation = old_configured_state_abbreviation
    @target_client_state_abbreviation = target_client_state_abbreviation
    copy_target_configuration_to_system_folder
    copy_app_assets_and_straggler_files
    checkout_straggler_files
    puts("Client configuration toggle complete system complete. features.yml file is now set to:")
    resource_registry_result = `cat system/config/templates/features/features.yml`
    puts(resource_registry_result[0..800])
    #   puts("Settings yml now set to:")
    #   settings_yml_result = `cat config/settings.yml`
    #   puts(settings_yml_result[0..400])
  end
end
