class AddTypeToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_admin, :boolean, default: false
  end
end
