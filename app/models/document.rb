class Document < Attachment
  
  file_accessor :attachment do
    storage_path { |a| "boat/documents/#{rand(100)}_#{a.name}" }
  end

  validates :type,
    presence: true
end