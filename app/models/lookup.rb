#TODO - add i18n
class Lookup < CouchRest::Model::Base
  use_database :lookup

  include PrimeroModel

  property :name
  property :description
  property :lookup_values, :type => [String]

  design do
    view :by_name,
            :map => "function(doc) {
                if ((doc['couchrest-type'] == 'Lookup') && doc['name']) {
                  emit(doc['name'], null);
                }
            }"
  end

  validates_presence_of :name, :message => "Name must not be blank"
  validates_presence_of :lookup_values, :message => I18n.t("errors.models.lookup.value_presence")
  validate :is_name_unique, :if => :name

  before_save :generate_id

  class << self
    extend Memoist

    def find_by_name(name)
      Lookup.by_name(:key => name).first
    end
    memoize :find_by_name

    def lookup_id_from_name(name)
      "lookup-#{name}".parameterize.dasherize
    end
    memoize :lookup_id_from_name

    def values(name, lookups = nil)
      if lookups.present?
        lookup = lookups.select {|lkp| lkp['name'] == name}.first
      else
        lookup = self.find_by_name(name)
      end
      lookup.present? ? lookup.lookup_values : []
    end
    memoize :values
  end

  def sanitize_lookup_values
    self.lookup_values.reject! { |value| value.blank? } if self.lookup_values
  end

  def is_name_unique
    lookup = Lookup.find_by_name(name)
    return true if lookup.nil? or self.id == lookup.id
    errors.add(:name, I18n.t("errors.models.lookup.unique_name"))
  end

  def valid?(context = :default)
    self.name = self.name.try(:titleize)
    sanitize_lookup_values
    super(context)
  end

  def generate_id
    self["_id"] ||= Lookup.lookup_id_from_name self.name
  end

end

