module GadgetsHelper
  private
    MAX_IMAGE_SIZE = 400
  
    def set_image_dimensions
      begin
        geo = Paperclip::Geometry.from_file @gadget.image
      rescue Paperclip::Errors::NotIdentifiedByImageMagickError
        @image_height = @image_width = MAX_IMAGE_SIZE
      end

      if geo
        begin
          ratio = geo.height.to_f / geo.width.to_f
        ## I don't ever expect this to happen!
        rescue ZeroDivisionError
          @image_height = geo.height > MAX_IMAGE_SIZE ? 
                                  MAX_IMAGE_SIZE : geo.height
          @image_width = 0
        end

        if geo.height > MAX_IMAGE_SIZE || geo.width > MAX_IMAGE_SIZE
          if geo.height > geo.width
            @image_height = MAX_IMAGE_SIZE
            @image_width = MAX_IMAGE_SIZE / ratio
          else
            @image_height = MAX_IMAGE_SIZE * ratio
            @image_width = MAX_IMAGE_SIZE
          end
        else
          @image_height = geo.height
          @image_width = geo.width
        end
      else
        @image_height = @image_width = MAX_IMAGE_SIZE
      end
    end
end
