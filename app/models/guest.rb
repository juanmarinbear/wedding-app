class Guest < ActiveRecord::Base
  DISHES = ['pato', 'res']

  before_validation :format_attributes, on: [:create, :update]

  has_one :guest, class_name: 'Guest', foreign_key: 'companion_id'
  belongs_to :companion, class_name: 'Guest', dependent: :destroy

  validates_presence_of :name, message:"Nombre es campo requerido."
  validates_presence_of :lastname, message:"Apellido(s) es campo requerido."

  validates_numericality_of :mobile, greater_than:0, :only_integer =>true, message:"Celular invalido"
  validates :mobile, length: { minimum: 10, maximum: 10, message:"Formato de 10 digitos." }

  validates :email,
          :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_nil=>false, message:"Email invalido." }

  validates :dish, inclusion: {in:DISHES,message:"Selecciona un platillo."}


  accepts_nested_attributes_for :companion, allow_destroy: true


  def self.dishes
    [['Platillo','platillo'],['Pato','pato'], ['Res','res']]
  end

  protected
  def format_attributes
    ['name', 'lastname'].each do |name|
      name = name.to_sym
      self[name] = self[name].titleize
    end
    ['email','facebook', 'twitter', 'instagram'].each do |name|
      name = name.to_sym
      self[name] = self[name].downcase
    end
  end



end
