require 'anemone'
require 'fileutils'

module Precis

  class Crawler

    def initialize(start_url)
      @start_url = start_url

      p save_dir

      # open("hoge.txt", "w") {|f| f.write s}
    end

    def page_pattern
      /prtimes.jp\/main\/html\/rd\/p\/[\d\.]+.html/
    end

    def save_dir
      File.expand_path('../../../data', __FILE__)
    end

    def process
      crawl do |page|
        puts page.url
        save_html(page)

        sleep(1)
      end
    end

    def save_html(page)

      save_path = page.url.to_s.sub(/https?:\/\//, '')

      real_save_path = File.join(save_dir, save_path)

      # urlがディレクトリなら、末尾に'index.html'をつける
      if real_save_path =~ /\/$/
        real_save_path = real_save_path + 'index.html'
      end
      puts "*** real_save_path: #{real_save_path}"

      real_save_dir = File.expand_path('..', real_save_path)
      puts "*** real_save_dir: #{real_save_dir}"

      # fail

      # 実際に保存するdirectoryを作成
      FileUtils.mkdir_p real_save_dir

      open(real_save_path, 'w') do |f|
        f.write page.body.to_s
      end
    end

    def crawl
      Anemone.crawl(@start_url) do |anemone|
        anemone.focus_crawl do |page|
          page.links.keep_if { |link| link.to_s.match(page_pattern) } # crawl only links that are pages or blog posts
        end

        anemone.on_every_page do |page|
          yield page
        end
      end
    end

  end

end
