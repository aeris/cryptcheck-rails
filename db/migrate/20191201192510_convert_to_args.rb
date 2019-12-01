class ConvertToArgs < ActiveRecord::Migration[5.2]
  def self.up
    add_column :analyses, :args, :jsonb, after: :host
    Analysis.all.each { |a| a.update! args: { port: a.port }.compact }
    add_index :analyses, %i[service host args], unique: true
    remove_column :analyses, :port
  end

  def self.down
    add_column :analyses, :port, :integer
    Analysis.all.each { |a| a.update! port: a.args }
    remove_column :analyses, :args
    add_index :analyses, %i[service host port], unique: true
  end
end
