require 'dragonfly/cloudinary_data_store/version'
require 'cloudinary'

module Dragonfly
  class CloudinaryDataStore

    attr_reader :env_prefix

    def initialize(config = {})
      @env_prefix = config[:env_prefix] || false
    end

    def write(content, opts = {})
      options = {
        exif:          true,
        resource_type: :auto,
        foder:         env_prefix ? Rails.env : nil,
        public_id:     public_id(opts[:path])
      }

      result = ::Cloudinary::Uploader.upload(content.path, options)
      local_public_id("#{result['public_id']}.#{result['format']}")
    end

    def read(uid)
      url  = cloudinary_url(uid, format: ext(uid))
      data = ::Cloudinary::Downloader.download(url)

      return nil unless data

      begin
        resource_data = ::Cloudinary::Api.resource(public_id(uid), exif: true)
        [data, resource_data['exif']]
      rescue ::Cloudinary::Api::NotFound
        Dragonfly.warn("Image with uid #{public_id(uid)} not found on Cloudinary")
        nil
      end
    end

    def destroy(uid)
      ::Cloudinary::Uploader.destroy(public_id(uid))
    end

    def url_for(uid, options = {})
      options = { format: ext(uid) }.merge(options)
      cloudinary_url(uid, options)
    end

    private

    def cloudinary_url(uid, options)
      ::Cloudinary::Utils.cloudinary_url(public_id(uid), options)
    end

    def public_id(uid)
      cloudinary_public_id = env_prefix ? "#{Rails.env}/#{uid}" : uid
      Pathname.new(cloudinary_public_id).sub_ext('')
    end

    def local_public_id(id)
      env_prefix ? id.split('/')[1..-1].join('/') : id
    end

    def ext(uid)
      File.extname(uid).delete('.')
    end
  end
end
