require 'rubygems/package'


class GetPackageDetailedInfo
  PACKAGE_URL_TEMPLATE = 'https://cran.r-project.org/src/contrib/%<name>s_%<version>s.tar.gz'.freeze

  def call(name:, version:)
    gzipped_package = HTTParty.get(format(PACKAGE_URL_TEMPLATE, name: name, version: version)).body

    description = get_package_description(gzipped_package)

    ParseDcf.new.call(description)
  end

  def get_package_description(gzipped_package)
    package_reader = Zlib::GzipReader.new(StringIO.new(gzipped_package))
    unzipped_package = StringIO.new(package_reader.read)
    package_reader.close

    Gem::Package::TarReader.new(unzipped_package) do |tar|
      tar.each do |tarfile|
        return tarfile.read if tarfile.full_name.ends_with?('DESCRIPTION')
      end
    end
  end
end
