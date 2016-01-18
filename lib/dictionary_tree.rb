
# require './letter_node'

class DictionaryTree

  attr_accessor :root, :depth
  attr_reader :num_letters

  def initialize ( word_def_array = [] )
    @root = LetterNode.new
    @root.letter = nil
    @nodes = {}
    @depth = 0

    word_def_array.each  do | word_def |
      word_node = LetterNode.new
      word_node.word = word_def[0]
      word_node.letter = word_def[0][0]
      word_node.definition = word_def[1]
      @nodes[word_def[0]] = word_node
    end
  end

  def definition_of( word )
    if @nodes[word]
      @nodes[word].definition
    else
      nil
    end
  end

  def insert_word( word, definition )
      word_node = LetterNode.new
      word_node.word = word
      word_node.letter = word[0]
      word_node.definition = definition
      @nodes[word] = word_node
      if word.length > @depth
        @depth = word.length
        @num_letters = word.length
      end
  end

  def remove_word( word )
    @nodes[word] = nil
  end

  def num_words
    @nodes.length
  end

end