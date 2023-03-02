class ParseDcf
  CHAR_DETECTION_CONFIDENCE = 0.5
  ENCODINGS_TO_CONVERT = %w[ISO-8859-2]

  # rubocop:disable Metrics/AbcSize
  def call(dcf_content)
    dcf_content.split("\n").inject({}) do |hash, line|
      if line[':']
        line_parts = line.split(':').map(&:strip)
        hash.merge({ line_parts.first.gsub('/', '').to_sym => fix_encoding(line_parts.last) })
      else
        hash.merge({ hash.keys.last => hash[hash.keys.last] + fix_encoding(line.strip) })
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def fix_encoding(dcf_content)
    detection_result = CharDet.detect(dcf_content)

    if detection_result['confidence'] > CHAR_DETECTION_CONFIDENCE && detection_result['encoding'].in?(ENCODINGS_TO_CONVERT)
      dcf_content.encode('UTF-8', detection_result['encoding'])
    else
      dcf_content.encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace, replace: '')
    end
  end
end
