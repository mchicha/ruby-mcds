class ChangePublishToArchiveInMessagesTable < ActiveRecord::Migration
  def change
    rename_column :messages, :publish, :archived
  end
end
