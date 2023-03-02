# frozen_string_literal: true

describe IndexPackage do
  let(:package_info) do
    {
      Package: 'test',
      Version: '1.0.0',
      Depends: 'R (>= 3.6.0), test2'
    }
  end

  let(:detailed_package_info) do
    {
      Author: 'Author',
      Maintainer: 'Maintainer',
      DatePublication: '2022-01-01',
      License: 'License'
    }
  end

  before do
    allow(GetPackageDetailedInfo).to receive(:new).and_return(double(call: detailed_package_info))
  end

  it 'creates new package' do
    aggregate_failures do
      expect { described_class.new.call(package_info) }.to change(Package, :count).by(1)

      package = Package.last

      expect(package.name).to eq('test')
      expect(package.version).to eq('1.0.0')
      expect(package.r_version).to eq('R (>= 3.6.0)')
      expect(package.dependencies).to eq(['test2'])
      expect(package.authors).to eq(['Author'])
      expect(package.maintainers).to eq(['Maintainer'])
      expect(package.licence).to eq('License')
      expect(package.publication_date).to eq(detailed_package_info[:DatePublication].to_date)
      expect(package.indexed_at).to be_present
    end
  end

  context 'when package already exists' do
    let!(:package) { Package.create!(name: 'test', version: '0.9', indexed_at: 1.day.ago) }

    it 'does not create new package' do
      expect { described_class.new.call(package_info) }.not_to change(Package, :count)
    end

    fit 'updates existing package' do
      aggregate_failures do
        expect { described_class.new.call(package_info) }.to change { package.reload.indexed_at }

        expect(package.name).to eq('test')
        expect(package.version).to eq('1.0.0')
        expect(package.r_version).to eq('R (>= 3.6.0)')
        expect(package.dependencies).to eq(['test2'])
        expect(package.authors).to eq(['Author'])
        expect(package.maintainers).to eq(['Maintainer'])
        expect(package.licence).to eq('License')
        expect(package.publication_date).to eq(detailed_package_info[:DatePublication].to_date)
      end
    end
  end
end
