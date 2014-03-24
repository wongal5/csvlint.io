class LocalDataset < DataKitten::Dataset
  extend DataKitten::PublishingFormats::Datapackage

  def origin
    :local
  end
  
  def publishing_format
    :datapackage
  end
end

class Package
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :dataset, type: String
  field :type, type: String

  has_many :validations

  def parse_package(dataset, validations)
    attributes = {
      :url => dataset.origin == :local ? nil : dataset.access_url,
      :dataset => Marshal.dump(dataset),
      :validations => validations,
      :type => dataset.publishing_format
    }

    return attributes
  end

  def create_package(sources, schema_url = nil, schema = nil)
    return nil if sources.count == 0    
    
    if sources.first.class == Hash
      sources.map! { |io| 
        {
          :body => Mongoid::GridFs.get(io[:csv_id]).data,
          :csv_id => io[:csv_id],
          :filename => io[:filename]
        }  
      }
    end
            
    if sources.count == 1 && possible_package?(sources.first)
      dataset = create_dataset(sources.first)
      return create_datapackage(dataset) unless dataset.nil?
    end    

    update_attributes({ type: set_type(sources) })

    sources.each do |source|
      validations << Validation.create_validation(source, schema_url, schema)
    end
  
    save
    self
  end
  
  def create_dataset(source)
    if source.respond_to?(:body)
      dataset = LocalDataset.new(access_url: source.string_io)
    else
      dataset = DataKitten::Dataset.new(access_url: source)
    end
    return nil unless [:ckan, :datapackage].include? dataset.publishing_format
    dataset
  end
  
  def create_datapackage(dataset)  
    validations = create_validations(dataset)
    
    return nil if validations.count == 0
    
    update_attributes( parse_package(dataset, validations) )
    save
    self
  end
  
  def create_validations(dataset)
    validations = []
    dataset.distributions.each do |distribution|
      if can_validate?(distribution)
        validations << Validation.create_validation(distribution.access_url, nil, create_schema(distribution) )
      end
    end
   validations
  end
  
  def possible_package?(source)
    source.class == String || local_package?( source )
  end
  
  def local_package?(source)
    source.respond_to?(:string_io) && source.filename =~ /datapackage\.json/
  end  
  
  def set_type(sources)
    return "files" if sources.first.respond_to?(:tempfile) 
    return "urls" if sources.first.class == String
  end

  def can_validate?(distribution)
    return false unless distribution.format.extension == :csv
    return distribution.access_url && distribution.access_url =~ /^http(s?)/
  end

  def create_schema(distribution)
    unless distribution.schema.nil?
      schema = Csvlint::Schema.from_json_table(nil, distribution.schema) 
    end
    return schema
  end

end