class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :visits_count
      t.string :disponible
      t.string :tamano
    end
  end
end
