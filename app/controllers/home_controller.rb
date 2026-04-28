class HomeController < ApplicationController
  def index
    @ruby_version = RUBY_VERSION
    @rails_version = Rails.version
    @environment = Rails.env
    @uptime = uptime
    @db_connected = db_connected?
  end

  private

  def uptime
    seconds = Process.clock_gettime(Process::CLOCK_MONOTONIC).to_i
    hours   = seconds / 3600
    minutes = (seconds % 3600) / 60
    "#{hours}h #{minutes}m"
  end

  def db_connected?
    ActiveRecord::Base.connection.execute("SELECT 1")
    true
  rescue StandardError
    false
  end
end
