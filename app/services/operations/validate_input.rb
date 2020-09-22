require 'dry/transaction/operation'

module Operations
  class ValidateInput
    include Dry::Transaction::Operation

    def call(input, contract_klass:)
      result = contract_klass.new.call(input)
      return Failure(input.merge(errors: result.errors.to_h)) unless result.success?

      Success(result.to_h)
    end
  end
end
