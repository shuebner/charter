class CaptainImage < Image

  image_accessor :attachment do
    storage_path { |a| "captain/images/#{rand(100)}_#{a.name}" }
  end

end