require 'rjb'

class Kuromoji

  Rjb::load(File.expand_path('../kuromoji-0.8-SNAPSHOT.jar', __FILE__))

  module  JavaIterator
    def each
      i = self.iterator
      while i.has_next
        yield i.next
      end
    end

    def map(&proc)
      i = self.iterator
      ret = []
      while i.has_next
        ret << proc.call(i.next)
      end
      ret
    end
  end

  def initialize
    tokenizer = Rjb::import('org.atilika.kuromoji.Tokenizer')
    @tknizer = tokenizer.builder.build
  end

  def tokenize(sentence)
    tokenized_list = @tknizer.tokenize(sentence)
    tokenized_list.extend JavaIterator
    list = tokenized_list.map do |x|
      [x.surface_form, x.all_features.split(',')]
    end
  end

end

