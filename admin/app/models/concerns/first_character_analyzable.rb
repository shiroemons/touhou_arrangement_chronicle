module FirstCharacterAnalyzable
  extend ActiveSupport::Concern

  included do
    # 列挙型の定義
    enum :first_character_type, {
      symbol: "symbol",
      number: "number",
      alphabet: "alphabet",
      hiragana: "hiragana",
      katakana: "katakana",
      kanji: "kanji",
      other: "other"
    }

    # バリデーション
    validates :first_character_type, presence: true
    validates :first_character, presence: true, if: -> { %w[alphabet hiragana katakana].include?(first_character_type) }
    validates :first_character_row, presence: true, if: -> { %w[hiragana katakana].include?(first_character_type) }

    before_validation :analyze_first_character
  end

  private

  def analyze_first_character
    return if name.blank?

    first_char = name[0]
    self.first_character_type = determine_character_type(first_char)

    case first_character_type
    when "alphabet", "hiragana", "katakana"
      self.first_character = first_char
    end

    if %w[hiragana katakana].include?(first_character_type)
      self.first_character_row = determine_character_row(first_char)
    end
  end

  def determine_character_type(char)
    case char
    when /\A[ぁ-ん]\z/
      "hiragana"
    when /\A[ァ-ン]\z/
      "katakana"
    when /\A[一-龯]\z/
      "kanji"
    when /\A[a-zA-Z]\z/
      "alphabet"
    when /\A[0-9]\z/
      "number"
    when /\A[!@#$%^&*(),.?":{}|<>]\z/
      "symbol"
    else
      "other"
    end
  end

  def determine_character_row(char)
    row_mappings = {
      hiragana: {
        "あ" => /\A[あいうえお]\z/,
        "か" => /\A[かきくけこ]\z/,
        "さ" => /\A[さしすせそ]\z/,
        "た" => /\A[たちつてと]\z/,
        "な" => /\A[なにぬねの]\z/,
        "は" => /\A[はひふへほ]\z/,
        "ま" => /\A[まみむめも]\z/,
        "や" => /\A[やゆよ]\z/,
        "ら" => /\A[らりるれろ]\z/,
        "わ" => /\A[わをん]\z/
      },
      katakana: {
        "あ" => /\A[アイウエオ]\z/,
        "か" => /\A[カキクケコ]\z/,
        "さ" => /\A[サシスセソ]\z/,
        "た" => /\A[タチツテト]\z/,
        "な" => /\A[ナニヌネノ]\z/,
        "は" => /\A[ハヒフヘホ]\z/,
        "ま" => /\A[マミムメモ]\z/,
        "や" => /\A[ヤユヨ]\z/,
        "ら" => /\A[ラリルレロ]\z/,
        "わ" => /\A[ワヲン]\z/
      }
    }

    mappings = first_character_type == "hiragana" ? row_mappings[:hiragana] : row_mappings[:katakana]
    mappings.find { |row, pattern| char.match?(pattern) }&.first || "その他"
  end
end
