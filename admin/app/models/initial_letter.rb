class InitialLetter
  include ActiveModel::Model

  using StringEx

  INITIAL_LETTER_LIST = %w[symbol number hiragana katakana kanji alphabet other].freeze

  KIND = %w[symbol number hiragana katakana kanji alphabet].freeze
  KANA = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをん'.freeze
  KANA_LIST = KANA.chars
  ALPHABET_LIST = ('A'..'Z').to_a
  LIST = KANA_LIST + ALPHABET_LIST

  def self.select_initial_letter(name)
    detail = ''
    case name
    when /\A\d/
      type = 'number'
    when /\A\p{hiragana}/
      type = 'hiragana'
      detail = name.to_seion.first
    when /\A\p{katakana}/
      type = 'katakana'
      detail = name.to_seion.first.to_hiragana
    when /\A[一-龠]/
      type = 'kanji'
    when /\A[a-zA-Zａ-ｚＡ-Ｚ]/
      type = 'alphabet'
      detail = name.tr('ａ-ｚＡ-Ｚ', 'a-zA-Z').first.upcase
    else
      type = 'symbol'
    end
    [type, detail]
  end
end
