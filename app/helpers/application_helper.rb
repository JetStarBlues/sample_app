module ApplicationHelper

	# Lesson 22 @ 5:00 - something to do with title page
	# Return a title on a per-page basis
	def title
		base_title = "RoR Sample App"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
end
