# frozen_string_literal: true

describe GetPackageDetailedInfo do
  it 'downloads and unpacks data' do
    File.open('spec/files/A3_1.0.0.tar.gz', 'rb') do |file|
      allow(HTTParty).to receive(:get).and_return(OpenStruct.new(body: file.read))
    end

    expect(described_class.new.call(name: 'A3', version: '1.0.0')).to eq({
      Author: 'Scott Fortmann-Roe',
      Date: '2015-08-15',
      DatePublication: '52',
      Depends: 'R (>= 2.15.0), xtable, pbapply',
      Description: 'Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.',
      License: 'GPL (>= 2)',
      Maintainer: 'Scott Fortmann-Roe <scottfr@berkeley.edu>',
      NeedsCompilation: 'no',
      Package: 'A3',
      Packaged: '33 UTC; scott',
      Repository: 'CRAN',
      Suggests: 'randomForest, e1071',
      Title: 'Accurate, Adaptable, and Accessible Error Metrics for PredictiveModels',
      Type: 'Package',
      Version: '1.0.0'
    })
  end
end
