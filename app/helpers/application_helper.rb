module ApplicationHelper
  def title(page_title = "")
    content_for :title, page_title.to_s
  end
  def keywords(page_keywords = "")
    content_for :keywords, page_keywords.to_s
  end
  def head_desc(page_description = "")
    content_for :head_desc, page_description.to_s
  end
  def mobile_url(path)
    content_for :mobile_url, "http://lgd.pub#{path}"
  end
  def path(path)
    content_for :path, path
  end
  def pc_host(pc_host)
    content_for :pc_host, pc_host
  end
  def h1(h1)
    content_for :h1, h1
  end

  def ld_json(json)
    content_for :ld_json, json
  end
end
