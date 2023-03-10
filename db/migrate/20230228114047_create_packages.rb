class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :version, null: false
      t.string :title
      t.string :r_version
      t.jsonb :dependencies
      t.jsonb :authors
      t.jsonb :maintainers
      t.datetime :publication_date
      t.string :licence

      t.datetime :indexed_at, null: false
      t.timestamps
    end
  end
end
