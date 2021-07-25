# frozen_string_literal: true

class User
  attr_reader :type, :symbol

  TYPE = %w[Human Computer].freeze

  def initialize(type, symbol)
    @type = type
    @symbol = symbol
  end

  private

  attr_writer :type, :symbol
end
