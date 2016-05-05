class Event < ActiveRecord::Base
	mount_uploader :event_image, ImageUploader
	enum category: ['NIGHTLIFE', 'SPORTS', "Others"]
	enum subcategories: ['DJ NIGHT', 'LADIES NIGHT', 'LIVE MUSIC', 'COMEDY', 'CRICKET', 'FOOTBALL']
end