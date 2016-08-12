class Lab < ApplicationRecord

  # Associations

  has_many :lab_user_links, :dependent => :destroy
  has_many :users, :through => :lab_user_links

  has_many :contacts,      :dependent => :destroy
  has_many :organizations, :dependent => :destroy

  # Validations

  validates :name, :presence   => { :message => "Le nom est obligatoire."  },
                   :uniqueness => { :message => "Ce nom est déjà utilisé." }

  # Callbacks

  before_save do
    self.slug = name.parameterize
  end

  # Methods

  def to_param
    slug
  end

end