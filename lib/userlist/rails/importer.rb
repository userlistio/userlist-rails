module Userlist
  module Rails
    class Importer
      def initialize(config = {})
        config[:push_strategy] ||= :direct
        @config = Userlist.config.merge(config)
      end

      def import(model, &block)
        find_each(model) do |record|
          print "Pushing #{model.name} #{record.id}..."
          instance_exec(record, &block)
          print " ✔︎\n"
        end
      end

    private

      attr_reader :config

      def push
        @push ||= Userlist::Push.new(config)
      end

      def find_each(model, &block)
        if model.respond_to?(:find_each)
          model.find_each(&block)
        elsif model.respond_to?(:each)
          model.each(&block)
        else
          raise "Cannot iterate over #{model} because it doesn't implement .find_each, nor .each"
        end
      end
    end
  end
end
