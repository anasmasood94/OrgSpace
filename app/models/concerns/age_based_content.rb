module AgeBasedContent
  extend ActiveSupport::Concern

  def age_appropriate_content_for(user)
    case user.age
    when 0..12
      content_for_children
    when 13..17
      content_for_teens
    else
      content_for_adults
    end
  end

  private

  def content_for_children
    # Implement child-appropriate content filtering
    "Content suitable for children under 13"
  end

  def content_for_teens
    # Implement teen-appropriate content filtering
    "Content suitable for teenagers (13-17)"
  end

  def content_for_adults
    # Implement adult content
    "Content suitable for adults (18+)"
  end
end