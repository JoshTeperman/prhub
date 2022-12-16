class CommentsChannel < ApplicationCable::Channel
  def subscribed
    require 'pry';binding.pry
    stream_for Current.user
  end
end
