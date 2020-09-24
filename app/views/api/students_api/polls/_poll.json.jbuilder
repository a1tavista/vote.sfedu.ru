json.id poll.id
json.title poll.name
json.starts_at poll.starts_at
json.starts_at_localized I18n.l(poll.starts_at, format: :default)
json.ends_at poll.ends_at
json.ends_at_localized I18n.l(poll.ends_at, format: :default)
json.participated poll.student_participated_in_poll?(@current_kind)

json.meta do
  json.id poll.id
  json.resource 'polls'
end

if local_assigns[:full_representation]
  json.options poll.options do |option|
    json.id option.id
    json.title option.title
    json.description option.description
    json.image_data option.image_data
  end
end

