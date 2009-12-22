class String
  def check_every(time_interval, &block)
    Boatman.tasks ||= Array.new
    Boatman.tasks << {
      :time_interval => time_interval,
      :block => block,
      :directory => Boatman::MonitoredDirectory.new(self)
    }
  end
end
