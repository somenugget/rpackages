class GetExistingPackages
  PACKAGES_FILE_URL = 'https://cran.r-project.org/src/contrib/PACKAGES'.freeze

  def call
    HTTParty.get(PACKAGES_FILE_URL).body.split("\n\n").map do |package|
      parse_package(package)
    end
  end

  private

  def parse_package(package)
    package.split("\n").inject({}) do |hash, line|
      if line[': ']
        line_parts = line.split(': ')
        hash.merge({ line_parts.first.to_sym => line_parts.last })
      else
        hash.merge({ hash.keys.last => hash[hash.keys.last] + line.strip })
      end
    end
  end
end
