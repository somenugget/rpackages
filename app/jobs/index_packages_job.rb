class IndexPackagesJob < ApplicationJob
  def perform(*)
    IndexPackages.new.call
  end
end
