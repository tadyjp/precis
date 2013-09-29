require "bundler/gem_tasks"
require 'precis'
require 'rjb'

namespace :precis do

  desc 'prtimes.jpから記事をクロール'
  task :crawl do
    crawler = Precis::Crawler.new("http://prtimes.jp/")
    crawler.process
  end

  desc 'クロールしたhtmlからdfを計算し、fileに保存'
  task :calc_df do
    Precis::Tfidf.calc_df
  end

  desc 'tfの計算'
  task :calc_tf do
    file = File.expand_path('../data/prtimes.jp/main/html/rd/p/000000001.000000401.html', __FILE__)
    Precis::Tfidf.calc_tf(file)
  end

  desc 'tfの計算_ALL'
  task :calc_tf do
    Precis::Tfidf.calc_tf_all
  end
end
