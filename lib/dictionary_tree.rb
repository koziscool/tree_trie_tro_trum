
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
        child = find_or_create_child_node( parent, c )
        child.words_on_branch += 1
        child.definition = word_def[1] if i == word.length - 1
        parent = child
      end
      @num_words += 1
    end
  end

  def find_or_create_child_node( parent, letter )
    existing_child = get_child_node(parent, letter )
    existing_child ? existing_child : create_child_node( parent, letter )
  end

  def get_child_node( parent, letter )
    parent.children.each do |child_node|
      return child_node if child_node.letter == letter
    end
    nil
  end

  def create_child_node( parent, letter )
    new_child = LetterNode.new
    new_child.letter = letter
    new_child.parent = parent
    new_child.depth = parent.depth + 1
    new_child.children = []
    new_child.words_on_branch = 0
    parent.children << new_child
    @num_letters += 1
    new_child
  end

  def definition_of( word )
    cursor = @root
    word_arr = word.split("")
    word_arr.each do |c|
      existing_child = get_child_node( cursor, c )
      existing_child ? ( cursor = existing_child ) : (return nil)
    end
    cursor.definition
  end

  def end_node_for( word )
    parent = @root
    word_arr = word.split("")
    word_arr.each do |c|
      existing_child = get_child_node( parent, c )
      return nil unless existing_child
      parent = existing_child
    end 
    parent   
  end

  def insert_word( word, definition )
    parent = @root
    word_arr = word.split("")
    word_arr.each do |c|
      child = find_or_create_child_node( parent, c )
      child.words_on_branch += 1
      child.definition = definition if child.depth == word.length
      parent = child
    end
    @num_words += 1
  end


  def remove_word( word )
    definition_node = end_node_for( word )
    return unless definition_node

    num_letters_to_be_removed = 0 
    parent = @root
    word_arr = word.split("")
    word_arr.each do |c|
      existing_child = get_child_node( parent, c )
      existing_child.words_on_branch -= 1
      if existing_child.words_on_branch == 0
        parent.children.delete( existing_child )
        num_letters_to_be_removed += 1
        parent = existing_child
        existing_child = nil
      else
        parent = existing_child
      end
    end
    definition_node.definition = nil
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