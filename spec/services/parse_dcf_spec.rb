# frozen_string_literal: true

describe ParseDcf do
  it 'parses DCT' do
    dcf = <<~DCF
      Package: test
      Version: 1.0.0
      Depends: R (>= 3.6.0), test2
      Imports: shiny (>= 1.2.0), ggplot2 (>= 3.0.0), gridExtra (>= 2.3.0),
              colourpicker, shinythemes, emojifont, rintrojs
    DCF

    expect(described_class.new.call(dcf)).to eq({
      Package: 'test',
      Version: '1.0.0',
      Depends: 'R (>= 3.6.0), test2',
      Imports: 'shiny (>= 1.2.0), ggplot2 (>= 3.0.0), gridExtra (>= 2.3.0),' \
        'colourpicker, shinythemes, emojifont, rintrojs'
    })
  end
end
