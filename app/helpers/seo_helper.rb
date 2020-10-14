module SeoHelper
  include ActionView::Helpers::AssetUrlHelper

  def default_tags
    {
      site: "Система анкетирования Объединённого совета обучающихся ЮФУ",
      description: "От твоего выбора сегодня зависит завтрашняя жизнь",
      keywords: ["юфу", "студсовет"],
      og: {
        title: :title,
        description: :description,
        type: "website",
        url: root_url,
        image: [
          {
            _: image_url("og_cover.png"),
            width: 1179,
            height: 731,
          },
        ],
      },
      reverse: true,
    }
  end
end
