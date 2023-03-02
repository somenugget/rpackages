class IndexPackages
  REINDEXING_THRESHOLD = 5.days

  def call
    remove_non_existing_packages

    packages_info.each do |package_info|
      IndexPackage.new.call(package_info) if should_reindex?(package_info)
    end
  end

  private

  def remove_non_existing_packages
    packages_to_remove = existing_packages.keys - packages_info.map { |package_info| package_info[:Package] }

    Package.where(name: packages_to_remove).destroy_all
  end

  def should_reindex?(package_info)
    existing_packages[package_info[:Package]].blank? ||
      existing_packages[package_info[:Package]] < REINDEXING_THRESHOLD.ago
  end

  def packages_info
    @packages_info ||= GetAllPackagesInfo.new.call
  end

  def existing_packages
    @existing_packages ||= Package.all.pluck(:name, :indexed_at).to_h
  end
end
