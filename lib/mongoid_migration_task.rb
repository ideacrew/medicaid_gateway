# frozen_string_literal: true

require 'rake'

# Base class for client config toggler
class MongoidMigrationTask < Rake::Task
  def initialize(task_name, app)
    super(task_name, app)
    @actions << proc { self.migrate }
  end

  def self.define_task(*args, &blk)
    Rake.application.define_task(self, *args, &blk)
  end
end
