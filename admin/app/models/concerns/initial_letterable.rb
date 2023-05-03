module InitialLetterable
  extend ActiveSupport::Concern

  included do
    before_validation :set_initial_letter

    enum initial_letter_type: {
      symbol: 'symbol',
      number: 'number',
      hiragana: 'hiragana',
      katakana: 'katakana',
      kanji: 'kanji',
      alphabet: 'alphabet',
      other: 'other',
    }

    validates :initial_letter_type, inclusion: { in: InitialLetter::KIND }
    validates_each :initial_letter_detail do |record, attr, value|
      if record.initial_letter_type.in?(%w[hiragana katakana]) && !value&.start_with?(/[#{InitialLetter::KANA}]/o)
        record.errors.add(attr, 'is not kana')
      elsif record.initial_letter_type == 'alphabet' && !value&.start_with?(/[A-Z]/)
        record.errors.add(attr, 'is not alphabet')
      elsif record.initial_letter_type.in?(%w[symbol number kanji other]) && value.present?
        record.errors.add(attr, 'is invalid')
      end
    end
  end

  def set_initial_letter
    type, detail = InitialLetter.select_initial_letter(name)
    self.initial_letter_type = type
    self.initial_letter_detail = detail
  end
end
