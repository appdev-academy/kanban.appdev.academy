module UpsertPositions
  extend ActiveSupport::Concern

  included do
    # This method upserts "position" fields for specific ActiveRecord subclass
    #
    # @param [ActiveRecord] klass - ActiveRecord class with "position" field
    # @param [{ Integer => Integer }] positions - hash with ids of ActiveRecord class as keys and positions set in values
    # @return [void]
    # @example
    #   upsert_positions(Task, {21 => 0, 5 => 1, 6 => 2})
    def upsert_positions(klass, positions)
      query = <<-SQL
        UPDATE #{klass.name.downcase.pluralize}
        SET position = CASE id
          #{positions.map { |id, position| "WHEN #{id} THEN #{position}" }.join("\n")}
        END
        WHERE id IN (#{positions.keys.join(",")})
      SQL

      ActiveRecord::Base.connection.execute(query)
    end
  end
end
