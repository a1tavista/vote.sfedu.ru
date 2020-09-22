json.id stage.id
json.title 'Рейтинг НПР'
json.description "Анкетирование студентов Южного федерального университета"
json.starts_at stage.starts_at
json.starts_at_localized I18n.l(stage.starts_at, format: :default)
json.ends_at stage.ends_at
json.ends_at_localized I18n.l(stage.ends_at, format: :default)
json.participated false

json.meta do
  json.id stage.id
  json.resource 'stages'
end
