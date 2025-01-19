require "test_helper"

class FirstCharacterAnalyzableTest < ActiveSupport::TestCase
  def setup
    @circle = Circle.new(name: "テスト", slug: "test")
    @artist_name = ArtistName.new(name: "テスト", is_main_name: true)
  end

  test "カタカナの名前を正しく解析できること" do
    @circle.name = "テスト"
    @circle.valid?

    assert_equal "katakana", @circle.first_character_type
    assert_equal "テ", @circle.first_character
    assert_equal "た", @circle.first_character_row
  end

  test "ひらがなの名前を正しく解析できること" do
    @circle.name = "てすと"
    @circle.valid?

    assert_equal "hiragana", @circle.first_character_type
    assert_equal "て", @circle.first_character
    assert_equal "た", @circle.first_character_row
  end

  test "漢字の名前を正しく解析できること" do
    @circle.name = "東方"
    @circle.valid?

    assert_equal "kanji", @circle.first_character_type
    assert_nil @circle.first_character
    assert_nil @circle.first_character_row
  end

  test "アルファベットの名前を正しく解析できること" do
    @circle.name = "ZUN"
    @circle.valid?

    assert_equal "alphabet", @circle.first_character_type
    assert_equal "Z", @circle.first_character
    assert_nil @circle.first_character_row
  end

  test "数字の名前を正しく解析できること" do
    @circle.name = "4次元"
    @circle.valid?

    assert_equal "number", @circle.first_character_type
    assert_nil @circle.first_character
    assert_nil @circle.first_character_row
  end

  test "記号の名前を正しく解析できること" do
    @circle.name = "@HOME"
    @circle.valid?

    assert_equal "symbol", @circle.first_character_type
    assert_nil @circle.first_character
    assert_nil @circle.first_character_row
  end

  test "ArtistNameでも同様に解析できること" do
    @artist_name.name = "らき☆すた"
    @artist_name.valid?

    assert_equal "hiragana", @artist_name.first_character_type
    assert_equal "ら", @artist_name.first_character
    assert_equal "ら", @artist_name.first_character_row
  end
end
