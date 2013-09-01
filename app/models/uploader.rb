class Uploader < ActiveRecord::Base
  has_many :images

  accepts_nested_attributes_for :images
  before_validation :format_attributes, on: [:create, :update]

  validates_presence_of :name, message:"Nombre es campo requerido."
  validates_presence_of :lastname, message:"Apellido(s) es campo requerido."

  validates :email,
          :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_nil=>false, message:"Email invalido." }


  protected
  def format_attributes
    ['name', 'lastname'].each do |name|
      name = name.to_sym
      self[name] = self[name].titleize
    end
    ['email'].each do |name|
      name = name.to_sym
      self[name] = self[name].downcase
    end
  end

end
