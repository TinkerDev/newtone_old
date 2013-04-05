class CreateVkTokens < ActiveRecord::Migration
  def change
    create_table :vk_tokens do |t|
      t.string :access_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
