module MergeNestedErrors
  def errors_merge!(instance_errors)
    instance_errors.messages.each do |column, messages|
      messages.each { |m| errors.add(column, m) }
    end
  end
end
