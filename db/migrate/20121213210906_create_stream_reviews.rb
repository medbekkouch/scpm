class CreateStreamReviews < ActiveRecord::Migration
  def self.up
    create_table  :stream_reviews do |t|
      t.integer   :stream_id
      t.integer   :review_type_id
      t.text      :text
      t.timestamps
    end
  end

  def self.down
    drop_table    :stream_reviews
  end
end
