class GithubUser
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :name, :string

  validates_presence_of :id, :name
end
