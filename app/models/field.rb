class Field < ApplicationRecord

  # Associations

  belongs_to :parent, :class_name => 'Field',
                      :optional   => true

  has_many :children, :class_name  => 'Field',
                      :foreign_key => :parent_id,
                      :dependent   => :destroy

  # Validations

  validates :name, :presence   => { :message => "Le nom est obligatoire."  },
                   :uniqueness => { :message => "Ce nom est déjà utilisé.", :scope => :parent_id }

  # Methods

  # Class Methods

  def self.root_options(allow_blank = false)
    options = where(parent_id: nil).order(:name).collect do |field|
      [ field.name, field.id ]
    end

    allow_blank ? [['', nil]] + options : options
  end
end