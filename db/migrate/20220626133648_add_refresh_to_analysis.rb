class AddRefreshToAnalysis < ActiveRecord::Migration[7.0]
  def up
    add_column :analyses, :refresh_at, :timestamp

    delay = Rails.configuration.refresh_delay
    progress = ProgressBar.create total: Analysis.count, format: '%t (%c/%C) %W %e'
    Analysis.all.each do |analysis|
      analysis.update_column :refresh_at, analysis.updated_at + delay
      progress.increment
    end
  end

  def down
    remove_column :analyses, :refresh_at
  end
end
