class TripImage < Image

  image_accessor :attachment do
    storage_path { |a| "trip/images/#{rand(100)}_#{a.name}" }
  end

end