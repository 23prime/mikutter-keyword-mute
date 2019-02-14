Plugin.create(:mute_word) do
  UserConfig[:muted_words] = UserConfig[:muted_words].reject(&:empty?)
  exclude_words = UserConfig[:muted_words]

  settings('キーワードミュート') do
    multi('指定した単語を含むツイートをミュートします', :muted_words)
  end

  filter_show_filter do |msgs|
    msgs = msgs.reject { |msg| exclude_words.any? { |word| msg.to_s.include?(word) } }
    [msgs]
  end
end
