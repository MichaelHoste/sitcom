class RenameContactTagLinksToItemTagLinks < ActiveRecord::Migration[5.0]
  def change
    rename_table :contact_tag_links, :item_tag_links

    add_column    :item_tag_links, :item_type,  :string,  :after => :contact_id, :default => 'Contact', :index => true
    rename_column :item_tag_links, :contact_id, :item_id
  end
end
