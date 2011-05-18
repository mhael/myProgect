class CheckEmailValidator < ActiveModel::EachValidator
  EmailAddress = begin
    pattern = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/
  end

  def validate_each(record, attribute, value)
    unless value =~ EmailAddress
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end

end
