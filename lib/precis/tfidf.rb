require 'nokogiri'
require File.expand_path('../../kuromoji', __FILE__)
require 'pry'
require 'active_support/all'

module Precis

  class Tfidf

    def self.calc_df
      self.new.calc_df
    end

    def self.calc_tf(file)
      self.new.calc_tf(file)
    end

    def self.calc_tf_all
      self.new.calc_tf_all
    end

    def kuromoji
      @kuromoji ||= Kuromoji.new
    end

    def calc_tf_all
      data_files do |file|
        puts file
        calc_tf(file)
      end
    end

    def calc_tf(file)
      list = []
      split_html(extract_html(file).inner_text).each do |line|
        item = {
          line: line,
          score: calc_line_importance(line)
        }
        list << item
      end

      list.sort! {|a, b| b[:score] <=> a[:score] }

      list[0..2].each do |item|
        puts "\t#{sprintf("%.3f", item[:score])} #{item[:line]}"
      end
    end

    # 1行の重要度を計算
    def calc_line_importance(line)
      score = 0.0
      terms = list_terms(line)
      terms.each do |term|
        # puts "#{term}\t#{idf[term]}"
        score += idf[term]

        # puts "\t#{term}\t#{idf[term]}"
      end

      score /= (terms.length + 1)

      # if terms.length == 0
      #   score /= terms.length
      # else
      #   score /= (terms.length + 1)
      # end

      # p "#{score} : #{terms.length} : #{line}"

      score
    end

    def calc_df
      count_hash = Hash.new {|h, k| h[k] = 0 }

      data_files do |file|
        list_terms(extract_html(file).text).uniq.each do |term|
          count_hash[term] += 1
        end
      end

      count_hash = Hash[count_hash.sort_by{|key,val| -val}]

      save_df(count_hash)
    end

    # データファイル
    def data_files
      Dir.glob(save_dir + "/**/*").each_with_index do |file, _index|
        next if File::ftype(file) == "directory"

        _index += 1
        puts "*** #{_index}" if _index % 10 == 0

        yield file
      end
    end

    # 与えられたhtmlを行に分解する
    # @param [String] str 分解するhtml
    # @return [Array] 行の配列
    def split_html(str)
      str.gsub(/[\r\n]+|\s\s+/, "\n")
        .split("\n")
        .select { |_line| _line.present? }
    end

    # DFをファイルに保存
    # @param [Hash] hash 保存するhash
    def save_df(hash)
      open(df_file, 'w') do |f|
        hash.each do |term, count|
          f.write "#{term}\t#{count}\n"
        end
      end
    end


    def tf

    end

    # DFデータを読み込みhashにする
    # @return [Hash] DFデータ {単語 => 文書数}
    def idf
      @df_hash ||= begin
        df_hash = Hash.new {|h, k| h[k] = 0 }
        open(df_file) do |f|
          f.each do |line|
            k, v = line.chomp.split("\t")

            df_hash[k] = Math.log(total_document_count / v.to_f)
          end
        end
        df_hash
      end
    end

    def total_document_count
      11612
    end

    def df_file
      File.expand_path('../../../data', __FILE__) + '/df.txt'
    end

    def save_dir
      File.expand_path('../../../data', __FILE__)
    end

    # fileのhtmlから必要部分を抜き出す
    # @param [String] file ファイル名
    # @return [String] 抜き出した文字列
    def extract_html(file)
      doc = Nokogiri::HTML(File.read(file))
      html_fragment = doc.css('#releasedetail')

      # 該当するhtml部分がなければnil
      return if html_fragment.nil?

      html_fragment
    end

    # 文字列に含まれる単語を抜き出す
    # @param [String] str 計算する文字列
    # @return [Array] 文字列に含まれる文字の配列
    def list_terms(str)
      tokens = kuromoji.tokenize(str)

      ret = []

      tokens.each do |token|
        if token[1][0] == '名詞' || token[1][0] == '動詞'
          ret << token[0]
        else
          nil
        end
      end

      ret
    end


  end

end
