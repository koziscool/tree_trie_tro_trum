
class DictionaryTree

  attr_accessor :root, :depth
  attr_reader :num_letters, :num_words

  def initialize ( word_def_array = [] )
    @root = LetterNode.new
    @root.letter = nil
    @root.children = []
    @root.depth = 0
    @num_letters = 0
    @num_words = 0
    @max_depth = 0

    word_def_array.each  do | word_def |
      word = word_def[0].split("")
      parent = @root
      word.each_with_index do |c, i|
        child = get_child_node( parent, c )
        child.words_on_branch += 1
        child.definition = word_def[1] if i == word.length - 1
        parent = child
      end
      @num_words += 1
    end
  end

  def get_child_node( node, letter )
    node.children.each do |child_node|
      return child_node if child_node.letter == letter
    end
    new_child = LetterNode.new
    new_child.letter = letter
    new_child.parent = node
    new_child.depth = node.depth + 1
    new_child.children = []
    new_child.words_on_branch = 0    
    node.children << new_child
    @num_letters += 1
    new_child
  end

  def definition_of( word )
    cursor = @root
    word_arr = word.split("")
    word_arr.each do |c|
      found_letter = false
      cursor.children.each do |child_node|
        if child_node.letter == c
          cursor = child_node
          found_letter = true
          next
        end
      end
      return nil unless found_letter
    end
    cursor.definition
  end

  def insert_word( word, definition )
    parent = @root
    word_arr = word.split("")
    word_arr.each do |c|
      child = get_child_node( parent, c )
      child.words_on_branch += 1
      child.definition = definition if child.depth == word.length
      parent = child
    end
    @num_words += 1
  end

  def remove_word( word )
    parent = @root
    word_arr = word.split("")
    num_letters_to_be_removed = 0 
    word_arr.each do |c|
      child = nil
      parent.children.each do |node|
        child = node if node.letter == c
      end
      return if child == nil
      child.words_on_branch -= 1
      if child.words_on_branch == 0
        parent.children.delete( child )
        num_letters_to_be_removed += 1
        parent = child
        child = nil
      else
        parent = child
      end
    end
    parent.definition = nil
    @num_letters -= num_letters_to_be_removed
    @num_words -= 1
  end

  def dive( node )
    @max_depth = node.depth if node.depth > @max_depth 
    node.children.each { |child| dive(child) }
  end

  def depth
    @max_depth = 0
    dive( @root )
    @max_depth
  end


end