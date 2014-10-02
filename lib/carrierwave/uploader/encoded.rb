# encoding: utf-8

require 'open-uri'

module CarrierWave
  module Uploader
    module Encoded
      extend ActiveSupport::Concern

      include CarrierWave::Uploader::Callbacks
      include CarrierWave::Uploader::Configuration
      include CarrierWave::Uploader::Cache

      # define class that extends IO with methods that are required by carrierwave
      class CarrierStringIO < StringIO
        # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Create-random-and-unique-filenames-for-all-versioned-files
        def original_filename
           #"#{secure_token}.#{file.extension}" if original_filename.present?
           "#{secure_token}.jpg"
           #"base64file.jpg"
        end

        #TODO calculate image type from encoded string w/ imagemagick
        def content_type
          "image/jpg"
        end

        protected
        def secure_token
          #var = :"@#{mounted_as}_secure_token"
          #model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
          SecureRandom.uuid
        end

      end

      ##
      # Caches the file by decoding it from the given string.
      #
      # === Parameters
      #
      # [encoded64 (String)] The base64 representation of the file
      #
      def decode!(encoded64)
        io = CarrierStringIO.new(Base64.decode64(encoded64))
        
        cache!(io)
      end

    end # Encoded
  end # Uploader
end # CarrierWave
