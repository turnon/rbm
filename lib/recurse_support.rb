class ActiveRecord::Base

    def self.can_recurse(*methods)
      methods.each do |m|
        define_method "#{m}_recurse" do
          arr = []
          r = -> obj { arr << obj; subarr = obj.send m; subarr.each &r unless subarr.empty? }
          self.send(m).each &r
          arr
        end
      end
    end

end
