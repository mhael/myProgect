class ExistValidator < ActiveModel::EachValidator
include UsersHelper

  def validate_each(record, attribute, value)
    nick = record.get_user_name_from_link(value)
    record.errors[attribute] << (options[:message] || "is not valid user code") if nick.nil?
  end
end
