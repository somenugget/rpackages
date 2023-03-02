class GetAllPackagesInfo
  PACKAGES_FILE_URL = 'https://cran.r-project.org/src/contrib/PACKAGES'.freeze

  def call
    HTTParty.get(PACKAGES_FILE_URL).body.split("\n\n").map do |package|
      ParseDcf.new.call(package)
    end
  end
end
