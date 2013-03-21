class CompositeTripImage < Image
  image_accessor :attachment do
    storage_path { |a| "composite_trip/images/#{rand(100)}_#{a.name}" }
  end
end
