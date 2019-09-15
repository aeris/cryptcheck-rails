class CreateAnalyses < ActiveRecord::Migration[5.2]
	def change
		create_table :analyses, id: :uuid do |t|
			t.string :service, null: false
			t.string :host, null: false
			t.integer :port
			t.boolean :pending, null: false, default: true
			t.jsonb :result

			t.timestamps
		end

		add_index :analyses, %i[service host port], unique: true
	end
end
