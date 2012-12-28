class Visit < ActiveRecord::Base
  attr_accessible :link_id
  belongs_to :link, counter_cache: true
end
