module SeoHelper
  include ActionView::Helpers::AssetUrlHelper

  def default_tags
    {
      site: "Система анкетирования ОСО ЮФУ",
      description: "Помогает студентам сделать университет лучше.",
      keywords: [
        "юфу",
      ],
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
