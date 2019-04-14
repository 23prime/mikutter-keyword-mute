Plugin.create(:mute_word) do
  UserConfig[:muted_words] = UserConfig[:muted_words].reject(&:empty?)
  exclude_words = UserConfig[:muted_words]

  settings('キーワードミュート') do
    multi('指定した単語を含むツイートをミュートします', :muted_words)
  end

  def include?(msg, word)
    msg_s = msg.to_s
    case_ignore = false

    if word =~ %r{^/}
      if word =~ %r{/i$}
        word = word[1..-3]
        case_ignore = true
      elsif word =~ %r{/$}
        word = word[1..-2]
      end
    end
    return msg_s =~ Regexp.new(word, Regexp::IGNORECASE) if case_ignore
    return msg_s =~ Regexp.new(word)
  end

  filter_show_filter do |msgs|
    msgs = msgs.reject { |msg| exclude_words.any? { |word| include?(msg, word) } }
    [msgs]
  end
end
