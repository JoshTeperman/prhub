class PullRequest
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :github_id, :integer
  attribute :title, :string
  attribute :repo, :string
  attribute :url, :string
  attribute :repo_url, :string
  attribute :created_at, :datetime
  attribute :state, :string
  attribute :draft, :boolean
  attribute :user, :string
  attribute :file_count, :integer
  attribute :comments, :integer
  attribute :additions, :integer
  attribute :deletions, :integer

  alias_method :draft?, :draft

  def closed?
    state == 'closed'
  end
end
