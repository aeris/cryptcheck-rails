class Stat < ApplicationRecord
  def self.create!(name, data, date = Date.today)
    self.delete_by name: name, date: date
    super name: name, date: date, data: data
  end

  def self.[](name)
    self.where(name: name).order(date: :desc).limit(1).first
  end
end
