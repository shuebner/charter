class BoatImage < Image

  image_accessor :attachment do
    storage_path { |a| "boat/images/#{rand(100)}_#{a.name}" }
  end

end