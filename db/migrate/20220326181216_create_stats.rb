class CreateStats < ActiveRecord::Migration[7.0]
  def change
    create_table :stats, id: :uuid do |t|
      t.string :name
      t.date :date
      t.jsonb :data
    end

    add_index :stats, %i[name]
  end
end
