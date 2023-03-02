# frozen_string_literal: true

describe GetAllPackagesInfo do
  before do
    allow(HTTParty).to receive(:get).and_return(response)
  end

  let(:response) do
    OpenStruct.new(body: <<~DCF)
      Package: A3
      Version: 1.0.0
      Depends: R (>= 2.15.0), xtable, pbapply
      Suggests: randomForest, e1071
      License: GPL (>= 2)
      MD5sum: 027ebdd8affce8f0effaecfcd5f5ade2
      NeedsCompilation: no

      Package: abstractr
      Version: 0.1.0
      Imports: shiny (>= 1.2.0), ggplot2 (>= 3.0.0), gridExtra (>= 2.3.0),
              colourpicker, shinythemes, emojifont, rintrojs
      Suggests: knitr, rmarkdown
      License: GPL-3
      MD5sum: 696a9da933b8bc0bb4c93bedc2aa876b
      NeedsCompilation: no
    DCF
  end

  context 'when package have multiline imports' do
    let(:response) do
      OpenStruct.new(body: <<~DCF)
        Package: abstractr
        Version: 0.1.0
        Imports: shiny (>= 1.2.0), ggplot2 (>= 3.0.0), gridExtra (>= 2.3.0),
                colourpicker, shinythemes, emojifont, rintrojs
        Suggests: knitr, rmarkdown
        License: GPL-3
        MD5sum: 696a9da933b8bc0bb4c93bedc2aa876b
        NeedsCompilation: no
      DCF
    end

    it 'returns list of packages' do
      expect(described_class.new.call).to eq([{
        Package: 'abstractr',
        Version: '0.1.0',
        Imports: 'shiny (>= 1.2.0), ggplot2 (>= 3.0.0), gridExtra (>= 2.3.0),' \
          'colourpicker, shinythemes, emojifont, rintrojs',
        Suggests: 'knitr, rmarkdown',
        License: 'GPL-3',
        MD5sum: '696a9da933b8bc0bb4c93bedc2aa876b',
        NeedsCompilation: 'no'
      }])
    end
  end

  context 'when package has one line imports' do
    let(:response) do
      OpenStruct.new(body: <<~DCF)
        Package: A3
        Version: 1.0.0
        Depends: R (>= 2.15.0), xtable, pbapply
        Suggests: randomForest, e1071
        License: GPL (>= 2)
        MD5sum: 027ebdd8affce8f0effaecfcd5f5ade2
        NeedsCompilation: no
      DCF
    end

    it 'returns list of packages' do
      expect(described_class.new.call).to eq([{
        Package: 'A3',
        Version: '1.0.0',
        Depends: 'R (>= 2.15.0), xtable, pbapply',
        Suggests: 'randomForest, e1071',
        License: 'GPL (>= 2)',
        MD5sum: '027ebdd8affce8f0effaecfcd5f5ade2',
        NeedsCompilation: 'no'
      }])
    end
  end
end
