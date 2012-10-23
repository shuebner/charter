class TripImage < Image

  image_accessor :attachment do
    storage_path { |a| "trip/#{rand(100)}_#{a.name}" }
  end

end