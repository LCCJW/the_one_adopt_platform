class CreateLuckyAnimals < ActiveRecord::Migration[6.0]
  def change
    create_table :lucky_animals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :animal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
