class BlogEntryImage < Image

  image_accessor :attachment do
    storage_path { |a| "blog_entry/images/#{rand(100)}_#{a.name}" }
  end

end