class Mechanize::Form
  # A Generic api to get value
  # @see set
  def get(type, criteial)
    case type.to_sym
    when :text, :hidden, :textarea, :keygen
      (f=field(criteia)) ? f.value : nil
    when :radiobutton 
      (f=radiobutton(criteia)) ? f.checked? : nil
    when :checkbox
      (f=checkbox(criteia)) ? f.checked? : nil
    when :multi_select_list, :select_list
      (f=field(criteia)) ? f.value : nil
    when :multi_select_list_text, :select_list_text
      (f=field(criteia)) ? f.text_value : nil
    when :file_upload
      (f=file_upload(criteia)) ? f.file_name : nil
    else
      raise ArgumentError, "the type argument is wrong -- #{type.insepect}"
    end
  end

  # A Generic api to set value
  #
  # types: :text, :hidden, :textarea, :keygen, :radiobutton, :checkbox, 
  #        :multi_select_list[_text] :select_list[_text] :file_upload
  #
  # @param type [Symbol,String] 
  # @param value [Object] use nil to pass the set.
  #
  # @example
  #
  #   set :text, "foo"
  #   set :checkbox, true
  #   set :select_list, "1"
  #   set :select_list_text, "EPUB"
  #
  # @see get
  def set(type, criteia, value)
    return nil if value.nil?

    case type.to_sym
    when :text, :hidden, :textarea, :keygen
      (f=field(criteia)) ? f.value = value : nil
    when :radiobutton 
      (f=radiobutton(criteia)) ? f.check(value) : nil
    when :checkbox
      (f=checkbox(criteia)) ? f.check(value) : nil
    when :multi_select_list, :select_list
      (f=field(criteia)) ? f.value = value : nil
    when :multi_select_list_text, :select_list_text
      (f=field(criteia)) ? f.text_value = value : nil
    when :file_upload
      (f=file_upload(criteia)) ? f.file_name = value : nil
    else
      raise ArgumentError, "the type argument is wrong -- #{type.insepect}"
    end
  end
end

class Mechanize::Form::MultiSelectList 
  # Select no options
  def select_none_with_tagen
    @text_value = []
    select_none_without_tagen
  end
  alias select_none_without_tagen select_none
  alias select_none select_none_with_tagen

  # Select all options
  def select_all_with_tagen
    @text_value = []
    select_all_withoutout_tagen
  end
  alias select_all_without_tagen select_all
  alias select_all select_all_with_tagen

  def text_value
    value = []
    value.concat @text_value
    value.concat selected_options.map { |o| o.text }
    value
  end

  def text_value=(values)
    select_none
    [values].flatten.each do |value|
      option = options.find { |o| o.text == value }
      if option.nil?
        @text_value.push(value)
      else
        option.select
      end
    end
  end
end

class Mechanize::Form::SelectList
  def text_value
    value = super
    if value.length > 0
      value.last
    elsif @options.length > 0
      @options.first.value
    else
      nil
    end
  end

  def text_value=(new)
    if new != new.to_s and new.respond_to? :first
      super([new.first])
    else
      super([new.to_s])
    end
  end
end

class Mechanize::Form::RadioButton
  # check_with_tagen(nil)
  # check_with_tagen(true)
  # check_with_tagen(false)
  def check_with_tagen(check=true)
    if check.nil?
      return
    elsif check
      check_without_tagen
    else
      uncheck
    end
  end

  alias check_without_tagen check
  alias check check_with_tagen
end

