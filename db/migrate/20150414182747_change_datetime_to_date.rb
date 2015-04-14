class ChangeDatetimeToDate < ActiveRecord::Migration
  def change
    remove_column :cats, :birth_date
    add_column :cats, :birth_date, :date
  end
end
