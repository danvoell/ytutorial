module ApplicationHelper
  
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="alert clearfix">
      <h4>#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  
  def asset_url(source)
    URI.join(root_url, asset_path(source))
  end
  
  def bootstrap_paginate(pages, options={})
    options.reverse_merge!(
      :class => 'pagination', 
      :renderer => BootstrapLinkRenderer, 
      :previous_label => '&lt;&lt;'.html_safe, 
      :next_label => '&gt;&gt;'.html_safe
    )
    will_paginate(pages, options)
  end
  
  def gridify(collection, partial, opts = {})
    rows = []
    coll_copy = collection.dup
    cols = opts[:cols] || 3
    begin
      row = []
      cols.times { row << coll_copy.shift }
      row.compact!
      rows << row
    end while coll_copy.present?
    
    width = opts[:col_width] || 3
    output = ""
    rows.each do |row|
      output << "<div class='row-fluid'>\n"
      row.each do |col|
        output << "<div class='span#{width}'>\n"
        output << render({partial: partial, object: col}.merge(opts))
        output << "\n</div>"
      end
      output << "\n</div>"
    end
    
    output.html_safe
  end
  
  # improved version of https://gist.github.com/1160287
  def wrap(str, opts = {})
    opts = opts.with_indifferent_access
    max_len = opts[:max_length] || 20
    seperator = opts[:seperator] || "<wbr>"
    return str unless str.length > max_len
    ret = ""
    begin
      idx = str.index(seperator)
      if idx.nil? || idx > max_len
        ret += str[0..max_len]
        str = str[(max_len + 1)..-1]
      else
        ret += str[0..idx]
        str = str[(idx + 1)..-1]
      end
      ret << seperator
    end while str.present?
    
    ret.html_safe
  end
end
