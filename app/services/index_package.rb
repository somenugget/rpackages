# frozen_string_literal: true

class IndexPackage
  def call(package_info)
    name = package_info[:Package]
    version = package_info[:Version]

    detailed_package_info = GetPackageDetailedInfo.new.call(name: name, version: version)
    full_package_info = { **package_info, **detailed_package_info }

    package = Package.find_or_initialize_by(name: full_package_info[:Package])
    package.update!(package_attributes(full_package_info))
  end

  private

  def package_attributes(package_info)
    r_version, dependencies = extract_dependencies(package_info[:Depends])

    {
      r_version: r_version,
      dependencies: dependencies,
      authors: package_info[:Author]&.split(','),
      maintainers: package_info[:Maintainer]&.split(','),
      title: package_info[:Title],
      version: package_info[:Version],
      publication_date: package_info[:DatePublication],
      licence: package_info[:License],
      indexed_at: DateTime.current
    }
  end

  def extract_dependencies(depends)
    return [nil, []] if depends.blank?

    r_version, dependencies = depends.split(',').map(&:strip).partition { |dependency| dependency.start_with?('R') }

    [r_version.first, dependencies]
  end
end
