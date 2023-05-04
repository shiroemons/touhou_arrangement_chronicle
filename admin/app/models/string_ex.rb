module StringEx
  refine String do
    def to_hiragana
      tr('ァ-ン', 'ぁ-ん')
    end

    def to_katakana
      tr('ぁ-ん', 'ァ-ン')
    end

    def to_seion
      tr('ぁぃぅぇぉっゃゅょゎ', 'あいうえおつやゆよわ')
        .tr('がぎぐげござじずぜぞだぢづでどばびぶべぼ', 'かきくけこさしすせそたちつてとはひふへほ')
        .tr('ぱぴぷぺぽ', 'はひふへほ')
        .tr('ァィゥェォャュョヮ', 'アイウエオヤユヨワ')
        .tr('ヴガギグゲゴザジズゼゾダヂヅデドバビブベボ', 'ウカキクケコサシスセソタチツテトハヒフヘホ')
        .tr('パピプペポ', 'ハヒフヘホ')
    end
  end
end
