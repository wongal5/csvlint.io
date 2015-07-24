class EmbeddedObject


  include Mongoid::Document
  include Mongoid::Timestamps

  field :filename, type: String
  field :url, type: String
  field :state, type: String
  field :result
  # by leaving this blank Mongoid should store as an object by default, but will only access the attr_reader vals
  field :csv_id, type: String
  index :created_at => 1

  belongs_to :schema
  accepts_nested_attributes_for :schema

  belongs_to :package

  def self.create_validation(io, schema_url = nil, schema = nil)
    if io.class == String
      validation = EmbeddedObject.find_or_initialize_by(url: io)
    else
      validation = EmbeddedObject.create
    end
    # either `create` of `find_or_initialize_by` methods creates (and saves) the Validation model
    # (and to MongoDB) - the IO params will be saved
    begin
      validation.validate(io, schema_url, schema, expiry)
    rescue NoMethodError
      # byebug
      puts validation.class
    end

    validation
  end

  def validate(io, schema_url = nil, schema = nil, expiry)
    validation = EmbeddedObject.validate(io, schema_url, schema, nil) # invokes self.validate, makes even more instance variables available
    self.update_attributes(validation)
  end

  def self.validate(io, schema_url = nil, schema = nil, dialect = nil)
    if io.class == Hash && !io[:body].nil?
      filename = io[:filename]
      io = StringIO.new(io[:body])
    end
    # Validate
    validator = Csvlint::Validator.new( io, dialect, schema && schema.fields.empty? ? nil : schema )
    # check_schema(validator, schema) unless schema_url.blank?
    # check_dialect(validator, dialect) unless dialect.blank?
    state = "valid"
    state = "warnings" unless validator.warnings.empty?
    state = "invalid" unless validator.errors.empty?
    state = "not_found" unless validator.errors.select { |e| e.type == :not_found }.empty?

    if io.class == String
      # It's a url!
      url = io
      filename = File.basename(URI.parse(url).path)
      csv_id = nil
    else
      # It's a file!
      puts "this was not the spec you were looking for"
    end

    attributes = {
        :url => url,
        :filename => filename,
        :state => state,
        :result => validator
    }

    if schema_url.present?
      # Find matching schema if possible
      schema = Schema.where(url: schema_url).first
      attributes[:schema] = schema || { :url => schema_url }
    end
    attributes
  end

end